---
title: Trucos y consejos para el RHCE y RHCSA
date: 2022-07-13T21:00:35.086Z
lang: es
tags:
  - RHCE
  - RHCSA
  - RHEL
  - FOSS
  - Linux
categories:
  - FOSS
cover:
  image: https://admins.guru/rhel8-cover.png
lastmod: 2023-08-25T09:45:44.535Z
---

Aunque hice el examen de RHCE algún tiempo, sigue habiendo trucos y consejos que siempre transmito a los interesados y que vienen indicados en el libro que escribimos: [Red Hat Enterprise 8 Administration](https://s.admins.guru/buyonamazon):

- No recuerdes cada paso, por ejemplo, nunca recuerdo la configuración de BIND, asi que recuerdo el paquete con el fichero que tiene ejemplos, lo instalo y lo consulto.
- Instala `mlocate` y ejecuta `updatedb` tan pronto como empieces, así podrás usar `locate <fichero>` para encontrar archivos rápidamente en tu sistema.
- Usa tu editor preferido... Es habitual user `vi` o `vim` porque son bastante estándar, pero si estás acostumbrado a otro, ponte cómodo en el sistema.
- Como decía un instructor: "Cualquiera con el tiempo suficiente pasaría el RHCE"
- El examen RHCE/RCHSA está basado en el rendimiento... debes cubrir los objetivos durante la duración del examen, no necesariamente en la forma más elegante.
  - Por ejemplo: si te dicen que configures el `resolv.conf` puedes bien usar `nmcli` para modificar la configuración o puedes escribir el fichero con un `echo nameserver 1.1.1.1 > /etc/resolv.conf`, al final, en neto, ambas tendrán el mismo efecto, y aunque es cierto que usar `nmcli` permite algo más portable y elegante, pero para el examen... el objetivo es hacerlo de la forma más rápida para poder pasar al siguiente punto.

Puedes encontrar más consejos en [Red Hat Enterprise 8 Administration](https://s.admins.guru/buyonamazon)
{{<disfruta>}}
