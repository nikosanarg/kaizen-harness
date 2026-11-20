---
name: test
description: "Qué merece un test y cómo se escribe, incluida la regresión de un bug. Usar en features, bugs, optimizaciones y tareas de sólo tests."
---

# Test

Qué merece un test y cómo se escribe. Ejecutarlos y leer resultados es `verify`.

---

## Qué testear

**Comportamiento observable**, no implementación. Un test que se rompe por renombrar algo
privado o cambiar una estructura interna, sin cambio de comportamiento, resta.

Prioridad cuando no se cubre todo:

1. La lógica de negocio o decisión que introduce el cambio.
2. Los casos borde detectados en `understand`.
3. Manejo de errores y caminos de fallo.
4. Contratos con el exterior del módulo.

No merecen test propio: getters y setters triviales, wrappers que sólo delegan,
configuración estática, código de terceros.

---

## Test de regresión en bugs

Todo bug corregido lleva un test que falla sin el arreglo y pasa con él. Comprobá que falla
**antes** de arreglar: uno que nunca viste en rojo no prueba nada.

---

## Cómo se escribe un buen test

**Una afirmación conceptual por test.** Varios asserts valen si describen el mismo
comportamiento.

**El nombre describe el caso**, no la función: qué situación, qué se espera. Quien lo ve
fallar sabe qué se rompió sin abrir el archivo.

**Independiente y determinístico.** No depende del orden, de tests previos, del reloj, de
la red ni de datos entre corridas. Tiempo y aleatoriedad se inyectan.

**Explícito.** Los datos que importan se ven en el test. Una fixture compartida que esconde
qué lo hace pasar es deuda.

**Falla con un mensaje útil.** Assert específico antes que genérico.

---

## Dónde vive un test

**Con la unidad que prueba.** El archivo se llama por el componente, página, módulo o
endpoint que verifica; quien toca esa unidad encuentra ahí todo lo que la cubre. Si no
existe, se crea.

**Nunca** se nombra por versión, iteración, sprint o frente. Un `v1-2-23.test` agrupa por
*cuándo*, que deja de importar al mergear: nadie sabe qué tiene adentro, quien cambia un
componente no sabe qué tests le tocan, y cada versión suma un archivo que nadie mira. Es el
defecto de un módulo llamado `utils2`.

La tentación aparece con la integración de una tanda: cubre varias unidades y ninguna
parece dueña. Igual tiene dueño: el punto donde se integran (la pantalla que monta las
piezas, el contrato compartido, el reducer que las une). Si no hay ninguno, el nombre
describe **la costura**, no la versión.

---

## Mocking

Se mockea lo que está fuera del borde de lo testeado: sistemas externos, red, disco, reloj,
aleatoriedad. No la lógica que se prueba: si testear una función exige mockear cinco cosas
internas, el problema es el diseño, no el test.

Se sigue la forma de mockear del repo. Una librería de testing nueva se plantea, no se
introduce.

---

## Cobertura

Se **mantiene**, no se persigue: lo nuevo llega con sus caminos relevantes cubiertos y el
proyecto no queda peor.

Nunca tests sólo para subir el número. Si el perfil declara un umbral, se respeta; si no,
no se inventa.

---

## Fuera de alcance

Acá no se declara framework ni comando (perfil del proyecto) ni se ejecuta o interpreta la
suite (`verify`).
