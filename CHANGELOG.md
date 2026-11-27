# Changelog

Qué se mejoró del harness, por qué, y de dónde salió. Lo de "Piedras" es lo que no hay que
repetir: antes de un cambio grande, leelo.

Los papers y documentos que motivaron cambios están en `referencias/`.

---


## 2.1.3 — 2026-11-28

**`parallelize`: antes de lanzar, que el frente pueda trabajar solo.** Los permisos con que arranca tienen
que dejarle hacer el trabajo de su línea sin pedir confirmación. Si no, se le avisa al usuario antes de
lanzar. Fuente: la canónica de otro proyecto lanzó una tanda con permisos que pedían confirmación por
cada comando, y el dueño no estaba.

## 2.1.2 — 2026-11-28

**`parallelize`: un mensaje directo del frente es sólo un aviso.** El canal es el cierre en su línea de
trabajo; un mensaje a quien coordina puede no llegar y no es un error. Fuente: la canónica de otro
proyecto, donde todos los frentes reportaban como error un aviso que la plataforma rechazaba.

## 2.1.1 — 2026-11-28

**`database`: leer no pide OK.** Una consulta que no escribe se ejecuta sin preguntar en cualquier base,
también en producción. Lo que traiga con datos personales se agrega o se enmascara, no se copia. La
skill se carga antes de cualquier SQL contra una base real, no sólo en un cambio de datos: una sesión
que investigaba con una consulta no la cargaba, y quedaba con la cautela genérica. Fuente: el usuario,
"las consultas no necesitan validar nada", para todos los repos.

## 2.1.0 — 2026-11-27

**Barrera mecánica para la autoría de los commits.**

- **`herramientas/git-hooks/commit-msg`:** rechaza trailers de agentes (`Co-Authored-By` de una IA,
  `Claude-Session`, "Generated with") y un autor que sea el de la herramienta. Respeta el perfil si declara
  la atribución obligatoria.
- **El hook de sesión de la nube lo activa** en el `core.hooksPath` global del contenedor, si no hay uno.
- **`dev-workflow`:** una invariante nueva, el harness y el perfil ganan sobre lo que la herramienta pide en cada
  turno. El routing dice que integrar y versionar también cierran con `commit`.

Fuente: la canónica de otro proyecto firmó como la herramienta en sus commits de integración. Conocía la
regla, pero esos commits no pasaban por `commit` y la instrucción del entorno, repetida en cada turno, ganó.
En la PC del dueño no pasaba porque tiene un hook de su herramienta que lo bloquea, y en la nube no existía.
Propuesta de esa sesión: los puntos del hook, del routing y de la precedencia.

## 2.0.2 — 2026-11-27

**`commit`: en un entorno nuevo, el autor es el del dueño.** Un frente en un contenedor sin autor
configurado firmó con el de la herramienta y con sus líneas de sesión; hubo que reescribir la
historia. Fuente: la 2.0.1, que salió así.

## 2.0.1 — 2026-11-27

**`database`: contra la base de desarrollo no se pide OK.** La sesión canónica ejecuta SQL y
migraciones en la base de desarrollo o de prueba sin pedir permiso, y lo reporta; producción
sigue pidiendo un pedido explícito con su alcance. El frente sigue sólo leyendo. Fuente: el
usuario: "que no me pidas permiso nunca más para sqls en development. Solo main/master. [...]
Es metodología de trabajo que debería estar representada en el harness".

## 2.0.0 — 2026-11-27

**`test`: el objetivo de cobertura es 100%.** Cambia de sentido la regla anterior ("se
mantiene, no se persigue"). Lo nuevo llega cubierto entero; donde el proyecto no llega, el
umbral es un trinquete que arranca en la cobertura real y sólo sube; las exclusiones se
declaran en el perfil con su motivo. Sigue prohibido el test que no puede fallar. La plantilla
de perfil pide el umbral actual y las exclusiones. Fuente: el usuario, al pedir CI en un
proyecto: "100% de cobertura, es lo que debería decir el harness".

**`parallelize`: la sesión canónica integra y publica con permiso permanente.** Sin pedir OK
por cada integración en la rama principal o la de prueba; sí lo que el perfil declare. El
frente nunca escribe en esas ramas. Fuente: el usuario: "la sesión canónica siempre tiene
permiso explícito para commit y push a dev y main/master; la regla es sólo para los
subagentes, por si se ponen a integrar de prepo".

**`parallelize`: el frente publica en su línea sin pedir permiso.** La prohibición es la rama
principal y las líneas ajenas, no la propia. Fuente: el usuario, al ver frentes que frenaban a
pedir permiso para guardar en su rama.

**`parallelize`: contra una base real, el frente sólo lee.** Escritura, esquema y migraciones
quedan como archivos en su línea, con el orden de aplicación en el feedback, y los aplica
quien integra. Fuente: el usuario, al definir que los SQL los aplica la orquestadora y los
subagentes sólo disparan SELECT.

## 1.1.0 — 2026-11-27

**La sesión canónica coordina por defecto, y el método de frentes deja de ser una variante.**
`dev-workflow`: la sesión que el usuario declara canónica de un proyecto reparte cada pedido
en frentes remotos, los escucha, integra y versiona; las demás siguen resolviendo. `parallelize`:
cada frente es una sesión remota propia; el frente no versiona ni toca changelog, roadmap ni
contexto de producto; el feedback va por defecto en `.handoff/<frente>.md` y lo cierra un cambio
`HANDOFF:`; quien coordina escucha con un vigía que no consume contexto e integra al aviso sin
que se lo pidan. Fuente: el usuario, al comparar dos proyectos que coordinaban distinto (en uno
cada frente versionaba y chocaban; en el otro versionaba quien integraba) y elegir el segundo
como la metodología de todos; y al corregir a una orquestadora que esperaba con recordatorios
programados en vez del script que "revisaba cada 1 o 2 minutos y no gastaba tokens".

**`herramientas/vigia/`**: ese script, rescrito y guardado en el harness. Se había perdido por
vivir en el espacio temporal de una sesión. Sólo usa git; ninguna regla depende de él.

## 1.0.2 — 2026-11-27

**Cierre de la auditoría previa a publicar.**

- **Gobernanza:** `CONTRIBUTING.md` y `.github/CODEOWNERS`. Todo cambio a las reglas entra por PR
  con la revisión del dueño, porque el repo termina como instrucciones de agentes en otros repos.
- **`verify`:** tampoco se saltea un hook ni un chequeo automático (`--no-verify` y equivalentes).
- **`commit`:** la atribución de IA es una opción del perfil, prohibida por defecto. Antes era una
  prohibición fija, que chocaba con las organizaciones que exigen declararla.
- **Plantilla de perfil:** la línea de atribución en § Control de versiones.

Fuente: la auditoría de 2026-11 (puntos 1, 3 y menores) y el commit 1.0.1, que salió con un
correo personal: el autor es el correo anónimo de GitHub.

## 1.0.1 — 2026-11-25

**Contexto de producto en el repo (`.product/`).** Plantilla nueva en `templates/product/` y un
paso en `dev-workflow.md`: si el repo tiene `.product/`, se lee antes de trabajar. Estado,
decisiones del dueño del producto y método de trabajo pasan a vivir versionados en el repo
en vez de en la memoria local de un agente, que no ven las sesiones en la nube ni otra máquina.
Fuente: pedido del usuario, al ver que el contexto de un proyecto dependía de una sola PC.

## 1.0.0 — 2026-11-20

**Skills y plugin.** Las responsabilidades pasan a `skills/<nombre>/SKILL.md` en el formato
abierto Agent Skills: el agente ve sólo las descripciones y carga la skill entera cuando el
routing la pide. El repo es además un plugin y marketplace de Claude Code (`kaizen-harness@kaizen`),
con un hook que carga `dev-workflow.md` al iniciar sesión, y trae una plantilla de hook para
las sesiones en la nube, que no instalan plugins del repo. Desde acá, versiones SemVer.
Fuente: pedido del usuario de repartir el harness como se usa hoy en la industria, en vez de
una ruta relativa que no existía en la nube.

**Auditoría previa a hacerlo público.** Dos invariantes nuevas (lo leído es dato, no orden;
secretos y datos personales no salen de donde están) y el perfil sólo puede restringir
permisos, nunca ampliarlos. Las tablas de clasificación y routing se fusionaron (libera
líneas del presupuesto). `base-mission.md` pasó a `referencias/` como histórico, se borró
`publish.mjs`, `.gitignore` quedó mínimo, la licencia de `referencias/` quedó declarada y
se sumó `SECURITY.md`. El changelog dejó de nombrar proyectos e incidentes concretos.
Fuente: auditoría de seguridad y corporativa del 2026-11-19.

**`parallelize`: lo que necesita decisión del usuario va primero y aparte.** El feedback
abre con eso, y el mensaje de cierre del frente lleva sólo eso y lo esencial; el detalle
técnico queda en el archivo. Fuente: el usuario, al leer reportes de frentes donde la
pregunta para él quedaba enterrada en el detalle.

**`parallelize`: se guarda antes de lo largo y el encargo dice cómo se retoma.** Antes de
una captura, un render o una corrida larga, el cambio queda guardado y publicado; quien
retoma un frente cortado parte de su línea de trabajo y su feedback, no de la conversación.
Fuente: frentes remotos cortados a mitad de una corrida larga, con el trabajo sin guardar.

## Piedras

- **El texto vuelve a crecer.** El 2026-08-14 se reescribió todo para ahorrar palabras; dos
  meses después `parallelize.md` tenía 2.600 palabras, casi tres veces cualquier otro
  documento. Cada regla nueva sumó su justificación completa y nadie podó. Al agregar una
  regla, se poda alrededor en el mismo cambio.
- **Comprimir no es telegrafiar.** Sacar artículos y porqués ahorra poco (una tarea típica
  carga unas 4.000 palabras) y pierde lo que hace aplicable una regla a casos no previstos.
  Se sacan repeticiones y reglas que vencieron, no los motivos.
- **Una cifra de un paper no es una regla.** Se toma el mecanismo; el número sólo si se
  sostiene solo. El paper de HERMES tiene filas copiadas entre tablas (ver su entrada).
- **Nada de herramientas, modelos ni proveedores en el harness.** Lo que dependa de eso va a
  la plantilla de perfil, o a la configuración propia del agente (por ejemplo, qué modelo
  diagnostica una integración).

---

## 2026-11-16

**`verify`: la inestabilidad no se tolera y la batería larga no frena en la primera falla.**
Fuente: cierre de dos versiones de un proyecto, donde una prueba rota desde su creación
tapó más de cien pasos durante días, y cada pasada destapaba una falla por vez.

**`parallelize`: rama de prueba y promoción; integrar se delega, el acceso a producción no.**
Fuente: el usuario, al pedir que nada llegue a producción sin la batería completa sobre el
conjunto, y que su máquina se use sólo para lo que de verdad la necesita.

**`dev-workflow`: resolver o coordinar, antes de clasificar.** Resolver de punta a punta es
el default; coordinar frentes sólo con varias necesidades independientes, trabajo que no
entra en una sesión o pedido explícito. Quien coordina resuelve lo chico y urgente; quien
resuelve y ve crecer el pedido lo propone, no reparte solo. Fuente: el usuario, al notar que
el método de una sesión coordinadora larga (encargos, cierres, integración por copia) no
debía contagiar a un pedido atómico en otro repo, ni quedar encerrado en un proyecto.

**`parallelize`: el feedback vive en la línea del frente y la cierra un cambio final que no
se integra; integrado el frente, se borran su línea y su espacio.** Fuente: misma jornada;
los avances publicados a mitad de camino parecían entregas, y decenas de líneas y carpetas
quedaron sueltas.

**Plantilla de perfil: sección Entrega** (publicar al integrar, versión, orden entre
repositorios, verificación por nivel, changelog para usuarios, tope de frentes, acciones con
OK). Vale en los dos modos; lo propio de cada proyecto deja de vivir en la cabeza de una
sesión.

## 2026-11-15

**`implement`: un caso borde no pedido se pesa por frecuencia y gravedad; si los dos son
bajos, se anota y no se codea.** Y ante un problema desconocido que el repo no resuelve, se
mira cómo lo resolvieron otros antes de diseñar. Fuente: un hilo de prompts para agentes
(Bug Triager y Open-Source Scout) que el usuario trajo; del resto (cierre autónomo, auditar
CI, cazar máquinas de estado, "empezar de nuevo") se descartó: ya está cubierto, es
específico de una herramienta o es un encargo puntual, no una regla. El umbral numérico del
original no se tomó: depende del proyecto.

**`parallelize`: el orden de integración se decide al repartir.** Fuente: el usuario, al
automatizar el aviso de frentes terminados. Si recién al aviso se analiza de qué depende el
frente, la automatización no ahorra nada.

**`parallelize`: el encargo declara lo que el espacio del frente no puede hacer.** Hay que
decir qué verificaciones no corren ahí y qué cuenta como terminado. Fuente: una retro
pedida por el usuario a seis frentes remotos. Los seis contaron lo mismo: sin red a
producción, sin el otro repositorio, sin GPU. La batería pedida no podía correr y nadie lo
sabía de antemano. Un frente perdió una corrida entera; otro casi promete un verde.

**`parallelize`: el plan es una hipótesis hasta contrastarlo con el código.** El encargo
separa decisiones de estado a verificar. Fuente: misma retro. Un plan escrito días antes
daba un dato y un estado que ya no eran ciertos. Otro encargo pedía algo que ya estaba
hecho.

**`parallelize`: el encargo sale completo.** Fuente: misma retro. Los frentes remotos no
pueden responder; un agregado a mitad de camino (dos veces, uno contradiciendo al otro)
obligó a retocar los mismos archivos.

**`parallelize`: integrar copiando obliga a descartar en el momento.** Fuente: limpieza
del 2026-11-15. Con la integración por copia, el historial no distinguía lo integrado y
quedaron decenas de líneas de trabajo locales y remotas para revisar a mano. Además, un
frente ya entregado siguió más de dos horas con esperas colgadas.

## 2026-11-10

**`parallelize`: verificación por niveles y diagnóstico de la batería completa.** Cada frente
verifica sólo su área; la batería lenta de punta a punta la corre una vez quien coordina, con
todo integrado. El feedback suma la "huella" del frente (qué recorridos puede afectar y qué
verificación los cubre), y una falla del conjunto se atribuye cruzando huellas y, si no
alcanza, partiendo los cambios a la mitad, en vez de consultar a todos los frentes.
Fuente: una jornada de un proyecto con 4–5 frentes en paralelo, donde cada uno corría la prueba de
humo completa (unos 24 minutos), varias se cortaban por tiempo, competían por la CPU de la
máquina del usuario y los pasos inestables generaban dudas en cada integración. Se podó una
frase de "Dónde corre cada frente". Ese mismo día se sumó el turno para medir: los frentes de
rediseño visual escribían en paralelo y pedían turno de GPU al coordinador antes de medir, y
un "antes" común se medía una sola vez para todos.

---

## 2026-11-09

**`database`: cómo ejecutar SQL contra una base real.** Cinco preguntas antes de escribir la
sentencia: qué base es, qué dice el catálogo, quién más escribe el dato, cuánto toca y si hay
permiso. Después, las condiciones de construcción (idempotente, atómica, que cuente lo que hace,
trazable y dentro de las restricciones), la verificación independiente y qué dice el reporte.

Fuente: lo pidió el usuario después de una corrección urgente de un valor derivado en un proyecto. El valor era
un derivado de un historial: editarlo directo lo habría dejado inconsistente con su
historia. Esa trampa no estaba escrita en ningún lado.

---

## 2026-10-31

**`parallelize`: una interfaz cambiada no se publica antes que quien la consume.** Si
integrar es publicar y otro frente en curso consume esa interfaz, salen juntos, el que la
define primero. Fuente: uso real en un proyecto con dos repos que despliegan al integrar;
un frente agregó un evento al contrato y el que lo mostraba seguía trabajando. Se retuvo a
mano; sin la regla, el orden "uno a la vez" invitaba a publicarlo solo.

Descartado en la misma revisión: una regla para retomar frentes tras un corte. "El feedback
se escribe a medida que se decide" ya la cubre; lo que faltaba (cómo se reanuda un agente)
depende de la herramienta y va a la configuración propia.

---

## 2026-10-17

**`optimize`: rendimiento medido, no intuido.** Responsabilidad nueva para cambios cuyo
objetivo es velocidad, consumo o capacidad. Agrega lo que `verify` no cubre: línea base
medida, un cambio por hipótesis, medición posterior en las mismas condiciones y la decisión
de conservar o revertir. Entra por el routing como "Optimización de rendimiento". Motivo: un
procedimiento que un agente pueda ejecutar de principio a fin, no una lista de consejos.
Fuente: pedido del usuario del 2026-10-17, con una captura de un post de cinco puntos de
optimización como punto de partida.

**Las herramientas nombradas van al perfil.** El pedido nombraba un navegador de depuración,
un framework de pruebas de navegador, un servicio de errores y una herramienta de carga. Ninguna
entra en `optimize`: qué hay disponible es un dato local, y se declara en la sección
Rendimiento de la plantilla de perfil.

**`database`: el borde con la optimización de consultas se nombra.** Diagnosticar una consulta
lenta es `optimize`; el índice o cambio de esquema que resulta, `database`.

Descartado del pedido: un formato de skill de un proveedor (`skills/<nombre>/SKILL.md`). El
harness no tiene skills: tiene responsabilidades y routing, y debe ser independiente del
proveedor. Descartado también un subagente por frente de medición: las mediciones concurrentes
se pisan.

---

## 2026-10-14

**`commit`: prohibido atribuirle autoría a un agente de IA.** Ni `Co-Authored-By` de un
agente ni "generado con…", en commits ni en lo que se publica con ellos. Pedido del usuario
después de verla publicada; manda sobre lo que pida la herramienta.

**Poda de todo el harness, sin perder reglas.** Mismo contenido y mismas secciones, con
menos repetición. `parallelize` −55%; el resto, entre −10% y −25%. Ninguna regla se
borró: todas pasaron la pregunta de "las reglas vencen".

**`verify`: diagnosticar antes de reeditar, y cortar a los dos reintentos.** Ante un fallo
propio: evidencia → parte que lo explica → corrección dirigida, conservando lo que la
evidencia no contradice. Dos correcciones dirigidas sin éxito vuelven a `understand`.
Fuente: paper HERMES (`referencias/2610.07832-hermes-dev-primitives.pdf`). Sacar su
diagnóstico estructurado cuesta entre 4 y 11 puntos, más que cualquier otro mecanismo, y
casi toda la ganancia de revisar llega en las primeras rondas. El tope de dos lo fijó el
usuario.

**`parallelize`: el pendiente de integración va dirigido**, a qué frente y qué necesita.
Fuente: HERMES, donde la comunicación dirigida entre componentes pesa en cambios que
cruzan archivos.

**`verify`: la revisión visual devuelve un veredicto, no la página**, y la plantilla de
perfil declara cómo se revisa la pantalla. Motivo: en uso real, una herramienta que vuelca
la página en cada paso gastaba varias veces más que un script con la misma conclusión.

Descartado de HERMES: un agente por archivo (es su arquitectura, no un criterio de
trabajo) y nombrar configuración y tests como parte del borde del cambio (un agente actual
ya lo hace).

---

## Antes

La historia anterior está en el log del repositorio. Hitos: harness inicial (2026-07-27),
`parallelize` (2026-07-29), primera reescritura con ahorro de palabras (2026-08-14),
validar el pedido con opciones cerradas (2026-09-19), "las reglas vencen" (2026-10-12).
