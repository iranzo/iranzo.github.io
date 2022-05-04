---
layout: post
title: Migrar de SPIP 1.9 a 2.0
date: 2008-12-13T18:10:58.000Z
author: Pablo Iranzo Gómez
tags:
  - spip
  - foss
lang: es
modified: 2022-05-04T13:15:43.525Z
categories:
  - FOSS
---

Con la reciente salida de SPIP 2.0, llega el momento de considerar migrar.

Como siempre es necesario que comprobemos si tenemos una copia de seguridad reciente, la compatibilidad de los plugins que utilizamos, etc

Una vez nos hemos armado de valor, y en el caso de la web que ahora estás leyendo, el cambio se hizo bajando el fichero zip de la nueva versión de spip, descomprimiéndolo en /var/www/html/ para conservar los contextos SELinux del servidor para páginas web y sobretodo, desactivando durante la actualización las plantillas, urls personalizadas, etc.

Una vez descomprimido y entrado a la parte interna de la web se nos pedirá actualizar la base de datos.

El proceso que llevará mayor o menor tiempo en función de su complejidad, artículos, etc nos ofrecerá al acabar la nueva interfaz de SPIP con más funciones AJAX, etc.

En este punto ya podemos volver a activar nuestras plantillas personalizadas y ahora, y como novedad, podemos definir el tipo de url's a utilizar para la web desde el espacio de configuración del sitio, incluyendo el nuevo modo 'arbóreo'

Puedes ver la lista de novedades (en francés) en <http://www.spip.net/fr_article3784.html>

Yo he habilitado la compresión gzip de las páginas web para consumir menos ancho de banda, así como la gestión del tipo de url's desde dentro de la intranet.

Como mejoras he notado que algunos feeds que me daban fallo vuelven a funcionar con las mejoras del nuevo spip y un aspecto de mayor velocidad, así como formularios más 'vistosos' en la parte interna de edición

Por supuesto, tienes la posibilidad de descargar plugins desde la propia interfaz interna de SPIP que se instalarán automáticamente para su uso...

Por ahora no he encontrado problemas con las plantillas de `mollio` que utilizo, excepto con el plugin de PDF's que he actualizado en el repositorio para esta versión.

A disfrutarla!
