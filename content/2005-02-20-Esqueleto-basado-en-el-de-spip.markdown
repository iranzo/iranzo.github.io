---
layout: post
title: Esqueleto basado en el de spip-contrib
date: 2005-02-20T22:52:00Z
tags: spip, cms, foss
lang: es
comments: true
---
### Introducción

Antes de nada... Estos esqueletos se basan en los aparecidos en [http://www.spip-contrib.net](http://www.spip-contrib.net/), gracias a un mensaje que se envió a la lista de correo de SPIP en Español, hablando de otros modelos basados en esos mismos (los de [nqnwebs para atén](http://www.nqnwebs.com.ar/article.php3?id_article=39) de Martín Gaitán)

Lo que me llamó la atención de estos esqueletos era que se adaptaban bien al tamaño de pantalla y se veían adecuadamente tanto en [Mozilla](http://www.mozilla.org/) como otros navegadores, y que al disponer de dos áreas de menús, se adaptaban más cómodamente al diseño modular que habíamos utilizado Laura Primo y [Pablo Iranzo Gómez](http://alufis35.uv.es/~iranzo/) para las webs de [http://Linuv.uv.es](http://Linuv.uv.es/) y la versión anterior de [http://Alufis35.uv.es](http://Alufis35.uv.es/).

### Créditos

- Este esqueleto se basa en el trabajo del grupo de diseño de [http://www.spip-contrib.net](http://www.spip-contrib.net/)
- Utiliza la parte de agenda con modificaciones del esqueleto [epona](http://www.spip-contrib.net/article509.html)
- Utiliza la parte de atributos EXIF de [PhotoPholder](http://www.jakeo.com/software/fotopholder/index.php)
- Utiliza la corrección de transparencias de archivos PNG en IE de [http://homepage.ntlworld.com/bobosola/](http://homepage.ntlworld.com/bobosola/)
- Utiliza partes del trabajo de Laura Primo y [Pablo Iranzo Gómez](http://alufis35.uv.es/~iranzo/) en el diseño de la web de LinUV y Alufis35
- Utiliza parte del bucle de [http://www.spip-contrib.net/_marabbeh_](http://www.spip-contrib.net/_marabbeh_) (extraer según estructura del sitio en sectores en lugar de por bloques de bucles)

Queremos agradecer desde aquí a todos ellos su trabajo previo que ha posibilitado la creación de este.

### Características

- Permiten modificar el logotipo y frase de la web modificando un artículo con una palabra clave especial
- Permiten modificar el mensaje de la web con otro artículo con una frase especial
- La web se adapta al tamaño del navegador, de forma que siempre se muestra la máxima información posible evitando los molestos desplazamientos que tienen muchas webs al ser diseñadas para resoluciones bajas.
- Tiene un diseño a base de módulos, que añadidos a cada plantilla principal (rubrique, sommaire, article, etc) en la sección derecha o izquierda del menú, permiten adaptar el diseño de la página a la información mostrada.
- El album fotográfico muestra controles adelante-atrás así como información de las cabeceras EXIF que proporcionan las cámaras digitales (modelo, focal, diafragma, hora, etc) (además, utiliza el sistema de caché de SPIP para mejorar la navegación)
- El módulo de agenda así como el de mini-agenda permiten mostrar eventos programados en nuestra web
- La ficha de información del autor, permite el envío de mensajes, pero oculta su dirección de correo electrónico para evitar SPAM
- Cada sección y artículo muestran un mini-icono que facilita su localización al navegar por las distintas páginas del sitio web.
- Las cabeceras de los archivos, así como los META, se generan dinámicamente en función de las palabras claves asignadas a los artículos
- En el caso de los artículos con la palabra clave "Frase", se asigna su decripción a la descripción general de la web (META DESCRIPTION).
- Muestra las noticias sindicadas de otras webs como si fueran artículos de la propia
- Soporte automatizado para [Google Sitemaps](http://www.google.com/webmasters/sitemaps/), simplemente enviar el archivo con el mapa del sitio y listo
- Soporte automatizado para [ROR: Resources Of a Resource](http://www.rorweb.com/)

### Requisitos

Estos esqueletos han sido desarrollados sobre la versión SPIP 1.8.2d, y aunque debería funcionar sobre las posteriores a la 1.7.2, no se han realizado pruebas al respecto.

Los esqueletos están pensados para, y asumen, que el servidor tenga habilitada la reescritura de enlaces .html a .php3 según se explica en [http://www.spip.net/es_article2024.html](http://www.spip.net/es_article2024.html), aunque es posible adaptarlos para que funcionen sin ellas.

Para su funcionamiento, necesita que las siguientes redirecciones estén habilitadas (se hizo así para facilitar la indexación por parte de buscadores):

~~~apache
RewriteRule ^spip/rubrique([0-9]+).html$ rubrique.php3?id_rubrique=$1 [QSA,L]
RewriteRule ^spip/article([0-9]+).html$ article.php3?id_article=$1 [QSA,L]
RewriteRule ^spip/breve([0-9]+).html$ breve.php3?id_breve=$1 [QSA,L]
RewriteRule ^spip/secteur([0-9]+).html$ secteur.php3?id_rubrique=$1 [QSA,L]
RewriteRule ^spip/album([0-9]+).html$ album.php3?id_document=$1 [QSA,L]
RewriteRule ^spip/plan.html$ plan.php3 [QSA,L]
RewriteRule ^spip/mot([0-9]+).html$ mot.php3?id_mot=$1 [QSA,L]
RewriteRule ^spip/imprimir([0-9]+).html$ imprimir.php3?id_article=$1 [QSA,L]
RewriteRule ^spip/auteur([0-9]+).html$ auteur.php3?id_auteur=$1 [QSA,L]
~~~

Actualmente y para usar las URL Propres (las URL Propres, permiten generar rutas de acceso a los artículos basadas en el título del mismo, facilitando que sean recordadas por los usuarios y mejorando la gestión por parte de los buscadores de Internet) de SPIP, las redirecciones que tengo habilitadas son las siguientes (adjunto el archivo htaccess por motivos de comodidad):

~~~apache
RewriteRule ^spip/rubrique([0-9]+).html$ rubrique.php3?id_rubrique=$1 [QSA,L]
RewriteRule ^spip/article([0-9]+).html$ article.php3?id_article=$1 [QSA,L]
RewriteRule ^spip/breve([0-9]+).html$ breve.php3?id_breve=$1 [QSA,L]
RewriteRule ^spip/secteur([0-9]+).html$ secteur.php3?id_rubrique=$1 [QSA,L]
RewriteRule ^spip/album([0-9]+).html$ album.php3?id_document=$1 [QSA,L]
RewriteRule ^spip/plan.html$ plan.php3 [QSA,L]
RewriteRule ^spip/mot([0-9]+).html$ mot.php3?id_mot=$1 [QSA,L]
RewriteRule ^spip/imprimir([0-9]+).html$ imprimir.php3?id_article=$1 [QSA,L]
RewriteRule ^spip/auteur([0-9]+).html$ auteur.php3?id_auteur=$1 [QSA,L]
RewriteRule ^+-[^/.]+(-+)?(.html)?$ mot.php3 [QSA,E=url_propre:$0,L]
RewriteRule ^+[^/.]++?(.html)?$ breve.php3 [QSA,E=url_propre:$0,L]
RewriteRule ^-[^/.]+-?(.html)?$ rubrique.php3 [QSA,E=url_propre:$0,L]
RewriteRule ^_[^/.]+_?(.html)?$ auteur.php3 [QSA,E=url_propre:$0,L]
RewriteRule ^@[^/.]+@?(.html)?$ site.php3 [QSA,E=url_propre:$0,L]
RewriteRule ^[^/.]+(.html)?$ article.php3 [QSA,E=url_propre:$0,L]
~~~

La redirección para album, pdf.php3 e imprimir son las únicas no estándar, así que en caso de no poder o no querer hacer uso de este sistema, se deberían modificar los esqueletos de estas páginas (así como de los módulos relacionados) para utilizar la estándar con extensiones en php3

- Para el funcionamiento del conversor a PDF, es necesaria la utilidad "htmldoc"
- Para el correcto escalado de archivos con transparencias, es recomendable el gestor "convert" o "ImageMagick" para gestionar la creación de miniaturas
- Para el módulo de agenda es necesario habilitar la opción de Fecha de publicación anterior

Como requisitos adicionales, una vez instaladas las plantillas, es necesario:

- Crear enlaces simbólicos (o copias) de los archivos .php3 de la carpeta de los esqueletos a la principal de SPIP
- Crear enlaces simbólicos (o copias) de los archivos .css de la carpeta de los esqueletos a la principal de SPIP
- Crear enlaces simbólicos (o copias) de las plantillas: article-album.html, rubrique-album.html, rubrique-agenda.html y rubrique-synd.html a los correspondientes -(NUM#) según cúal sea el ID de nuestra sección para agenda, galería fotográfica y para titulares de otras webs.
- Crear un grupo de palabras llamado "Design" con al menos estas palabras clave: "Notadeldia", "Agenda", "Frase", "Banner_cabecera"
- Crear un artículo y asociarle la palabra "Frase", para que las plantillas tomen del título y del logotipo del artículo el logotipo y frase para la web.
- Crear un artículo y asociarle la palabra "Notadeldia" para que se muestre el mensaje del día en la sección central de la portada.
- Crear un artículo y asociarle la palabra cabecera" para mostrar en la parte superior derecha el logotipo de dicho artículo y enlazarlo al campo URL de dicho artículo
- Crear una sección llamada agenda y asociarle tanto a la sección como a los artículos publicados en ella la palabra clave "Agenda" (si se publican artículos con la palabra clave Agenda aparecen en la miniagenda, aunque no en la de la sección)
- Crear para la sección de titulares, una sección y dentro de ella, una nueva sección por cada web referenciada, de forma que dentro de dicha sección sólo se referencie un sitio web, para que así la plantilla muestre en esa sección, los artículos sindicados como artículos propios.
- Enviar a Google Sitemaps el archivo sitemap.php3 para que lo indexe Funcionamiento

Además de los esqueletos normales de SPIP, estos tienen los siguientes módulos que se utilizan para definir o mostrar información adicional al tipo de documento que estamos visualizando, permitiendo simplificar la forma de mantener el código de los esqueletos a través de la reutilización.

Actualmente está formado por los siguientes módulos laterales:

~~~text
  ------------------------ ------------------------------------------------------------------------------------------------
  Módulo                   Cometido
  mod_agenda.html         Muestra la mini agenda con los eventos del mes en curso
  mod_artsautalbum.html   Muestra los artículos del mismo autor cuando estamos en un album (en función del id_document)
  mod_artsaut.html        Muestra los artículos del mismo autor
  mod_artssec.html        Muestra los artículos en la misma sección
  mod_breves.html         Muestra las noticias breves del sitio
  mod_popul.html          Muestra los 5 artículos más populares del sitio
  mod_salida.html         Muestra las opciones de salida del documento (Impreso o PDF)
  mod_secciones.html      Muestra las secciones que cuelgan de la raíz del sitio
  mod_tira.html           Muestra la tira cómica [E.C.O.L.](http://tira.escomposlinux.org/)
  mod_traduc.html         Muestra otras traducciones del artículo en curso
  mod_exif.html           Muestra las cabeceras EXIF de las imágenes (si existen datos)
  mod_inscrip.html        Permite inscribirse al sitio web
  mod_jerarquia.html      Muestra la jerarquía en secciones para llegar al artículo
  mod_jerarquiasec.html   Muestra la jerarquía en secciones para llegar a la sección
  mod_keywordbrev.html    Muestra las palabras clave de la breve
  mod_keyword.html        Muestra las palabras clave del artículo
  mod_nextprev.html       Muestra los botones adelante y/o atrás en las galerías
  mod_nota.html           Muestra el mensaje del sitio web en la portada
  mod_opbl1.html          Abre el estilo de bloque 1
  mod_opbl2.html          Abre el estilo de bloque 2
  mod_opbl3.html          Abre el estilo de bloque 3
  mod_clobl1.html         Cierra el estilo de bloque 1
  mod_clobl2.html         Cierra el estilo de bloque 2
  mod_clobl3.html         Cierra el estilo de bloque 3
  ------------------------ ------------------------------------------------------------------------------------------------
~~~

Las plantillas generales (rubrique, -album, -synd, article, etc) llevan un div que se llama lefter y otro que se llama righter, esos son los paneles laterales, podremos incluir, activar o desactivar los módulos que queramos haciendo INCLURES.

Los módulos, en caso de no tener datos que mostrar, no aparecen, por ejemplo el de traducciones, el de palabras clave o el de datos EXIF, de forma que sólo aparecerán en caso de que los hayamos inclido (y de que sean necesarios claro).

En principio, una vez tenidas en cuenta las anteriores consideraciones, podremos trabajar con normalidad con el sitio web, con la única limitación o pega (que no he sabido resolver y de la que no he recibido respuesta en la lista de SPIP) de que los artículos deben obligatoriamente llevar al menos una palabra clave asociada, que no pertenezca al grupo de palabras "Design", que por otro lado, dado que las plantillas establecen los META KEYWORDS en función de las palabras clave indicadas, nos
ayudará a que los buscadores visiten nuestras webs.  Te recomiendo en este caso que crees un grupo de palabras clave llamado "Tema" y que recomiendes (mediante la opción adecuada en la definición del grupo) que se escoja al menos una palabra de este grupo.

Para utilizar la agenda, deberás publicar artículos en su sección y asignarles la fecha del evento en el campo de "Fecha de Publicación Anterior", para que así SPIP la coloque en el día apropiado

En caso de que tengas alguna duda relacionada o considerases que alguna parte de este documento o de las plantillas se puede mejorar, no dudes en colgar un mensaje al respecto.

Saludos
