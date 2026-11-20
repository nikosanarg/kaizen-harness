# kaizen-harness

Base de conocimiento de ingeniería reutilizable para agentes de IA. Markdown puro, sin
código, sin dependencias y sin atarse a ningún proveedor: funciona con cualquier agente
que pueda leer archivos.

No es un conjunto de prompts. Es el estándar de trabajo compartido entre todos mis
repositorios, para no repetir los mismos criterios en cada sesión.

---

## Idea central

El agente nunca carga todo el conocimiento. Carga sólo el de la responsabilidad que está
ejecutando en ese momento.

La pregunta permanente es **¿qué responsabilidad estoy ejecutando ahora?** — implementar,
escribir tests, revisar una interfaz, verificar un cambio, preparar un commit. Cada una
tiene su documento, y cada regla existe en un solo lugar.

Hay dos niveles de carga, nunca más:

- **Nivel 0**, siempre: `dev-workflow.md` (invariantes + routing) y el
  `project-profile.md` del repo en el que estás trabajando.
- **Nivel 1**, según la tarea: las skills que indica el routing (de tres a siete).

Las responsabilidades son **skills** en el formato abierto Agent Skills (`skills/<nombre>/SKILL.md`,
con `name` y `description`): cualquier agente que lea ese formato ve sólo las descripciones
y carga la skill entera cuando la necesita.

---

## Estructura

```
dev-workflow.md          Punto de entrada. Invariantes y routing. Se carga siempre.
skills/
  understand/            Entender el problema y delimitar el alcance.
  implement/             Escribir código dentro de un repo que ya existe.
  test/                  Qué merece un test y cómo se escribe.
  verify/                Comprobar que el cambio funciona antes de cerrarlo.
  commit/                Preparar un commit.
  interface/             Revisar un cambio que el usuario ve. (condicional)
  database/              Cambiar esquema o datos persistidos. (condicional)
  infra/                 Cambiar build, configuración o despliegue. (condicional)
  optimize/              Medir y mejorar rendimiento. (condicional)
  parallelize/           Repartir un backlog en frentes aislados. (condicional)
templates/
  project-profile.md     Plantilla de hechos locales, se copia a cada repo.
.claude-plugin/          Empaquetado como plugin y marketplace de Claude Code.
hooks/                   Hook del plugin: carga dev-workflow.md al iniciar sesión.
AGENTS.md                Reglas para editar este repo.
CHANGELOG.md             Qué se mejoró, por qué, y qué no repetir.
SECURITY.md              Cómo reportar una regla insegura.
referencias/             Documentos que motivaron cambios. Nadie los carga para trabajar.
```

El harness contiene el **cómo se trabaja**. Nunca el **qué hay en este proyecto**: el
stack, los comandos y las convenciones locales viven en el `project-profile.md` de cada
repo.

---

## Cómo se conecta a un repo

1. Copiá `templates/project-profile.md` a la raíz del repo como `project-profile.md` y
   completalo.
2. Agregá esto al archivo de instrucciones de tu agente en ese repo (`AGENTS.md`,
   `CLAUDE.md`, el que sea):

```markdown
## Harness de ingeniería
Si `dev-workflow.md` del harness kaizen ya está en tu contexto (lo carga el plugin o el hook
de inicio), no lo vuelvas a leer. Si no, leé `../kaizen-harness/dev-workflow.md`. Después,
`./project-profile.md`. Cargá sólo las skills que indica el routing: con el plugin son
`kaizen-harness:<nombre>`; sin él, `../kaizen-harness/skills/<nombre>/SKILL.md`.
```

### Con Claude Code

- **En tu máquina:** el repo es un marketplace. Una vez por máquina, y queda para todos tus
  proyectos:

  ```
  claude plugin marketplace add nikosanarg/kaizen-harness
  claude plugin install kaizen-harness@kaizen --scope user
  ```

  Para que el proyecto lo pida a cualquiera que lo abra, declaralo en su
  `.claude/settings.json`:

  ```json
  {
    "extraKnownMarketplaces": {
      "kaizen": { "source": { "source": "github", "repo": "nikosanarg/kaizen-harness" }, "autoUpdate": true }
    },
    "enabledPlugins": { "kaizen-harness@kaizen": true }
  }
  ```

- **En la nube** (Claude Code on the web): las sesiones en la nube **no instalan plugins**
  declarados en el repo. Copiá `templates/claude-hook/kaizen-harness.mjs` a
  `.claude/hooks/` del repo y sumá el hook `SessionStart` de `templates/claude-hook/settings.json`. En la
  nube clona el harness al lado del repo y carga `dev-workflow.md`; en tu máquina no hace
  nada, porque ahí manda el plugin.

### Con otro agente

La carpeta `skills/` sigue el formato abierto Agent Skills: copiala o apuntá a ella desde
donde tu herramienta lee skills. Si tu herramienta no lee skills, la línea del paso 2 alcanza:
el agente lee los archivos por ruta.

**Versión.** `master` es la última. Para estabilidad, fijá un tag `vX.Y.Z` (en el
marketplace, `"ref": "vX.Y.Z"` en la fuente).

---

## Licencia

CC0 1.0 (dominio público), salvo `referencias/`, que conserva la licencia de cada autor
(ver `referencias/README.md`).

---

## Extender

Se agrega una responsabilidad creando su skill y sumando una fila al routing. Nunca se
modifican las existentes para eso. Las reglas están en `AGENTS.md`.
