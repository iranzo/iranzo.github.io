---
layout: post
title: Combinar correspondencia con OpenOffice.org
date: '2010-04-05T21:50:00.001+02:00'
author: Pablo
tags: 
modified_time: '2010-04-05T22:16:08.804+02:00'
blogger_id: tag:blogger.com,1999:blog-4564313404841923839.post-834340470617137892
blogger_orig_url: http://iranzop.blogspot.com/2010/04/combinar-correspondencia-con.html
---

Hacía un tiempo que no usaba la función de combinar correspondencia y en el equipo de sobremesa con Fedora 13 x86_64 no conseguía hacerla funcionar.

Antes de nada: 

####¿Qué es combinar correspondencia?

Una de las ventajas de tener la información en formato digital es su tratamiento, y una de las opciones más habituales, es tener bases de datos con la información que necesitamos y acceder a ella.

La función de 'combinar correspondencia' permite utilizar los datos de una base de datos para rellenar campos en un documento y luego, escoger la salida (impresión, nuevos documentos, email, etc).

#### Pasos

Antes de nada, es conveniente instalar el paquete `openoffice.org-emailmerge`

En mi caso, tuve que vaciar la carpeta de configuración de OpenOffice (no me aparecía la opción de configuración para correo dentro de las opciones de 'Writer').

En dicha opción, deberemos configurar servidor SMTP saliente, email, nombre del remitente, etc.

Una vez configurado, podemos iniciar el asistente desde el menú herramientas y paso a paso seguir el proceso de creación.

En los diversos pasos iremos:

- Escogiendo el documento origen
- Origen de datos (por ejemplo una hoja de cálculo ODS y también aplicarle filtros para escoger sólo los registros (por filas) que nos interesen)
- Tipo de destino (Cartas, o email)
- Documento (aquí, podremos minimizar el asistente y comenzar a editar nuestra carta, email, etc)
- Proceder a combinar el documento (haciendo el envío de emails, etc).

Los pasos 'críticos' son :

- escoger el origen de datos y ajustar el filtro para afectar sólo a los datos que nos interesen
- editar el documento que sirve de plantilla para la combinación insertando todos aquellos campos que queramos que aparezcan (por ejemplo, de una libreta de direcciones: nombre, apellidos, dirección, etc)
- a la hora de la combinación , escoger si es un email, el asunto y el campo que contiene la dirección de email del destinatario.

Una vez finalizado, en ese último paso del asistente podemos lanzar el envío de los correos.