# Project Profile — <NOMBRE DEL PROYECTO>

Plantilla. Copiala a la raíz del repo como `project-profile.md` y completala.

Declara los **hechos locales** del proyecto: lo único que el harness no sabe ni puede
inventar. Nada de cómo trabajar, eso vive en el harness.

Regla para el agente que lo lee: **un dato que no está declarado acá no se deduce ni se
inventa. Se pregunta**, y una vez confirmado, se pide que quede escrito acá.

Borrá las secciones que no apliquen y las instrucciones entre `<>`.

---

## Stack

<Lenguajes, frameworks y versiones relevantes. Sólo lo que cambia cómo se escribe o cómo
se verifica el código.>

## Arquitectura

<Tres a cinco líneas: cómo está organizado el repo y dónde va cada tipo de código. No un
diagrama: lo mínimo para que alguien nuevo sepa dónde poner algo.>

---

## Comandos

| Propósito | Comando |
|---|---|
| Lint | `<comando o "no hay">` |
| Formateo | `<comando o "no hay">` |
| Build | `<comando o "no hay">` |
| Tests | `<comando o "no hay">` |
| Suite de verificación antes de cerrar | `<comando o "los tres de arriba">` |
| Levantar el proyecto localmente | `<comando o "no aplica">` |
| Medición de rendimiento (benchmark, carga o perfil) | `<comando o "no hay">` |

<Si un comando necesita entorno previo —variables, servicios levantados, base de datos—,
anotalo acá.>

<Si el proyecto tiene interfaz, declará en qué dirección local queda una vez levantado y
qué pantallas hay que mirar para dar por revisado un cambio visual. `verify` pide mirar la
pantalla e `interface` define qué se mira; lo que ninguno de los dos sabe es dónde está.
Sin este dato la revisión visual se saltea por falta de información y no por decisión, que
es la peor forma de saltearla.>

---

## Convenciones propias

<Sólo lo que no se deduce leyendo el código. Si el repo es consistente, casi nada va acá.
Lo que sí vale: una regla que el linter no captura, un patrón obligatorio, algo que parece
incoherente pero es intencional.>

## Zonas sensibles

<Dónde un cambio pide cuidado extra o consulta previa: código generado, módulos con
contratos externos, integraciones críticas, legado en migración.>

---

## Datos

<Completar sólo si el proyecto persiste datos.>

- Motor: `<...>`
- Mecanismo de migraciones: `<...>`
- Comando para aplicar migraciones: `<...>`
- ¿Se puede parar el servicio para desplegar? `<sí / no>` <Define si aplica la disciplina
  de cambios incrementales de `database.md`.>

## Infraestructura

<Completar sólo si el repo define cómo se construye o despliega.>

- Ambientes: `<...>`
- Dónde se declara la configuración de cada ambiente: `<...>`
- Cómo se manejan los secretos: `<...>`
- Cómo se verifica un cambio de infra localmente: `<...>`

## Interfaz

<Completar sólo si el proyecto tiene UI.>

- Sistema de diseño / librería de componentes: `<... o "no hay">`
- Dónde viven los tokens o variables de estilo: `<...>`
- Tamaños de pantalla soportados: `<...>`
- Cómo se revisa la pantalla (script o herramienta, y qué devuelve): `<...>`

## Tests

- Framework: `<...>`
- Dónde viven los tests: `<...>`
- Umbral de cobertura, si el proyecto define uno: `<... o "no hay">`

## Rendimiento

<Completar sólo si el proyecto tiene escenarios o requisitos de rendimiento. `optimize` los
usa como fuente de rutas y ambiente; sin ellos, la medición se pregunta.>

- Rutas críticas (flujos, endpoints o jobs que importan, y por qué): `<...>`
- Ambiente de medición (local, staging, cómo se levanta con datos representativos): `<...>`
- Telemetría de producción de solo lectura (errores, trazas), si existe: `<herramienta y qué
  se puede leer, o "no hay">`
- Objetivos o presupuestos ya definidos (métrica y umbral): `<... o "no hay">`

## Documentación

<Dónde vive la documentación que un cambio puede dejar desactualizada, para que cerrar la
tarea incluya sincronizarla (ver `commit.md` § Documentación del proyecto).>

- Registro de cambios (changelog): `<ruta o "no hay">`
- Documento de convenciones o arquitectura compartidas (el que se relee antes de crear un
  primitivo nuevo, y se actualiza al agregar uno): `<ruta o "no hay">`
- Versionado: ver § Entrega.

## Entrega

<Cómo llega un cambio a los usuarios. Vale para una sesión que resuelve sola y para quien
coordina frentes.>

- ¿Integrar en la rama principal publica (despliega)? `<sí, dónde / no>`
- Versión: esquema y cuándo se sube (por cambio publicado, por tanda, sólo a pedido): `<...>`
- Orden entre repositorios, si hay varios (por ejemplo, quien define un contrato antes que
  quien lo consume): `<... o "no aplica">`
- Verificación del frente (rápida, de su área) y batería completa (la corre quien integra,
  una vez): `<comandos>`
- Cómo se confirma que lo publicado está en línea: `<comando, URL o "no aplica">`
- Changelog para usuarios: si cada versión lleva título, resumen o imagen, y quién los
  escribe: `<... o "no hay">`
- Frentes simultáneos como máximo, y dónde corren (local, remoto): `<...>`
- Acciones que siempre piden OK explícito del usuario (publicar datos, borrar, pagar):
  `<... o "ninguna">`
  Lo que este perfil autoriza sólo puede restringir lo que el harness ya pide confirmar, nunca
  ampliarlo. Un cambio a este archivo se revisa como un cambio de permisos.

## Control de versiones

<Sólo si el proyecto tiene reglas propias: convención de ramas, formato de commit,
restricciones sobre qué se commitea o dónde.>

- Atribución de IA en commits y pull requests: <prohibida (default) | obligatoria, con esta
  forma: … | indiferente>

---

## Responsabilidades que no aplican

<Las del harness que este repo nunca necesita, para que no se carguen. Ejemplo: en backend
puro, `interface`.>
