---
layout: post
title: Fedora
date: 2008-06-14T05:00:00.000Z
author: Pablo Iranzo Gómez
tags:
  - Fedora
  - linux
  - foss
lang: es
categories:
  - FOSS
cover:
  relative: true
  image: Pantallazo-00.png
lastmod: 2025-02-12T09:34:18.229Z
---

### Introducción

[Fedora](http://fedoraproject.org/) es una distribución [Linux]({{<relref "2004-03-18-Que-es-Linux.es.md">}}) fruto del desarrollo de la extinta Red Hat Linux.

Red Hat Linux se readaptó al entorno empresarial proporcionado las opciones de soporte que las empresas buscaban en el software libre y del código de Red Linux, nacieron dos versiones, Red Hat Enterprise Linux, disponible para clientes con suscripciones (Red Hat no vende "licencias de uso", vende servicios de soporte, actualización en forma de suscripciones, puede verse como una especie de tarifa plana para acceder a todas las versiones de los productos subscritos, soporte, etc) válidas y Fedora Core, sucesor directo de Red Hat Linux.

Así pues el panorama quedaba del siguiente modo:

- Red Hat Enterprise Linux con ciclos de soporte de 7 años (parches, instalación, nuevo hardware, etc) que proporcionaban estabilidad a las empresas para mantener su sistema.
- Fedora Core, con ciclos de desarrollo de 6 meses, orientada a desarrollar e incluir tecnología punta en la distribución

Con el nacimiento de Fedora Core, Red Hat siguió colaborando (Hay una lista de contribuciones en <http://fedoraproject.org/wiki/RedHatContributions>) en el desarrollo de Linux a través de RHEL y de Fedora, así como a través de los proyectos "upstream" dedicando recursos económicos y humanos alrededor de la comunidad Fedora, así como de las colaboraciones desinteresadas de personas de todo el mundo (algunos de ellos se consideran [Embajadores](http://fedoraproject.org/wiki/Ambassadors))

Puedes consultar más información del proyecto en [http://fedoraproject.org/wiki/Overview](http://fedoraproject.org/wiki/Overview)

### Características

Fedora, como decíamos, aporta una distribución equivalente a la antigua Red Hat Linux (misma estabilidad, etc que hace que mucha gente la utilice en los servidores en entornos de producción donde antes utilizaba Red Hat Linux), pero que a diferencia de Red Hat Enterprise Linux, se enfoca a introducir más rápidamente las novedades tecnológicas disponibles.

Todo el software incluido en Fedora es Software Libre.

#### Anaconda

Una de las características que más tiempo llevan es Anaconda, el instalador que utiliza la distribución para las operaciones de instalación y actualización desde un medio de instalación.

Aparte del interfaz gráfico de instalación y una versión en modo texto muy similar dispone de una funcionalidad que lo convierte en único: La posibilidad de utilizar guiones de instalación que permitan automatizar completamente una instalación sin requerir interacción alguna por parte del usuario (ideal para instalar aulas de informática, colegios, lugares públicos tales como zonas de navegación, bibliotecas, etc).

Puedes consultar información al respecto en [Kickstart: instalaciones automatizadas para anaconda]({{<relref "2008-05-11-Kickstart-instalaciones.es.md">}})

#### Security Enhanced Linux (SELinux)

[SELinux]({{<relref path="2008-01-04-Security-Enhanced-Linux-SELinux.en.md" lang="en">}}) es un conjunto de módulos de seguridad para el kernel incorporados y activados por defecto en Fedora que confinan los programas en sus "compartimentos", impidiendo que realicen acciones que no deberían.

Por ejemplo SELInux, puede proteger un sistema con un Apache afectado por una vulnerabilidad impidiendo que un atacante pueda acceder a ficheros ya sea para leer o escribir que no debiera.

¿Y por qué no es mejor un entorno chroot? En un entorno chroot, se utilizan ciertos binarios y librerías de sistema para crear un sistema mínimo donde se ejecuta el programa, si un "atacante" comprometiera el servicio, cierto es que no entraría al sistema anfitrión, pero podría hacer de las suyas desde ese entorno "chroot" atacando a otras máquinas de la red interna.

SELinux fue desarrollado en colaboración con la Agencia de Seguridad Nacional Norteamericana (NSA) y permite varias políticas de funcionamiento, desde la estándar en Fedora/RHEL (targetted) que sólo gestiona ciertos servicios sin afectar al resto de los instalados, a la estricta con varios niveles de credenciales que impiden acceso a datos para los que no se ha sido autorizado.

#### LVM

[Gestor de Volúmenes Lógicos (LVM)]({{<relref "2007-03-09-Gestor-de-Volumenes-Logicos-LVM.es.md">}}) viene incorporado de serie y habilitado por defecto en Fedora desde hace ya muchas versiones, como novedad en la versión 9 es la inclusión de la posibilidad de utilizar volúmenes cifrados para todos los datos (hasta el momento se podía hacer con volúmenes que no fueran el de sistema, por ejemplo con /home), aumentando así la seguridad de los datos confidenciales que se llevan en dispositivos portátiles o PC's de cara a posibles [pérdidas o robos](http://news.google.es/news?hl=es&ned=es&q=datos++port%C3%A1til+robado&btnG=Buscar).

#### PackageKit

Es una capa de abstracción que permite crear herramientas de gestión de paquetes independientemente del sistema de paquetes utilizado, en el caso de Fedora, PackageKit viene integrado con yum y con el entorno gráfico para mostrar información de actualizaciones, progreso de las mismas, etc y que permitirá que se utilice la misma aplicación gráfica para la gestión del software conforme otras distribuciones lo vayan adoptando al igual que han hecho con el proyecto NetworkManager que permite
gestionar y configurar las conexiones de red de nuestro equipo (Cable, Wifi, VPN, Marcado, etc)

### Instalación

La instalación de Fedora se puede realizar de forma gráfica o en un interfaz en modo texto y debido a los requisitos de memoria del nuevo instalador, requiere un mínimo de 256Mb de RAM (se añadieron funcionalidades para poder recuperar la instalación en caso de fallo, que requirieron cargar más datos en el ramdisk inicial). En cualquier sistema actual no deberíamos tener ningún problema en instalarla.

La secuencia de imágenes muestra los pasos seguidos desde que metemos y arrancamos el DVD hasta que tenemos el sistema instalado y funcionando.

![Arranque DVD](Pantallazo-00.png)
![Arranque kernel](Pantallazo-01.png)
![Verificación disco](Pantallazo-02.png)
![Inicio instalador](Pantallazo-03.png)
![Selección idioma](Pantallazo-04.png)
![Selección teclado](Pantallazo-05.png)
![Inicialización disco](Pantallazo-06.png)
![Configuración red](Pantallazo-07.png)
![Zona horaria](Pantallazo-08.png)
![Password de root](Pantallazo-09.png)
![Clave sencilla](Pantallazo-10.png)
![Particionamiento](Pantallazo-11.png)
![Cifrado de discos](Pantallazo-12.png)
![Aplicar cambios en disco](Pantallazo-13.png)
![Formateo](Pantallazo-14.png)
![Preparación instalador](Pantallazo-15.png)
![Preparando paquetes](Pantallazo-16.png)
![Repositorios de software](Pantallazo-17.png)
![Verificando dependencias](Pantallazo-18.png)
![Empezando instalación](Pantallazo-19.png)
![Progreso instalación](Pantallazo-20.png)
![Acabando instalación](Pantallazo-21.png)
![Fin de instalación y reinicio](Pantallazo-22.png)
![Clave de cifrado de disco en arranque](Pantallazo-23.png)

Tras el primer arranque mostrará unas últimas páginas de configuración y creación de un usuario que nos dejarán en la pantalla que vemos a continuación para iniciar sesión en el equipo.

![Login al entorno gráfico](Pantallazo-24.png)
![Informe y envío de errores](Pantallazo-25.png)
![Actualizaciones pendientes](Pantallazo-26.png)
![Acceso como root para actualizar](Pantallazo-27.png)
![PackageKit realizando las tareas de actualización](Pantallazo-28.png)
![Actualización completada](Pantallazo-29.png)
![Password del protector de pantalla con posibilidad de dejar notas](Pantallazo-30.png)

### ¿Y ahora qué?

Fedora, como decíamos es una distribución de software 100% libre que incorpora gracias a la colaboración con Sun, etc una implementación libre de su máquina Virtual (IcedTea), así como plugins libres para ver videos de Shockwave Flash, etc.

Cuando intentamos visualizar algún formato propietario, Fedora nos informa de los problemas del uso de formatos propietarios y nos ofrece adquirir versiones licenciadas de los códecs para reproducirlos.

Para los casos donde la legislación lo permite, y siguiendo la información de <http://www.benavent.org/diario/2008/06/fedora-9-just-installed.html> y <http://hacktux.com/fedora>

Procederemos a:

- Instalar el repositorio de Livna en nuestra máquina visitando <http://rpm.livna.org> y presionando sobre el texto Fedora 9 repository RPM e instalándolo con nuestra clave de administrador.
- Instalar el repositorio de Adobe en nuestro equipo instalando desde la web de [Adobe](http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash) la selección del desplegable "YUM para Linux"

Ahora ya podremos instalar las librerías necesarias:

#### Flash

- Desinstalaremos con `yum remove swfdec-mozilla gnash-plugin` los plugins que instala por defecto Fedora
- Instalaremos con `yum install flash-plugin pulseaudio-libs libflashsupport`

#### Adobe Acrobat Reader

- Lo instalaremos con `yum install AdobeReader_esp`
- Activaremos el plugin en mozilla con:

```bash
#!bash
cd /usr/lib/mozilla/plugins/
ln -s /opt/Adobe/Reader8/Browser/intellinux/nppdf.so .
```

#### Audio/Video

- Instalaremos con `yum install exaile vlc xmms-mp3 xine xine-lib-extras-nonfree gstreamer-plugins-ugly gstreamer-plugins-bad gstreamer-plugins-good gstreamer-plugins-pulse`

#### Java SUN

- Desinstalaremos los paquetes de icedtea y openjdk instalados en el equipo
- Descargaremos de <http://www.java.com> el fichero RPM que proporcionan y lo instalaremos desde una consola lanzando el instalador con: `chmod +x jre-* ./jre-(VERSION)`

Se nos pedirá aceptar la licencia y al cabo de un rato lo tendremos instalado para activar el plugin en Firefox haremos:

```bash
#!bash
cd /usr/lib/mozilla/plugins
ln -s /usr/java/latest/plugin/i386/ns7/libjavaplugin_oji.so .
```

#### Drivers gráficos acelerados

En los repositorios de livna existen paquetes de la forma kmod-tarjeta-gráfica y xorg-x11-drv-tarjeta-gráfica que al instalarlos modificarán en nuestro sistema la configuración de X-Window System en `/etc/X11/xorg.conf` y que permitirán en caso de disponer una tarjeta sin drivers acelerados libres (como ocurre con las gráficas Intel que permiten disfrutar de AIGLX y los efectos gráficos de
Compiz sólo presionando un botón del panel de administración "Efectos de Escritorio".

En el caso de NVIDIA tuve que agregar las siguientes líneas a la sección "Files":

```conf
ModulePath "/usr/lib/xorg/modules/extensions/nvidia"
ModulePath "/usr/lib/xorg/modules"
```

#### Extras

Recomiendo instalar `yum-presto` y `yum-fastestmirror` para que yum utilice rpm's diferenciales y por otro lado utilice el mirror más rápido para la descarga, todas las funciones se harán de forma transparente y además, disfrutaremos de mayor velocidad :-)

Y ya tendremos el sistema listo y preparado para funcionar...

PD: Si puedes y estás de acuerdo, instala el paquete "smolt", permite enviar un informe de tu hardware a [http://smolt.fedoraproject.org](http://smolt.fedoraproject.org/) que facilita saber qué tipo de hardware hay y se está utilizando y en caso de que algo no te funcione puedes notificarlo. Siempre es más fácil que se desarrolle para mejorar el soporte sobre el hardware que se está utilizando ¿no?

{{<disfruta>}}
