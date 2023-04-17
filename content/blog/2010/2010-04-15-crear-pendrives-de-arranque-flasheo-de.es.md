---
layout: post
title: Crear pendrives de arranque (flasheo de bios) en un ejecutable autoextraible (Linux/Windows)
date: 2010-04-15 14:18:00 +0200
author: Pablo Iranzo Gómez
lang: es
tags:
  - fedora
  - foss
modified: 2023-04-17T21:48:53.760Z
categories:
  - FOSS
  - Fedora
---

Usando unetbootin (<http://unetbootin.sourceforge.net/>) podemos crear pendrives de arranque a partir de imágenes ISO o imágenes de disco, así como ficheros propios o bien predefinidos para varias distribuciones.

Si queremos además, crear un fichero ejecutable autodescomprimible, para que el usuario final sólo deba ejecutarlo e introducir un pendrive y que se cree 'solo', deberemos tener además:

- 7zip <http://sourceforge.net/projects/sevenzip/files/> (para crear un fichero comprimido con los ficheros a incluir)
- 7zip SFX (7zS.sfx) dentro del fichero 'Extra' de <http://sourceforge.net/projects/sevenzip/files/>

En una carpeta, copiaremos el ejecutable de unetbootin al que llamaremos `unetbootin.exe`, añadiremos el fichero `7z.sfx` y la imagen de flasheo BIOS a la que llamaremos `flash.img`.

Yo añado también un fichero `syslinux.cfg` que desactiva la linea `vesamenu.c32` que pone por defecto unedbootin, quedando:

```cfg
---------- syslinux.cfg --------------
default unetbootindefault
prompt 0
menu title UNetbootin
timeout 100

label unetbootindefault
menu label Default
kernel /ubnkern
append initrd=/ubninit
-----------------------------------------
```

Con 7zip comprimiremos los ficheros `flash.img` , `syslinux.cfg` y `unedbootin.exe` a un fichero llamado `todo.7z`.

Crearemos un fichero 'config.txt con las órdenes a ejecutar, por ejemplo

```bash
------------------- config.txt ----------------
!@Install@!UTF-8!
RunProgram="unetbootin.exe lang=es method=diskimage imgfile='flash.img' cfgfile='syslinux.cfg' nocustom=y nodistro=y  message='Presione OK para generar Pendrive de Flasheo BIOS'  installtype=USB"
!@InstallEnd@
-------------------------------------------------
```

Puedes consultar la referencia de comandos en <http://sourceforge.net/apps/trac/unetbootin/wiki/commands>

Los que hay indicados, ponen el idioma en castellano, indica que usaremos una imagen de disco que está en el fichero `flash.img`, usaremos el fichero de menu `syslinux.cfg`, no permitiremos personalizar la creación, no dejaremos escoger distribución, definimos el mensaje a mostrar y crearemos un medio USB

En el paso final, debemos concatenar los ficheros en un único ejecutable

```bash
#!bash
cat 7zS.sfx config.txt todo7z > autoejecutable.exe
```

Cuando enviemos el fichero `autoejecutable.exe` a un usuario, al ejecutarlo, se descomprimirá el fichero `todo.7z` contenido dentro del ejecutable y se lanzará la línea de comando del `config.txt`, lanzando unetbootin para la creación....

Podemos utilizar este método (sin hacer el autoejecutable), para crear un pendrive de arranque de forma manual y poder actualizar nuestra bios, etc.
{{<disfruta>}}
