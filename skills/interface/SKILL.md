---
name: interface
description: "Revisar un cambio que el usuario ve o toca: estados, accesibilidad, consistencia visual. Usar en cambios de interfaz, antes de verify."
---

# Interface

Cómo se revisa un cambio que el usuario ve o toca.

Se carga cuando el cambio afecta la interfaz. El criterio es **coherencia con lo
existente**: no se impone estética, se audita que el cambio no cree una isla visual o de
comportamiento.

---

## Coherencia con lo existente

Antes de definir un espaciado, color, tamaño o patrón de interacción, mirá cómo lo
resuelve el resto del producto y usá eso. Si hay sistema de diseño, tokens o librería de
componentes, se usan: un valor a mano habiendo token es un defecto.

Un componente nuevo se justifica cuando ninguno cubre el caso, no cuando el que hay necesita
una variante. Antes de crear, revisá si la admite.

Por qué cuesta caro: una copia local con una diferencia chica se ve igual el día que nace y
distinta el día que alguien mejora el original; esa pantalla queda atrás sin que nadie lo
note. Y la misma forma repetida con medidas apenas distintas es lo que hace que dos
pantallas no alineen.

La terminología también es interfaz: las mismas palabras que el resto del producto para los
mismos conceptos.

---

## Estados que se olvidan

Todo lo que muestra datos o acepta interacción tiene más de un estado. Los más omitidos:

- **Vacío**: sin datos todavía, o búsqueda sin resultados. Son distintos.
- **Cargando**: qué se ve mientras se espera, y si la espera es larga.
- **Error**: qué se muestra y qué puede hacer el usuario después. Sin salida es un
  callejón.
- **Deshabilitado**: por qué, y si el usuario puede saberlo. Un control apagado promete que
  en algún caso se enciende; si no hay ninguno, no es un control.
- **Parcial**: datos incompletos, listas largas, textos que desbordan, nulos.

El cambio está completo cuando los estados que aplican están resueltos como en el resto del
producto.

---

## Accesibilidad mínima

No es una auditoría: es el piso, y no se negocia.

- Todo control operable con teclado, foco visible, orden de tabulación razonable.
- Todo control con nombre accesible, también los de sólo ícono.
- El significado nunca va sólo por color.
- Contraste suficiente para leer.
- Imagen con contenido, con texto alternativo; decorativa, sin.

---

## Comportamiento

Un control hace lo que dice. Si cambiar un default cambia lo que significa el control —una
selección vacía que antes quería decir "todo"—, se cambia el significado; no se conserva la
excepción. Un dato y la acción que lo modifica van en el mismo lugar, y no se ofrece
"agregar" lo que ya está.

Verificá en los tamaños de pantalla que el producto soporta, no sólo en el tuyo, con los
puntos de quiebre que el proyecto ya define.

Las acciones destructivas se confirman o se deshacen; las que tardan avisan; las repetibles
no se disparan dos veces por accidente.

---

## Fuera de alcance

Acá no se define un sistema de diseño, ni se eligen paletas o tipografías, ni se decide
producto. Tampoco se escribe código (`implement`) ni se corre nada (`verify`).
