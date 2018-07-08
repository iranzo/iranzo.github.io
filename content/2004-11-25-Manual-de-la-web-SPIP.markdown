---
layout: post
title: Manual de la web SPIP
date: 2004-11-25T18:44:00Z
tags: cms, spip
lang: es
comments: true
---

### Manual de instrucciones de la web

### Introducción

Para facilitar el uso de la web tanto por personas acostumbradas al trabajo con ordenadores, como personas que no lo están,hacía falta una de forma de agrupar a la vez un sistema sencillo de manejar como potente en su funcionamiento y posibilidades de adaptación.

Se analizaron los diversos sistemas libres de gestión de contenidos (la opción de editar directamente las páginas quedó descartada por su complejidad y falta de uniformidad, etc), y entre los más habituales: PHP-Nuke, Post-Nuke, Drupal, etc se fueron descartando debido a los problemas de seguridad de los que adolecían los más extendidos como PHP-Nuke, o a la orientación a personas acostumbradas al manejo de estos sistemas.

### SPIP

Al final se escogió a SPIP: Sistema para la Publicación en Internet.  SPIP es un gestor de contenido diseñado con la idea de crear los archivos digitales de Le Monde Diplomatique y se creó combinando otros sistemas ya utilizados en revistas online.

Como características, cabe destacar, que debido a su orientación al mundo editorial SPIP contempla características muy interesantes:

- Varios niveles de acceso: Administrador, Editor, Redactor
- Estructura por secciones
- Completo soporte multilingüe (con gestión de traducciones entre artículos, etc)
- Soporte avanzado para formatos dentro de los artículos, inclusión de documentos como imágenes, vídeos, etc, enlaces internos, notas al pie, etc

Además de todas estas, SPIP aporta toda la funcionalidad de un gestor de contenido, como la creación de ficheros de sindicación, sindicación de titulares de otras páginas, buscador, imágenes por cada categoría, etc.

### Estructura de SPIP

SPIP está estructurado en torno a secciones (rubriques) que pueden estar ubicadas en el raíz del sitio, o bien dentro de otras secciones.

A nivel de publicación, SPIP soporta dos tipos de artículo, las breves y los artículos.

Las breves están orientadas a pequeñas notas, no muy desarrolladas, por ejemplo, convocatorias de reuniones, concentraciones, etc, por otro lado, los artículos están orientados a comunicados de prensa, y a noticias más elaboradas, por ejemplo, en el caso de una concentración, explicando los motivos que han llevado a esa situación, enlaces a las noticias en otros sitios, etc.

### La web

El aspecto actual se basa en una modificación de las plantillas estándar de SPIP, con plantillas especiales para mostrar galerías fotográficas, etc, así como iconos personalizados según la sección.

La potencia de SPIP se basa precisamente en tener un mismo sistema para edición de artículos, gestión, etc que a su vez permite aplicando unas plantillas bastante sencillas de crear, personalizar completamente el aspecto de la web, llegando a ejemplos como los mostrados en la web de spip.

Llegando a hacer que parezca mentira que por debajo esté funcionando el mismo sistema de gestión.

Actualmente existe un equipo desarrollando una nueva apariencia para la web, de forma que su aspecto resulte más atractivo y muestre de forma más organizada la información.

### Precauciones

A modo de ejemplo, publicar una noticia de dos líneas de texto convocando a una manifestación o enlazando a otra web como un artículo no es buena idea, cuando disponemos de las noticias breves que además de tener más visibilidad, no "desilusionan" al entrar y ver que están vacías.

De igual modo, al poner un enlace a otra noticia o a otra web, no basta con indicar la dirección, sino hacerlo de forma que la persona que lea la noticia, sin más que pinchar encima, pueda acceder a ella.

Claro está, es conveniente, una vez creado un artículo, ver el aspecto que tiene, para proceder a corregir todos los detalles que se nos pudieran haber pasado por alto.

Debemos pues, procurar dotar a los artículos y como consecuencia a la web, de los mejores contenidos posibles, lo más completos, referenciados y sobre todo actualizados, para así poder ser un lugar de referencia del que la gente pueda obtener información

### Entrada a la zona administrativa

En la página principal, pincharemos sobre el enlace "Espacio privado" y nos aparecerá la ventana de inicio de sesión.

Tras introducir el identificador de usuario, se nos solicitará la contraseña. Realizado este trámite, SPIP, nos muestra su panel de gestión.

A partir de ahora, podremos acceder a todas las funciones de SPIP para las que estamos autorizados, escribir artículos, solicitar su publicación, modificarlos, crear secciones, etc

La primera pantalla que nos aparece, es una especie de resumen de las citas pendientes según el calendario de la web, listado de secciones, artículos en curso de redacción, peticiones administrativas pendientes de atención, así como una lista con los atajos a las funciones que habitualmente más se utilizan.

La aplicación está plagada de iconos que nos muestran la ayuda de la que dispone el entorno para dicho cuadro, utilizando estos botones podremos conocer rápidamente cómo utilizar una función que desconocíamos.

Vamos a presionar sobre el enlace "Nuevo Artículo", ya que es donde principalmente vamos a trabajar.

### Creando un artículo

Cuando pinchamos el atajo para crear un nuevo artículo nos aparece una nueva ventana.

En ella, tenemos unos recuadros para ir rellenando los campos que luego darán forma a nuestro artículo.

#### Antetítulo, Título y Subtítulo

Como en una noticia de un periódico, tenemos un antetítulo, un título y un subtítulo, que nos permiten crear una pequeña ampliación sobre el texto que vamos a tratar. A modo de ejemplo, se pueden consultar noticias ya publicadas en la web que hacen uso de estos campos.

El campo estrictamente necesario es el título y la sección.

#### Sección

Debemos escoger correctamente la sección, para así facilitar que artículos de temáticas relacionadas estén juntos, a la vez que facilitamos que la persona encargada de la labor de editor, tenga que perder menos tiempo y pueda realizar un mejor trabajo.

Además de esta estructura, tenemos una sección para tablón de anuncios (donde publicaremos las breves), otra para galería fotográfica (artículos que no tengan texto, o muy pequeño y tengan muchas fotografías adjuntas, por ejemplo el de una concentración, evento, etc).

#### Descripción

Una vez escogida adecuadamente la sección donde irá ubicado, debemos especificar una descripción rápida del artículo que aparecerá junto al título mientras el artículo esté en la parte principal de la portada y que ayudará al visitante a conocer el contenido, en caso de omitirse, se utilizará el comienzo del texto del artículo.

#### Epígrafe

El epígrafe es una ampliación de la descripción que nos permite obtener una introducción al texto del artículo.

#### Texto

Este es el lugar donde trabajaremos principalmente, como habremos visto, en cada uno de los cuadros tenemos el botón de ayuda para abrir la ayuda del entorno y conocer el funcionamiento de cada cuadro, su función y las opciones que podemos utilizar en su interior.

Dentro del cuadro de texto podemos utilizar código HTML para aplicar formato, o bien utilizar los atajos que incorpora SPIP.

#### Atajos

Párrafos: Se deben separar entre sí con una línea en blanco: dos retornos de carro seguidos.

Listas numeradas "-#" o listas de elementos "-" al principio de la línea. Listas anidadas: añadiendo asteriscos tras el guión según el nivel de anidamiento.

Cursiva, texto entre llaves "`{`" y "`}`"

Negrita, texto entre llaves dobles "`{ {`" y "`} }`"

Subtítulos, precedido por tres  \#\#\#

Línea de separación horizontal, cuatro guiones seguidos "`----`"

Hipervínculos:

- a otro artículo: "[texto](http://alufis35.uv.es/destino)", donde texto y destino son los que vamos variando nosotros, existen una serie de destinos "especiales":
- art# Artículo,
- br# Enlace a la noticia breve,
- doc# Documento adjunto,
- img# Imagen adjunta,
- emb# Adjunto incrustado en la web (por ejemplo un vídeo),
- mot# Palabra clave,
- site# Web,
- aut# Autor",
- como por ejemplo art# que nos permite insertar el enlace a otro artículo de la web, y si dejamos el texto en blanco, nos indica el título que le asignamos.

Hipervínculos a diccionarios externos, por defecto WikiPedia `[?palabra]`

Notas al pie de página, texto entre dobles corchetes "`[[` y "`]]`", por defecto son notas numeradas, si pones entre "<" y ">" (dentro de los corchetes), puedes forzar a un número o a una nota con por ejemplo asterisco.

Tablas: Se separa cada columna con la barra vertical: "`|`" y se indica título entre dobles llaves "{ {" y "} }`

Texto sin interpretar: encerrado entre el tag HTML

Código a no interpretar y mostrar de forma especial entre el tag: "`code`"

#### Post Scriptum

Este cuadro nos permite añadir texto al final del artículo, que por ejemplo nos puede ser útil para referenciar a otros artículos relacionados, etc.

### Las breves

Una noticia breve, se parece mucho a un artículo, con la limitación de sólo poder publicarse en las secciones de primer nivel.

La breve contiene Título, opción para escoger sección, el texto de la breve y un enlace.

Todo en SPIP depende de la plantilla que se utilice, de forma que algunos campos pueden no aparecer a pesar de haberlos puesto (de ahí el siguiente punto de este documento).

Por norma, sería aconsejable limitar las breves a pequeños avisos, que se escribieran todo en el título, por ejemplo : "Próxima reunión del AdR el día X en la cafetería del campus"

Luego en el texto, se podría ampliar un poco más la información, pero siempre, teniendo en mente que se debería escribir un artículo al que enlace la breve, indicando los motivos que impulsan a esa concentración, cita, etc de forma que quede ampliada la información que con el título no es suficiente.

### Comprobando el resultado

Una vez hemos escrito un artículo y hemos presionado el botón de validar, nos aparece una vista previa de cómo quedará el artículo, su título, antetítulo, descripción, etc.

Como "extras" a lo que ya habíamos visto, ahora podremos cambiar el idioma del artículo por si no es el adecuado, añadir autores al mismo (para artículos compartidos) y sobre todo, revisarlo para ver que esté bien escrito, con un formato adecuado, etc.

Tras realizar todos estos pasos, podemos cambiar el estado para pedir la publicación del mismo, así el editor podrá saber que queremos publicarlo, y tras comprobar que es correcto, procederá a validarlo para que aparezca en la web.

Si el artículo lleva alguna fotografía, podemos adjuntarla también en este paso, así como algún documento. Si quisiéramos ubicarlas en algún lugar en concreto del documento, deberíamos volver a modificar el documento y utilizar los enlaces explicados anteriormente con los números que asigna SPIP a cada documento adjuntado.

También podemos adjuntar iconos personalizados a los artículos, de forma que por ejemplo un artículo que vaya en la sección de acción sindical aparezca como un megáfono.

Actualmente, si no se especifica ninguno en el artículo, se utilice el de la sección.

### Consideraciones

Si el artículo va a tener documentos adjuntos, sería interesante, que por ejemplo en el caso de referencias técnicas, etc, éstos se publiquen como un artículo, no como un adjunto a un artículo, el motivo es muy sencillo, si un artículo lleva un adjunto, es poco probable que un buscador lo descargue y lo indexe, mientras que si es texto, los buscadores lo encontrarán, lo añadirán a sus bases de datos, y permitirán que se encuentre el artículo con mayor facilidad.

Si el artículo va a tener adjuntadas muchas fotografías, por ejemplo en el caso de fotografías de una install party, un evento, etc, es recomendable crear dos artículos, uno con todo el texto del artículo, detallando por ejemplo, el motivo del evento, del programa del mismo, y por otro lado, en la parte de "post Scriptum", ponga el enlace a otro artículo publicado en la sección de "Galería fotográfica", donde se pondrían todas las imágenes relacionadas, permitiendo que la gente que sólo esté interesada en el texto, lo descargue rápidamente y por otro lado pueda consultar las fotografías con más calma.

Una de las cosas a tener en cuenta para la publicación: cuanto más completo sea el artículo con textos claros, bien estructurados, enlaces a los lugares de dónde se ha sacado la información, o dónde se puede ampliar o contrastar la misma, enlaces a la Wikipedia para las palabras más "complejas" o que son importantes, pero no tienen lugar para una explicación dentro del artículo, etc, harán por un lado que los buscadores encuentren y valoren mejor la página y la información, favoreciendo que se la visite, y por otro lado, harán que los visitantes se lleven una buena impresión del trabajo realizado y vuelvan a ella convirtiéndola en un lugar de consulta frecuente, ampliando así su utilidad.
