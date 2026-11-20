---
name: understand
description: "Pasar del pedido a un entendimiento verificado del problema antes de tocar código: validar el pedido, causa raíz de un bug, alcance y cómo preguntar. Usar al empezar una feature, un bug, un refactor o una optimización."
---

# Understand

Cómo pasar del pedido a un entendimiento verificado del problema, antes de tocar código.

Termina cuando podés enunciar qué está mal o qué falta, dónde y cuál es el borde del cambio,
y cada requerimiento tiene un criterio de terminado observable. No cuando "ya te queda
claro".

---

## Enunciar el problema

Antes de explorar, escribí en una frase qué se pide. Si necesita un "y también", hay más de
una tarea: separalas y confirmá el orden.

Distinguí síntoma de pedido real. "Agregá un botón para reintentar" es una solución; el
problema es que algo falla y el usuario queda sin salida. Se implementa lo pedido, pero si
no resuelve el problema que lo motiva, se dice.

---

## Validar el pedido

El pedido en lenguaje natural se convierte en una lista de requerimientos. Cada uno dice
qué cambia y cómo se sabe que está hecho: algo que se puede mirar o correr. "Que quede
mejor" no es un criterio.

Del mismo texto salen dos cosas que se verifican distinto:

- **Límite**: lo que no se toca. Se comprueba en el diff.
- **Guardarraíl**: lo que tiene que seguir siendo cierto. Se comprueba comparando antes y
  después. Uno incomprobable es un deseo: preguntá qué lo volvería comprobable.

Cada requerimiento responde tres preguntas, y cada una fija una decisión:

- **¿Depende de algo que se entrega por separado?** (otro servicio, repositorio, esquema).
  Fija el orden: lo que provee va antes que lo que consume.
- **¿Se deshace barato?** Fija cuánto se verifica antes de entregar. Lo que no se deshace se
  consulta (`dev-workflow`, "Cuándo detenerse a preguntar").
- **¿Se puede verificar solo?** Fija si es una entrega propia. Lo que no, va junto con
  aquello de lo que depende.

Se responden leyendo el repo; se pregunta sólo lo que no se deduce.

Señales de que el texto no alcanza y completarlo a ojo da el trabajo equivocado:

- Una referencia sin la propiedad ("como tal producto"): ¿qué de ese producto?
- Una enumeración que admite dos cortes.
- Un referente sin borde ("lo demás", "lo pendiente"): se enumera y se confirma.
- Un texto cortado a la mitad: se pregunta, no se completa.

Con más de un requerimiento, la lista se declara antes de empezar. No es un documento: es el
entendimiento por escrito.

---

## Explorar antes de concluir

"Esto no existe en el repo" exige haber buscado:

- Por **nombre** del concepto y sus sinónimos del dominio (`Cliente` puede ser `Customer`,
  `Account` o `Party`).
- Por **uso**, no sólo definición: quién llama a lo que vas a tocar determina el impacto.
- Por **precedente**: lo más probable es que el repo ya resolvió algo parecido, y esa es la
  forma correcta acá.

Leé entero el código que vas a modificar, no sólo las líneas a tocar: los supuestos suelen
estar arriba y abajo.

---

## Delimitar el alcance

El borde se declara: qué archivos entran, qué comportamiento cambia, qué queda igual. Lo
que aparece en el camino y cae afuera —código muerto, otro bug, una convención rota— se
anota y se reporta al final. No se arregla de paso.

Identificá qué puede romper el cambio: quién consume lo que modificás, qué contratos
dependen del comportamiento actual, qué datos guardados asumen la forma vieja.

---

## Causa raíz, en bugs

Un bug no está entendido hasta explicar la cadena causal completa: qué entrada o estado
produce el comportamiento incorrecto, y por qué el código actual lo produce.

Todavía no llegaste si:

- El arreglo que se te ocurre es un `if` que esquiva el caso malo.
- No podés escribir un test que falle determinísticamente sin el arreglo.
- La explicación incluye "por algún motivo" o "a veces".

Reproducir antes de arreglar no es opcional. Si no se reproduce, se dice, en vez de arreglar
a ciegas.

---

## Ambigüedad

Anotá los casos borde que el pedido no cubre: entrada vacía, valores límite, concurrencia,
fallo de una dependencia, permisos insuficientes. Para cada uno, o el repo ya define un
comportamiento —se sigue— o es una decisión nueva. Las chicas se toman y se declaran; las
que cambian lo que el usuario percibe se preguntan.

---

## Cómo preguntar

Todos los huecos en una sola ronda, no de a uno.

Si el medio lo permite, con opciones cerradas: una por lectura posible, la recomendada
primero y marcada, y respuesta libre siempre disponible. Si no, texto con opciones
numeradas. Una pregunta abierta sobre algo con pocas respuestas le pasa al usuario el
trabajo de enumerarlas.

Mientras se espera, se avanza en lo que no depende de la respuesta.

---

## Fuera de alcance

Acá no se decide **cómo** implementar (`implement`), ni se escriben specs formales, ni se
estiman esfuerzos, ni se documentan decisiones en herramientas externas.
