---
author: Pablo Iranzo Gómez
title: Autofirma en Linux
tags:
  - foss
  - Fedora
  - certificate
  - signing
  - Linux
layout: post
date: 2021-09-09 00:00:00 +0100
category: tech
description: Instalando Autofirma en Fedora 34
lang: es
slug: autofirma-en-linux
modified: 2022-03-23T10:01:02.570Z
---

Recientemente, estuve usando un ordenador que no utilizo con frecuencia, pero necesitaba poner una firma en un PDF (y la persona receptora no sólo quería ver la firma 'digital', sino tener una imagen 'firmada').

Autofirma, descargable desde el [portal de firma electrónica](https://firmaelectronica.gob.es/Home/Descargas.html) tiene por suerte una versión para Fedora en formato RPM y que permite realizar esta función.

Lamentablemente, a pesar de haberlo instalado y que se instalaron algunas dependencias adicionales, el programa no arrancaba como correspondía.

Finalmente, cuando volví a usar mi equipo habitual, vi que faltaba una dependencia, Java estaba instalado, pero al parecer, necesitaba también el paquete `java-11-openjdk` además del ya instalado `java-1.8.0-openjdk`.

Espero que encuentres esta nota si te falla!
