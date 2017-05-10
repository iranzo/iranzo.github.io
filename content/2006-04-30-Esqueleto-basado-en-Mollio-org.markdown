---
layout: post
title: Esqueleto basado en Mollio.org
date: 2006-04-30T05:06:00Z
tags: spip, cms
lang: es
---
### Introducción

Estos esqueletos se basan en el modelo tipo C de la web de [www.mollio.org](http://www.mollio.org/), gracias a un mensaje que se
envió a la lista de correo de SPIP en Español.

Los esqueletos se ajustqan al tamaño de pantalla y se visualizan adecuadamente tanto en [Mozilla](http://www.mozilla.org/) como otros navegadores, y al disponer de dos áreas de menús, se adaptaban más cómodamente al diseño modular que habíamos utilizado Laura Primo y [Pablo Iranzo Gómez](http://alufis35.uv.es/~iranzo/) para las webs de [http://Linuv.uv.es](http://Linuv.uv.es/) y la versión anterior de [http://Alufis35.uv.es](http://Alufis35.uv.es/).

### Créditos

- Este esqueleto se basa en el trabajo del grupo de diseño de [http://www.mollio.org](http://www.mollio.org/)
- Utiliza la parte de agenda con modificaciones del esqueleto [epona](http://www.spip-contrib.net/article509.html)
- Utiliza la parte de atributos EXIF de [PhotoPholder](http://www.jakeo.com/software/fotopholder/index.php)
- Utiliza la corrección de transparencias de archivos PNG en IE de [http://homepage.ntlworld.com/bobosola/](http://homepage.ntlworld.com/bobosola/)
- Utiliza partes del trabajo de Laura Primo y [Pablo Iranzo Gómez](http://alufis35.uv.es/~iranzo/) en el diseño de la web de [LinUV](http://LinUV.uv.es/) y [Alufis35](http://Alufis35.uv.es/)
- Utiliza parte del bucle de [http://www.spip-contrib.net/_marabbeh_](http://www.spip-contrib.net/_marabbeh_) (extraer según estructura del sitio en sectores en lugar de por bloques de bucles)
- Se basa en los anteriores esqueletos de Alufis35, basados en spip-contrib Esqueleto basado en el de spip-contrib
- Laura Primo ha colaborado (como viene haciendo) en la creación de estos esqueletos y se ha encargado de la validación [http://W3.org](http://W3.org/) de los mismos.
- El módulo "Nube" es una adaptación del enviado por [Juan Martínez](mailto:comcincoARROBAzemos98.org) utilizado en su web [www.colectivosolano.org](http://www.colectivosolano.org/)

Queremos agradecer desde aquí a todos ellos su trabajo previo que ha posibilitado la creación de este.

### Características

- Permiten modificar el logotipo y frase de la web modificando un artículo con una palabra clave especial
- Permiten modificar el mensaje de la web con otro artículo con una frase especial
- La web se adapta al tamaño del navegador, de forma que siempre se muestra la máxima información posible evitando los molestos desplazamientos que tienen muchas webs al ser diseñadas para resoluciones bajas.
- Tiene un diseño a base de módulos, que añadidos a cada plantilla principal (rubrique, sommaire, article, etc) en la sección derecha o izquierda del menú, permiten adaptar el diseño de la página a la información mostrada.
- Dichos módulos se habilitano o deshabilitan con las palabras clave adecuadas
- El album fotográfico muestra controles adelante-atrás así como información de las cabeceras EXIF que proporcionan las cámaras digitales (modelo, focal, diafragma, hora, etc) (además, utiliza el sistema de caché de SPIP para mejorar la navegación)
- El módulo de agenda así como el de mini-agenda permiten mostrar eventos programados en nuestra web
- La ficha de información del autor, permite el envío de mensajes, pero oculta su dirección de correo electrónico para evitar SPAM
- Cada sección y artículo muestran un mini-icono que facilita su localización al navegar por las distintas páginas del sitio web.
- Las cabeceras de los archivos, así como los META, se generan dinámicamente en función de las palabras claves asignadas a los artículos
- En el caso de los artículos con la palabra clave "Frase", se asigna su decripción a la descripción general de la web (META DESCRIPTION).
- Muestra las noticias sindicadas de otras webs como si fueran artículos de la propia
- Soporte automatizado para [Google Sitemaps](http://www.google.com/webmasters/sitemaps/), simplemente enviar el archivo con el mapa del sitio y listo
- Soporte automatizado para [ROR: Resources Of a Resource](http://www.rorweb.com/)
- Validan con el comprobador de w3.org en [http://validator.w3.org/](http://validator.w3.org/)
- Los esqueletos han sido internacionalizados y ahora cuentan con soporte para Español, Inglés, Catalán y Francés
- Es posible escoger una licencia para asociarla a los artículos y así que los buscadores la indexen también
- Soporte para MicroSummary de Firefox 2

### Requisitos

Estos esqueletos han sido desarrollados sobre la versión SPIP 1.9.2 y debido a sus características deberían ser la versión mínima sobre la que se utilizarán.

La versión para 1.8.3 está también disponible en la url arriba indicada, bajo la carpeta 1.8.3 y ya no se desarrolla para ella, es posible que la información aquí mostrada no sea aplicable.

Los esqueletos están pensados para ser utilizados con reescritura de URLS según se explica en [http://www.spip.net/es_article2024.html](http://www.spip.net/es_article2024.html), aunque son perfectamente compatibles en caso de no tenerla.

Para su funcionamiento, necesita que las siguientes redirecciones estén habilitadas (se hizo así para facilitar la indexación por parte de buscadores):

Actualmente y para usar las URL Propres (Las URL Propres, permiten generar rutas de acceso a los artículos basadas en el título del mismo, facilitando que sean recordadas por los usuarios y mejorando la gestión por parte de los buscadores de Internet) de SPIP, las redirecciones a habilitar son las que se distribuyen en el archivo htaccess de la carpeta "mollio", donde entre otras, se ha incorporado un esqueleto "parser" que en caso de que se nos visitara desde urls con reescritura html en lugar de propres, notifica (Hace un http redirect permanente de archivos estilo article10.html a la URL correspondiente en propre o el sistema habilitado en ese momento en el servidor) a los visitantes y buscadores el nuevo esquema.

- El funcionamiento del conversor PDF se ha migrado al plugin [article_pdf](http://trac.rezo.net/trac/spip-zone/browser/_plugins_/_test_/article_pdf) de spip con modificaciones para la internacionalización de los pdf's generados
- Para el correcto escalado de archivos con transparencias, es recomendable el gestor "convert" o "ImageMagick" para gestionar la creación de miniaturas
- Para el módulo de agenda es necesario habilitar la opción de Fecha de publicación anterior

Como requisitos adicionales, una vez instaladas las plantillas, es necesario:

- Copiar la arpeta "plugins" de "mollio" al raíz del sitio, y luego, en la parte de gestión de SPIP, activar el plugin article_PDF
- Crear enlaces simbólicos (o copias) de las plantillas: article-album.html, rubrique-album.html, rubrique-agenda.html y rubrique-synd.html a los correspondientes -(NUM#) según cúal sea el ID de nuestra sección para agenda, galería fotográfica y para titulares de otras webs.
- Crear un grupo de palabras llamado "Design" con al menos estas palabras clave: "Notadeldia", "Agenda", "Frase", "Banner_cabecera", "Creditos", "rubrique1", "rubrique2", "rubrique3", "rubrique4", "rubrique5" *(Ver parte "Configuración con Palabras Clave")
- Crear una sección llamada agenda y asociarle tanto a la sección como a los artículos publicados en ella la palabra clave "Agenda" (si se publican artículos con la palabra clave Agenda aparecen en la miniagenda, aunque no en la de la sección)
- Crear para la sección de titulares, una sección y dentro de ella, una nueva sección por cada web referenciada, de forma que dentro de dicha sección sólo se referencie un sitio web, para que así la plantilla muestre en esa sección, los artículos sindicados como artículos propios. (sólo si se van a referenciar webs externas)
- Enviar a [Google Sitemaps](http://www.google.com/webmasters/sitemaps/) la url del sitio con la página sitemap (por ejemplo [http://Alufis35.uv.es/spip/spip.php...](http://Alufis35.uv.es/spip/spip.php?page=sitemap)) para que lo indexe
- Si se utiliza la web para un sitio de noticias, enviar a Google News la solicitud y a Google Sitemaps la url SITIO/spip.php?page=sitemap-googlenews para cumplir con los requisitos para los artículos (requiere redirects del servidor Web (.htaccess))
- Crear un artículo y asociarle la palabra "Frase", para que las plantillas tomen del título y del logotipo del artículo el logotipo y frase para la web. (opcional)
- Crear un artículo y asociarle la palabra "Notadeldia" para que se muestre el mensaje del día en la sección central de la portada. (opcional)
- Crear un artículo y asociarle la palabra "Banner_cabecera" para mostrar en la parte superior derecha el logotipo de dicho artículo y enlazarlo al campo URL de dicho artículo (opcional), si le añadimos una fecha de redacción anterior, podemos especificar la fecha de caducidad en la web (para campañas, etc)
- Crear la palabra clave "Banners" en Design y asociarla a los artículos que deban salir como al estilo de Banner_cabecera pero en el lateral derecho.
- Crear un artículo y asociarle la palabra "Creditos" para mostrar dicho enlace en el pie de cada página a una página con información sobre la web, autores, etc (opcional)
- Crear un grupo de palabras clave y llamarlo Licencia y luego, se van creando palabras clave a las que se le asocia el logotipo de la licencia, en la descripción se pone la URL para leer la licencia completa y en el TEXTO, se pone el código que aparece en [http://creativecommons.org/license/](http://creativecommons.org/license/) tras acabar de escogerla, para que los buscadores indexen el tipo de licencia del artículo

### Funcionamiento

Además de los esqueletos normales de SPIP, estos tienen los siguientes módulos que se utilizan para definir o mostrar información adicional al tipo de documento que estamos visualizando, permitiendo simplificar la forma de mantener el código de los esqueletos a través de la reutilización.

Actualmente está formado por los siguientes módulos:

~~~text
  Módulo              Cometido
  ------------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  mod_agenda         Muestra la mini agenda con los eventos del mes en curso
  mod_artsautalbum   Muestra los artículos del mismo autor cuando estamos en un album (en función del id_document)
  mod_artsaut        Muestra los artículos del mismo autor
  mod_artssec        Muestra los artículos en la misma sección
  mod_breves         Muestra las noticias breves del sitio
  mod_banners        Muestra hasta 5 banners laterales
  mod_popul          Muestra los 5 artículos más populares del sitio
  mod_salida         Muestra las opciones de salida del documento (Impreso o PDF)
  mod_secciones      Muestra las secciones que cuelgan de la raíz del sitio
  mod_tira           Muestra la tira cómica [E.C.O.L.](http://tira.escomposlinux.org/)
  mod_traduc         Muestra otras traducciones del artículo en curso
  mod_exif           Muestra las cabeceras EXIF de las imágenes (si existen datos)
  mod_inscrip        Permite inscribirse al sitio web
  mod_jerarquia      Muestra la jerarquía en secciones para llegar al artículo
  mod_jerarquiasec   Muestra la jerarquía en secciones para llegar a la sección
  mod_keywordbrev    Muestra las palabras clave de la breve
  mod_keyword        Muestra las palabras clave del artículo
  mod_nextprev       Muestra los botones adelante y/o atrás en las galerías
  mod_nota           Muestra el mensaje del sitio web en la portada
  mod_share          Muestra enlaces para publicar directamente la web en sitios de bookmarking social
  mod_nube           Muestra una nube de palabras clave en función de las asociadas a artículos en la web
  mod_rub            Muestra los artículos que estén en una rubrique (del raíz) que tenga asociada una palabra clave en un módulo lateral, eliminándolos de la parte principal de la web
  mod_license        Permite mostrar la licencia predeterminada CC by-nc-sa 2.5 o bien, las escogidas mediante palabras clave para cada artículo
  mod_technorati     Muestra los enlaces de otros blogs que enlazan al artículo en curso

  Plantilla                                   Soporte RSS
  ------------------------------------------- --------------------------------------------------------------------------------------------
  sommaire                                    Sitio completo
  article                                     Sitio completo
  breve                                       Sitio completo
  rubrique-* (album, synd,agenda,estándar)   Sitio completo y sección, en el caso de -synd se envía el feed de los artículos sindicados
  mot                                         Sitio completo y artículos con esa palabra clave
  album                                       se comporta como article
  el resto                                    el sitio completo
~~~

### Configuración por palabras clave

Ahora se puede configurar el aspecto visual de Mollio mediante el uso o no de palabras clave.

Todas estas palabras deberán estar creadas en el grupo "Design" para que no interfieran con los artículos mostrados en la web.

Palabras clave "BASE", dentro de Design, como todas las especiales

~~~text
  Palabra        Descripción
  -------------- -----------------------------------------------------------------------------------------------------------------------------------------------------
  _is_config   Indica que este archivo debe ser tratado como un fichero de configuración (Debe asignarse a todos los que quieran incluir alguna de las siguientes)

  Palabra                 Descripción
  ----------------------- --------------------------------------------------------------------------------
  _is_sommaire          Indica que el fichero de configuración afecta a la página principal
  _is_site              Indica que el fichero de configuración afecta al sitio (para el color)
  _is_article           Indica que el fichero de configuración afecta a los artículos
  _is_auteur            Indica que el fichero de configuración afecta a la página del autor
  _is_breve             Indica que el fichero de configuración afecta a las noticias breves
  _is_album             Indica que el fichero de configuración afecta a los álbumes fotográficos
  _is_plan              Indica que el fichero de configuración afecta al mapa del sitio
  _is_recherche         Indica que el fichero de configuración afecta a la página de búsqueda
  _is_correo            Indica que el fichero de configuración afecta a la entrada al correo
  _is_forum             Indica que el fichero de configuración afecta a la página de comentarios
  _is_forums            Indica que artículo redirije a la página de entrada a los foros
  _is_jabber            Indica que el fichero de configuración afecta a la página de entrada de Jabber
  _is_login             Indica que el fichero de configuración afecta a la página de inicio de sesión
  _is_rubrique          Indica que el fichero de configuración afecta a las secciones
  _is_rubrique-agenda   Indica que el fichero de configuración afecta a la Agenda
  _is_rubrique-album    Indica que el fichero de configuración afecta a los Álbumes
  _is_contact           Indica que el artículo se utilizará tanto por título como por enlace como medio de contacto

  Propiedad                           Descripción                                                                                                                                                           Aplica a
  ----------------------------------- --------------------------------------------------------------------------------------------------------------------------------------------------------------------- ------------
  _is_blue / _is_red / is_grey   Color del sitio (predeterminado azúl)                                                                                                                                 _is_site
  _has_email                        Habilita mostrar la página para ver el correo                                                                                                                         _is_site
  _has_jabber                       Habilita mostrar la página para el cliente jabber                                                                                                                     _is_site
  _has_customhead                   Incluye el archivo custom_head.html con los códigos de urchin, etc que quiera crear cada usuario                                                                     _is_site
  _shows_license                    Muestra el icono y texto del tipo de lidencia o sólo incluye las cabeceras para los buscadores en caso de que _has_license esté activado pero no _shows_license   _is_site
  _has_plan                         Habilita mostrar la pestaña de mapa del sitio                                                                                                                         _is_site
  _has_persistent_recherche        Muestra siempre el cuadro de búsqueda haya o no banner                                                                                                                _is_site
  _has_forums                       Muestra la pestaña para acceder a los foros                                                                                                                           _is_site

  Propiedad           Indica que la página debe incluir el módulo
  ------------------- ---------------------------------------------
  _has_agenda       mod_agenda.html
  _has_banners      mod_banners.html
  _has_breves       mod_breves.html
  _has_popul        mod_popul.html
  _has_nube         mod_nube.html
  _has_exif         mod_exif.html
  _has_inscrip      mod_inscript
  _has_keywords     mod_keywordbrev.html mod_keyword.html
  _has_license      mod_license.html
  _has_menu         A todas
  _has_mots         mod_mots.html
  _has_nextprev     mod_nextprev.html
  _has_salida       mod_salida.html
  _has_secciones    mod_secciones.html
  _has_share        mod_share.html
  _has_tira         mod_tira.html
  _has_traduc       mod_traduc.html
  _has_samesect     mod_artssec.html
  _has_sameauth     mod_artsaut.html mod_artsautalbum.html
  _has_rubriques    mod_rub.html
  _has_technorati   mod_technorati.html
  _has_contact      Incluirá un enlace al artículo marcado como _is_contact
~~~

Por ejemplo, para crear una web con el juego de colores Rojo, crearemos un artículo al que le asignaremos las palabras:

"_is_config" "_is_site" "_is_red"

Para crear una página de sommaire con nube de palabras clave, articulos populares y menu, haremos otro artículo con las palabras clave:

"_is_config" "_is_sommaire" "_has_menu" "_has_popul" "_has_nube"

NOTA:

Actualmente las plantillas sólo muestran los módulos que originalmente tenían, aunque se irán revisando para poder incluir más módulos con la intención de poder configurar mejor la apariencia sin necesidad de tocar el código HTML, así como, si fuera posible, elegir ubicación del módulo y orden

En caso de no indicar _is_config o ninguno de los módulos a los que afecta, se utiliza la que hasta ahora era la disposición estándar de módulos, etc

Los módulos, en caso de no tener datos que mostrar, no aparecen, por ejemplo el de traducciones, el de palabras clave o el de datos EXIF, de forma que sólo aparecerán en caso de que los hayamos inclido (y de que sean necesarios claro).

En principio, una vez tenidas en cuenta las anteriores consideraciones, podremos trabajar con normalidad con el sitio web, con la única limitación o pega (que no he sabido resolver y de la que no he recibido respuesta en la lista de SPIP) de que los artículos deben obligatoriamente llevar al menos una palabra clave asociada, que no pertenezca al grupo de palabras "Design", que por otro lado, dado que las plantillas establecen los META KEYWORDS en función de las palabras clave indicadas, nos
ayudará a que los buscadores visiten nuestras webs.

Te recomiendo en este caso que crees un grupo de palabras clave llamado "Tema" y que recomiendes (mediante la opción adecuada en la definición del grupo) que se escoja al menos una palabra de este grupo.

Para utilizar la agenda, deberás publicar artículos en su sección y asignarles la fecha del evento en el campo de "Fecha de Publicación Anterior", para que así SPIP la coloque en el día apropiado

En caso de que tengas alguna duda relacionada o considerases que alguna parte de este documento o de las plantillas se puede mejorar, no dudes en colgar un mensaje al respecto.

PD:

Puedes consultar el funcionamiento a nivel de usuario de las plantillas consultando el artículo Manual de usuario de los esqueletos modificados de spip-contrib, pues es análogo al de estas plantillas.

Puedes también consultar los [últimos cambios](https://github.com/iranzo/mollio-spip) en el código
