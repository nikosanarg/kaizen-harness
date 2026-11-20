> **Material histórico, no normativo.** Notas de un harness anterior para otra herramienta. No se carga para trabajar y contradice al harness actual en varios puntos: manda `dev-workflow.md` y `skills/`.

# Harness Genérico - Tutorial - How to use (Windows) - no data sensible ni corporativa

Notas personales, **genéricas y reutilizables en cualquier PC Windows** (sin nada corporativo/de
producto), para entender qué es un "harness" de Devin CLI, cómo se instala desde cero y cómo funciona
un pipeline de desarrollo asistido por subagentes especializados.

## 1. Qué es un harness y dónde vive

Un harness es un repo git aparte (no depende de ningún proyecto puntual) que versiona tu
configuración de Devin CLI: agentes custom, skills de conocimiento, presets de permisos/MCPs y,
opcionalmente, un quality gate determinístico. Se instala una vez por máquina y queda **proyectado**
dentro de la config global de Devin (`%APPDATA%\devin\`) mediante *directory junctions* de NTFS — no
copia archivos, los enlaza. Por eso un `git pull` en el repo + volver a correr el instalador alcanza
para que Devin, en cualquier proyecto, tenga el comportamiento más nuevo, sin reinstalar nada.

```text
mi-harness/                           (repo git, versionado)
├── AGENTS.md                         # opcional: dispara un wizard de onboarding dentro de ESTE repo
├── ONBOARDING.md                     # guion de instalación (wizard guiado o manual)
├── setup.ps1 / uninstall.ps1         # instalador/desinstalador idempotente (junctions)
├── CHANGELOG.md                      # por qué se tomó cada decisión de configuración
└── devin-global-config/              # <- esto es lo que se enlaza a %APPDATA%\devin\
    ├── AGENTS.md                     # orquestador global (siempre activo)
    ├── config.example.json           # plantilla de permisos / MCPs / hooks
    ├── agents/<nombre>/AGENT.md      # subagentes custom
    ├── skills/<nombre>/SKILL.md      # skills de conocimiento
    └── scripts/                      # scripts que los hooks pueden invocar (ej. quality gate)
```

`%APPDATA%\devin\` (tu config real) queda así después de correr el instalador: `AGENTS.md`,
`agents\<nombre>` y `skills\<nombre>` son *junctions* apuntando al repo; `scripts\<lo-que-sea>\`
igual. `config.json` **no** se enlaza (es tuyo, local, con secretos) — se mergea a mano o guiado desde
`config.example.json`.

## 2. Los primitivos nativos de Devin CLI (la base, sin nada custom)

Todo lo que ofrece un harness está construido **encima de mecanismos que Devin CLI ya trae de
fábrica**. Vale la pena separarlos, porque son los que necesitás si querés armar tu propio harness de
cero, en una máquina limpia:

| Primitivo | Qué es | Cómo se activa |
|---|---|---|
| `%APPDATA%\devin\AGENTS.md` | "System prompt" global — se inyecta siempre, en toda sesión y todo repo | Se lee automáticamente si existe |
| `<repo>\AGENTS.md` | Reglas específicas de ESE repo (convenciones, stack, comandos de verificación) | Se lee automáticamente al abrir Devin parado en ese repo |
| `%APPDATA%\devin\agents\<nombre>\AGENT.md` | Subagente custom: frontmatter YAML (`name`, `description`, `permissions.allow/deny`) + prompt en Markdown | Se invoca con `run_subagent(profile: "<nombre>")` |
| `%APPDATA%\devin\skills\<nombre>\SKILL.md` | Conocimiento/checklist invocable, puede otorgar permisos de tool | Manual (`skill` tool / `/nombre`) o autodetectada si la descripción calza con el pedido |
| `%APPDATA%\devin\config.json` | `permissions` (allow/deny/ask), `mcpServers`, `hooks` (ej. `Stop`), `agent.model`, `read_config_from` | Se lee al arrancar Devin |
| `%APPDATA%\devin\scripts\` | Scripts arbitrarios (PowerShell, etc.) que los `hooks` del `config.json` pueden invocar | Referenciados desde `hooks.*.hooks[].command` |

Un harness **es**, en el fondo, contenido bien escrito para estas 5-6 carpetas/archivos, más un
instalador prolijo que no pise nada que ya tengas configurado a mano. No hay magia adicional de Devin
CLI por debajo.

## 3. Cómo arrancar un harness de cero (PC Windows nueva, sin nada instalado)

### Prerrequisitos
- **Windows 10/11 con PowerShell.**
- **Git para Windows**, con `C:\Program Files\Git\bin` en el `PATH` (trae `sh.exe`). Devin CLI ejecuta
  los *command hooks* (ej. un quality gate) vía `sh -c` (formato heredado de Claude Code); sin `sh`
  disponible, cualquier hook `command` falla en silencio con `program not found`. Verificá con
  `Get-Command sh`.
- **Node.js + npm** (los servidores MCP típicamente se levantan con `npx`).
- **Devin CLI** instalado y logueado.

### Paso 1 — Los archivos base a mano (entendiendo qué hace cada uno)
Si no tenés ningún repo de harness para clonar, podés construir esto vos mismo, archivo por archivo:

1. **(Opcional) `%APPDATA%\devin\AGENTS.md` propio.** Un `.md` con las reglas mínimas que querés
   siempre activas (ej. "trabajá en ramas `feature/*`", "commits con mensaje descriptivo"). Conviene
   mantenerlo corto — lo pesado (pipelines largos, checklists) conviene moverlo a skills on-demand
   para no gastar contexto en tareas triviales.
2. **`%APPDATA%\devin\config.json` propio.** Arrancá de `{}` y andá sumando:
   - `permissions.allow`: lo que usás seguido (`Read(**)`, `Exec(git)`, `Exec(npm)`, etc.) para que no
     te pregunte por cada cosa trivial.
   - `permissions.ask`: lo sensible (`git push`, borrar archivos, escribir `.env`/secretos).
   - `mcpServers`: las integraciones que necesites (control de versiones, gestor de tickets, memoria
     persistente entre sesiones, navegador, etc. — ver tabla de ejemplo más abajo).
   - `hooks` (opcional): si querés un gate determinístico al terminar una tarea (`Stop`), apuntando a
     un script propio.
3. **(Opcional) Tus propios agentes/skills.** Calcá el formato frontmatter de un `AGENT.md`/`SKILL.md`
   de ejemplo (son autocontenidos, no dependen de nada externo) y guardalos en
   `%APPDATA%\devin\agents\<nombre>\` / `skills\<nombre>\`.
4. **Verificación:** listá las skills/agentes disponibles y confirmá que los MCPs configurados
   levanten sin error.

### Paso 2 — Empaquetarlo como un repo instalable (para reusarlo en otra PC o compartirlo)
Una vez que tenés contenido que funciona, conviene versionarlo en su propio repo git con esta
estructura (la del diagrama de la sección 1) y un `setup.ps1` que:
- Cree un *junction* por cada agente/skill (`Directory Junction` de NTFS — no requiere permisos de
  administrador) apuntando desde el repo hacia `%APPDATA%\devin\agents\` / `skills\`.
- Antes de enlazar, si ya existe algo con ese nombre que **no** sea del harness, haga backup en vez de
  pisarlo (para no romper personalizaciones previas).
- Sea **idempotente** (correrlo varias veces no debe romper nada) — en PowerShell 5.1,
  `Remove-Item -Force` sobre un *directory junction* puede tirar error; conviene un helper que borre el
  link con la API de `.NET` (`Directory.Delete`) sin tocar el contenido real al que apunta.
- Registre la ruta del repo en un archivo (ej. `%APPDATA%\devin\harness-repo-path.txt`) para poder
  chequear actualizaciones automáticamente al inicio de cada sesión (`git fetch` + comparar contra el
  remoto).
- Un `uninstall.ps1` simétrico que revierta los enlaces y restaure los backups.

### Paso 3 — Config de ejemplo (`config.example.json`) para no perder secretos
Mantené separados:
- **Lo versionable** (`config.example.json`, con placeholders tipo `TU_TOKEN_AQUI`): permisos,
  estructura de `mcpServers`, `hooks`.
- **Lo local** (`config.json` real del usuario, nunca commiteado): tokens, rutas absolutas de
  binarios, contraseñas.

Ejemplo de `mcpServers` típicos que un harness suele traer preconfigurados (cada uno resuelve una
necesidad distinta; no hace falta tenerlos todos):

| Servidor MCP (ejemplo) | Para qué | Necesita secreto |
|---|---|---|
| Control de versiones (ej. GitHub) | Leer repos, PRs, issues, commits | Sí — token de acceso |
| Gestor de tickets/documentación (ej. Jira/Confluence) | Leer y buscar tickets/páginas | Depende — a veces OAuth por navegador |
| Diseño (ej. Figma) | Leer diseños para implementar UI | Depende |
| Navegador (Playwright / Chrome DevTools por CDP) | Automatizar/inspeccionar un navegador ya abierto | No, si te conectás a una sesión ya logueada |
| Memoria persistente | Recordar contexto entre sesiones (grafo local) | No |
| Razonamiento estructurado | Descomponer problemas complejos paso a paso | No |
| Análisis de calidad de código (ej. SonarQube) | Analizar el código con reglas de calidad/seguridad | Sí — token de la instancia |

> Nota sobre el MCP de análisis de calidad tipo SonarQube: suele requerir una versión relativamente
> reciente del servidor (que soporte autenticación por token/Bearer vía API); instancias viejas que
> solo aceptan usuario/contraseña (basic auth) no son compatibles con el protocolo del MCP.

### Paso 4 — Un quality gate determinístico (opcional pero recomendado)
Podés configurar un hook `Stop` que corra un script propio cada vez que Devin intenta terminar una
tarea, y que la **primera vez** lo bloquee, obligándolo a re-verificar requerimientos, limpiar el
código (sin logs de debug ni comentarios temporales) y probar de verdad (tests, `curl`, capturas de
navegador) antes de dejarlo cerrar en el segundo intento. Es el complemento *determinístico* de
cualquier subagente auditor (que es probabilístico). Detalles a tener en cuenta en Windows:
- El `command` del hook debe poder resolverse vía `sh` (ver prerrequisitos) — evitá `%VARIABLE%` y
  backslashes en el string del comando; usá `$VARIABLE` y barras `/`, que sí se expanden/interpretan
  bien.
- Si el script imprime texto con tildes/acentos, generalo en ASCII puro o forzá UTF-8 en la salida —
  PowerShell 5.1 puede leer un `.ps1` sin BOM como ANSI y corromper los caracteres especiales.
- El hook debe ser **stateless** (no depender de un ID de sesión que Devin no expone) para no
  quedarse "trabado en aprobado" entre sesiones distintas sobre el mismo proyecto.

### Paso 5 — Verificación y mantenimiento
- Confirmá que los *junctions* existan en `%APPDATA%\devin\agents\` y `skills\`.
- Confirmá que los MCPs levanten sin error (si alguno falla, suele ser un token vencido o un tema de
  red/proxy).
- Para mantenerlo al día: `git pull` en el repo del harness + volver a correr `setup.ps1`. Podés
  automatizar el aviso comparando `HEAD` local contra el remoto al inicio de cada sesión.

> **Redes corporativas:** si vas a instalar esto en una red con proxy/certificados propios, es
> probable que necesites configurar variables de proxy (`HTTP_PROXY`/`HTTPS_PROXY`), el registry de
> npm, y/o un truststore de certificados adicional para herramientas que no usan el store de Windows
> (ej. Java). Eso queda fuera del alcance de esta guía genérica — es específico de cada red.

## 4. Las 3 capas de comportamiento

- **Orquestador (`AGENTS.md` global, siempre activo):** reglas de oro cortas (ej. rama `feature/*`,
  convención de commits, disciplina de memoria persistente, auto-mejora editando su propia
  configuración) + un criterio simple: **tarea trivial → resolver directo**, **tarea no trivial →
  invocar un pipeline de desarrollo más completo**, **pedido puntual → delegar a un subagente sin
  levantar todo el pipeline**.
- **Skills de conocimiento** (se activan solas o a demanda; algunas ejemplos típicos de un harness de
  equipo):

  | Skill (ejemplo) | Dispara con | Aporta |
  |---|---|---|
  | Pipeline de desarrollo | Feature no trivial | Fases, routing de revisiones, reglas de handoff |
  | Principios de trabajo | Siempre | Buenas prácticas transversales (ej. buscar antes de construir, decisión final humana) |
  | Convenciones del equipo/stack | Cualquier tarea de código | Stack y convenciones reales verificadas (no inventadas) |
  | Disciplina de memoria | Inicio/cierre de sesión | Qué guardar en memoria persistente y cómo podarla |
  | Checklist de migraciones de DB | Cambios de base de datos | Operaciones destructivas, compatibilidad con rolling-deploy |
  | Checklist de infraestructura | Dockerfile/manifests/CI | Buenas prácticas de contenedores, despliegue, pipelines |
  | Armado de commits | Cierre de tarea | Mensaje de commit consistente con el estilo del repo |
  | Gate de calidad de código | Pre-commit | Analiza el diff contra reglas de calidad (ej. vía SonarQube) |

- **Subagentes especializados** (`run_subagent(profile:...)`), cada uno con permisos acotados en su
  propio frontmatter — un auditor de calidad o de seguridad **no debería poder** escribir código de
  producción por diseño (`deny: Write(src/**)`):

  | Agente (ejemplo) | Rol | Puede escribir |
  |---|---|---|
  | Estratega de producto | Replantea el "qué"/"por qué" antes de codear, alternativas | Su reporte |
  | Analista funcional | Reglas de negocio, ambigüedades, edge cases, Definition of Done | Su reporte |
  | Analista técnico | Arquitectura, base de datos, contratos de API, impacto de infra | Su reporte |
  | Desarrollador | Implementa código de producción | El repo completo |
  | Debugger | Causa raíz metódica antes de parchear | Código + test de regresión |
  | Revisor de diseño/UX | Audita interfaz, puntúa dimensiones, detecta inconsistencias visuales | Su reporte |
  | Oficial de seguridad | OWASP Top 10 + STRIDE, secretos, config por ambiente | Solo su reporte |
  | Centinela de calidad | Gate final: tests, limpieza, changelog, gate de git/tickets | Tests, changelog, su reporte (nunca código de producción) |

- **Handoff por archivos**, no por resumen: los subagentes se pasan documentos intermedios (spec,
  notas de implementación, reportes de seguridad/calidad) a través de una carpeta fuera del repo (por
  ejemplo, en el home del usuario), identificada de forma estable y re-deducible (ej. a partir del
  nombre de la rama de git actual), para que el esquema sobreviva a compactaciones de contexto,
  trabajo simultáneo en varios repos relacionados, o tener varias sesiones abiertas en paralelo.

## 5. El pipeline de desarrollo, fase por fase

Se levanta solo para trabajo **no trivial** (feature nuevo, impacto en lógica de negocio/arquitectura/
base de datos/contratos de API, refactor grande, o si se pide explícitamente). Para cada fase detallo
qué hace funcionalmente y qué conocimiento/tooling hace falta para operarla o auditarla.

### Fase 1 — Diagnóstico de entorno (autocuración, opcional)
**Qué hace:** antes de instalar dependencias, valida que el entorno de red/paquetes funcione; si hay
bloqueos, intenta reconfigurar en caliente lo necesario (proxy, registries). Si igual falla, **corta**
(no reintenta en loop), usa lo que ya está instalado localmente, y avisa.
**Conocimiento necesario:** cómo configurar proxies y archivos de config de gestores de paquetes
(`.npmrc`, `settings.xml` de Maven, `pip.conf`, etc.) — solo relevante en redes restringidas.

### Fase 2 — Descubrimiento y refinamiento
- **Estratega de producto** *(solo si es feature nuevo)*: replantea el problema antes de codear,
  desafía premisas, propone alternativas con esfuerzo estimado. **Conocimiento:** visión de producto y
  negocio del proyecto puntual.
- **Analista funcional**: reglas de negocio, ambigüedades del pedido, edge cases, Definition of Done.
  **Conocimiento:** dominio funcional del producto, lectura de tickets/requerimientos.
- **Analista técnico**: dependencias, impacto en base de datos, arquitectura, contratos de API,
  impacto de infraestructura. **Conocimiento:** el stack real del proyecto (frontend, backend, base de
  datos, integraciones).
- **Orquestador:** consolida ambos análisis en una especificación unificada y la presenta para
  **aprobación humana explícita antes de tocar código** — este es el punto de control más importante
  del pipeline.

### Fase 3 — Planificación técnica
Con la especificación aprobada, se arma el plan de tareas (orden de implementación, dependencias entre
capas — por ejemplo: capa de datos primero, después estado/orquestación, después interfaz).

### Fase 4 — Construcción (acá se escribe código → siempre con supervisión activa)
- **Desarrollador:** implementa el código de producción siguiendo la especificación — funciones
  chicas, tipado estricto donde el lenguaje lo permita, sin "ruido" de IA (comentarios obvios,
  bloques try/catch vacíos). **Conocimiento:** convenciones de código y estilo del proyecto (linter,
  formateo, patrones de arquitectura ya establecidos).
- **Suite de tests:** cobertura de la lógica nueva, simulando fallos y cubriendo los edge cases
  detectados en la fase de refinamiento. **Conocimiento:** el framework de testing del proyecto y sus
  convenciones de mocking.

### Fase 5 — Quality Gate
- **Gate de seguridad** *(condicional: autenticación, datos sensibles, endpoints expuestos,
  dependencias nuevas)*: revisión tipo OWASP Top 10 + modelo de amenazas STRIDE, escaneo de secretos
  (tokens, contraseñas, claves privadas hardcodeadas), verificación de que la configuración esté
  completa en todos los ambientes (desarrollo/staging/producción). Disciplina de "cero ruido": solo
  reporta hallazgos con alta confianza y con un escenario de explotación concreto. Un veredicto
  bloqueante frena el avance. **Conocimiento:** fundamentos de seguridad de aplicaciones, cómo se
  gestionan secretos en el proyecto (variables de entorno, gestor de secretos).
- **Centinela de calidad** (auditor final, no puede tocar el código de producción):
  1. Corre la suite de tests real y exige un test de regresión por cada bug corregido.
  2. Escanea código "sucio" típico de asistentes de IA (comentarios obvios, manejo de errores vacío).
  3. Verifica variables de entorno nuevas declaradas donde corresponda, migraciones de base de datos
     si hubo cambios de esquema, y que se haya actualizado la versión del paquete si aplica.
  4. Actualiza el registro de cambios (changelog) del proyecto.
  5. Documenta en la herramienta de documentación del equipo si el cambio es relevante.
  6. Valida convenciones de control de versiones: rama correcta, mensaje de commit con el formato
     esperado.
  7. Si hay un analizador de calidad de código configurado (tipo SonarQube), corre el análisis sobre
     el diff y rechaza si aparecen issues críticos/bloqueantes.
  Si rechaza, se reasigna la corrección y se vuelve a auditar hasta que apruebe. **Conocimiento:**
  testing del stack del proyecto, reglas de calidad de código vigentes, convenciones de versionado.

### Routing — qué revisiones según el tipo de cambio
No conviene correr todo siempre; el pipeline enruta según qué toca el cambio:

| Tipo de cambio | Roles que se disparan |
|---|---|
| Frontend / interfaz | Revisor de diseño + centinela de calidad |
| Backend / API / lógica | Analista técnico (planificación) + centinela de calidad; si toca autenticación/datos sensibles/dependencias nuevas → sumar oficial de seguridad |
| Base de datos / migraciones | Analista técnico + centinela de calidad, apoyado en el checklist de migraciones |
| Infraestructura / CI-CD | Checklist de infraestructura + centinela de calidad |
| Feature nuevo / cambio de producto | Arranca con el estratega de producto |
| Bug | Debugger (causa raíz) en vez de parche directo |

### Quality gate determinístico
Complementa al auditor de calidad (que es probabilístico): un script corre en el hook de "terminar
tarea" de Devin CLI y **bloquea el primer intento de cerrar**, obligando a re-verificar requerimientos,
limpiar el código y probar de verdad (navegador con capturas, llamadas reales a APIs, o tests); recién
en el segundo intento, con evidencia, deja cerrar.

## 6. Invocar un rol suelto (sin levantar todo el pipeline)

Para pedidos puntuales que no ameritan las 5 fases, alcanza con invocar el subagente correspondiente
directamente:

| Pedido típico | Rol a invocar |
|---|---|
| "auditá la seguridad" | Oficial de seguridad |
| "revisá el diseño/UX" | Revisor de diseño |
| "replanteá este feature" | Estratega de producto |
| "debuggeá este error" | Debugger |
| "revisá la calidad" | Centinela de calidad |
| "analizá el impacto técnico" | Analista técnico |
| "refiná el requerimiento" | Analista funcional |
| "implementá esto" | Desarrollador |

Los roles solo-lectura (analista funcional, analista técnico, estratega de producto, revisor de
diseño, oficial de seguridad, centinela de calidad) pueden correr **en paralelo en segundo plano**,
porque leer/correr tests/escribir su reporte ya está pre-aprobado. El desarrollador (y el debugger
cuando aplica el fix) conviene que corran con supervisión activa, porque escribir código del repo
suele requerir aprobación explícita.

## 7. Para seguir profundizando

Estos conceptos se pueden chequear siempre contra los archivos reales de tu propio harness (una vez
que lo tengas armado):
- El `README.md`/`ONBOARDING.md` del repo del harness — instalación y arquitectura, con el detalle de
  troubleshooting específico de tu red/entorno.
- El `CHANGELOG.md` — para entender *por qué* cada pieza de configuración quedó como quedó.
- Cada `AGENT.md`/`SKILL.md` individual — el prompt completo de cada rol, si necesitás el detalle
  exacto de una misión puntual.