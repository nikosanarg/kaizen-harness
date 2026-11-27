---
name: parallelize
description: "Repartir varias necesidades independientes en frentes aislados que corren a la vez (agentes o sesiones), con encargos completos, feedback e integración. Usar sólo cuando se decidió coordinar."
---

# Parallelize

Cómo repartir varias necesidades en frentes aislados que corren a la vez sin pisarse.

Va antes de clasificar cada necesidad. Produce el reparto y el encargo de cada frente, no
código; después cada frente sigue su routing.

Termina cuando cada frente tiene un encargo autocontenido, sabe qué territorio ajeno no
toca, cada superposición inevitable tiene política de fusión decidida, y cada frente tiene
su orden de integración: entra apenas termina, o espera a cuál.

---

## Cómo se agrupa

**Por lo que se toca, no por tema.** Necesidades parecidas sin archivos en común van en
frentes distintos; sin relación pero con un archivo en común, en el mismo: separarlas sólo
muda el conflicto a la integración.

**Tantos frentes como se puedan atender a la vez.** Menos mezcla territorios; más deja
trabajo esperando sin ganancia.

Antes de cerrar, ubicá cada necesidad por los archivos que toca. La que no comparte
territorio con ninguna es su propio frente.

---

## El encargo de cada frente

Quien ejecuta no vio la conversación: el encargo alcanza solo. Lleva alcance exacto,
decisiones ya tomadas con su porqué —omitirlas invita a reabrirlas— y qué tocan los otros
frentes, para reconocer territorio ajeno y frenar en vez de adivinar.

**No se pide un criterio que el frente no puede comprobar** (ver un render, tocar una
pantalla, credenciales reales): repartido, cada frente se disculpa por lo mismo. Se junta
una sola vez en la lista de revisión humana del cierre.

**El encargo declara lo que el espacio del frente no puede hacer.** Un frente remoto o
recortado puede no tener red a ciertos servicios, el otro repositorio, credenciales o GPU.
El encargo dice qué verificaciones no corren ahí, cuáles quedan para quien coordina y qué
cuenta como terminado. Si no, cada frente pierde tiempo descubriéndolo, o promete una
verificación que nunca va a cumplir.

**El plan es una hipótesis hasta que se contrasta con el código.** Antes de encargar, se
revisa que el estado que describe siga siendo cierto: versiones, lo ya hecho, lo que ya
existe. El encargo separa las decisiones, que no se reabren, del estado descripto, que el
frente verifica. Si no, el frente planifica sobre un dato viejo, o rehace algo que ya
estaba.

**El encargo sale completo.** Un frente que no puede responder no negocia un agregado: si
llega a mitad de camino, rehace lo que ya tocó. Un agregado sólo se manda si es urgente, y
en un único mensaje sin contradicciones.

**El encargo dice cómo se retoma.** Un frente se puede cortar (tiempo, máquina, sesión) y
otro tiene que seguirlo: el encargo nombra su línea de trabajo y su feedback. Quien retoma
parte de ahí, no de la conversación cortada: lee el feedback, lo contrasta con el último
cambio guardado y sigue por lo pendiente. Lo que no quedó guardado se rehace, no se da por
hecho.

---

## Superposiciones

Si dos frentes tocan el mismo punto sí o sí, al repartir se decide cuál sienta la base y
cuál aplica encima. No queda para quien integra.

Si en ejecución un frente necesita algo ajeno, no lo toca: lo anota como pendiente de
integración y sigue.

---

## Reglas de ejecución de cada frente

- Sólo dentro del territorio declarado.
- No integrar el propio frente: lo hace quien reúne todos (ver "Al reintegrar"; `commit`
  para cada integración parcial). **En su propia línea, en cambio, guarda y publica sin pedir
  permiso**, tan seguido como haga falta: es su espacio, y es lo que ve quien coordina. Lo
  vedado es la rama principal y las líneas ajenas.
- **Lo nuevo se inventaria, no se testea todavía.** Aislado, un frente testea contra su
  suposición de los demás; si no coincide, el test describe algo que nunca existió. Deja en
  el feedback qué casos, componentes y contratos merecen test (`test` decide). Excepción:
  la regresión de un bug se escribe en el frente, porque es la evidencia de la causa raíz.
- Verificar al cierre, no a mitad. Lo que ya funcionaba sigue funcionando (`verify`).
- **Se guarda antes de lo largo.** Antes de una captura, un render o una corrida larga, el
  cambio queda guardado y publicado en la línea de trabajo: un corte a mitad de algo largo
  no se lleva lo hecho antes.
- **Lo que mide comparte la máquina: va por turno.** Un frente que necesita medir rendimiento
  o capturar con el recurso compartido (la GPU, la máquina del usuario) pide turno a quien
  coordina, espera el permiso y avisa al liberarlo; escribir código y compilar no esperan.
  Dos mediciones a la vez se inflan una a la otra y ninguna sirve. Un "antes" común se mide
  una sola vez y lo reusan todos los frentes.
- **Cada frente verifica su área, no el sistema entero.** La batería lenta de punta a punta
  la corre una sola vez quien reúne todos, con todo integrado: corrida por frente, multiplica
  el tiempo y mide lo que los demás todavía no integraron.
- Lo que el pedido dejó para más adelante, ningún frente lo hace por su cuenta.
- **Contra una base real, el frente sólo lee.** Escritura, cambio de esquema o migración no
  los ejecuta: los deja como archivos idempotentes en su línea, y su feedback dice en qué
  orden aplicarlos al integrar. Los aplica quien integra (`database`), que es quien sabe en qué
  estado está la base con todos los frentes juntos.
- **El frente no versiona.** Ni versión, ni changelog, ni roadmap, ni contexto de producto:
  los cierra quien integra, sobre el conjunto (ver "Al reintegrar"). Tocados por cada frente,
  chocan en cada integración. Lo que el frente escribiría ahí va a su feedback.

---

## El feedback de cada frente

Quien integra no vio nada de adentro; sin feedback sólo queda releer el cambio. Va **en un
archivo dentro de la línea de trabajo del frente** —`.handoff/<frente>.md`, salvo que el
perfil declare otro; si el frente toca varios repositorios, el encargo dice en cuál—, no en
el último mensaje ni en un canal aparte, y **se escribe a medida que se decide**: es por
donde se lo retoma. **El frente termina con un último cambio que sólo cierra ese archivo y
lo declara terminado**, con un asunto que empieza con `HANDOFF:`; nada va después. Así quien
coordina sabe que terminó sin preguntarle ni adivinar por silencio (un
frente que publica avances a mitad de camino parece terminado), y ese cambio final no se
integra. Un mensaje directo a quien coordina es, a lo sumo, un aviso: puede no llegar, y que
falle no es un error del frente ni algo para reportar.

Contenido, en este orden:

- **Lo que necesita decisión del usuario**, arriba y separado del detalle técnico: qué hay
  que decidir, las opciones y la recomendada. Mezclado con el resto, se lee tarde o no se
  lee. El mensaje con que el frente cierra lleva sólo esto y lo esencial de lo demás (qué
  cambió, cómo se verificó, qué quedó afuera); el detalle queda en el archivo.
- **Decisiones sobre las ambigüedades que el encargo marcó**, y por qué.
- **Desvíos del encargo**, explicados: quien integra necesita saber si puede confiar en el
  resto.
- **Pendiente de integración**: territorio ajeno que hacía falta tocar. Dirigido: a qué
  frente le toca y qué necesita de él, concreto como para aplicarlo sin reconstruirlo.
- **Deuda preexistente vista al pasar**, ajena al pedido entero: se anota con archivo y
  línea, no se toca (`understand` § Delimitar el alcance).
- **Inventario de lo que falta testear.**
- **Resultado real de la verificación de cierre**: qué se corrió y qué dio. Si no distingue
  lo verificado de lo asumido, no sirve.
- **Huella del frente**: qué áreas y recorridos del producto puede afectar, y qué
  verificación los cubre. Es lo que permite atribuir una falla del conjunto sin preguntarle a
  cada frente.

Es documento de trabajo: vive hasta integrar y consolidar. Volcado lo que vale a la
documentación permanente, se borra; si queda, duplica y se desactualiza.

---

## Antes de repartir

**El punto de partida se valida.** Verde (build, lint, tests del proyecto) y con todo
artefacto no versionado que haga falta reproducido. Roto, se hereda multiplicado por cada
frente.

**Lo compartido que todavía no existe se crea antes de repartir.** Si varios frentes
necesitan desde el principio algo que nadie tiene —un tipo, una firma, el nombre de un
recurso—, se deciden nombre y forma y se crea como artefacto mínimo real. Descripto en
prosa, converge por suerte.

Si el punto de partida cambia antes de que arranquen —una decisión, un dato, uno de esos
recursos—, se propaga a todos; si no, divergen desde el primer paso.

---

## Dónde corre cada frente

**Cada frente es una sesión remota propia**, salvo que el perfil diga otra cosa: no compite
por el contexto ni por la máquina de quien coordina, y sigue aunque quien coordina se corte.
Repartir en agentes locales es la excepción, no el atajo.

**Cada frente en su propio espacio aislado.** Sobre uno compartido, cada cambio queda
integrado al escribirse y la verificación de cierre mide lo que otros tenían a medio hacer.

En control de versiones:

- **El reparto se registra en el punto común antes del primer frente**: todos arrancan de
  un estado idéntico, y el criterio queda en la historia cuando los feedbacks ya no están.
- **Una línea de trabajo por frente**, desde ese punto validado, con un nombre que lo
  identifique.
- **Cada integración deja rastro propio**, para poder revisar o revertir un frente entero.

Si los espacios no se pueden separar, o un encargo no sale autocontenido, no se paraleliza:
se hace en serie. La velocidad no le gana a la calidad.

**Esperar no es trabajo, y escuchar tampoco debería costar.** Quien coordina también es un
frente: avanza en lo que no depende de los demás —lo suyo, los feedbacks ya escritos, la
reintegración—. No espera mirando ni consultando el estado de cada frente, ni se programa
recordatorios: deja un **vigía**, un proceso que no consume contexto, revisa la línea de
cada frente cada uno o dos minutos y lo despierta cuando aparece un cambio de cierre (el del
harness está en `herramientas/vigia/`). Al aviso integra en el acto, sin que nadie se lo
pida, en el orden decidido al repartir, y vuelve a dejar el vigía con los frentes que siguen
abiertos. Si el vigía vence sin novedad, se mira si los frentes siguen vivos.

---

## Al reintegrar

**Si el proyecto tiene una rama de prueba, se integra ahí y se promueve.** Los frentes entran
a la rama de prueba; la batería completa corre sobre el conjunto y, recién con eso verde, la
rama de prueba pasa a la principal. Integrar directo en la principal publica cada frente sin
haberlo probado junto con los demás. Un arreglo urgente va directo y se baja a la de prueba
en el acto, para que no diverjan.

**Integrar se puede delegar; lo que necesita producción, no.** Juntar ramas, resolver choques
y verificar lo hace cualquier espacio con el código. Migraciones, confirmar lo publicado y lo
que necesite el recurso compartido quedan en quien tiene ese acceso.

**La sesión canónica integra y publica con permiso permanente.** Guarda y publica en la rama
principal y en la de prueba sin pedir OK por cada integración: el usuario y ella trabajan en
sincronía, y esperar su OK en cada frente frena todo. Sigue pidiendo OK lo que el perfil
declare en § Entrega. Un frente nunca escribe en esas ramas, aunque pueda: integrar de prepo
saltea la lectura del feedback, el orden y la batería del conjunto.

**El orden se decide al repartir, no al llegar.** Cuando un frente termina ya se sabe si
entra en seguida o espera a otro (una interfaz que el otro define, un archivo que también
toca). Decidirlo recién ahí deja el frente terminado esperando por algo que se sabía al
despachar.

El feedback se lee **antes** de integrar: dice qué no se pudo tocar y si la superposición
prevista salió como se esperaba.

**Un frente a la vez**, verificando después de cada uno: una superposición mal resuelta
aparece ahí y no se arrastra. Excepción: si un frente cambia una interfaz que consume otro
todavía en curso, y integrar es publicar, no sale solo; salen juntos, el que la define
primero. Solo, publica algo que nadie del otro lado sabe leer.

Antes de cerrarlo, se confirma el estado real, no el reporte: nada sin integrar, espacio no
desviado del punto común.

**El descarte va aparte, y sólo si la integración entró.** Integrar o publicar puede fallar
(otro integró antes); en la misma orden, el descarte correría igual y se perdería el
frente. Se confirma que el trabajo está en el punto común publicado y recién ahí se
descarta. Si falló, se resincroniza y se reintegra.

**Si se integra copiando cambios en vez de fusionando historias, el descarte va en el
momento.** Después, el historial ya no dice qué líneas de trabajo entraron, y limpiar exige
reconstruirlo a mano. Integrado un frente, se borran en el acto su línea de trabajo, también
la publicada, y su espacio aislado: sin eso se acumulan por decenas y nadie sabe cuáles
siguen vivas. Lo mismo vale para los procesos: el frente que entrega no deja nada
corriendo ni esperando.

**Al final, una consolidación sobre el conjunto, no una por frente.** Junta los
inventarios y completa la cobertura del código nuevo contra lo integrado, no contra lo que
cada frente supuso (`test` decide qué y cómo; `verify`, cómo se corre). Ahí aparecen los
bugs de integración que ningún frente podía ver.

**Una falla de la batería completa la diagnostica quien coordina, no todos los frentes.**
Primero cruza el recorrido que falló con la huella de cada frente; si no alcanza, parte los
cambios integrados a la mitad corriendo sólo esa verificación hasta aislar el culpable. Una
falla conocida por inestable se repite una vez antes de culpar a nadie. El arreglo va a quien
hizo el cambio si todavía tiene el contexto; si no, a un encargo nuevo y chico. Consultar a
todos los frentes cuesta un contexto entero por cada uno para que casi todos digan que no.

Después se cierra la versión con la disciplina de documentación de `commit`, una vez sobre
el conjunto. De los feedbacks pasa a la documentación permanente lo que debe sobrevivir
—decisiones, cambios, pendientes, primitivos compartidos agregados o cambiados (sin
entrada, el próximo no sabe que existen)— y se borran.

**La deuda vista al pasar va a un lugar fijo** —la sección de deuda del roadmap, o lo que
declare el perfil—, no mezclada en el changelog. Si varios frentes la vieron sin
coordinarse, se dice ("vista por N frentes"): es evidencia de que importa.

---

## Fuera de alcance

Acá no se decide qué hace falta en cada frente (`understand` y su routing), ni se
implementa (`implement`), ni se arma cada commit (`commit`), ni con qué ni cuántos frentes
corren a la vez (lo declara el perfil, § Entrega). Si coordinar o resolver se decide en
`dev-workflow`. Cómo se escribe un test o se lee una verificación
es de `test` y `verify`; acá sólo se decide cuándo corren.
