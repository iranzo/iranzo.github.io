---
layout: post
title: Creando plantillas Jigdo (Jigsaw Download) para descargar ISO's
date: 2008-01-04T18:43:29Z
category: [linux, iso]
---

### Introducción 

Jigdo (JIGsaw DOwnload) es una pequeña utilidad que permite ensamblar imágenes de CD/DVD a partir de los ficheros que las forman.

Por ejemplo, [Debian](http://www.debian.org/) ha estado utilizándolo durante algún tiempo para distribuir sus imágenes: se descarga un fichero jigdo y utilizando la orden jigdo-lite (paquete jigdo-lite en Debian y en las basadas en RPM[^1].  De este modo, sólo de descargan ficheros pequeños de incluso varios servidores, repartiendo la carga, y haciendo uso de posibles proxyes, etc.

Además, si ya disponíamos de ficheros descargados (por ejemplo si iniciamos con la versión X y hemos ido descargando y conservando los ficheros hasta la X.Y, jigdo puede utilizar dichos ficheros, comparándolos con los existentes en la plantilla y así, evitarnos descargar ficheros que ya tuviéramos...

### ¿Cómo funciona? 

Una plantilla Jigdo contiene dos partes: una, el archivo .jigdo que contiene la información de los ficheros que conforman la ISO[^2] y una plantilla que se crea en base al análisis que jigdo-file hace de la imagen original al crear las plantillas.

Al ejecutar jigdo-lite "archivo.jigdo", se nos preguntará por posibles ubicaciones (carpetas) que podrían tener ya los archivos que descargamos, y utilizará las URL's especificadas en el fichero ".jigdo" para descargar todos aquellos que no tuviéramos disponibles. Al final del proceso, jigdo ensamblará de nuevo la imagen con todos los ficheros, obteniendo una imagen idéntica a la original desde la que se crearon las plantillas. Como aliciente, sólo se habrán descargado los archivos realmente necesarios y en caso de fallos de conectividad, será necesario sólo descargar pequeñas partes en lugar de toda una ISO como se haría con métodos tradicionales.

### ¿Cómo creo un fichero .jigdo y un .template? 

Por ejemplo, si descargamos la imagen ISO de CentOS [mirror.centos.org](http://alufis35.uv.es/mirror.centos.org), podemos montarla usando loopback y colocarla en una carpeta (por ejemplo para proporcionar nuestro propio servidor espejo o árbol de instalación), podremos hacer:

(Supongamos que la iso está en /var/www/CentOS/isos/ y que la carpeta con el contenido de la iso en /var/www/CentOS/tree/, haremos:

{% highlight bash %}
jigdo-file mt -i /var/www/CentOS/isos/CentOS-5.0-i386-bin-DVD/CentOS-5.0-i386-bin-DVD.iso -j /var/www/CentOS/Centos5-DVD.jigdo -t /var/www/CentOS/Centos5-DVD.template —uri Centosmirrors=[http://mirror.centos.org/centos-5/5/os/i386/](http://mirror.centos.org/centos-5/5/os/i386/) /var/www/CentOS/tree/
{% endhighlight %}

Tras un rato de procesado y verificación de la imagen ISO<->Árbol de instalación, tendremos los dos nuevos ficheros listos para su uso.

Utilizando un editor de texto, podemos editar nuestro fichero .jigdo y establecer la URL para nuestros paquetes (por ejemplo: [http://mirror.centos.org/centos-5/5/os/i386](http://mirror.centos.org/centos-5/5/os/i386))

Proporcionando estos dos ficheros a alguien, disfrutará de mejores descargas de nuestras ISO's que se reconstruirán en su máquina.

### ¿Cómo obtengo una ISO desde un fichero .jigdo? 

Fácil:

`jigdo-lite http://SERVIDOR/RUTA/file.jigdo`

JigDo descargará la descripción, buscará el fichero de plantilla, lo descargará y comenzará la creación de la imagen ISO, descargando los ficheros que no encuentre en la carpeta opcional que podemos indicarle.

Espero que te sea útil :)

* * * * *

[^1]:[del repositorio de Dag](http://dag.wieers.com/rpm/packages/jigdo/)

[^2]:Puede utilizarse para distribuir otro tipo de ficheros

Puedes ver una plantilla de ejemplo (.jigdo y .template) que cree para este artículo, y que actualmente, permite obtener un DVD de instalación de CentOS 5 a partir de sus RPM's individuales.

Puedes probarlo utilizando: jigdo-lite [http://alufis35.uv.es/deploy/Centos5-DVD.jigdo](http://alufis35.uv.es/deploy/Centos5-DVD.jigdo)

Or: jigdo-lite [http://alufis35.uv.es/deploy/CentOS51-DVD.jigdo](http://alufis35.uv.es/deploy/CentOS51-DVD.jigdo)

