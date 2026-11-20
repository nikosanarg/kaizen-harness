---
name: implement
description: "Escribir código dentro de un repo existente que otros mantienen: reutilizar, respetar convenciones, calidad en lo que se toca, configuración. Usar en toda tarea que cambie código."
---

# Implement

Cómo se escribe código dentro de un repo que ya existe y que otros mantienen.

---

## Leer el estilo antes de escribir

El código nuevo tiene que ser indistinguible del que ya está. Mirá dos o tres archivos
vecinos y copiá nombres, manejo de errores, densidad de comentarios, estructura de módulos,
forma de exportar y de testear.

Si el repo es inconsistente, seguí el código más cercano al que tocás: no el más nuevo ni
el que preferís.

---

## Reutilizar

Antes de escribir una función, verificá que no exista; antes de sumar una dependencia, que
el repo no traiga algo que lo resuelva. Una dependencia nueva es una decisión de
arquitectura: se justifica o se pregunta, nunca en silencio. Si el repo no lo resuelve y el
problema no es conocido, mirá cómo lo resolvieron otros proyectos antes de diseñar: un
diseño desde cero repite errores que ya tienen solución.

Extender un archivo es el default. Uno nuevo se justifica cuando el actual pasaría a tener
dos responsabilidades, no cuando se hace largo.

---

## Calidad de paso

El alcance mínimo protege el código que **no** tocás; no permite dejar peor el que sí.
Dentro de lo que ya modificás, esto se arregla sin preguntar ni anunciarlo como desvío:

- **Un duplicado local de algo compartido** —control hecho a mano, helper recreado, estilo
  copiado—: se reemplaza por el compartido. Si no cubre el caso, se lo **extiende**: un
  fork local nace desactualizado.
- **Un valor escrito a mano donde hay una fuente única.** Si la fuente no lo declara y el
  valor existe en la capa que la alimenta, se agrega ahí; ni literal ni segunda fuente.
- **Un comentario que dejó de ser cierto.** Es peor que ninguno: el próximo lo cree. Los
  que afirman que algo "no existe" caducan solos.
- **Una precedencia, criterio o regla reescrita por segunda vez.** Se resuelve en un lugar
  y los dos llamadores lo consumen. Dos copias ya divergieron, aunque no se note.

Dos límites para que no sea un refactor encubierto: no cambia el comportamiento observable
de lo que no tocabas, y no crece hasta pedir revisión propia. Si necesita decisiones que el
pedido no cubre, se propone.

Lo que está **fuera** del diff se anota y se nombra al reportar: ni se arregla ni se calla.

**Un caso borde que nadie pidió se pesa antes de codearlo:** cuán seguido pasaría y cuán
grave sería. Si los dos son bajos, se anota y el código queda como está. Diseñar para lo
raro o lo futuro suma complejidad que paga todo el resto.

---

## Alcance del diff

El diff contiene el cambio pedido y nada más: ni reformateos de líneas no tocadas, ni
renombres ajenos, ni estilo hacia tu preferencia, ni dependencias actualizadas sin pedido.

Si el cambio exige algo estructural fuera del alcance, es una decisión: pará y planteala.

---

## Qué es código limpio acá

No es estilo —eso lo define el linter—. Es esto:

**Una función hace una cosa** y su nombre lo dice. Si necesita un "y", se parte.

**Los errores se manejan o se propagan**, nunca se tragan. `catch` vacío, error logueado y
descartado o default que oculta un fallo: defectos.

**Sin abstracción prematura.** Una capa, interfaz o punto de extensión se crea con dos usos
reales, no para un caso hipotético.

**Nada que el sistema muestre o registre puede afirmar algo falso**, ni en pantalla ni en
un log, historial o auditoría. Tres disfraces: el default que rellena una ausencia con un
dato plausible (un cero que nadie midió, un nombre que no se supo); la frase en pasado
sobre algo que no se concretó; el atajo que responde por una fuente no consultada. Ante la
duda, **decir menos**: una ausencia declarada es un dato correcto; una afirmación inventada
es un defecto indetectable. Un fallback sin hecho real es peor que su ausencia, porque
además la oculta.

**Sin ruido.** Ni comentarios que repiten la línea, ni código comentado, logs de
depuración, `TODO` sin destinatario o variables que sólo renombran. El comentario que vale
explica por qué, no qué.

**Sin estado oculto.** Efectos secundarios inesperados, mutar argumentos y globales nuevas
se evitan, salvo que el repo ya trabaje así.

**Tipado y validación al nivel del repo.** Si el proyecto usa tipos estrictos, lo nuevo
también. No se debilita un tipo para que compile.

---

## Configuración y secretos

Lo que cambia entre ambientes se lee de configuración, no se escribe en el código.
Credenciales y claves van por el mecanismo que el proyecto ya use. Una variable nueva se
declara donde están las demás: verificalo, no lo asumas.

---

## Fuera de alcance

Acá no se escriben tests (`test`), no se corre nada (`verify`), no se revisa interfaz
(`interface`) ni se decide el alcance (`understand`).
