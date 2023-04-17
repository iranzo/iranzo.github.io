---
author: Pablo Iranzo Gómez
title: How to run a NYM Validator
tags:
  - NYM
  - crypto
  - validator
  - fedora
  - Linux
  - CentOS
  - RHEL
  - foss
layout: post
date: 2021-05-09 12:40:34 +0200
categories:
  - tech
lang: en
modified: 2023-04-17T21:36:05.683Z
---

As said in the article about [mixnodes]({{<relref "2021-05-09-run-a-nym-mixnode.en.md">}}), NYM is a technology aiming for providing privacy for the communications.

Apart of the mixnodes, other key piece in the infrastructure are the validators.

As said, the project uses Open Source technology to run, and they have a nice docs with details on how to run a node at <https://nymtech.net/docs/>, and the one relevant for mixnodes at <https://nymtech.net/docs/run-nym-nodes/validators/>.

In this case, we can follow the instructions for compiling, but I faced some issues (compiling went fine, but initial sync failed), so in this case, we will use the pre-compiled version provided with the `0.10.0` release.

Let's now clone the repository:

```sh
git clone  https://github.com/nymtech/nym.git
cd nym
git checkout tags/v0.10.0
```

The binaries we're interested are inside the `validator` folder, and two of them are important:

- `libwasmvm.so`
- `nymd`

The official guide, already provides enough information about creating a systemd unit file, setting the `LD_LIBRARY_PATH` environment variable in our `.bashrc`, etc. So we will use them after installing the required packages:

```sh
dnf -y install certbot nginx
systemctl enable nginx
systemctl start nginx
```

Those packages will enable our system to serve secure web pages using a domain name validated with let's encrypt.

Pay special attention to the required steps:

- Initialize the validator as described using `nymd init $SERVER --chain-id testnet-finney`
- Run `wget -O $HOME/.nymd/config/genesis.json https://nymtech.net/testnets/finney/genesis.json` to overwrite the created file with the one for `finney` release.
- Edit the `$HOME/.nymd/config/config.toml` file as described (`persistent_peers`, `cors_allowed_origins` and `create_empty_blocks`)
- Edit the `$HOME/.nymd/config/app.toml` to set the proper values for `minimum-gas-prices` and enabling `[API]`

Once this is performed, initialize an user, and remember the key that you typed and of course, store the mnemonic properly.

Follow the steps on the guide for setting the systemd service so that the process starts automatically after each reboot:

- `systemctl enable nymd`
- `systemctl start nymd`

After a while, with the process started, you can create the validator using the command at the documentation by creating a transaction and staking (you'll need tokens for that, and the program will ask your confirmation and password before signing and broadcasting the request).

Before it, remember to open the firewall ports:

```sh
for port in 1317/tcp 9090/tcp 26656/tcp; do
firewall-cmd --add-port=${port}
firewall-cmd --add-port=${port} --permanent
done
```

Once it's finished, you're ready to run the validator as instructed in the official guide.

## Claiming rewards

Once the remaining steps for setting it up have been followed, and the validator has been running for a while, you can check the obtained rewards:

```sh
nymd query distribution validator-outstanding-rewards halvaloper<...the address you get when "nymd keys show default --bech=val"...>

```

Using the values obtained from previous command, you can withdraw all rewards with:

```sh
nymd tx distribution withdraw-rewards halvaloper<...the address you get when "nymd keys show default --bech=val"...> --from nym-admin   --keyring-backend=os   --chain-id="testnet-finney"   --gas="auto"   --gas-adjustment=1.15   --commission --fees 5000uhal
```

If you want to check your current balances, check them with:

```sh
~/.nymd/nymd query bank balances hal<address>
```

For example:

```
balances:
- amount: "22976200"
  denom: stake
- amount: "919376"
  denom: uhal
pagination:
  next_key: null
  total: "0"
```

You can, of course, stake back the available balance to your validator with the following command:

```sh
nymd tx staking delegate halvaloper<...the address you get when "nymd keys show nym-admin --bech=val"...> <amount>stake      --from nym-admin   --keyring-backend=os   --chain-id "testnet-finney"   --gas="auto"   --gas-adjustment=1.15   --fees 5000uhal
```

{{<note>}}

The value to be used instead of the `<amount>stake` can be calculated from the available balance. For example, if you've `999989990556` in the balance, you can stake `999909990556`, note that the 5th digit, has been changed from `8` to `0` to leave some room for fees (amounts are multiplied by 10^6).
{{</note>}}

Remember to replace `halvaloper` with your validator address and `nym-admin` with the user you created during initialization.

Additionally you can also fix some of the data provided for your validator with:

```sh
nymd tx staking edit-validator   --chain-id=testnet-finney   --moniker=<mymoniker>   --details="Nym validator"   --security-contact="YOUREMAIL"   --identity="XXXXXXX"   --gas="auto"   --gas-adjustment=1.15   --from=nym-admin --fees 2000uhal
```

With above command you can specify the `gpg` key last numbers (as used in `keybase`) as well as validator details and your email for security contact

{{<enjoy>}}
