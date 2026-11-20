---
name: database
description: "Cambiar esquema, migraciones o acceso a datos persistidos, y ejecutar SQL contra una base real con seguridad. Usar en cambios de datos, antes de implement."
---

# Database

Cómo se cambia el esquema y el acceso a datos persistidos.

Se carga cuando el cambio toca datos que sobreviven al proceso. La diferencia: **el estado
existente no se edita en el diff**; los datos viejos siguen ahí después del deploy.

Corto a propósito: sólo lo que vale en cualquier motor y proyecto.

---

## El dato viejo existe

Antes de cambiar una estructura, preguntá qué pasa con lo guardado bajo la forma anterior.
Toda columna obligatoria nueva, cambio de tipo o restricción nueva responde qué se hace con
las filas que no la cumplen.

Un cambio de esquema que sólo funciona sobre una base vacía no está terminado.

---

## Compatibilidad durante la transición

Asumí un período en que conviven código viejo y esquema nuevo, o al revés. Por eso los
cambios seguros son incrementales:

- Agregar es seguro; quitar y renombrar, no.
- Un renombre va en pasos: agregar lo nuevo, escribir en ambos, migrar, dejar de usar lo
  viejo, y recién ahí quitarlo.
- Una restricción nueva se agrega después de garantizar que los datos la cumplen.

Si el perfil declara que no hace falta (el servicio puede parar), se sigue el perfil.

---

## Operaciones destructivas

Borrar columnas, tablas o filas, o sobrescribir datos, no se revierte con un revert de
código. Se identifican antes y se plantean, no se ejecutan por iniciativa propia.

Toda migración debería poder deshacerse; si no se puede, se dice.

---

## Ejecutar SQL contra una base real

Vale para un incremental, una corrección de datos o un ajuste pedido de urgencia. Sólo si el
perfil autoriza al agente a ejecutar. El SQL se escribe al final: antes se responden estas
preguntas.

**1. ¿Qué base es?** El perfil dice cuántos ambientes hay y a cuál apunta la conexión local. Si
esa base es la que usan los usuarios, cada sentencia es producción. Si hay otra base que no se
alcanza desde acá, el reporte dice qué falta aplicar en ella.

**2. ¿Cómo está el esquema de verdad?** Se lee el catálogo de la base, no el esquema canónico ni
el código: columnas, tipos, defaults, restricciones, índices únicos, triggers. Ahí está lo que
puede rechazar la sentencia o hacerla distinta.

**3. ¿Quién más escribe este dato?** Antes de tocar un valor se busca en el código cómo se
escribe:
- **Valores derivados:** si se calcula desde otra tabla (un saldo desde un libro de
  movimientos, un contador desde sus filas), se cambia por su fuente, con el mismo patrón que usa
  el código. Si se edita el derivado solo, la próxima operación lo pisa o lo deja inconsistente.
- **Copias en memoria:** si un proceso vivo guarda una copia, puede volver a escribirla encima.
  Se averigua qué ve un usuario conectado y se informa.

**4. ¿Cuánto toca?** Se mide antes con una consulta de sólo lectura: cuántas filas, cómo se
distribuyen, extremos. Esa cifra se compara con el resultado y entra en el reporte.

**5. ¿Hay permiso?** Lo destructivo (borrar, sobrescribir, actualizar en masa) se ejecuta sólo con
un pedido explícito del usuario que defina el alcance. Si la medición muestra algo que el pedido
no previó, se pregunta antes: filas que no esperaba, datos que se pierden sin vuelta.

Construcción:
- **Idempotente.** Correrla dos veces no hace daño: `IF NOT EXISTS`, una marca o referencia única
  que el conflicto descarta, o un filtro que excluye lo ya hecho.
- **Atómica.** Una sola sentencia o una transacción. Nunca la mitad aplicada.
- **Cuenta lo que hace.** Devuelve las filas tocadas, para no tener que suponerlo.
- **Trazable.** Si el dominio guarda historia (movimientos, auditoría), el ajuste deja su
  registro con un concepto o etiqueta que lo explique.
- **Respeta las reglas de la base.** Se mantiene dentro de las restricciones del catálogo, sin
  desactivarlas.

Después de ejecutar se verifica con una consulta independiente que comprueba lo pedido. El
conteo de la propia sentencia no alcanza: hay que confirmar el invariante. Se compara con la
medición previa.

El reporte dice:
- qué se ejecutó, contra qué base y cuántas filas tocó;
- el antes y el después;
- efectos colaterales, como usuarios conectados que siguen viendo el valor viejo;
- si se puede revertir y cómo.

---

## Forma del cambio

El esquema cambia por el mecanismo que el proyecto ya use. Ni se toca una base a mano por
fuera, ni se edita una migración ya aplicada en algún ambiente.

Una migración se prueba corriéndola, no leyéndola.

**Si el mecanismo es un esquema canónico más scripts sueltos aplicados a mano, el
incremental no entra al repo.** Se versiona el canónico, que crea la base entera desde cero.
El incremental es un archivo de trabajo de ciclo corto:

1. Se escribe idempotente, para correrlo dos veces sin daño.
2. Se integra al canónico en el mismo cambio que el código que lo usa.
3. Lo aplica una persona en cada ambiente, antes de desplegar el código que lo lee.
4. Se borra. No se commitea nunca, ni para borrarlo después: el canónico ya tiene el cambio,
   y un incremental versionado es una segunda copia que nadie mantiene y que queda en la
   historia.

Al entregar, se dice qué incremental aplicar y en qué orden respecto del deploy, con su
contenido en el reporte, no en el diff.

**Un incremental se nombra por la versión que lo introduce.** Si los scripts sueltos no
tienen una herramienta que los nombre, cada uno es `v{NNNN}-{feature}` con su extensión:
`NNNN` es la versión del perfil sin puntos y `feature`, lo que agrega en pocas palabras.
`1.9.3` da `v193-…`; `2.81.50788` da `v28150788-…`. Se sabe cuándo entró y de qué trata sin
abrirlo.

Sin puntos, el orden alfabético deja de coincidir con el de versiones cuando un componente
llega a dos dígitos (`1.10.0` da `v1100`, antes que `v193`), y dos versiones pueden dar el
mismo prefijo (`1.10.0` y `11.0.0`). El orden de aplicación lo decide la versión, no el
explorador de archivos.

---

## Fuera de alcance

Acá no hay conocimiento de un motor concreto, ni modelado de dominio. Diagnosticar consultas
lentas por rendimiento es `optimize`; el índice o cambio de esquema que resulte, se entrega
acá. Motor, herramientas y comandos están en el perfil.
