---
layout: post
title: Migrar de SPIP 1.8 a 1.9
date: 2006-07-01T14:48:00.000Z
tags:
  - spip
  - cms
  - foss
lang: es
modified: 2022-03-23T09:58:32.713Z
---

### Introducción a SPIP 1.9

SPIP 1.9 va a traer bastantes mejoras respecto a versiones anteriores, entre ellas:

- Abandono de la compatibilidad con PHP3 y con ella, las extensiones ".php3" en los ficheros
- Nueva organización de las carpetas
- Nuevo sistema para llamar a los esqueletos (dejando de lado también el .php3)
- Nuevas balizas y filtros
- Sistema de complementos
- Nuevos criterios para bucles (incluído uno para paginación)
- Introducción de algunos elementos de programación AJAX(Desplazan parte de la carga de trabajo del servidor al cliente que visita la página, haciendo que la navegación sea más fluída y el servidor no se sobrecargue)
- Soporte UTF-8

### Proceso de actualización a SPIP 1.9 (de forma limpia)

El proceso lo podemos llevar a cabo de varias formas, tanto por la parte del servidor como por las plantillas, pero teniendo en cuenta una serie de precauciones.

La forma más recomendablem a mi parecer es la siguiente, ya que limpiamos lo que pudiera quedar del SPIP antiguo y mantenemos los datos para la nueva versión.

Una vez preparadas las plantillas para la nueva versión (Ver cambios necesarios más adelante), seguiremos los siguientes pasos:

- Antes de nada, hacer una copia de seguridad de la base de datos y descargar todos los archivos de la web (esqueletos), spip, etc (por si acaso) y la base de datos que hemos copiado entre ellos.
- Si hemos personalizado los esqueletos por nosotros mismos, habremos tenido que adaptarlos a la nueva versión (aunque en la mayoría de los casos los antiguos son prácticamente compatibles exceptuando pequeños cambios), si son los estándar, podremos eliminarlos del servidor.
- De la web, eliminaremos todos los archivos excepto el ecrire/inc-connect.php3, el ecrire/mes_options.php3 y el /mes_fonctions.php3 y estos tres archivos, los renombraremos a ".php", igualmente, mantendremos la carpeta IMG ya que no se modificará y nos ahorrará mucho tiempo de volver a subirlas a la web.
- Subimos la nueva versión de SPIP descargada de spip.net.

Hasta aquí, tenemos actualizados los ficheros, ahora viene la base de datos, por lo que:

- Entraremos a [http://www.nuestrositio.com/ecrire/](http://www.nuestrositio.com/ecrire/) e introduciremos un nombre de usuario y contraseña de un administrador, de este modo al acceder a la parte privada nos pedirá actualizar la versión de la base de datos, crearemos el fichero que nos indique en ecrire/data/ y concluirá la actualización.
- Lo siguiente es evidentemente... crear una copia de la base de datos ahora ya con la versión 1.9 y salvarla a nuestro equipo por si acaso.
- Sólo nos queda copiar nuestras plantillas modificadas al servidor tal cual las teníamos con 1.8 y así mantendremos el aspecto original de la web.

- Si nuestro proveedor soporta el htpasswd, sería recomendable copiar el que viene con spip htpasswd.txt al nombre que nos haya indicado nuestro proveedor (habitualmente ".htpasswd"), así como habilitar las url_propres en ecrire/mes_options.php

### Adaptar los esqueletos

Una de las cosas a tener en cuenta, es que con la desaparición de los .php3, han desaparecido también (al formar parte de las mejoras) las parejas de esqueletos .html/.php3, ahora las llamadas a los esqueletos se realizan con el parámetro page=plantilla.html, o con una nueva baliza llamada #URL_PAGE que nos permite crear url's de la forma en la que SPIP las utiliza y que previsiblemente, hará que no tengamos que volver a poner las url's a mano a pesar de los cambios de versión porque podrá
encargarse SPIP de adaptarlas a la nueva forma de hacerlo en cada caso.

Por ejemplo, un INCLURE antes se hacía así:

```spip
<INCLURE(cabecera.php3){id_rubrique=3}>
```

y ahora se hace de la siguiente forma:

```spip
<INCLURE{fond=cabecera}{id_rubrique=3}>
```

Al igual que antes, por ejemplo para llamar a un album fotográfico, hacíamos:

```spip
<INCLURE(album.php3){id_document=34}>
```

Ahora, haremos:

```spip
<INCLURE{fond=album}{id_rubrique=3}>
```

que automáticamente spip transformará en:

```spip
spip.php?page=album&id_rubrique=3
```

Este nuevo sistema, además de facilitar la validación XHTML y hacerlo independiente del tipo de URL (propre, html, propres2, etc) que estemos utilizando, permite añadir y eliminar fácilmente parámetros de la url sin más que concatenar |parametre_url'variable',valor, separador o bien, eliminar parámetros sin más que dejar el valor vacío.

En los esqueletos que creemos o modifiquemos emplearemos la baliza `#DOSSIER_SQUELETTE/cualquier_contenido` cuando queramos referenciar cualquier directorio o archivo que contenga la carpeta de nuestros esqueletos.

Este método, por ejemplo, se usa en la referencia a las hojas de estilo, podremos hacerla de modo que sea independiente del lugar donde las ubiquemos o del nombre que tenga la carpeta, al utilizar la baliza `#DOSSIER_SQUELETTE`, devolverá la ruta donde estén almacenadas. De este modo, podremos incluir el archivo `favicon.ico` dentro de la carpeta de las images de nuestras plantillas con `#DOSSIER_SQUELETE/images/favicon.ico`.

Así mismo, a partir de esta versión podemos indicar la ruta hasta el directorio de las imágenes de forma genérica, dando de este modo libertad para la elección del nombre de las carpetas tales como la de las imágenes utilizadas en la web (anteriormente era obligatorio renombrarla a IMG/).

Otro punto importante, es la posibilidad de crear ficheros `local_LANG.php`, donde LANG es el código ISO para el idioma, por ejemplo, es fr uk it ca, etc que permiten crear textos propios que serán traducidos a los idiomas en los que lo hayamos configurado, permitiendo así poder internacionalizar con mayor facilidad los esqueletos, y a diferencia de otras versiones, podemos incluirlos en la carpeta del esqueleto para poder mantenerlos sin mezclar nuestro código con el estándar de SPIP.

PD: Puedes ver otras mejoras a SPIP en el siguiente artículo: [http://www.spip.net/fr_article3368.html](http://www.spip.net/fr_article3368.html), de momento, en Francés
