---
name: verify
description: "Comprobar que un cambio funciona antes de declararlo terminado: lint, build, tests, releer el diff, no relajar verificaciones. Usar al cerrar toda tarea que tocó código."
---

# Verify

Cómo se comprueba que un cambio funciona antes de declararlo terminado: de "creo que anda" a
"comprobé que anda". No se saltea en ninguna tarea que tocó código.

---

## Qué se ejecuta

Lo que declare el perfil, en orden: **lint → build → tests**. Cada etapa es más cara que la
anterior; un fallo temprano ahorra tiempo.

Si el perfil no declara un comando, no se inventa ni se deduce de un archivo de
configuración: se pregunta, y lo confirmado se pide que quede en el perfil.

Durante el desarrollo vale correr sólo lo afectado. Antes de cerrar, la suite de
verificación del perfil.

---

## Cómo se leen los resultados

**Un fallo es un fallo.** No se reinterpreta como "no relacionado" sin comprobarlo viendo el
repo sin tus cambios.

Ante un fallo, distinguí:

- **Introducido por el cambio** → se arregla antes de cerrar; es parte de la tarea.
- **Preexistente** → ni se arregla ni se ignora: se reporta, con cómo se comprobó que ya
  estaba.
- **Inestable (flaky)** → se reporta como tal, con la evidencia. No se descarta una falla
  llamándola flaky sin comprobarlo. Y no se tolera: una verificación que a veces falla
  enseña a ignorar fallas. Se vuelve determinista o se saca, como tarea propia.

**Una batería larga no frena en la primera falla.** Si corta ahí, una falla vieja tapa todo lo
que viene después y cada corrida descubre de a un problema. Corre entera y resume al final.

**Un fallo introducido se diagnostica antes de volver a editar.** Primero la evidencia —qué
falló y con qué salida—, después qué parte del cambio la explica, y recién ahí una
corrección dirigida a esa parte. Lo que la evidencia no contradice se conserva: no se
reescribe todo ni se prueba otra variante a ver si pasa.

**Dos reintentos sobre el mismo fallo cortan el ciclo.** Si tras dos correcciones dirigidas
sigue fallando, falla el entendimiento, no el arreglo: se vuelve a `understand` con lo que
enseñaron los intentos, en vez de probar un tercero.

Una verificación nunca pasa relajando lo que verifica: ni se borra o deshabilita un test
que molesta, ni se suprime un hallazgo real del linter, ni se debilita un tipo para que
compile, ni se saltea un hook o un chequeo automático del control de versiones o de la
integración continua. Si parece necesario, se plantea; no se ejecuta.

---

## Comprobación funcional

Comandos en verde prueban que el código corre, no que resuelve el problema. Si hay efecto
observable, se comprueba por el medio que el proyecto permita: ejecutarlo, llamar al
endpoint, mirar la pantalla, inspeccionar el dato.

**Mirar la pantalla se automatiza, y se pide un veredicto, no la página.** Si la revisión
visual se repite, un script la recorre en los anchos que importan y devuelve sólo lo que
falla; capturas, sólo si algo falló. Una herramienta que vuelca la página entera en cada
paso sirve para explorar un flujo desconocido; repetida, multiplica lo que se lee sin decir
más.

Volvé al enunciado de `understand` y verificá punto por punto el comportamiento pedido,
casos borde incluidos.

---

## Higiene antes de cerrar

Releé el diff completo como si fuera de otro: restos de depuración, cambios ajenos,
archivos tocados por accidente, código a medio migrar.

Toda configuración nueva tiene que estar declarada donde el proyecto declara las demás.

---

## Qué se reporta

Qué se ejecutó, con qué resultado y qué no se pudo verificar.

Prohibido declarar terminado lo no verificado u omitir un fallo. Lo que quedó sin comprobar
—falta un entorno, un dato, un permiso— se dice con esa palabra: **no verificado**.

---

## Fuera de alcance

Acá no se decide qué testear ni se escriben tests (`test`), ni se eligen herramientas o
declaran comandos (perfil del proyecto), ni se prepara el commit (`commit`).
