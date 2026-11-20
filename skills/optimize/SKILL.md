---
name: optimize
description: "Mejorar el rendimiento con evidencia: medir antes y después y conservar la ganancia. Usar cuando el objetivo es velocidad, consumo o capacidad."
---

# Optimize

Cómo se mejora el rendimiento con evidencia: de "parece lento" a "medí que bajó y se
conserva". Se carga cuando el objetivo es velocidad, consumo de recursos o capacidad bajo
carga. No se carga para optimizar por las dudas.

Es un ciclo: medir, diagnosticar, cambiar una cosa, medir de nuevo, conservar o revertir. Las
mediciones se hacen de a una: dos corridas simultáneas en la misma máquina se pisan. Por eso
no se reparte en subagentes ni en paralelo.

---

## Antes de medir

**Lo que el código dice, se lee.** Lenguajes, frameworks, gestores, puntos de entrada y
cómo se reparten las piezas (interfaz, API, workers, batch, base, colas, caché, servicios
externos) se infieren del repo. Un monorepo se recorre componente por componente y después
se miran sus interacciones. Preguntar lo que el código responde es costo sin beneficio.

**El perfil se contrasta con el código.** Un dato del perfil que el código contradice se
reporta; no se usa en silencio.

**Rutas críticas: las que recorre mucha gente o donde la lentitud cuesta.** Un flujo, un
endpoint, un job. Cada una se asocia a los componentes que atraviesa.

**Objetivo.** Si el pedido no fija un número, se mide la línea base y se propone uno; el
usuario decide si basta. No se persigue una cifra inventada.

**Git.** Se anota qué cambios sin commitear ya existían. Son ajenos: no se pisan ni entran en
el commit de esta tarea.

---

## Medir la línea base

Cada ruta crítica es un escenario: entrada concreta, datos representativos, ambiente
declarado. El ambiente lo fija el perfil; si no, se pregunta. Nunca se mide con carga contra
producción.

La métrica es la que pide el problema. Para latencia, percentiles (p50 y p95 como mínimo): el
promedio esconde la cola que sufre el usuario. Una métrica primaria por cambio; las demás
vigilan regresiones.

Las corridas comparten máquina, datos y repeticiones, y se declara si la caché estaba fría o
caliente. Se reporta la dispersión: si es del mismo orden que el efecto buscado, la medición
no es concluyente, y se dice.

---

## Diagnosticar antes de cambiar

No se elige la optimización de una lista: se mira dónde se gasta el tiempo o los recursos con
la herramienta que el perfil declara o el repo ya trae. Si no hay ninguna y la medición la
necesita, se pregunta antes de instalar (las dependencias nuevas son decisiones, ver
`implement`).

Casi todo cuello de botella es de una de cuatro formas:

- **Trabajo repetido**: la misma consulta o petición por cada elemento de una lista.
- **Trabajo innecesario**: recalcular o renderizar algo que no cambió.
- **Trabajo fuera de la ruta crítica**: lo que carga antes de que haga falta.
- **Espera evitable**: llamadas en serie que podían ir juntas, o un dato que no cambia y se
  pide cada vez.

Dónde mirar cambia por componente: en interfaces, el hilo principal, la carga inicial y los
pedidos de red; en backend, latencia por percentil, operaciones por petición y llamadas
externas con sus timeouts; entre capas, la latencia acumulada y el trabajo duplicado.

Para cada cuello se anota lo observado, la causa supuesta y qué resultado la confirmaría o la
descartaría. Sin forma de confirmarla, es hipótesis, no hallazgo.

---

## Priorizar y cambiar lo mínimo

Se ordena por impacto esperado y confianza en la hipótesis, dividido por costo y riesgo. Sin
evidencia no se aplica: queda como pendiente, con su razón.

Un cambio por hipótesis, para que su medición atribuya el efecto. Antes de escribirlo quedan
definidos cómo se comprueba que el comportamiento no cambió (tests existentes o el escenario
de `verify`) y qué métrica se mira después. Se revisan los efectos en otros caminos y la
consistencia de los datos: una caché nueva necesita definido quién la invalida. El código se
escribe según `implement`; los tests que exige, según `test`.

---

## Medir después y decidir

Mismo escenario, ambiente y repeticiones que la línea base. Según el resultado:

- **Mejora por encima del ruido, con comportamiento verificado**: se conserva.
- **Neutro, dentro del ruido, o negativo**: se revierte sólo el cambio propio, a mano y sin
  comandos que descarten trabajo ajeno. Queda registrado como intento, con su número.
- **Inconcluso**: se dice. No se conserva por intuición.

Cada resultado lleva variación absoluta y porcentual, con unidades y condiciones.

El ciclo cierra cuando las rutas críticas están evaluadas, cada mejora conservada tiene su
medición y lo pendiente tiene su causa anotada. No hace falta mejorar todas las rutas: un
diagnóstico que no justifica cambios es un resultado válido.

---

## Límites

- Medición en local, de prueba o staging. La telemetría de producción se lee sin modificarla,
  con el acceso que el usuario autorizó. Nada de carga contra producción.
- La instrumentación de medición es temporal y se quita antes de cerrar; no se agrega
  telemetría permanente.
- Nada de dependencias ni servicios nuevos mientras alcance lo existente.

---

## Reporte

Además de lo que pide `verify`: componentes evaluados, escenarios y condiciones de medición
(ambiente, datos, repeticiones, dispersión), cuellos con su evidencia, cambios conservados y
revertidos con su motivo, tabla antes/después con unidades, y pendientes con su causa. Lo
observado se separa de lo supuesto y de lo recomendado.

---

## Fuera de alcance

Acá no se verifica el comportamiento funcional ni se escriben tests (`verify`, `test`). Un
índice o cambio de esquema que pida el diagnóstico es cambio de datos (`database`); caché,
servidor, CDN o despliegue, `infra`; la pantalla y sus estados, `interface`. No se escribe el
código del cambio (`implement`), ni el commit (`commit`), ni se reparte el backlog
(`parallelize`). Herramientas, comandos y rutas concretas están en el perfil.
