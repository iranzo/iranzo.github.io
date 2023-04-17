---
layout: post
title: Herramientas de sincronización/backup
date: 2011-12-08 11:52:00 +0100
author: Pablo Iranzo Gómez
lang: es
tags:
  - fedora
  - dropbox
  - foss
modified: 2023-04-17T21:48:05.222Z
categories:
  - FOSS
  - Fedora
---

Hace tiempo, estuve buscando una forma de simplificar por un lado, la sincronización de los documentos, fotos, etc entre diversos ordenadores y por otro utilizar esa copia en otros equipos a modo de 'backup' en caso de fallo hardware de algún equipo.

Estuve probando y evaluando diversas herramientas multiplataforma y junto a algunas más, las que más probé fueron estas:

- [AeroFS](http://www.aerofs.com/)
- [Dropbox](http://db.tt/NV5zDvs)
- [Syncany](http://www.syncany.org/)
- [Sparkleshare](http://sparkleshare.org/)
- [Wuala](http://www.wuala.com/)
- [SpiderOak](https://spideroak.com/download/referral/dfba22f9764b55ab68427da014e9f0e5)

Actualmente necesito 'salvar/sincronizar' unos 35Gb de datos (fotos la gran mayoría y no precisamente en RAW), lo que provocó estas comparativas, preferiblemente de servicios que ofrecieran espacio gratuito.

En resumen, de las OpenSource (Syncany/Sparkleshare), están todavía bastante en pañales, aunque prometen mucho, más syncany por la variedad de posibles destinos de copias que sparkleshare (necesidad de repositorio git, etc).

De las 'comerciales', Wuala ofrecía posibilidad de compartir espacio local a cambio de espacio en la nube que permitía compartir esos GB no utilizados por GB fuera de donde tenías tus ordenadores, garantizando que en caso de problemas fisicos, ambientales,etc, poder acceder a los datos, pero en Octubre de 2011, con la salida de la nueva versión, dejaron de ofrecer el servicio, convirtiendo el espacio conseguido en un 'vale' hasta Octubre de 2012... que ha provocado que tenga que reemplazar esa solución que venía utilizando.

Dropbox, a pesar de los referrals y de cuenta de email ".edu", no ofrece más de 16 Gb a no ser que sean planes de pago, que por ahora la deja fuera (además del hecho de no permitir especificar clave de cifrado de los datos, que por otro lado aporta que si alguien había subido el fichero antes, la subida es instantánea).

SpiderOak ofrece menos espacio (pero parte de 5Gb y ahora es posible subir hasta 50Gb por referrals), tiene repositorio para yum para las actualizaciones y se puede ejecutar tanto en modo 'GUI' como en línea de comandos (por contra la sincronización se lanza cada x tiempo, no parece tan fluida como Dropbox).

AeroFS: una recién llegada, que sigue en versión alpha, basada en Java, multiplataforma (EL6 o superior) y que no ofrece de 'salida' espacio online, simplemente la sincronización entre tus equipos, pudiendo hacer cambios en cualquiera de ellos y luego sincronizándolos entre sí, incluso sin conectividad a Internet (sólo hace falta internet para dar de alta una carpeta nueva en un equipo o dar de alta un equipo (para sincronización de autorizaciones con el servidor de Aerofs)).

Actualmente AeroFS es la que más promete por no limitar el espacio excepto al que dispongas en tus equipos, pero con mi colección de documentos y 4 equipos a la vez he tenido problemas de ficheros renombrados "terminados con números entre paréntesis", sincronizaciones lentas (utilizar un interfaz vía hamachi en lugar del interfaz de red local), no sincronización de enlaces simbólicos y destrucción de ficheros con enlaces duros (deja sólo una copia), pero es la única que cubre por ahora mis necesidades con respecto a lo que hacía wuala (a excepción de no tener aplicaciones para móvil y claro está, no funcionar si ningún equipo con los datos está conectado).

De como evolucionen syncany y aerofs de aquí a octubre, decidirá si escojo una de estas dos o sigo evaluando alternativas para los backups... por ahora sigo con Dropbox para cosas rápidas que no necesito excesiva privacidad y para el resto Wuala y he añadido duplicity para hacer backup a un NAS en mi red local a la espera de ir probando mejor AeroFS y ver cómo respira syncany...
{{<disfruta>}}
