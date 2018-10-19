---
layout: post
title: Privacidad en las comunicaciones electrónicas
date: 2004-05-23T20:40:00Z
tags: software, privacy
lang: es
comments: true
---

**Tabla de contenidos**
<!-- TOC depthFrom:1 insertAnchor:true orderedList:true -->

1. [Orígenes](#orígenes)
2. [Actualidad](#actualidad)
3. [¿Cómo proteger nuestra privacidad entonces?](#¿cómo-proteger-nuestra-privacidad-entonces)
    1. [Web](#web)
    2. [Redes](#redes)
    3. [Correo Electrónico](#correo-electrónico)
    4. [Redes inalámbricas](#redes-inalámbricas)
4. [Marco legal](#marco-legal)
5. [Consideraciones](#consideraciones)
6. [Enlaces](#enlaces)

<!-- /TOC -->

Este artículo, es una sencilla introducción al mundo del cifrado y a modo de resumen o extracto de diversos artículos, presenta información que luego es ampliada en los enlaces indicados, tanto en el cuerpo del artículo como al final en la sección dedicada a tal efecto.

<a id="markdown-orígenes" name="orígenes"></a>
### Orígenes

Desde tiempos inmemoriales, a la vez que se avanzaba en la comunicación, se avanzaba también en la necesidad de mantener la privacidad de las mismas...

Cuando la escritura fue dejando de ser un privilegio de unas minorías y comenzó a utilizarse más ampliamente, era necesario también una firma, algo que indicase que el mensaje provenía de una persona y el lacre hizo perfectamente su función, una vez terminado un escrito, se plegaba sobre sí mismo y se dejaba caer unas gotas de lacre sobre la junta y se presionaba con un sello sobre el papel, dejando por un lado las dos partes del escrito unidas y sólo separables rompiendo el sello y por otro
lado, con un sello identificativo de cada persona que certificaba que ese mensaje había salido de sus manos.

El lacre ha permitido que los mensajes fueran firmados y que se supiera si habían sido leídos o no de antemano, pero no permitía proteger la privadidad, ya que siempre podía ser interceptado y leído y ya nunca entregado, lo que lo convertía en poco fiable para transmitir grandes secretos.

Se hacía necesaria una forma de codificación que a ojos de extraños fuera ininteligible, pero para los receptores y emisores legítimos fuera clara.

Uno de los métodos más utilizados era la permutación de letras, si en un mensaje cambiábamos de orden todas las letras, siguiendo por ejemplo el orden del abecedario tendríamos un mensaje completamente distinto:

Siguiendo el abecedario: abcdefghijklmnñopqrstuvwxyz y una semilla de permutación, el mensaje:

- Hola, este es un mensaje de saludo

...quedaría con una clave de permutación 13 (rot13)[^1]:

- Ubyn, rfgr rf ha zrafnwr qr fnyhqb

Que a simple vista parece algo ininteligible.

Estos sistemas se basaban en un secreto común, un código o llave que aplicada dos veces sobre el mismo mensaje en un sentido o en otro, lo descifraba o cifraba. Lo que se hacía entonces era transmitir una clave de cifrado y aplicarla por ambas partes para poder leer el mensaje.

Los problemas aparecían cuando la clave era interceptada, ya que así, si se interceptaban los mensajes, aplicando la clave era posible descifrarlo.

Un buen sistema de cifrado debe ser "fuerte", existen algunos, que mediante un análisis del texto cifrado puede romperse, por ejemplo, sabiendo las frecuencias de aparición de las letras en un texto suficientemente grande de un idioma, si repetimos la estadística con un mensaje cifrado, podríamos asociar en base a las presencias relativas de cada carácter, su equivalencia entre el cifrado y el descifrado, pudiendo así romper la protección del mensaje.

Uno de los sistemas "modernos" más conocidos fue la máquina [Enigma](http://es.wikipedia.org/wiki/Enigma) famosa por ser utilizada por las fuerzas militares alemanas durante la [Segunda Guerra Mundial](http://es.wikipedia.org/wiki/Segunda_Guerra_Mundial) y permitir, tras romper su cifrado, adelantar el fin de la guerra.

La máquina Enigma se basaba en una clave que una vez introducida cambiaba mediante unos tambores rotatorios el resultado de apretar una tecla, de forma que al apretar varias veces una misma tecla, se obtenían resultados diferentes, dificultando enormemente el descifrado de un mensaje si no se conocía la clave inicial.

<a id="markdown-actualidad" name="actualidad"></a>
### Actualidad

Hoy en día las comunicaciones siguen siendo algo necesario y la privacidad de las mismas es, si cabe, aún más necesaria.

Con la aparición de nuevos medios técnicos, y el fomento del uso de las comunicaciones electrónicas (teléfono, fax, internet, email), ha aumentado considerablemente el flujo de las comunicaciones, pero paralelamente ha aumentado la potencia de cálculo de los ordenadores y por tanto, de la posibilidad de analizar el tráfico que pasa por ellos.

Prácticamente todo el tráfico de Internet pasa por unos cuanto servidores, lo que posibilita que un programa espía ubicado en ellos capture y registre información de todo tipo.

Echelon [^2] era hasta hace unos años una simple sospecha, pero fue reconocido por haber sido utilizado por el gobierno Americano, así como los Ingleses (con sus respectivas "colonias") y que, en los casos declarados, hay sospechas de haber favorecido notablemente a empresas Americanas frente a Europeas en grandes acuerdos comerciales (por ejemplo a Boing frente a Airbus)...

Echelon se rumoreaba que registraba las comunicaciones telefónicas, emails, etc.

Todos conocemos los sistemas de reconocimiento de voz para PC que permiten dictarle al ordenador un texto, también conocemos el sistema de las compañías telefónicas, que a través de la voz nos permiten ir entrando en diversas opciones de sus menús para facilitarnos la búsqueda de información y por otro lado conocemos la potencia de buscadores de internet para encontrar en base a un texto que escribamos... si se combinan ambas podemos tener un potente sistema que catalogue nuestras conversaciones
y permita realizar búsquedas sobre ellas...

Se rumorea que en Alemania, si durante una conversación telefónica se cita un número de palabras "prohibidas", automáticamente la conversación pasa a ser registrada para posterior análisis...

Se rumorea también que operadores de telefonía escuchan aleatoriamente conversaciones para comprobar la calidad de la comunicación...

<a id="markdown-¿cómo-proteger-nuestra-privacidad-entonces" name="¿cómo-proteger-nuestra-privacidad-entonces"></a>
### ¿Cómo proteger nuestra privacidad entonces?

<a id="markdown-web" name="web"></a>
#### Web

Para las páginas web, el estándar adoptado son las SSL [^3] que cifran la comunicación entre el cliente y un servidor web autentificado con un certificado digital firmado por ciertas compañías consideradas de confianza y utiliza un cifrado de 56 ó 128 bits. Este cifrado es el más conocido, ya que es el que utilizan bancos, comercios, etc

Como medida adicional de seguridad, los bancos utilizan tarjetas de claves, solicitar carácteres al azar de una clave definida por el usuario, etc.

El uso de esta medida de seguridad viene indicado en los navegadores por el prefijo "**https**" en la barra de direcciones de la página que estamos visitando, así como un símbolo de un candadito en la barra de estado.

Este sistema tiene un inconveniente y es que las empresas que firman los certificados y están reconocidas por los navegadores más habituales son unas pocas y cobran por sus servicios, de forma que muchos particulares o servidores gratuitos no pueden ofrecer certificados que sean auntomáticamente validados ya que son generados individualmente.

Como alternativa libre surgió [CACERT](http://www.cacert.org/) que ofrece un servicio gratuito de firma de certificados, de forma que el día en que CACERT sea añadida a todos los navegadores[^4], automáticamente sus certificados sean validados sin molestias para el visitante (teniendo que aceptar manualmente el certificado).

Estos certificados se basan en cadenas de confianza: tu navegador confía en unas empresas de certificado (CA [^5] y todos los certificados "firmados" por esas empesas son válidos ante el navegador.... algo así como la frase "los amigos de mis amigos son mis amigos"

<a id="markdown-redes" name="redes"></a>
#### Redes

Para las conexiones entre diversas redes, se utilizan VPN[^6]. Una VPN enlaza dos equipos a través de otra red (generalmente internet) y permite utilizar un sencillo cifrado, para que los datos enviados no estén desprotegidos,mediante una VPN es fácil unir distintas redes como si fueran una sola a la vez que se crea un poco más de seguridad para los datos que se transmiten[^7].

<a id="markdown-correo-electrónico" name="correo-electrónico"></a>
#### Correo Electrónico

El tema del correo electrónico es un aspecto muy importante, pero poco explorado por los usuarios. El más integrado en los programas más comerciales, es el basado en certificados, al estilo de las SSL, con el inconveniente de que requiere de un certificado firmado por una CA de confianza que es costoso en el caso de una comercial, o poco extendido en el caso de CACERT.

El otro sistema, más ampliamente utilizado y uno de los más potentes existente es el GPG[^8], un derivado libre de PGP[^9].

GPG se basa en el sistema de llave pública/llave privada. En dicho sistema, cada interlocutor dispone de dos claves complementarias, una que todo el mundo conoce y otra que sólo el conoce, y que a su vez, están protegidas por una contraseña.

Mediante este sistema, para enviar un mensaje cifrado, hacen falta cuatro claves para llevar a cabo la transferencia completa del mensaje:

  |---|---|
  |*Usuario 1*|       *Usuario 2*|
  |Clave privada 1   |Clave privada 2|
  |Clave pública 1   |Clave pública 2|

El usuario 1, cuando quiere enviar un mensaje cifrado al usuario 2 debe, por un lado cifrar el mensaje con su clave privada y con la clave pública de la otra persona.

Al recibir el usuario 2 el mensaje, utiliza su clave privada para deshacer el cifrado de su clave pública y la clave pública del usuario 1 para deshacer el cifrado de la clave privada del usuario 1.

Siguiendo este esquema, al ser necesarias las claves privadas de cada usuario y una clave que todo el mundo conoce, nos aseguramos que sólo el receptor podrá abrir el mensaje cifrado, de forma que aunque fuera interceptado, no se podría hacer nada con él.

Este sistema se basa en las mencionadas cadenas de confianza. Una clave pública de una persona es firmada a su vez por personas que tienen constancia de que realmente dicha clave pública pertenece a quien dice ser, en el momento que se ha realizado esa comprobación (encuentro personal, linea de comunicación segura, etc), se pasa a firmar la clave pública de dicha persona con tu clave pública, de modo que cualquier persona que confíe en tí, confía a su vez con los usuarios de los que has firmado su clave.

A cada firma, se le puede asignar también una "fiabilidad", por ejemplo, puedo recibir un mensaje de una "persona 1" que conozco, pero no estoy seguro de si su clave es o no esa, así que la acepto, pero le asigno poca confianza... si a su vez, en mi "anillo de claves" tengo a otros usuarios que han firmado a su vez la firma de la persona 1 y yo confío en los otros usuarios, estoy indirectamente confiando en la "persona 1"...

Las claves públicas se suelen ubicar en webs de fácil acceso, así como en una red mundial de servidores de claves, que a partir del email o nombre de una persona, nos proporciona su clave pública para poder enviarles mensajes cifrados.

Una característica muy importante es la "firma" de los mensajes, que es el equivalente a estampar nuestro sello personal sobre el lacre fundido de los mensajes, deja una marca que aunque cualquiera pueda ver el mensaje, en caso de cualquier modificación del mismo (por ejemplo una falsificación de un mensaje, alteración, etc), indica al receptor que la verifique que el mensaje permanece inalterado desde su envío (por lo tanto es un mensaje legítimo), o bien que ha sido modificado (por lo que deberemos hablar con el remitente para solicitarle el reenvío del mismo).

Si combinamos la firma de mensajes con el cifrado, dispondremos de un sistema muy bueno de cifrado que nos asegurará privacidad en las comunicaciones.

<a id="markdown-redes-inalámbricas" name="redes-inalámbricas"></a>
#### Redes inalámbricas

WEP[^10] Es un sistema de cifrado equivalente a las SSL pero para redes inalámbricas, pero que ha demostrado ser fácilmente "rompible" y por lo tanto insuficiente para asegurar los datos enviados en una conexión.

En muchos casos se refuerza el WEP con túneles VPN cifrados con [FreeSWAN](http://www.freeswan.org/) además del uso de aplicaciones seguras (SSH, etc)

Actualmente poca gente protege sus redes inalámbricas y son numerosos los informes, incluso de empresas como Hewlett-Packard avisando sobre cómo haciendo wardriving[^11] es posible ntrar a las redes internas de muchas empresas.

Incluso utilizando WEP, una red inalámbrica no es segura, ya que debido a fallos de diseño, es posible acceder a ella saltándose la clave de cifrado.

<a id="markdown-marco-legal" name="marco-legal"></a>
### Marco legal

Uno de los principales escollos para la criptografía fue y sigue siendo las leyes de exportación[^12] americanas, que impedían su exportación al extranjero de programas que incorporaran cifrado "fuerte" y que provocó situaciones tan ridículas como que el código fuente del programa PGP no pudiera ser exportado electrónicamente y que por lo tanto fuera impreso completamente en muchísimos volúmenes de texto, que se sacaron legalmente (sólo era ilegal en formato binario) del país, permitiendo que a su llegada a Europa, fueran escaneados y convertidos de nuevo a código de ordenador para crear la versión Europea de PGP (sin la restricción de exportación americana).

Los gobiernos argumentan que el uso de cifrado es indicativo de actividades delictivas y gran parte de la gente piensa que si no va a hacer nada malo, no tiene porqué ocultarlo, el problema no viene de aquí, sino que en parte, la dignidad de las personas se basa en la privacidad, la intimidad, que es un derecho otorgado por la constitución y que no debemos consentir en perder.

Se ha demostrado sobradamente que muy a pesar de los intentos de los gobiernos por impedir la criptografía, los terroristas[^13] siguen atentando, por lo tanto, quien tenga que hacer algo, lo hará de igual modo a pesar del atropello hacia nuestros derechos y libertades de impedirnos el secreto de las comunicaciones.

El gobierno Francés, conocido otrora como el de la "Legalité, Fraternité, Equalité", prohibió en su país el uso del sistema de cifrado PGP ya que no podían leer el contenido de los mensajes... Permitiendo juzgar como terroristas a los usuarios de cifrados que ellos no controlaran (es amplia la historia de puertas traseras(backdoors)[^14] en los programas informáticos para permitir accesos no autorizados)

Más recientemente y también por parte del [gobierno francés](http://barrapunto.com/article.pl?sid=04/04/27/1654246&mode=thread) se ha juzgado a un investigador por publicar en una web un informe acerca de un antivirus francés que se jactaba de ser invulnerable y 100% eficaz frente a virus conocidos y desconocidos.

El [Científico acusado](http://ciberderechos.barrapunto.com/article.pl?sid=04/05/20/1956239) mediante varias pruebas conceptuales, demostró que esa publicidad que hacían del antivirus no era cierta y a pesar de ello, se enfrenta a una pena de hasta dos años de cárcel[^15] y 15.000 Euros de multa además de los gastos económicos en abogados y viajes de Boston a París para asistir al juicio...

Según el método científico, es la discusión sobre los experimentos y los problemas encontrados los que ayudan a mejorarlos y a llegar a soluciones, y en el caso de la computación, ha demostrado que sí, gracias a encontrarse fallos de seguridad, los programas han ido mejorando corrigiéndolos, por un lado los afectados y por otro lado los relacionados, para evitar los errores que otros han cometido... según la ley francesa, cualquier persona que informe sobre fallos de seguridad será denunciada...

En España si no recuerdo mal, era necesario comunicar las claves de cifrado a las fuerzas policiales en caso de requerimiento...

En fin, se intenta proteger a la gente haciéndolos ignorantes[^16].

El Software Libre ya ha demostrado que su fuerza se basa en que al estar disponible a la revisión y mejora de millones de personas en todo el mundo resulta más robusto y confiable... y cada vez más, aporta un grado de privacidad (debido a la no existencia de puertas traseras) que otros sistemas no ofrecen.

Hoy en día, en nombre de la "Seguridad", se están instalando cámaras en las calles (en Central Park, con reconocimiento facial, para saber quién entra y quien sale), chips en los coches para pasar por las aduanas o bien reconocerlos por la matrícula, se espían correos, webs visitadas, y ahora, en nombre de "Los derechos de Autor", se están espiando las comunicaciones de otros programas como los P2P[^17].

En Grecia, según una reciente [noticia](http://barrapunto.com/article.pl?sid=04/05/22/231200) será delito la compra de CD's del top-manta con penas de hasta 3 meses de cárcel... Con la excusa de la seguridad, los derechos de autor y demás, gestión digital de derechos [^18] se han creado protocolos como TCPA[^19]/Palladium[^20] que relegan al poseedor de un ordenador a ser un simple usuario que sólo puede hacer lo que se le ofrece, muy al estilo de lo que pasa con los DVD's promocionales, que obligan a ver los anuncios sin posibilidad alguna de saltarlos...

Existen alternativas como [Freenet](http://freenetproject.org/index.php?page=faq) que a costa de hacernos perder velocidad en nuestras conexiones, nos garantizan una mayor seguridad (los datos viajan por varios servidores antes de alcanzar realmente al destino, de forma similar a como cuando se utilizan redes de proxies para acceder a los servidores web), de forma que dificultan notablemente la posibilidad de trazarlos.

<a id="markdown-consideraciones" name="consideraciones"></a>
### Consideraciones

El software de cifrado no debe utilizarse sólo cuando haya algo privado que decir ya que llamará la atención, debe utilizarse por costumbre y de contínuo, dada la potencia actual de los ordenadores, el cifrado sólo es útil hasta que saquen máquinas suficientemente potentes como para romperlo en un plazo razonable de tiempo (un escrito cifrado que necesite un año para romperlo, no es útil, pues estará muy desfasado cuando se complete el descifrado). Por eso, al utilizar con normalidad el cifrado y la firma de los mensajes, estaremos contribuyendo a mantener nuestra privacidad para los momentos donde realmente sea necesaria.

Debemos dejar de asociar el uso de cifrado, o de programas que oculten nuestras actividades en Internet a actividades/actitudes delictivas, estamos en nuestro derecho constitucional a la privacidad y como derecho, debemos ejercerlo siempre que podamos, para que no caiga en el olvido ni sea moneda de cambio ante empresas, monopolios, etc

Se puede conseguir "seguridad" sin sacrificar la privacidad, puede que no sea tan sencillo, pero ya se ha demostrado en multitud de ocasiones que a pesar de los grandes recortes de libertades, no tenemos "paz", sino al contrario, obtenemos radicalización por parte de la gente que quiere seguir haciendo "mal" (que lo van a seguir haciendo si quieren) y represión para el resto de nosotros.

¡Utiliza el cifrado!

<a id="markdown-enlaces" name="enlaces"></a>
### Enlaces

- [Kriptopolis](http://www.kriptopolis.org/)]
- [PGP Internacional](http://www.pgpi.org/)
- [Introducción a GPG: Necesidad y guía rápida en siete pasos](http://bulma.net/body.phtml?nIdNoticia=1684)
- [Noticia en HispaSec del científico acusado](http://www.hispasec.com/unaaldia/2034) [Patentes de Software]({filename}2004-05-13-Patentes-de-Software.markdown)
- [Redes Inalámbricas (declaradas) en España](http://www.nodedb.com/index.php?country=europe&state=es&city=)
- [Preguntas frecuentes sobre informática fiable](http://linuca.org/body.phtml?nIdNoticia=207)

[^1]: Web con un programa que cifra y descifra en [www.rot13.com](http://www.rot13.com/)
[^2]: [Informe Echeclon](http://altavoz.nodo50.org/echelon2000.htm), [El Programa Echelon](http://www.ugt.es/globalizacion/echelon.htm)
[^3]: Secure Socket Layers: Capas de sockets seguras
[^4]: Existe una petición a Mozilla foundation para incluir estos certificados con su navegador
[^5]: Certification Authority
[^6]: Virtual Private Network
[^7]: Por lo que son ampliamente utilizadas para interconectar organismos con diversas delegaciones
[^8]: GNU Privacy Guard
[^9]: Pretty Good Privacy: Privacidad bastante buena
[^10]: Wired Equivalent Privacy
[^11]: Técnica consistente en viajar con un vehículo y un equipo con posibilidad de conexión inalámbrica detectando las redes accesibles y marcándolas para su posterior acceso
[^12]: Leyes que actualmente impiden a científicos de países "no buenos" publicar en revistas americanas, congresos, etc...
[^13]: Los pongo aqui porque es el argumento recientemente utilizado desde los atentados del 11 de Septiembre para cualquier cosa que se aleje del pensamiento único: Antipatriotismo, terrorista, etc (un poco al igual que antes los "malos" eran los "comunistas")
[^14]: Por eso el Software Libre aventaja al Privativo, en que al haber libre disponibilidad del código, se puede analizar en busca de puertas traseras
[^15]: Le acusan con cargos de Terrorismo
[^16]: Seguridad por ocultación: aunque muchas empresas basan el modelo de seguridad en este sitema, se corre el riesgo de que el día que alguien de "dentro" difunda la información, se vean todos los fallos y alguien lo aproveche malintencionadamente ya que los fallos existen, sólo se han "tapado"
[^17]: Peer to Peer: Programas utilizados para el intercambio de archivos de igual a igual
[^18]: DRM:Digital Rights Management
[^19]: Trusted Computing Platform Alliance
[^20]: Nombre en Clave del sistema operativo de MS que permitiría un control absoluto bajo las políticas de "seguridad" de TCPA
