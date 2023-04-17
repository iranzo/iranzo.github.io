---
layout: post
title: Montar un router con la idea de wireless
date: 2003-06-18T21:39:00.000Z
tags:
  - linux
  - wireless
  - router
  - firewall
  - foss
lang: es
modified: 2023-04-17T21:53:19.856Z
categories:
  - FOSS
  - tech
---

### Introducción

Un nodo nos permitirá unir a personas conectadas desde sus tarjetas inalámbricas. Un nodo tiene que ser el punto de unión entre distintos clientes y a su vez enlazar con otros nodos para así crear una red.

En el caso de las redes inalámbricas, existen varias aproximaciones.

Un nodo puede ser un aparato denominado Punto de Acceso o por sus siglas en inglés AP (Access Point) que contiene en su interior un interfaz wireless y una conexión Ethernet RJ45 para enlazarlo o bien con un equipo o con una red.

Un aparato que realice dichas funciones no es especialmente asequible además de que está bastante limitado...

La solución más aceptada es utilizar un PC para que haga de nodo, teniendo así muchísima más flexibilidad a la hora de configurarlo (más problemático también, no es "enchufar y listo" como con un AP de hardware).

Las tarjetas a la venta en el mercado tienen tres modos de operación:

1. Ad-hoc: Es el modo estándar, en este tipo de modo de operación, es el equivalente a las redes con Windows en las que se trabaja de igual a igual, todos son clientes y servidores.
1. Managed: un servidor independiente (un AP) es el lugar al que se conectan todas las demás tarjetas inalámbricas, el AP gestiona todas las conexiones, enrutados, etc.
1. Master: Es el modo en el que trabaja el AP del punto anterior para que las tarjetas puedan trabajar como "Managed".

En redes con Windows sólo es posible trabajar en los dos primeros modos, el Ad-Hoc y el Managed, para ello, como se ve, es necesario un AP por hardware que trabaje como Master al que las tarjetas que trabajan en Managed se puedan conectar. Y este es el punto en el que Linux marca la diferencia... con Linux, existe un controlador (hostap) para las tarjetas basadas en Prism2 (p.ej. las Conceptronic). Con Linux y con esos controladores, es posible poner en modo Master las tarjetas de red
(generalmente PCMCIA con un adaptador PCI para equipos de sobremesa) y de ese modo, hacer un AP por software.

Quisiera expresar mi agradecimiento a Ghfjdksl de #wireless, a Jorti de #guadawireless y a Hilario y a Hawkmoon de #valenciawireless por la ayuda prestada para montar este nodo. Saludos también al resto de gente de #valenciawireless por sus larguísimas tertulias ;P

Hardware

Para la creación del nodo, necesitaremos unos componentes de hardware tanto de software.

En la creación del nodo de La Creu Wireless, el hardware es el siguiente:

- Placa AT Pentium 120
- 500 Mb HD
- 420 Mb HD (porque lo tenía a mano, pero posiblemente lo quite... lo que menos quiero es que el ordenador haga más ruido...)
- 64 mb Ram (iba a tener 16, pero a última hora conseguí más...)
- Tarjeta gráfica ATI Mach 64 Pro Turbo PCI
- Ethernet ISA P'n'P Intel PRO 10/10+
- Ethernet PCI basada en Realtek 8029 (10 mbps)
- Ethernet PCI basada en Realtek 8139 (10/100)
- Ethernet ISA P'n'P Compatible con NE 2000
- Tarjeta wireless todavía no la tengo, utilizo la ISA P'n'P compatible con NE2000 como si fuese la wireless (A la que en la actualidad tengo conectado un USR2450 en modo bridge con LinuxAP)
- Tarjeta de sonido SB 16 P'n'P (no se para qué porque no la tengo conectada ni nada, pero el caso es que como la tenía....)
- CD-ROM (instalé desde disco duro porque no tenía cd-rom en ese momento... pero bueno.. ahora sí ;))
- RJ45 (latiguillos), uno directo para conectar al módem y a la eth0 y luego tres cruzados para conectar a cada uno de los pc's sin necesidad de hub... si tienes hub, pues todos directos y listo...

Se aceptan regalos ;) (Portátiles incluidos... ;) )

Volviendo a la realidad... memoria le sobra por un tubo, pero bueno, puestos a ponerle, pues se le pone más :)

Disco duro me gustaría ponerle más, ya que como lo tengo que tener encendido todo el día para que sea un nodo "fijo", pues aprovechar y dejar las largas descargas bajándose en ese ordenador.

Lo de las tarjetas de red puede asustar al principio... pero bueno, tiene una clara explicación... en casa tengo dos ordenadores y ahora con el nodo tres, la conexión a Internet requiere otra tarjeta de red y no me permite compartirla directamente conectándola a un HUB, así que me parecía algo tonto el tener que gastarme dinero en un HUB cuando las tarjetas de red ya las tenía...

Así que el montaje de la falla es el siguiente:

- Intel Pro ISA 10/10+: eth0 conectada a mi conexión a Internet
- Realtek 8139 (10/100): eth1 conectada a mi equipo principal (también con otra tarjeta 10/100, así que red local a 100 mbps ;) )
- Realtek 8029: eth2 conectada al otro pc que tengo en casa (también con una ethernet a 10 mbps)
- Isa P'n'P NE2000: eth3 hace las labores de wireless hasta que tenga una de verdad (la utilizo para conectar otro equipo y hacer las pruebas como si estuviese conectado por wireless), en su momento será utilizada para conexiones "temporales" por cable, siendo entonces eth4 la wireless "real".

Realmente con un HUB podría quitar dos tarjetas de red del ordenador (ya que el ordenador principal y el secundario irían conectados al hub y no serían necesarias las tarjetas correspondientes y sólo utilizaría la otra que quedase para Internet y la otra para conectar al HUB (si mi conexión me permitiese hacerlo, hasta podría conectar mi módem al HUB y ahorrarme otra tarjeta.. pero bueno, el caso es que no se puede...)

Como se puede ver, no digo nada de ratón ni de monitor... el caso es que realmente no es necesario porque para hacer la instalación inicial se hará conectándolo a otro monitor, pero una vez puesto en marcha no hará falta para nada, de hecho hasta el teclado sobraría, pero como he dicho que es un P120 con AT, en los casos en los que tengo que apagar o reiniciar la máquina necesito algo que no implique un reset total (o sea, necesito tres teclas: CTRL-ALT-SUPR).

El teclado que tengo es uno de 84 teclas que será como un teclado normal pero sin el bloque numérico y sin el bloque de av-pag, etc de tamaño, tiene sólo dos leds, Bloq may y bloq despl, pero lo dicho... sobra ;)

Ahora el ordenador es un P200 MMX con 128 Mb de RAM, las tarjetas son una Intel Pro ISA 10/10+, una SMC 100, 3Com 3c509 y NE2000, discos tiene uno de 10 Gb, y otro de 20, configurados como:

- 128 Mb Swap
- 10 Mb boot
- 3 Gb sistema, usuarios
- Resto = 26 Gb para descargas diversas... (pero con ánimo educativo, no os vayais a pensar...)

Ahora vamos a la configuración del software...

### Sistema Operativo y Paquetes

El primer paso previo a todos, es que una vez configurado el hardware para que no se queje (IRQ's, puertos IO, etc) (si la placa es realmente P'n'P no habrá problemas pero la mía aunque es P'n'P dio algunos problemas así que... ajo y agua...) Si has de comprar tarjetas y puedes, cómpralas PCI y mejor todavía si compras un HUB porque así no tienes que tener el ordenador rellenito en todas sus ranuras con ethernets ;).

Lo primero a configurar entonces es la BIOS.

Como cada BIOS es de un papá y de una mamá distintos (aunque a veces la mamá sea siempre Award o Ami), daré la explicación general y que cada uno se las apañe con el manual de su placa base para hacer lo que digo...

PD: Si no sabes lo que es la BIOS, olvídate de seguir... esto no está hecho para tí... Mucho mejor que veas esto.

Configura las tarjetas en el orden que quieras, pero ten bien claro cuál será cada una (si son todas iguales pues será más problemático, pero no por ello imposible).

Primero pon el ordenador en fecha y hora, y en la opción que pone "Halt on" ponle que nada, es decir, que bajo ningún concepto el ordenador no arranque (por ejemplo por falta de teclado, falta de monitor, etc porque al fin y al cabo luego no lo tendrá...)

En la BIOS dile que de PNP su tía... le dices que el sistema operativo no es P'N'P y que no se maree (puedes probar diciendo que sí, no debería ser muy tortuoso y si lo es, siempre lo puedes cambiar otra vez ;))

Como dispositivo de arranque se le pondrá primero la disquetera, pero en el momento en que todo esté configurado, se pondrá fijo siempre el disco duro.

Si la placa es ATX, dile que tras un corte de luz, que se encienda sola... así evitarás los tiempos de apagón del nodo al mínimo.

Salva todos los cambios y reiniciará el ordenador... En mi caso, como no tenía en un primer momento ni disquetera ni cd-rom, aproveché que el disco duro contenía un Windows 95 y bajé la imagen de CD-ROM de instalación de Internet de Debian Potato, la convertí del .ISO a carpetas y directorios normales y la guardé por la red en el segundo HD del ordenador.

La imagen iso son unos 30 Mb y la descargué de la página de debian. (woody_netinst-20020626-i386.iso)

La decisión de tomar "Debian" como sistema a instalar fue sencilla (lo de que tenía que ser Linux estaba cantado por lo explicado en la introducción):

- **Red Hat Linux**: Está muy bien, de hecho es con la que más experiencia tengo, la tengo funcionando desde el año 96 en un servidor y me va genial, poquitos problemas excepto actualizaciones, etc (aunque con las nuevas herramientas es muy fácil). Las actualizaciones, en el momento de lanzarlas, si hay muchos clientes de pago, pues a los que no pagamos, pues ajo y agua y a esperarse a que no esté tan saturado... el formato de redhat, el RPM es el estándar más extendido. (Se puede bajar de internet en versión libre, llamada Fedora Core, o bien en clónicas basadas en RHEL).
- **SuSE Linux**: Está muy bien, si compras la distribución, tienes muchos cd's con programas, manuales, etc Bastante bien adaptada al Español (je, je), etc... Pero no se puede bajar la versión completa de internet porque tiene programas con licencias de distribución que no lo permiten, sólo si se compra. Utiliza el RPM que es un punto a favor, pero en contra es que no es compatible al 100% con las estructuras de directorios y funcionamientos de Red Hat, así que no hay forma de distinguir si ese
  RPM funcionará bien o no con SuSE. El peor inconveniente es la gran cantidad de recursos que necesita, tanto de RAM para la instalación como para el almacenamiento en disco (la mínima son unos 500 mb (pero mínima mínima mínima...)). La ventaja es que la configuración es toda en modo gráfico, con una autodetección genial, etc. Tenía experiencia con ella tanto de gastarla en casa como distribución linux, en la uni en un servidor como de haber colaborado en su traducción de manuales y de software de configuración.
- **Debian**: No tenia ni puta idea de ella, una vez que la intenté instalar casi me da algo con el programa de selección de paquetes a instalar (dselect de la Potato). La instalación es en modo texto. Tiene un sistema de actualización/instalación bastante bueno en modo texto. la decisión fue usar Debian... de paso que aprendía a gastarla, al ser en modo texto, tenía el aliciente de que facilita su administración remota (recordemos que el ordenador una vez instalado mínimamente no iba a tener ni teclado ni ratón ni monitor ni naa de na... excepto el cable de la luz y cuatro cables RJ45 para las tarjetas de red :))

Vale, como ya he comentado, en el nodo, en el momento de su creación no tenía ni disquetera ni CD-ROM, así que se copiaron los archivos a una instalación de Windows 95, se reinicia en modo-msdos y una vez en el, se cambia al directorio donde se extrajo la imagen de cd y se ejecuta el programa de instalación...

Si tienes grabadora y cd-rom en el nodo pues lo más sencillo es bajar la iso, grabarla a un CD y arrancar desde el CD-ROM (en la bios se puede configurar esa opción).

Como ya he dicho, la imagen de instalación es una NETINST, es decir, 30 mb mínimos que se utilizan para una vez respondidas unas preguntas copiar un sistema básico que se puede conectar a Internet y seguir bajando el resto de Internet... (Tengo una conexión a 128 kbps, así que que nadie me diga que es una locura porque es viable...)

Cuando yo hice la instalación, la netinst más habitual era la potato, pero hace nada que pasaron a Woody (3.0), el caso es que más o menos son parecidas y de hecho una vez instalé lo mínimo hice el cambio a Woody usando el programa que lleva para hacerlo...

No voy a explicar la instalación de Debian porque esto habla de configurar un nodo, no de instalar Linux, pero bueno, básicamente consistió en particionar el HD, crear una partición swap de 40 Mb (ya dije que mi disco duro era pequeñito..) y una de datos de 472 Mb como ext3 Es conveniente pensar un nombre para el nodo...la norma habitual, al menos en universidades, etc es ponerle nombres de estrellas o de científicos, pero bueno... Cada uno que le ponga el que le de la gana...

Se configura el teclado, la tarjeta de red (como tengo Internet por tarjeta de cable fue tan sencillo como decirle que cargase los módulos de las tarjetas de red (en el caso de las ISA indicando también la IO) y luego en la que estaba conectada a Internet, decirle que hiciese configuración automática por DHCP y ya estaba la conexión funcionando...

En la selección de paquetes puse lo mínimo mínimo, así que al ratito y tras un rearranque, me pidió asignar contraseñas y crear un usuario (no es recomendable estar siempre como administrador para trabajar con Linux...)

Vale, llegados a este punto, tenemos ya el Linux instalado y tenemos delante la consola para iniciar sesión en el sistema. Vamos a necesitar varios programas además de los básicos para trabajar con el nodo... si nos gusta Linux, pues nos gustará instalar alguno más, pero bueno... por un lado están los básicos y los recomendados...

Como lo que estoy haciendo es explicar la configuración de lo que yo hice con mi ordenador, pues allá vamos:

Para la wireless hace falta el wavemon que es un monitor de estado de la tarjeta y el zebra para enrutar dinámicamente.

En mi caso, ya que ese ordenador iba a hacer de medio "servidor" en mi casa, pues me interesó ponerle:

- samba: para compartir archivos e impresoras en un formato compatible con Windows y así poder luego bajar archivos de un ordenador a otro (del principal al nodo) mediante el entorno de red
- pptpd: para permitir conexiones VPN, permite que desde internet (o en este caso, desde la wireless), se pueda conectar con el nodo, y se asigne otra dirección IP que permita hacer otras cosas que de normal no se podría... En mi caso, tengo limite de descarga en Internet y aunque por el momento no lo apliquen no quita que pudieran hacerlo... causa pues de que no comparta mi acceso a Internet a no ser que conozca directamente al equipo que se conecta... es decir, una vez conectado mediante la wireless, hará una conexión VPN desde su Windows o su Linux al nodo y mediante un login y un pass tendrá acceso a Internet a través del nodo, que de otra forma no tendría...) (un nodo no tiene que necesariamente tener acceso a Internet, pero es recomendable para unir los nodos y facilitar la integración en la red, etc)
- webmin: es un programa hecho por caldera y que funciona en multitud de plataformas y distribuciones, permite muy fácilmente configurar desde un navegador muchísimas cosas del sistema. No digo que vaya a reemplazar a la configuración en modo consola, pero para muchas cosas es muchísimo más fácil hacerlo desde navegador que tener que entrar, etc...
- Otros paquetes instalados (muchos de ellos se instalan solitos como dependencias a los ya instalados...):

A ver, en resumen, interesa instalar el ssh porque con el podremos entrar desde fuera al servidor, el webmin y los módulos listados arriba, etc

Lo dicho, esto es lo que yo tengo puesto... los paquetes se instalan poniendo:

```bash
apt-get install
```

por ejemplo: `apt-get install wavemon zebra webmin-stunnel webmin-status wget vtun`

Automáticamente el programa se conectará a Internet y comenzará a bajar esos paquetes y todos los necesarios para que esos funcionen, es decir, si instalas webmin-status, para eso te hará falta primero el webmin y el programa lo instalará también solito tras pedir confirmación e indicar los megas a descargar y lo que ocupará una vez descomprimido.

### Red

Vale, se supone que ahora ya tenemos el sistema funcionando y bueno... algo es algo :) ahora viene lo serio... configurarlo para que se adapte a nuestras necesidades...

Lo primero es tener un Kernel modernito (a mi con el estándar no me iba, pero como veréis en la lista de paquetes con el 2.4 funciona bastante bien el P'N'P)

Tenemos que por un lado configurar las tarjetas de red: Para eso, entramos en /etc/modutils como root y tendremos varios archivos de configuración, para ser representativo pondré el de una tarjeta ISA que son los más difíciles:

Contenido de : /etc/modutils/eepro

```config
options eepro io=0x210
```

- Como veréis es altamente jodidísimo configurar una tarjeta de red... sólo indicando el puerto de entrada salida Linux ya le busca la IRQ apropiada (en casos chungos, se le puede indicar también)

Con el resto de tarjetas editaremos los ficheros para ver que está todo bien y los llamaremos con el nombre del módulo necesario (sale durante la instalación o en páginas de ayuda) Luego, editaremos el fichero /etc/modules y pondremos las tarjetas en el orden en el que queremos que se llamen:

```text
# /etc/modules: kernel modules to load at boot time.
#
# This file should contain the names of kernel modules that are
# to be loaded at boot time, one per line. Comments begin with
# a "#", and everything on the line after them are ignored.
unix
af_packet
eepro
tulip
3c59x
ne
sb
```

Es decir, primero se cargará la EtherExpress Pro 10/10+ de Intel, que se llamará eth0 (tal como se explicó en el apartado de hardware), luego la 8139 (10/100) como eth2, luego la ne2000 PCI (RTL 8029), luego la Novel 2000 ISA y por último la SoundBlaster...

En el caso de haber dos tarjetas con el mismo controlador, se irán creando consecutivamente... es decir, si hay dos RTL8029, pues serán eth1 y eth2 y así el resto... en mi caso como cada una es distinta no tuve ese "problema".

Tras editar ese fichero, tendremos que hacer que al siguiente arranque se tome esta configuración, así que ejecutaremos update-modules, para que el ordenador cree el /etc/modules.conf adecuado conforme a nuestros deseos., al siguiente arranque tendremos algo como:

```text
Real Time Clock Driver v1.10e
id: 0xb4 <7> io: 0x210 <6>eth0: Intel EtherExpress Pro/10+ ISA at 0x210,<6> 00<6>:aa<6>:00<6>:c9<6>:9d<6>:1a<6>, IRQ 11, 10BaseT.
eepro.c: v0.13 11/08/2001 aris@cathedrallabs.org
8139too Fast Ethernet driver 0.9.24
eth1: RealTek RTL8139 Fast Ethernet at 0xc486b000, 00:50:fc:4d:c7:d9, IRQ 9
eth1: Identified 8139 chip type ’RTL-8139C’
ne2k-pci.c:v1.02 10/19/2000 D. Becker/P. Gortmaker http://www.scyld.com/network/ne2k-pci.html
eth2: RealTek RTL-8029 found at 0x6100, IRQ 9, 00:C0:DF:E3:46:F9.
isapnp: Scanning for PnP cards...
isapnp: Calling quirk for 01:00
isapnp: SB audio device quirk - increasing port range
isapnp: Card ’Creative SB16 PnP’
isapnp: 1 Plug & Play card detected total
ne.c:v1.10 9/23/94 Donald Becker (becker@scyld.com)
Last modified Nov 1, 2000 by Paul Gortmaker
NE*000 ethercard probe at 0x340: 00 40 33 94 ad 7d
eth3: NE2000 found at 0x340, using IRQ 10.
Soundblaster audio driver Copyright (C) by Hannu Savolainen 1993-1996
sb: Creative SB16 PnP detected
sb: ISAPnP reports ’Creative SB16 PnP’ at i/o 0x220, irq 5, dma 1, 5
SB 4.13 detected OK (220)
sb: 1 Soundblaster PnP card(s) found.
```

Como vemos, ya ha ido asignando tarjetas.. eth0 la Intel, eth1 la 8139, eth2 la 8029 y eth3 la Ne2000, lo de la SoundBlaster es accesorio, pero mola que la pille el solito ;) (con un kernel de la 2.4 aviso...)

Ahora falta configurar las direcciones para cada tarjeta... editamos el fichero /etc/network/interfaces:

```text
# The first network card - this entry was created during the Debian installation
auto eth0
iface eth0 inet dhcp
auto eth1
iface eth1 inet static
address 1.1.1.1
netmask 255.255.255.0
auto eth2
iface eth2 inet static
address 1.1.2.1
netmask 255.255.255.0
auto eth3
iface eth3 inet static
address 10.34.12.129
netmask 255.255.255.224
#auto eth3
#iface eth3 inet static
# address 1.1.3.1
# netmask 255.255.255.0
```

Esto en cristiano viene a decir que cargue las tarjetas en el arranque (auto eth?), y lo de abajo, pues cómo configurarlas... la eth0 es la que estaba conectada a internet, por lo tanto como mi proveedor configura por DHCP, pues eso pone... la eth1 es la de mi red local con el primero ordenador, le asigna una ip 1.1.1.1 y una máscara de subred de tipo C.

En realidad la dirección 1.1.1.1 está asignada en internet y sería una cabronada el conectarme con eso configurado así, pero como hemos dicho, es una red local y no tiene porqué afectar a nadie, así que así se queda...

Con la segunda para la red local, pues lo mismo, pero con otra dirección 1.1.2.1 y con subred de tipo C y la ethernet 3 es lo que sería la wireless y le asigno una dirección real y válida, en mi caso, esta ip pertenece a Valencia Wireless y está asignada a mi nodo, cada uno que consulte en [http://www.redlibre.net](http://www.redlibre.net/) el direccionamiento y que se ponga encargado con el responsable de su zona si lo hay y si no, directamente con Redlibre...

Ahora, al arrancar el ordenador que hace de nodo, ya debería coger automáticamente esos datos para cada tarjeta y funcionar así bien...

Me podéis preguntar que porqué asigno la 1.1.1.1 a una y la 1.1.2.1 a dos tarjetas que pertenecen a la misma red local... lo ideal sería 1.1.1.2, pero luego tenía problemas con el DHCP (con un hub nunca hubiera pasado... pero como nadie me ha dado ninguno...) (luego se verá el motivo)

El siguiente paso, es que ya puestos, que el ordenador asigne direcciones a los ordenadores que se conecten de forma automática, es decir.. montar un servidor DHCP... para ello instalaremos el paquete DHCP y el servidor de nombres BIND, para que los equipos remotos que se conecten puedan pedir configuración automáticamente y que puedan
resolver nombres...

El fichero de configuración del DHCP es el siguiente: (/etc/dhcp3/dhcp.conf):

```text
#
# Sample configuration file for ISC dhcpd
#
ddns-updates on;
use-host-decl-names on;
allow unknown-clients;
default-lease-time 3600;
max-lease-time 7200;
authoritative;
subnet 10.34.12.128 netmask 255.255.255.224
option domain-name-servers 10.34.12.129;
range 10.34.12.131 10.34.12.158;
option broadcast-address 10.34.12.159;
option routers 10.34.12.129;
subnet 192.168.1.0 netmask 255.255.255.0
option domain-name-servers 192.168.1.1;
range 192.168.1.2 192.168.1.254;
option broadcast-address 192.168.1.255;
option routers 192.168.1.1;
subnet 1.1.1.0 netmask 255.255.255.0
option domain-name-servers 1.1.1.1;
option domain-name alufis;
range 1.1.1.3 1.1.1.254;
option broadcast-address 1.1.1.255;
option routers 1.1.1.1;
option netbios-name-servers 1.1.1.1;
option netbios-node-type 8;
subnet 1.1.2.0 netmask 255.255.255.0
option domain-name alufis;
option netbios-name-servers 1.1.2.1;
option netbios-node-type 8;
option domain-name-servers 1.1.2.1;
range 1.1.2.3 1.1.2.254;
option broadcast-address 1.1.2.255;
option routers 1.1.2.1;
subnet 1.1.3.0 netmask 255.255.255.0
option domain-name-servers 1.1.3.1;
option domain-name alufis;
range 1.1.3.3 1.1.3.254;
option broadcast-address 1.1.3.255;
option routers 1.1.3.1;
option netbios-name-servers 1.1.3.1;
option netbios-node-type 8;
host deneb
option host-name "deneb";
hardware ethernet 00:04:e2:33:4e:8d;
fixed-address 1.1.1.2;
server-name "deneb";
host darkstar
option host-name "darkstar";
hardware ethernet 00:80:c8:16:de:59;
server-name "darkstar";
fixed-address 1.1.2.2;
host Alnilam
option host-name "alnilam";
hardware ethernet 00:90:d1:06:57:dc;
fixed-address 10.34.12.130;
server-name "alnilam";
```

A ver... por partes...

Primero defino lo que será la wireless, con la ip asignada, la subred, el rango de ip's, etc...

```text
subnet 10.34.12.128 netmask 255.255.255.224 option domain-name-servers 10.34.12.129; range 10.34.12.130 10.34.12.158; option broadcast-address 10.34.12.159; option routers 10.34.12.129;
```

Esto viene a significar que la red 10.34.12.128 (valencia wireless, mi nodo), con máscara de subred (255.255.255.224), tiene un servidor de nombres situado en 10.34.12.129 (la asignada a eth3), una dirección de broadcast en .158 y un router en .129 (el mismo que el DNS, es decir, el nodo...).

El rango de ip's asignado van desde la siguiente al nodo (.33) hasta el .62 de esa forma los clientes que pidan configuración por DHCP por el interfaz con esa subred (eth3) obtendrán una IP dentro de ese rango...

192.168._._ son direcciones para redes privadas y en este caso la utilizaré para los equipos que se conecten mediante la VPN, es decir, equipos que primero se conectan por la wireless y luego se conectan mediante VPN, realmente no creo que fuese necesario indicarlo, pero lo prefiero así :)

Luego vienen definidas las redes para las tarjetas locales 1.1.1.1 y 1.1.2.1, si ambas tarjetas estuviesen en la misma red, con una sola definición bastaría, pero el problema sería que si a la 1.1.1.3 que se conecta por la segunda tarjeta de red con IP 1.1.1.2 le digo que el router es 1.1.1.1 que es la primera tarjeta de red, pues habrían problemas... no iría ni a tiros... esto con un HUB no pasa y no hace falta poner estas dos definiciones, pero en mi caso sí... así cada una es una red distinta
que va bien y asigna ip's automáticamente y resuelve nombres.

Luego vienen dos declaraciones de equipo, en mi caso, a mis dos equipos de casa, les asigno ip's fijas, porque no me van a hacer falta más (de hecho no haría falta ni el dhcp para ellas, pero bueno, puestos a hacerlo a lo grande... pues ya lo tengo listo para un día meter dos hubs y poder conectar tropocientos ordenadores en cada tarjeta de red ;))

Para asignar IP fija, se hace en base a la dirección MAC de la tarjeta de red, que son esos códigos en hexadecimal.

En el último caso defino otro ordenador pero sin ip fija (en su momento irá por la wireless y por eso no tiene nada puesto)

Respecto al servidor de nombres... no hice nada, sólo instalé el paquete y ya iba, así que no toqué nada :)

Hasta este punto los equipos cliente que se configuren para que pidan la configuración automáticamente, recibirán una configuración válida desde nuestro nodo, ahora sólo falta hacer alguna cosilla más ;)

### Masquerading

Tenemos un servidor DHCP, las tarjetas configuradas y un servidor de nombres... ahora sólo falta que enrute!!! de esa forma tendremos acceso a Internet desde cualquiera de nuestros ordenadores...

Para ello, si leemos el IP-MASQUERADING-HOWTO, sacaremos este interesante script:

```bash
#!bash
#!/bin/sh
#
# rc.firewall-2.4
FWVER=0.63
#
# Initial SIMPLE IP Masquerade test for 2.4.x kernels using IPTABLES.
#
# Once IP Masquerading has been tested, with this simple ruleset, it is highly recommended to use a stronger IPTABLES ruleset either given later in this HOWTO or from another reputable resource.
# Log:
# 0.63 - Added support for the IRC IPTABLES module
# 0.62 - Fixed a typo on the MASQ enable line that used eth0 instead of $EXTIF
# 0.61 - Changed the firewall to use variables for the internal and external interfaces.
# 0.60 - 0.50 had a mistake where the ruleset had a rule to DROP all forwarded packets but it didn’t have a rule to ACCEPT any packets to be forwarded either - Load the ip_nat_ftp and ip_conntrack_ftp modules by default
# 0.50 - Initial draft
#
echo -e "\n\nLoading simple rc.firewall version $FWVER..\n"
# The location of the ’iptables’ program IPTABLES=/sbin/iptables
EXTIF="eth0"
EXTIF2="eth3"
EXTIF3="sl+"
INTIF="eth1"
INTIF2="eth2"
INTIF3="ppp+"
LAN1="1.1.1.0/16"
echo " External Interface : $EXTIF"
echo " External Interface 2 : $EXTIF2"
echo " External Interface 3 : $EXTIF3"
echo " -----------------------------"
echo " Internal Interface : $INTIF"
echo " Internal Interface 2 : $INTIF2"
echo " Internal Interface 3 : $INTIF3"
echo " -----------------------------"
echo " Internal Network : $LAN1"
echo " enabling forwarding.."
echo "1" > /proc/sys/net/ipv4/ip_forward
echo " enabling DynamicAddr.."
echo "1" > /proc/sys/net/ipv4/ip_dynaddr
# Borrar reglas anteriores tanto en normal como en nat y por defecto no enrutar
$IPTABLES -t nat -F
$IPTABLES -F
$IPTABLES -P FORWARD DROP
#Conectar la red local para transferencia de datos
$IPTABLES -A FORWARD -s $LAN1 -d $LAN1 -j ACCEPT
#Pasar datos desde las locales a inet
$IPTABLES -A FORWARD -s $LAN1 -o $EXTIF -j ACCEPT
# Aceptar paquetes de entrada a la local
$IPTABLES -A FORWARD -i $EXTIF -d $LAN1 -m state —state ESTABLISHED,RELATED -j ACCEPT
# Enmascarar a internet
$IPTABLES -t nat -A POSTROUTING -o $EXTIF -j MASQUERADE
#Pasar datos desde las locales a la wireless
$IPTABLES -A FORWARD -s $LAN1 -o $EXTIF2 -j ACCEPT
$IPTABLES -A FORWARD -i $EXTIF2 -d $LAN1 -m state —state ESTABLISHED,RELATED -j ACCEPT
# Enmascarar a la wireless
$IPTABLES -t nat -A POSTROUTING -s $LAN1 -o $EXTIF2 -j MASQUERADE
#Entrada de la red local a los túneles wireless (sl+)
$IPTABLES -A FORWARD -s $LAN1 -o $EXTIF3 -j ACCEPT
$IPTABLES -A FORWARD -i $EXTIF3 -d $LAN1 -m state —state ESTABLISHED,RELATED -j ACCEPT
# Enmascarar a los túneles
$IPTABLES -t nat -A POSTROUTING -s $LAN1 -o $EXTIF3 -j MASQUERADE
#Paquetes de entrada entre las wireless y los túneles Wireless (sl+)
$IPTABLES -A FORWARD -i $EXTIF2 -o $EXTIF3 -j ACCEPT
$IPTABLES -A FORWARD -i $EXTIF3 -o $EXTIF2 -j ACCEPT
# Paquetes de entrada de la VPN a internet y a la wireless
$IPTABLES -A FORWARD -i $INTIF3 -o $EXTIF -j ACCEPT
$IPTABLES -A FORWARD -i $EXTIF -o $INTIF3 -m state —state ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A FORWARD -i $INTIF3 -o $EXTIF2 -j ACCEPT
$IPTABLES -A FORWARD -i $EXTIF2 -o $INTIF3 -m state —state ESTABLISHED,RELATED -j ACCEPT
# Programas
#------------------------------------------
# Proxy Transparente
echo "Transparent Proxy for SQUID"
$IPTABLES -t nat -A PREROUTING -p TCP —dport 80 -j REDIRECT —to-port 3128 -d ! $LAN1
$IPTABLES -t nat -A PREROUTING -p TCP —dport 25 -j REDIRECT —to-port 25 -d ! $LAN1
$IPTABLES -t nat -A PREROUTING -p TCP —dport 110 -j REDIRECT —to-port 110 -d ! $LAN1
# Gnome Meeting
echo "Gnome Meeting"
$IPTABLES -t nat -A PREROUTING -i $EXTIF -p TCP —dport 0000:30010 -j DNAT —to-dest 1.1.1.2
$IPTABLES -t nat -A PREROUTING -i $EXTIF -p TCP —dport 1720 -j DNAT —to-dest 1.1.1.2
$IPTABLES -A FORWARD -p tcp -i $EXTIF —dport 30000:30010 -d 1.1.1.2 -j ACCEPT
$IPTABLES -A FORWARD -p udp -i $EXTIF —dport 5000:5003 -d 1.1.1.2 -j ACCEPT
$IPTABLES -t nat -A PREROUTING -i $EXTIF -p UDP —dport 5000:5003 -j DNAT —to-dest 1.1.1.2
$IPTABLES -A FORWARD -p tcp -i $EXTIF —dport 1720 -d 1.1.1.2 -j ACCEPT
#Aim, MSN
echo "AIM, MSN"
$IPTABLES -t nat -A PREROUTING -i $EXTIF -p tcp —dport 5190 -j REDIRECT —to-ports 5190
$IPTABLES -t nat -A PREROUTING -i $EXTIF -p tcp —dport 1863 -j REDIRECT —to-ports 1863
$IPTABLES -A INPUT -i $EXTIF -p tcp —dport 5190 -j ACCEPT
$IPTABLES -A INPUT -i $EXTIF -p tcp —dport 1863 -j ACCEPT
$IPTABLES -A INPUT -i $EXTIF -p tcp —dport 4443 -j ACCEPT
$IPTABLES -A INPUT -i $EXTIF -p tcp —dport 5566 -j ACCEPT
$IPTABLES -A INPUT -i $EXTIF -p tcp —dport 1864 -j ACCEPT
#VNC Deneb :0
echo "VNC"
$IPTABLES -A FORWARD -i $EXTIF -p TCP —dport 5800 -j ACCEPT
$IPTABLES -A FORWARD -i $EXTIF -p TCP —dport 5900 -j ACCEPT
$IPTABLES -t nat -A PREROUTING -i $EXTIF -p TCP —dport 5800 -j DNAT —to 1.1.1.2:5800
$IPTABLES -t nat -A PREROUTING -i $EXTIF -p TCP —dport 5900 -j DNAT —to 1.1.1.2:5900
$IPTABLES -A FORWARD -i $EXTIF -p TCP —dport 5500 -j ACCEPT
$IPTABLES -t nat -A PREROUTING -i $EXTIF -p TCP —dport 5500 -j DNAT —to 1.1.1.2:5500
#Firewall
echo "Firewall"
$IPTABLES -A INPUT -p TCP —dport 3306 -i $EXTIF -j DROP
$IPTABLES -A INPUT -p TCP —dport 3306 -i $EXTIF2 -j DROP
$IPTABLES -A INPUT -p TCP —dport 3128 -i $EXTIF -j DROP
$IPTABLES -A INPUT -p TCP —dport 53 -i $EXTIF -j DROP
$IPTABLES -A INPUT -p TCP —dport 25 -i $EXTIF -j DROP
$IPTABLES -A INPUT -p TCP —dport 25 -i $EXTIF2 -j DROP
$IPTABLES -A INPUT -p TCP —dport 137 -i $EXTIF -j DROP
$IPTABLES -A INPUT -p TCP —dport 137 -i $EXTIF2 -j DROP
$IPTABLES -A INPUT -p TCP —dport 139 -i $EXTIF -j DROP
$IPTABLES -A INPUT -p TCP —dport 139 -i $EXTIF2 -j DROP
$IPTABLES -A INPUT -p TCP —dport 179 -i $EXTIF -j DROP
$IPTABLES -A INPUT -p TCP —dport 2600:2605 -i $EXTIF -j DROP
$IPTABLES -A INPUT -p TCP —dport 179 -i $EXTIF2 -j DROP
$IPTABLES -A INPUT -p TCP —dport 2600:2605 -i $EXTIF2 -j DROP
```

Si nos olvidamos hasta donde pone algo con IPTABLES, lo que tenemos es un script que habilita la funcionalidad de enrutado del kernel de linux, a partir de ese momento ya tendremos acceso "teórico" a internet...

El problema es que como sólo tendremos una dirección IP válida, lo que tendremos que hacer es hacer NAT (Network Address Translation), existen dos tipos de NAT, el de destino y el de origen, en nuestro caso es el de origen, es decir, al final, los datos que salgan tendrán que aparentar ser todos desde la misma IP...

Para eso utilizamos esas sentencias de iptables que es el firewall, etc incorporado en Linux:

Lo de hacerlo con variables (las definidas al principio), es por facilidad a la hora de modificarlo, como veréis las redes están definidas como IP/bits para hacer las conversiones acudid a: [http://www.linux-es.com/ipcalc.php](http://www.linux-es.com/ipcalc.php)

Las reglas definidas en este fichero, permiten que todo lo que salga por la eth0 (Internet) sea con NAT y que a su vez, lo que salga por eth3 (la wireless) sea también con NAT (para tener acceso a la wireless desde la red local), luego permite el tráfico de paquetes entre las ip's de las redes locales.

El script original fue modificado para cumplir con los requisitos de mi red, así que cada uno que lo adapte a la suya para que le sea útil.

Vale, un punto importante, es que al tener un trasto conectado todo el día a Internet, lo mejor es tenerlo bien asegurado, por eso, contar con una buena configuración de firewall así como el portscanner vendrá bien. Port scanner analiza y registra todos los intentos de escaneo de puertos contra nuestro equipo y posteriormente impide todo acceso desde las ip's originantes, tanto creando rutas nulas como vuelta a esas ip's como añadiéndola a los filtros de los TCP-wrappers En
/etc/portsentry.ignore.static, pondremos:

```text
127.0.0.1/32 0.0.0.0 1.1.0.0/16
```

Para que no bloquee los locales (como indica en la ayuda) y añadimos los de nuestra red local... equipos con IP 1.1._._ (esto permite bloquear a los graciositos que se conecten por la wireless...)

Luego, en el /etc/porsentry/portsentry.conf cambiaremos:

```bash
BLOCK_UDP="1"
BLOCK_TCP="1"
```

y entre las otras opciones escogeremos las aptas para nuestro sistema, el tipo de bloqueo a realizar, etc

Ahora si alguien intenta hacer el tonto haciendo escaneos de puertos, pues automáticamente le será impedido posterior acceso desde esa Ip...

Para arrancar el script del firewall crearemos un script con el formato estándar tal como sigue:

/etc/init.d/fire

```bash
#!bash
#!/bin/sh
IPTABLES=/sbin/iptables
# See how we were called.
case "$1" in
    start)
        /etc/init.d/rc.firewall
       ;;
    stop)
        echo -e "\nFlushing firewall and setting default policies to DROP\n"
        $IPTABLES -P INPUT DROP
        $IPTABLES -F INPUT
        $IPTABLES -P OUTPUT DROP
        $IPTABLES -F OUTPUT
        $IPTABLES -P FORWARD DROP
        $IPTABLES -F FORWARD
        $IPTABLES -F -t nat
        # Delete all User-specified chains
        $IPTABLES -X
        # Reset all IPTABLES counters
        $IPTABLES -Z
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    status)
        $IPTABLES -L
        ;;
    mlist)
        cat /proc/net/ip_conntrack
        ;;
    *)
        echo "Usage: fire start|stop|status|mlist"
        exit 1
        ;;
esac
```

Si ahora creamos los enlaces simbólicos apropiados a este script en `/etc/rc?.d` pondremos especificar cuando queremos que se arranque el
enrutamiento...

En mi caso:

```bash
rc0.d/K20fire
rc1.d/K20fire
rc2.d/S20fire
rc3.d/S20fire
rc4.d/S20fire
rc5.d/S20fire
rc6.d/K20fire
```

En esas carpetas dentro de /etc

Un problema que tendremos al apagar el ordenador, es que como no tendremos monitor, no podremos saber cuando está listo para apagar y no vamos a conectar un monitor cada vez para hacerlo...

Túneles

Ahora que parece que está más o menos esto en marcha, habría que hacer túneles entre los distintos nodos de otras personas, para eso os recomiendo el paquete VPND junto a los scripts de VPNS: VPN's [http://freshmeat.net/projects/vpns/](http://freshmeat.net/projects/vpns/)

Hay un bonito README en el VPNS.

### Consejos Finales

Vale, nuestro servidor tiene las tarjetas configuradas, enruta, hace de servidor DHCP, DNS, bloquea los escaneos de puertos... ahora sólo queda algún detalle interesante:

Lo primero: activar el soporte para el sistema de ficheros ext3, su compatibilidad con el ext2 es total, el cambio se hace simplemente poniendo:

`tune2fs -j /dev/hda1` (para la partición 1 del hd) y luego editando el /etc/fstab y donde ponga /dev/hda1 cambiar ext2 por ext3...

De ese modo, el sistema arrancará igual, pero con una ventaja... en caso de apagón, bloqueo, reseteo, etc, el sistema de ficheros ext3 crea un log de los cambios realizados y en esas situaciones, al siguiente rearranque, los puede corregir en la mayoría de las situaciones el solito, provocando que si se va la luz, en cuanto vuelva, automáticamente intente arrancar el solito (y en la mayoría de los casos lo conseguirá ;))

Otras cosas útiles.... configurar el SMB para poder acceder desde la red local con Windows... así el servidor que hace de nodo, puede quedarse bajando cosas por la noche (si es nodo tiene que estar todo el día en marcha) y luego simplemente te las transfieres a tu equipo mediante el entorno de red... (Existen hotwtos que lo explican muy bien así que.... a usar el Google que para eso está...)

Sería también recomendable que instalases el DNS2GO que permite asignar un nombre de dominio a una IP dinámica, de ese modo podrías aprovechar para poner una página web en tu nodo con el apache e instalar el webalizer para analizar sus visitas, etc Como DNS2GO es ahora de pago, yo utilizo NO-IP. En Debian tenéis un paquete llamado no-ip que incorpora un cliente listo para configurar y así actualizar automáticamente vuestra ip dinámica en el servidor DNS.

Para configurar el zebra, lo único que tengo hecho por el momento es editar el /etc/zebra/daemons y activar zebra, ospfd y el bgpd... cuando tenga tarjetas lo probaré y diré... (de esto se está encargando Hilario de ValenciaWireless

Por el momento es todo... con esto tienes un nodo... puedes acceder por SSH a el para configurarlo remotamente (el putty es un buen cliente para Windows, WinSCP para transferencias seguras de archivos ;)), configurarlo por web (Webmin) y ya con eso para empezar está bien...

Respecto a la VPN (pptpd)... Pues antes no... pero ahora ya va a la perfección ;)

Si no te conectas mediante VPN mediante la tarjeta de la wireless (eth3 en mi caso) no hay Internet (excepto por página web al puerto 80), y si te validas sí... así que si tienes poco ancho de banda, puedes controlar si accedes o no desde fuera de tu red casera... es decir.. gastas la red inalámbrica para acceder al de tu casita y una vez ahí accedes a través de ese a Internet ;)

Sería interesante activar también un Proxy tipo Squid para acelerar la navegación por Internet... tanto por la red local, como para los nodos (puedes restringir por ip's, etc ) (yo lo tengo puesto además con el adzapper, que me permite eliminar muchísimos anuncios de las webs por las que navego)

¡¡Un saludo y suerte!!

### Ficheros de configuración

#### Squid

```config
acl local src 1.1.0.0/16
http_access allow local
maximum_object_size 32768 KB
cache_dir ufs /var/spool/squid 512 16 256
httpd_accel_uses_host_header on
redirect_program /usr/lib/squid/squid_redirect
redirect_children 30 # PPTPD (para las VPN entrantes)
```

#### /etc/ppp/pptpd-options

```config
debug
name in chap-secrets
name Merak
auth
+chap
ms-dns 192.168.0.1
netmask 255.255.0.0
lock
```

#### /etc/ppp/chap-secrets

```config
# Secrets for authentication using CHAP
# client server secret IP addresses
prueba * probando *
```

{{<disfruta>}}
