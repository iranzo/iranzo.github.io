---
layout: post
title: Error según número de pitidos en la BIOS
date: 2004-04-12T09:54:00Z
tags: hardware
lang: es
comments: true
slug: Error-segun-numero-de-pitidos-en-es
---

Las BIOS (Basic Input Output System) de los pc's informan de los errores del hardware del pc en el arranque mediante un código de pitidos en el caso en el que no puede aparece nada por pantalla... aqui los podrás ver..

Código de errores emitido por la BIOS para indicar los problemas que surgen durante el POST (Power On Self Test (Autocomprobación tras el encendido)) del arranque:

## Errores Fatales

| Número de Pitidos | Significado                         |
| ----------------- | ----------------------------------- |
| 1                 | Error de refresco DRAM              |
| 2                 | Fallo de los 640Kb Ram base         |
| 4                 | Error del timer de sistema          |
| 5                 | Fallo del procesador                |
| 6                 | Error de la puerta de teclado A20   |
| 7                 | Error de excepción del modo virtual |
| 9                 | Error de checksum de la ROM-BIOS    |

## Errores no fatales

| Número de Pitidos | Significado                                               |
| ----------------- | --------------------------------------------------------- |
| 3                 | Fallo de comprobación de memoria convencional y extendida |
| 8                 | Fallo de monitor y fallo de trazado vertical y horizontal |
