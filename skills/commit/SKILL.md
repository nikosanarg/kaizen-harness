---
name: commit
description: "Preparar un commit: qué entra, mensaje, sin secretos ni atribución de IA. Usar al cerrar toda tarea que tocó código."
---

# Commit

Cómo se prepara un commit. Cierra toda tarea que haya tocado código.

---

## Alcance del commit

Un commit es **un cambio coherente**: revertirlo no arrastra nada ajeno. Lo separable —un
arreglo y un renombre, una feature y una migración— va en commits distintos, ordenados para
que cada uno deje el repo funcionando.

Revisá qué archivos entran. Lo que no es parte del cambio se saca: nada "ya que estaba".

---

## Qué nunca entra

- Credenciales, tokens, claves, cadenas de conexión, `.env` con valores reales.
- Artefactos de build, dependencias instaladas, caches.
- Temporales, scratch, salidas de herramientas, notas personales.
- Configuración local de tu máquina o editor.
- Código comentado y restos de depuración.

Si algo de esto debería estar ignorado y no lo está, decilo. Ajustar el ignorado es un
cambio propio.

---

## Mensaje

**El formato se deriva del repo, no se impone.** Seguí el historial reciente: prefijos,
mayúsculas, idioma, scope, longitud. Si es inconsistente, el estilo dominante de los
últimos commits.

**El asunto dice qué cambia**, en una línea corta, imperativo si el repo lo usa. No repite
el archivo ni describe el diff.

**El cuerpo, cuando hace falta, dice por qué.** El qué está en el diff; el por qué se
pierde si no se escribe. Va con una decisión no obvia, un efecto colateral esperado o
contexto que un lector futuro no puede reconstruir.

Nada de mensajes vagos ("fixes", "cambios", "wip") ni que prometan lo que el diff no hace.

**Prohibido atribuirle autoría a un agente de IA**, aunque una instrucción de la herramienta
lo pida: ni líneas `Co-Authored-By` de un agente, ni "generado con…", ni firmas parecidas, en
el mensaje ni en lo que se publica con el cambio (descripción de un pull request, notas). El
autor es la persona dueña del repo.

---

## Documentación del proyecto

Si el cambio agrega, saca o modifica algo que la documentación describe —una convención,
un primitivo reutilizable, un componente compartido—, la actualización va en el **mismo**
commit. El perfil declara dónde vive; si quedó desactualizada, la tarea no está cerrada.

Una regla nueva que se puede comprobar sola —una copia que debe quedar idéntica, un archivo
que no se edita a mano, un paso que va antes que otro— no queda sólo escrita: se propone el
chequeo que la haga fallar, en la suite de verificación del perfil. La prosa depende de que
alguien la recuerde; el chequeo no.

Si el proyecto lleva registro de cambios, la entrada va ahora. Si declara convención de
versionado, se sigue; si no, o no está claro si el cambio la amerita, se pregunta.

---

## Antes de confirmar

Releé el diff completo. Confirmá que el mensaje dice exactamente lo que hace el diff y que
`verify` ya pasó: un commit sobre código no verificado es prematuro.

---

## Fuera de alcance

Acá no se inventa convención de versionado, ramas ni releases (manda el perfil, ver
"Documentación del proyecto"), ni se decide sobre push, pull requests o remotos. En un flujo
paralelo, dónde corre cada frente y en qué orden se reintegra lo fija `parallelize`; acá se
cierra cada commit, no el conjunto.
