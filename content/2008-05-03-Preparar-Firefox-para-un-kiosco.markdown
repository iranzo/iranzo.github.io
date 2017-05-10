---
layout: post
title: Preparar Firefox para un kiosco
date: 2008-05-03T23:13:33Z
tags: linux, firefox, desktop
lang: es
---

### userChrome.css

Firefox tiene en la carpeta del usuario, y dentro del perfil una subcarpeta llamada chrome y en ella el fichero `userChrome.css`

Éste permite ajustar pequeños cambios en el diseño como mostrar u ocultar menús, botones, etc.

Por ejemplo, podemos esconder el menú de ayuda con:

~~~css
#helpMenu display: none !important;
~~~

### Compactando el entorno

Yo utilizo una visión más compacta reduciendo las barras, poniendo la barra de direcciones y búsqueda en la de menús:

~~~css
/* Remove the Edit and Help menus Id's for all toplevel menus: file-menu, edit-menu, view-menu, go-menu, bookmarks-menu, tools-menu, helpMenu */
#helpMenu, #go-menu  display: none !important;
 /* Remove Back button when there's nothing to go Back to */
#back-button[disabled="true"]  display: none;  /* Remove Forward button when there's nothing to go Forward to */
#forward-button[disabled="true"]  display: none;   /* Remove Stop button when there's nothing to Stop */
#stop-button[disabled="true"]  display: none;  /* Remove Home button */
#home-button  display: none;  /*Remove magnifying glass button from search box*/
.search-go-button-stack  display: none !important;
~~~

### Limitándolo

Para hacer una vista orientada a un kiosco, utilizaremos más limitaciones como esconder todos los menús:

~~~css
#helpMenu, #go-menu  display: none !important;
/*Remove magnifying glass button from search box*/
.search-go-button-stack  display: none !important;  /* remove preferences from edit menu */
menu[label="Archivo"] display: none !important
menu[label="File"] display: none !important
menu[label="Editar"] display: none !important
menu[label="Edit"] display: none !important
menu[label="Ver"]display: none !important
menu[label="View"]display: none !important
menu[label="Marcadores"]display: none !important
menu[label="Bookmarks"]display: none !important
menu[label="Ayuda"]display: none !important
menu[label="Help"]display: none !important
menu[label="Herramientas"]display: none !important
menu[label="Tools"]display: none !important
menu[label="Ir"]display: none !important
menu[label="Go"]display: none !important # También podemos esconder sólo algunos elementos
#
#menu[label="Archivo"] menuitem[label="Guardar como..."]display: none !important
#menu[label="Editar"] menuitem[label="Preferencias"] display: none !important
#menu[label="Edit"] menuitem[label="Preferences"] display: none !important /* disable statusbar updates */
statusbar[id="status-bar"] statusbarpanel[id="security-button"], statusbarpanel[id="page-report-button"], statusbarpanel[id="page-theme-button"], statusbarpanel[id="statusbar-updates"]  display: none !important
~~~

### Extensiones

También podemos hacer uso de extensiones con la finalidad de bloquear más el entorno.

Personalmente he utilizado "[keyconfig](https://addons.mozilla.org/es-ES/firefox/addon/6105)" para bloquear combinaciones de teclas y así evitar que aunque no aparezcan los menús, se puedan seguir utilizando.

Una muy interesante es "[publicfox](https://addons.mozilla.org/es-ES/firefox/addon/3911)", que permite proteger las opciones de about:config para que el usuario no pueda cambiar configuración de proxy, programas externos, etc

[Firefox limitado]({filename}/imagen/firefox-reducido.jpg)
