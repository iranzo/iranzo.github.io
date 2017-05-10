---
layout: post
title: (mi) Evolución con Linux
date: 2008-06-03T22:32:07Z
author: Pablo Iranzo Gómez
tags:  linux , fedora, desktop
lang: es
---

## Antecedentes

Llevo gastando Linux desde hace bastantes años...

Primero empecé con una copia de [Slackware](http://www.slackware.com/) 1.x que venía con la revista Sólo programadores cuya instalación consistía en descomprimir un fichero "zip" sobre un disco FAT16 (en aquella época tenía un disco duro de 80 Mb (sí, Megabytes) en un 386DX a 40 Mhz y la instalación venía a ocupar unos 15 Mb descomprimida.

Dicha instalación hacía uso de un sistema llamado UMSDOS que permitía, una vez cargado linux (mediante loadlin) hacer uso de las características de un filesystem de Linux cuando en realidad había por debajo un sistema FAT.

No recuerdo en aquella época cómo había oído hablar de Linux pero algo ya me sonaba pues me decidí a comprar dicha revista por el contenido del cd-rom (no había internet con tanta facilidad de acceso como hay ahora ;-) )

Ya en la facultad y gracias a Jose Mª, y al uso que hice del servidor de correo de la facultad de Físicas, pudimos probar en un equipo "viejo", un P100 con 32 Mb de RAM y un disco duro, creo recordar que de 500 Mb una instalación de [Red Hat](http://www.redhat.com/) Linux 5.0, que se convirtió en el punto de partida para poder practicar otras habilidades relacionadas con el mundo de Linux: servidores de correo, servidores web, etc.

Durante muchos años esta máquina fue actualizada hasta creo recordar que Red Hat Linux 9 ó 9.2, momento en el que con la confusión con el cambio a Fedora, pasó a ser una [Debian](http://www.debian.org/) 3.0

Durante aquella temporada, en casa hacía uso de SuSE Linux, principalmente porque era la forma de probar que las traducciones que hacíamos se veían bien durante el proceso de instalación, configuración,
etc

A la par que el servidor en la universidad pasaba a ser Debian 3.0, en mi pc de casa aterrizaba también Debian, primero en su versión estable y rápidamente en su versión "testing" con la que iba probando las nuevas versiones de software que venían. Como no, también pasé una temporada por Ubuntu pero la volví a actualizar a Debian.

## ¿Qué me parece cada distribución a día de hoy?

- [Slackware](http://www.slackware.com/): Tengo constancia de mucha gente que la utiliza, personalmente sólo estuvo en mis primeros pasos con Linux y sigue teniendo muy buena reputación, aunque como he dicho, hace años que no la utilizo.
- [Red Hat Linux](http://www.redhat.com/): Ya obsoleta, me introdujo en el mundo del manejo de dependencias, actualizaciones. Siempre me encantó [RHN](https://rhn.redhat.com) como herramienta que me permitía ver vía web el estado de todos mis sistemas, su estado de actualizaciones, así como algo de información de inventario. Pasó a ser Fedora y Red Hat Enterprise Linux poco después de la 9.2
- [SuSE](http://www.suse.de/): Durante el periodo de la 5.0 a la 8.0 que era cuando más la utilicé, me proporcionaba en un conjunto de discos unos buenos manuales y más software del que quisiera jamás :-). A su favor, era muy sencilla de configurar, detectaba muy bien el hardware y hasta funcionaba ;-). En su contra, toda la configuración en aquel momento venía en un fichero rc.config que SuSEConfig aplicaba sobre todo el sistema, destruyendo cualquier cambio personalizado que se hubiera podido realizar (lo que permitía arreglar las cosas si habíamos metido la pata).
- [Debian](http://www.debian.org/): Más espartana a la hora de instalarla pero ideal para equipos antiguos, Mientras SuSE necesitaba 80 Mb de RAM para poder cargar el instalador, Debian, funciona en equipos con 32Mb (aún tengo un Pentium a 75Mhz con 32 Mb de ram haciendo de router en el despacho de un amigo). No es que sea rápido, pero lleva funcionando bien muchos años. Debian tiene a su favor que los paquetes preguntan unas cuantas cuestiones básicas que permiten dejarlos configurados a la vez que se instalan, que como contrapartida hace que haya que estar pendiente de la instalación.
- [Ubuntu](http://www.ubuntu.com/): Una Debian con ciclos más cortos entre versiones, que permitía probar nuevos desarrollos para escritorio,etc. No hay demasiada diferencia con respecto a una Debian testing (que tampoco me resultó tan inestable) y de hecho, ante las dudas de un sistema corrupto solía alternar entre ellas para actualizar las versiones y con ello posibles paquetes corruptos. Dejé de gastarla por motivos ideológicos, personalmente le agradezco la difusión del software libre entre el gran público, pero a la vez, difundir el software libre con los "vicios" que venía arrastrando el software privativo (como no tener conciencia de que por qué es malo un controlador binario o los formatos propietarios) es, a mi parecer, un peligro a la larga para el software libre. A modo de ejemplo, hace años gasté casi el triple en un adaptador USB Wireless para disponer de uno con controlador libre (Zydas 1211) que me permitía utilizar dicho adaptador tanto en Linux x86 como x86_64 como en PowerPC. Mucha gente se contentaba con usar el ndiswrapper que utilizaba su controlador binario de Win32 y se encontró con la desagradable sorpresa de que en sistemas de 64 bits no era operativo. A corto plazo hace la vida fácil, a largo plazo, te encadena.  Por otro lado, Ubuntu ha dañado bastante al proyecto Debian contratando a muchos de sus programadores sin colaborar excesivamente liberando nuevo código aprovechable por otras distribuciones.
- [Gentoo](http://www.gentoo.org/): Gentoo se hizo muy famosa hace unos años porque supuestamente optimizaba el rendimiento sobre el hardware al compilarse específicamente sobre el hardware que se tenía y en base a otro software instalado. Personalmente sólo intenté instalarla durante dos días (no me compensaba el tiempo compilando con respecto a la supuesta mejora de rendimiento). El mejor punto es que como el proceso de instalación es manual, se aprende mucho acerca de cómo funciona un sistema con Linux y lo que otras distribuciones "esconden". Tienen muy buena documentación :)
- [CentOS](http://www.centos.org/): CentOS (Community Enterprise Operating System) es una comunidad que toma los códigos fuente de Red Hat Enterprise Linux ([ftp://ftp.redhat.com](ftp://ftp.redhat.com/)) y los compila tras eliminar todas las "marcas registradas" ofreciendo una distribución que tiene como objetivo ser compatible a nivel binario con RHEL, lo que la convierte en el campo de pruebas ideal para probar cosas que luego se integrarán en entornos de producción ( o por qué no... para practicar nuestras habilidades con una de las distribuciones más extendidas a nivel empresarial). Además de CentOS existen otras distribuciones que hacen una labor parecida como Scientific Linux, etc
- [Red Hat Enteprise Linux](http://www.redhat.com/rhel/): Una de las distribuciones más difundidas en entorno empresarial, [colaboradora activamente](http://fedoraproject.org/wiki/RedHatContributions) en el desarrollo de Linux a través del proyecto [Fedora](http://fedoraproject.org/) y que utiliza el sistema de paquetes RPM para la gestión de su software, uno de los más extendidos por otros fabricantes para proporcionar sus aplicaciones, controladores, etc.
- [Fedora](http://fedoraproject.org/): Evolución de Red Hat Linux (sin Enterprise) que sigue recibiendo el apoyo de Red Hat para que como comunidad desarrollen la distribución. Se ha caracterizado por introducir novedosas mejoras tecnológicas. Una de las quizás más controvertidas fue la introducción de [Security Enhanced Linux (SELinux)]({filename}2008-01-04-Security-Enhanced-Linux-SELinux.markdown), que inicialmente presentó algún problema para los usuarios pero que hoy en dia proporciona mayor seguridad de forma casi transparente.

## ¿Que me motivó?

- Slack, la primera que tuve debido a haberla conseguido con Sólo Programadores
- Red Hat Linux, la primera con un instalador fácil que conseguí y con la que estuve muchos años, se me hacía incómodo el manejo de dependencias en las actualizaciones, pero no era excesivamente grave... y en aquella época, era algo común entre las distribuciones :)
- SuSE Linux: Poder probar las traducciones del software y ver a qué se refería el manual (en papel).
- Debian: reducido tamaño: miles de paquetes que permitían instalar sólo lo mínimo... lo hacían complicado para usuarios noveles que se podían asustar al ver tantos paquetes pero realmente permite instalar programas sueltos sin tener que ir empaquetados junto con otro software que no se va a utilizar.
- Ubuntu: ciclos más cortos que Debian que permitían probar software más actualizado.
- Debian (de nuevo): Cifrado LVM. Por motivos laborales, mi portátil con Red Hat Enterprise Linux utiliza cifrado de la carpeta /home, algo que veo muy útil de cara a proteger información confidencial en caso de robo. Cuando tuve que reinstalar mi PC debido a un cambio de disco, aproveché la oportunidad para cifrar también mi disco y me encontré con que en aquel momento, sólo Debian (entre Debian, Ubuntu, Fedora, CentOS) era capaz de cifrar "TODO" el sistema de ficheros (excepto /boot).
    Mientras CentOS y Fedora permitían cifrar un volumen (con cryptsetup), Debian incorporaba en Debian Installer todo lo necesario, incluso mensajes que recomendaban cifrar el espacio de intercambio si se cifra algún otro volumen para prevenir posibles claves almacenadas en swap.
- CentOS: Posibilidad de usar SELinux y [Cobbler](http://cobbler.et.redhat.com/) (un software libre para gestión de infraestructuras de instalación), así como estar basada en Red Hat Enterprise Linux que me permitía practicar habilidades :)
- Fedora: Desde la versión 9 soporta cifrado completo como hacía Debian y como añadido lleva incorporado de serie SELinux, una característica que como ya he comentado me atrae por su filosofía. Además disponía de Firefox 3 (que iba mucho mejor en mi portátil con RHEL 5 que FF 1.5). Además, tiene ciclos cortos de desarrollo lo que permite también probar nuevas características y la verdad es que hay bastantes proyectos interesantes bajo el paraguas de Fedora ([smolt](http://smolt.fedoraproject.org/), directory server, FreeIPA, etc)

## En resumen

A día de hoy estoy utilizando Fedora 12 con LVM cifrado, Gnome como entorno, Firefox como navegador, gnome-terminal como consola, pidgin como programa de mensajería instantánea, xchat como cliente de IRC, k3b para grabación de DVD's y CD's y para contadas ocasiones LyX y OpenOffice para documentos. Para la parte multimedia, utilizo Exaile como reproductor (muy parecido a Amarok) y VLC como reproductor de vídeo.

En los servidores tengo una mezcla de Debian, CentOS y RHEL, moviendo los basados en Debian a CentOS por la mayor experiencia que tengo en la creación y gestión de paquetes RPM y la automatización de instalaciones([Kickstart: instalaciones automatizadas para anaconda]({filename}2008-05-11-Kickstart-instalaciones.markdown)).

En el blog de [Pere Benavent](http://www.benavent.org/diario/2008/06/fedora-9-just-installed.html) tienes información para terminar de afinar la instalación de Fedora 9 siguiendo sus instrucciones.
