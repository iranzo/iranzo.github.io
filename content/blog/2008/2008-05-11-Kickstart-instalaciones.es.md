---
layout: post
title: Kickstart - instalaciones automatizadas para anaconda
date: 2008-05-11T12:00:00.000Z
tags:
  - linux
  - kickstart
  - automation
  - unattended
  - foss
lang: es
categories:
  - FOSS
lastmod: 2023-08-25T09:48:47.059Z
---

### Instalar linux

Hoy en día todas las distribuciones suelen disponer de un instalador gráfico que mediante un sencillo asistente permiten particionar el sistema, seleccionar los paquetes, instalarlos y configurarlos.

El problema viene cuando en lugar de instalar un PC en 40 minutos, tenemos que instalar 20, cada uno de esos pc's, aunque podamos ir con varios discos a la vez, nos va a llevar más de 40 minutos hacer la instalación, por tener que ir siguiendo el asistente, escogiendo opciones, paquetes, configurando cosas, etc.

### Anaconda

Anaconda es un instalador basado en Python que incorpora en su base, un instalador en modo texto, y uno gráfico que entre sus muchas funcionalidades, incorpora la instalación en base a guiones llamados
kickstart.

### El archivo kickstart

Un archivo kickstart es un fichero de texto plano, que puede se le proporciona a Anaconda, como tal, puede ser un archivo que tengamos grabado en el disco de instalación, en otro medio de almacenamiento, o
incluso en un servidor remoto.

El hecho de que se albergue en un servidor remoto, abre nuevas posibilidades, como que por ejemplo, el archivo kickstart se genere dinámicamente para cada equipo, en base a perfiles de equipo, parámetros
opcionales, etc.

#### Estructura

La estructura de un kickstart podría ser:

```bash
#!bash
## Queremos instalar un sistema
install
## Queremos reiniciarlo al acabar la instalación
reboot ## Queremos utilizar como idioma Español
lang es_ES.UTF-8 ## nivel de registro
logging —level=info ## Autoconfigurar la red por dhcp sin soporte IPV6 y con nombre de host equipo
network —bootproto=dhcp —onboot=on —noipv6 —hostname=equipo ## teclado en español
keyboard es
## Zona horaria CET/CEST
timezone Europe/Madrid
## Utilizar shadow passwords y soporte md5
auth —useshadow —enablemd5
## Activar cortafuegos y permitir conexiones ssh externas
firewall —enabled —ssh
## Desactivar asistente tras la instalación (creación de cuentas de usuario, tarjeta de sonido, etc)
firstboot —disable
## Iniciar en modo activo Security Enhanced Linux
selinux —enforcing
# Instalar desde esta url (puede ser también un cdrom, ftp, nfs, etc)
url —url=http://1.1.1.1/cblr/links/CentOS51-i386
# Configurar el entorno gráfico del siguiente modo: Gnome a 1024x768 con 16 millones de colores y arrancarlo al iniciar el sistema
xconfig —defaultdesktop=GNOME —depth=24 —resolution=1024x768 —startxonboot
#Establecer la contraseña de root
rootpw —iscrypted $1$BljcG$Qz6eMZghIDmf8E7starqui.
#Activar una contraseña para grub
bootloader —location=mbr —md5pass=$1$BljcG$Qz6eMZghIDmf8E7staqUx.
#Activar estos servicios al iniciar en caso de no estarlo de forma predeterminada
services —enabled=setroubleshoot,funcd,smolt,NetworkManager
#Establecer un repositorio adicional para actualizaciones, paquetes extra, etc
repo —name=CentOS-updates —baseurl=http://1.1.1.1/cobbler/repo_mirror/CentOS-updates
#Particiones
#Borrar todas e inicializar etiquetas en hda (primer disco ide)
clearpart —all —initlabel —drives=hda #Crear una partición para arranque de 100 mb de tipo ext3
part /boot —fstype ext3 —size=100 —ondisk=hda #Crear un grupo de volúmenes en hda y llamarlo "Casa"
part pv.100000 —size=1 —grow —ondisk=hda
volgroup Casa —pesize=32768 pv.100000
#Crear una partición de Swap de 1Gb en el grupo Casa
logvol swap —fstype swap —name=Swap —vgname=Casa —size=1024
#Crear el volumen raíz de 4Gb
logvol / —fstype ext3 —name=root —vgname=Casa —size=4096
#Crear un volumen para el home de 1 Gb
logvol /home —fstype ext3 —name=home —vgname=Casa —size=1024 #Paquetes a instalar
%packages
@ Base
@ gnome-desktop
openssh-server
openssh
screen
mc
joe

```

Con esta estructura, el sistema quedará instalado y configurado de forma automática, se habrá detectado el hardware y cargado su soporte en caso de ser detectado y disponer los controladores apropiados.

### Dándole una vuelta de tuerca al kickstart

#### Scripts de Pre y Post instalación

Además de la información mostrada anteriormente, un fichero kickstart puede contener scripts que se ejecuten antes de comenzar la instalación (con el hardware y red ya operativos) y scripts que se ejecuten tras la instalación.

Un uso típico es determinar dinámicamente la estructura de discos en base al tamaño del mismo, o incluso establecer configuraciones RAID si se detecta más de un disco duro en el sistema, o mayor de cierta capacidad.

#### Pre instalación

Por ejemplo, la forma típica sería crear el esquema de particiones como hemos hecho arriba, pero utilizando comandos "echo", por ejemplo:

```bash
#!bash
%pre
#Obtener el primer disco del sistema y el total de discos
set $(list-harddrives)
let numd=$#/2 # Numero de discos
d1=$1 # Dispositivo del primer disco
S1=$2 # Tamanyo del primer disco (y sucesivamente)
DISCO=$d1
ORGANIZACION="Casa" echo "clearpart —drives=$DISCO —all —initlabel" >> /tmp/part-include
echo "part /boot —fstype ext3 —size=100 —ondisk=$DISCO" >> /tmp/part-include
echo "part pv.100000 —size=1 —grow —ondisk=$DISCO" >> /tmp/part-include
echo "volgroup $ORGANIZATION —pesize=32768 pv.100000" >> /tmp/part-include
echo "logvol swap —fstype swap —name=Swap —vgname=$ORGANIZATION —size=1024"
>> /tmp/part-include
echo "logvol / —fstype ext3 —name=root —vgname=$ORGANIZATION —size=4096" >> /tmp/part-include
echo "logvol /home —fstype ext3 —size=1024 —name=home —vgname=$ORGANIZATION" >> /tmp/part-include
```

Se obtendrán los datos de los discos detectados por anaconda y se irá escribiendo esa información a un fichero temporal que luego, lo incluiremos, reemplazando la parte del perfil donde antes definíamos las
particiones por :

```bash
%include /tmp/part-include
```

Así, para cada sistema podemos definir una organización basada en valores como la IP obtenida, etc y que sería procesador por un script, por ejemplo en PHP en el servidor.

#### Post instalación

Un script de instalación tiene una ventaja sobre un script de pre instalación, y es que podemos ejecutarlo sobre el sistema instalado o sobre el entorno de instalación, de forma que podemos copiar archivos generados en el pre (como los logs), copiar archivos del medio de instalación si es un CD, NFS, etc y luego actuar sobre nuestro sistema, por ejemplo:

```bash
#!bash
%post
#Sincronizar hora del sistema
echo "Sincronizar hora del sistema"
ntpdate pool.ntp.org
hwclock —systohc
```

### Generación dinámica

Dada la potencia de Linux y la habilidad de ejecutar scripts de pre instalación y post instalación, podemos configurar un sistema mediante estos scripts de la misma forma que lo haríamos en un sistema de forma manual, podemos dejar un sistema perfectamente configurado. Cierto es que a priori, nos llevará más tiempo ponerlo en marcha mediante este sistema que utilizando cuatro o cinco opciones en un menú, pero una vez hecho, tardaremos el mismo tiempo en instalar 1 sistema que 1000 con la ventaja
de que ya no tendremos que estar delante para verificar toda la operación.

Si tomamos como generador un script en php, albergado en nuestro servidor web, podemos hacer que una máquina al instalarse, envíe información de la MAC que está utilizando para instalarse con el parámetro "`kssendmac`" de anaconda y en base a ella, generar distintos perfiles según esa máquina esté pensada para servidor web, para estación de trabajo, para servidor de correo, o para cluster de almacenamiento, permitiendo que en cualquier momento la reaprovisionemos a un nuevo con la mínima inversión de tiempo por nuestra parte.

Existen diversos sistemas que facilitan estas tareas y permiten llevar un control de las máquinas que instalamos, etc que comentaremos más adelante.

### Información adicional

Hasta que nos familiaricemos con la sintaxis, es conveniente recordar que en los sistemas basados en Fedora o Red Hat, existe la utilidad system-config-kickstart que es un editor gráfico de archivos kickstart que nos puede servir de punto de inicio para empezar a modificarlos con nuestros scripts y adaptaciones personales.

- [Opciones soportadas en RHEL5](http://www.redhat.com/docs/manuals/enterprise/RHEL-5-manual/Installation_Guide-en-US/s1-kickstart2-options.html)
- [Opciones soportadas en Fedora](http://fedoraproject.org/wiki/Anaconda/Kickstart)
- [Configurador kickstart web](http://www.linux.kaybee.org:8080/demo/hosts/index.html)
  {{<disfruta>}}
