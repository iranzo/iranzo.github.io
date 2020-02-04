---
author: Pablo Iranzo Gómez
title: Clonando etiquetas Lego Dimensions
tags: lego, xbox, playstation, ps3, ps4, wii, dimensions, nfc, clonar, ntag213
layout: post
date: 2020-02-04 00:30:24 +0100
comments: true
category: blog
description:
lang: es
slug: lego-dimensions-cloning
---
[TOC]

## Introducción

En el artículo [Lego Dimensions]({filename}2019-08-19-lego-dimensions.es.md), hablaba de los packs disponibles para jugar con la consola.

Desgraciadamente, no están todos disponibles para ser comprados excepto de colecionistas, <brickset.com> o algunos vendedores.

Tras algo de búsqueda, diversas páginas proporcionan información acerca de los propios 'tags' o etiquetas y de cómo arreglarlos o clonarlos.

## Lista de materiales

Cada base de Lego Dimensions es una etiqueta NFC `NTAG 213` que puede ser sólo lectura (las figuritas) o lectura-escritura (vehículos).

Con un lector/escritor NFC en tu teléfono móvil, las etiquetas se pueden copiar/clonar para así, poder reparar etiquetas rotas sin tener que pasar por comprar otra vez el pack (la bse se puede abrir con un destornillador de precisión haciendo presión en unas pequeñas marcas que lleva, opuestas en la base con una forma de `+`).

Para poder 'crear' tus etiquetas, la siguiente lista de materiales es útil:

|    Elemento    |                 AliExpress                 |                                               Amazon                                                |
| :------------: | :----------------------------------------: | :-------------------------------------------------------------------------------------------------: |
|   Etiquetas    | <http://s.click.aliexpress.com/e/dMeJ0gug> |  [![]({static}imagen/dimensions/ntag213.png)](https://www.amazon.es/dp/B00NG4W3K2?tag=redken-21>)   |
|   Perforador   | <http://s.click.aliexpress.com/e/5U3WF4fq> | [![]({static}imagen/dimensions/holepuncher.png)](https://www.amazon.es/dp/B007QJC8WG?tag=redken-21) |
| Portaetiquetas | <http://s.click.aliexpress.com/e/_ruEsf3>  | [![]({static}imagen/dimensions/coinholder.png)](https://www.amazon.es/dp/B07CNTTVF9?tag=redken-21)  |

## Más información

Cada etiqueta puede leerse/escribirse desde tu teléfono (Probado con un [Nexus 5](https://www.amazon.es/dp/B016B7INC2?tag=redken-21), [Sony Xperia Z5](https://www.amazon.es/dp/B013WSM36A?tag=redken-21), [Samsung Galaxy S8](https://www.amazon.es/dp/B06XXFHG6J?tag=redken-21) y [Samsung Galaxy Note 9](https://www.amazon.es/dp/B07FT169LZ?tag=redken-21)), el 'truco', es siempre primero 'leer' la etiqueta y luego escribirla con los parámetros modificados.

Cada etiqueta dispone de un campo al principio con el número de serie, que no puede ser modificado, y una contraseña que se utiliza para validarla.

En este artículo [Manual para clonar figuras de Lego Dimensions](https://www.elotrolado.net/hilo_manual-para-clonar-figuras-de-lego-dimensions_2209995) habla de dos métodos, uno, usando una aplicación llamada `ldtageditor`, que puede localizarse en google mediante  <https://www.google.com/search?client=firefox-b-d&q=ldtageditor+apk> y otra, utilizando una aplicación de la Play Store de Android llamada [MIFARE++ Ultralight](https://play.google.com/store/apps/details?id=com.samsung.sprc.fileselector).

El segundo método es más 'complicado', ya que incluye calcular manualmente los ID's mediante una web o mediante una aplicación (busca por `ldcharcrpyto` o lee este mensaje <http://www.proxmark.org/forum/viewtopic.php?id=2657&p=2>).

El truco aquí está en::

- Lee las etiquetas antes de seleccionar el personaje/vehículo y escribirlo
- No pongas personajes que no están disponibles en la etiqueta, ya que hará que la consola no los reconocerá y no podrás usarlos hasta que los 'formatees' (usa la aplicación NFC Tools para eso)

Haciéndolo, serás capaz de clonar o escribir las etiquetas que estaban dañadas y poner las nuevas etiquetas en su lugar para permitirte seguir jugando como hacías!

Existe también un conjuno de imágenes 'listas-para-imprimir' en uno de los posts en <http://www.mediafire.com/file/b2d5a9dwj7ksry9/LD1inchimages.zip> que contiene las imágenes para cada etiqueta de personaje posible y sus vehículso con sus mejoras.

Disfruta!

Sigue mi canal de ofertas en Lego en Telegram aquí: <https://t.me/brickchollo>
