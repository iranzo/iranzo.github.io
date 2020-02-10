---
author: Pablo Iranzo Gómez
title: Postgres repl SSL replication
tags: postgres, foss, ssl, replication, federation, kubernetes, openshift
layout: post
date: 2019-01-08 17:30:36 +0100
comments: true
category: tech
description:
lang: en

---
[TOC]


# Postgres across clusters

For Postgres to work across clusters we do need to have the data being synchronized.

With some other databases we do have some master-master approach, but usually have very strict requirements on latency, bandwidth, etc that we cannot solve with On-Premise + external cloud providers.

If the replication is based on the storage level instead, then you face that database servers don’t deal well if the data changes underneath it, so it leads to data corruption, on top of the storage-level issues/requirements as well on bandwidth, latency, etc.


## Other approaches

- <http://evol-monkey.blogspot.com/2015/10/postgresql-94-streaming-replication.html>
- <https://hackernoon.com/postgresql-cluster-into-kubernetes-cluster-f353cde212de>

# Postgresql streaming replication over SSL

There are several ways to accomplish this if you do a quick search on a web crawler, but we've gone the PSQL Streaming replication over SSL for our environment.

A replication slot is (as defined in [documentation](https://www.postgresql.org/docs/9.4/warm-standby.html#STREAMING-REPLICATION-SLOTS))

> Replication slots provide an automated way to ensure that the master does not remove WAL segments until they have been received by all standbys, and that the master does not remove rows which could cause a recovery conflict even when the standby is disconnected.

## Background

- Quay requires a database that is available for each instance and provides required redundancy/replication
- Replicating via storage can lead to issues as the files will change underneath postgres
- Galera approach for mysql (multi-master) is known to have issues even when running on the same cluster
- For Federation we do want applications to run in different clusters, so an approach where a hot-standby is ready will probably overcome the limitations of master-master and the requirements for available database for all quay instances.

## Investigation

We started to investigate [how others approached](#other-approach) this situation and similar to what was done for another part of the setup for mongo, we went testing via replication over SSL.

We also checked several of the approaches, but one of them, PostDock images were lacking SSL support, but still had a nice way to do several overrides for configuration, etc via environment variables, which made them ideal for testing in an OpenShift/Kubernetes environment.

The environments we plan to use are:

- AIT cluster
- LEO cluster
- PIT cluster

## SSL

For the SSL setup side we did:

### Create Postgres Certs

Seems that Postgres doesn't check the certificate for the host 'by default', but just uses the certificate to encrypt, but still we did create the certificates using the name of the application in it for future usage.

Using the same certificate with all server names, we can also federate a single secret containing those certs rather than creating one SSL secret for each cluster.

```
./generate-cert.sh postgres
```

With output:

```
2018/11/29 15:04:29 [INFO] generate received request
2018/11/29 15:04:29 [INFO] received CSR
2018/11/29 15:04:29 [INFO] generating key: rsa-2048
2018/11/29 15:04:29 [INFO] encoded CSR
2018/11/29 15:04:29 [INFO] signed certificate with serial number 34111709152443674697969629831350216041253590538
```

Now, we do have all the required certificates for postgres generated.

```sh
-rw-r--r--. 1 iranzo iranzo 1001 nov 29 15:04 postgres.csr
-rw-rw-r--. 1 iranzo iranzo  208 nov 29 15:04 postgres-csr.json
-rw-------. 1 iranzo iranzo 1679 nov 29 15:04 postgres-key.pem
-rw-rw-r--. 1 iranzo iranzo 1753 nov 29 15:04 postgres.pem

```

### Our setup configuration

Setup:

- LEO will be the 'master' with $PGDATA at /var/lib/postgresql/data in a local volume
- AIT will be the 'slave' with $PGDATA at /var/lib/postgresql/data in a local volume
- PIT will be the 'slave' with $PGDATA at /var/lib/postgresql/data in a local volume

The first issue we found is that by default, PostDock Lack the SSL support, but as we were allowed to define settings for the configuration files we could override the settings via a variable named 'CONFIGS' set to `ssl:on,ssl_cert_file:'/etc/postgresql/server.crt',ssl_key_file:'/etc/postgresql/server.key'`.

This required to craft a custom image (`quay.io/iranzo/postdock:sslkeyschown`) that we submited as [PR to Postdock](https://github.com/paunin/PostDock/pull/205).

In the meantime, we did use <https://quay.io> to store our image and rebuild whenever we changed the code at our custom repo.

The changes in our image are very simple:

```diff
diff --git a/src/pgsql/bin/postgres/entrypoint.sh b/src/pgsql/bin/postgres/entrypoint.sh
index b09652c..1298dcb 100755
--- a/src/pgsql/bin/postgres/entrypoint.sh
+++ b/src/pgsql/bin/postgres/entrypoint.sh
@@ -42,7 +42,25 @@ else
     fi
 fi

-KEYS=$(egrep '(ssl_cert_file|ssl_key_file)' $PGDATA/postgresql.conf|cut -d "=" -f 2-)
+
+echo ">>> Trying to configure SSL"
+# Tweak keys to avoid permission issues:
+ORIGKEYS=$(echo $CONFIGS|tr "," "\n"|egrep '(ssl_cert_file|ssl_key_file)'|cut -d ":" -f 2-|tr "\n" " "|tr -d "\'")
+KEYS=""
+
+echo ">>> Trying to move ${ORIGKEYS} to proper folder"
+for file in ${ORIGKEYS}; do
+    # Check for file or link pointing to file
+    if [ -e /pg-ssl/$(basename ${file}) ]; then
+        echo ">>> Copying SSL file from /pg-ssl/$(basename ${file}) to ${file}"
+        mkdir -p $(dirname ${file})
+        cat /pg-ssl/$(basename ${file}) > ${file}
+        KEYS="$KEYS ${file}"
+    else
+        echo ">>> ERROR: SSL File ${file} doesn't exist on disk"
+    fi
+done
+
 chown -R postgres $PGDATA $KEYS && chmod -R 0700 $PGDATA $KEYS

 source /usr/local/bin/cluster/repmgr/configure.sh
```

From this, and once 'Quay' builds our image, we should, in the namespace for our project, add a new application via 'Deploy image' with `quay.io/iranzo/postdock:sslkeyschown` (sources at <https://github.com/iranzo/PostDock>)

The application will ask for some configuration options, name for the new application, etc

We must configure some environment variables:

### Environment configuration

- PARTNER_NODES: IP's of: postgres-leo.apps.e2e.bos.example.com,postgres-ait.apps.e2e.bos.example.com,postgres-aws.apps.e2e.bos.example.com (from below, but EXCLUDING the one we're that we'll be putting in CLUSTER_NODE_NETWORK_NAME)
  - LEO: 10.19.227.153
  - AIT: 10.19.115.226
  - AWS: internal-aba91353afe1c11e89f350a50403e669-443870799.us-east-1.elb.amazonaws.com
- CLUSTER_NAME: `quaydatabase`
- POSTGRES_DB: `quaydb`
- DB_USERS: `replication_user:replication_pass,quayuser:quaypass`
- CONFIGS: `ssl:on,ssl_cert_file:'/etc/postgresql/server.crt',ssl_key_file:'/etc/postgresql/server.key'`
- NODE_NAME: Identifying name for this instance
- NODE_ID: $(NUMBER DIFFERENT FOR EACH NODE + 1000, f.e. 1002)
- CLUSTER_NODE_NETWORK_NAME: $(SAME AS NODE_NAME that would go in PARTNER NODES)
- REPLICATION_HOST: "postgres" (name of app in deployment)

We did raise/update some issues:

- <https://github.com/paunin/PostDock/issues/124>
- <https://github.com/paunin/PostDock/issues/202>
- <https://github.com/paunin/PostDock/issues/203>

But finally as we had to build our own modified image we were able to circumvent them.

We did configure some more things to pass the certificates and key to the pods:

- Configure a secret with `server.crt` and `server.key` based on the `postgres.pem` and `postgres-key.pem` for each one of them.

As we're using a secret for storing the certificates, we'll use a volume exposing it to the host via the path `/pg-ssl`

~~~yaml
    - mountPath: /pg-ssl
              name: volume-yisiz
              readOnly: true
~~~

Our patched image, will find and move the certificates to their final destination (specified via environment variable in `CONFIGS`).

This image, also ensures valid permissions and ownership so that postgres can start and answer 'SSL' via a:

```sh
 iranzo   iranzo-save  …  RH  syseng  pit-hybrid  psql -h localhost -U replication_user -W replication_db -p 5432
Password for user replication_user:
psql (10.6)
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: disabled)

replication_db=# \dt
Did not find any relations.
replication_db=#
```

## Additional settings

- Configure a volume for storing permanent data in `/var/lib/postgresql/data` so that is kept and not destroyed on pod destroy.

## The bittersweet wrap-up

At this point we do have the postgres image started with SSL, however:

- In order to use replication between environments, we need a way to access postgres
- The creation and configuration of SSL setup gets us a bit closer to it
- OpenShift HAPROXY requires SNI-capable client, which is not[^1] the case, hence we still cannot have the traffic get into the postgres instance and hence, replication doesn't start as there's no communication.

All attempts to use a router (that only permits http and https or TLS-with-SNI) failed completely, as PSQL doesn't yet have the support in place, failed, even some other hacks on initialization scripts to use the alternate port instead.

Unfortunately, this became a major blocker at this time, not allowing us to setup a replicated postgres cluster across different OpenShift Clusters to have it as a database we can rely for setting up Quay on top.

## The plot twist

After finding no more ways, we discussed with our team members for putting more brains in this, and in conversations with with Pep, Mario and Ryan, it was suggested to instead use a LoadBalancer IP, that imposes no restrictions on the traffic, this however could only be acomplished on 3 environments (LEO, AIT and AWS)

As AWS seems to have no DNS resolution, we're limited to use IP's in the server name (for the CLUSTER_NODE_NETWORK_NAME) so that in case of failover, AWS can reach them.

With the current setup, we only needed to define 'persistent' storage for postgres so in case all three pods were destroyed at the same time, we do have some data to start over.

The final steps, outlined above in [Our setup configuration](#our-setup-configuration), were updated to use:

- PARTNER_NODES containing the LB IP address for the Load Balancer defined in each environment EXCEPT our own
- CLUSTER_NODE_NETWORK_NAME: our LB IP as it would go in PARTNER_NODES for other clusters

- PARTNER_NODES: IP's of: postgres-leo.apps.e2e.bos.example.com,postgres-ait.apps.e2e.bos.example.com,postgres-aws.apps.e2e.bos.example.com (from below, but EXCLUDING the one we're that we'll be putting in CLUSTER_NODE_NETWORK_NAME)
  - LEO: 10.19.227.153
  - AIT: 10.19.115.226
  - AWS: internal-aba91353afe1c11e89f350a50403e669-443870799.us-east-1.elb.amazonaws.com
- NODE_ID: $(NUMBER DIFFERENT FOR EACH NODE + 1000, f.e. 1002)
- CLUSTER_NODE_NETWORK_NAME: $(SAME AS NODE_NAME that would go in PARTNER NODES)
- REPLICATION_HOST: "postgres" (name of app in deployment)

With this approach, the LoadBalancer effectively passes the data on port 5432 (even if it's not SSL), and the cluster can form and start replication of data.

So next steps are:

- Define DNS name pointing to all 3 IP's that we can configure on apps
- Rely on psql standby to work in read-only mode and providing service
- Setup Quay to use that psql DNS name
- Automate the setup, including quay ENV variable for storage 'closer' to each cluster.

[^1]: [Thread on psql-hackers](https://www.postgresql.org/message-id/CAPPwrB_tsOw8MtVaA_DFyOFRY2ohNdvMnLoA_JRr3yB67Rggmg%40mail.gmail.com) and [pinged by us](https://www.postgresql.org/message-id/20181211145240.GL20222%40redhat.com)
