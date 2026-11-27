# Trabajar sobre este repositorio

Este repo **es** el harness: una base de conocimiento de ingeniería, en Markdown, sin
código y sin dependencias. Estas son las reglas para modificarlo. Aplican a cualquier
agente o persona que edite estos archivos.

Cuando trabajás en **otro** repo, este archivo no se lee. El punto de entrada es
`dev-workflow.md`.

---

## Estructura y dónde va cada cosa

| Archivo | Qué tipo de conocimiento acepta |
|---|---|
| `dev-workflow.md` | Invariantes transversales y routing. Nada técnico. |
| `skills/<nombre>/SKILL.md` | El "cómo" de una responsabilidad concreta del trabajo diario, en formato Agent Skills (`name` y `description` arriba). |
| `templates/project-profile.md` | Sólo la plantilla de hechos locales de un proyecto. |
| `templates/product/` | Sólo la plantilla del contexto de producto (`.product/`) de un proyecto. |
| `templates/claude-hook/` | El hook que lleva el harness a las sesiones en la nube de Claude Code. |
| `.claude-plugin/`, `hooks/` | Empaquetado como plugin. No llevan reglas. |
| `herramientas/<nombre>/` | Ayudas ejecutables opcionales para aplicar una regla (por ejemplo, el vigía de `parallelize`). No llevan reglas: la regla vive en su skill. |
| `SECURITY.md` | Cómo reportar una regla insegura. |
| `README.md` | Documentación para humanos. Ningún agente la necesita para trabajar. |
| `CONTRIBUTING.md`, `.github/CODEOWNERS` | Cómo se contribuye y quién revisa. No llevan reglas. |
| `CHANGELOG.md` | Qué se cambió del harness, por qué y de dónde salió, más las "piedras" a no repetir. |
| `referencias/` | Papers y documentos que motivaron cambios. Nadie los carga para trabajar. |

Antes de escribir algo, respondé: ¿esto vale en toda tarea, o sólo cuando estoy ejecutando
una responsabilidad puntual? La primera va en `dev-workflow.md`; la segunda, en su
documento.

---

## Reglas de diseño

**Una regla existe en un solo lugar.** Si una regla de testing aparece en `implement.md`,
está mal: se borra de ahí y se referencia por nombre. La duplicación es el único defecto
que degrada este harness de forma irreversible.

**`dev-workflow.md` tiene presupuesto: 150 líneas.** Es el único archivo que se carga
siempre. Si crece, todo el harness se vuelve más caro. Cuando se acerque al tope, el
contenido sobrante se mueve a una responsabilidad, no se comprime.

**Cada responsabilidad declara su borde.** Toda skill de `skills/` termina
con una sección "Fuera de alcance" que nombra qué responsabilidades cubren lo que él no
cubre. Es lo que mantiene los límites visibles.

**Criterios, no checklists.** Se escribe lo que cambia una decisión. Una regla que un
agente competente ya iba a cumplir es ruido y hace más caro leer las que sí importan.

**Las reglas vencen.** Cada una es una apuesta sobre algo que los agentes hacían mal cuando
se escribió. Cuando cambian los agentes que usan el harness, se repasa todo con la misma
pregunta: si esta regla no estuviera, ¿un agente actual haría algo distinto? Si no, se
borra. Una regla que nadie poda sólo suma costo de lectura.

**Nada específico de un stack, herramienta o proveedor.** Ni lenguajes, ni frameworks, ni
plataformas de CI, ni analizadores de calidad, ni servicios de hosting. Todo lo que varíe
entre proyectos va en la plantilla de perfil, no acá.

**Nada que dependa de ejecutar algo.** El harness funciona leyendo documentación. El
empaquetado (`.claude-plugin/`, `hooks/`, `templates/claude-hook/`) sólo hace llegar los
archivos y cargar `dev-workflow.md`; ninguna regla depende de él, y sin él todo se lee por ruta.
Lo mismo vale para `herramientas/`: ayudan a cumplir una regla, pero la regla se entiende y se
puede cumplir sin ellas.

**Independiente del proveedor de IA.** El texto de las reglas no menciona herramientas,
comandos ni nombres de agentes concretos. Las skills siguen el formato abierto Agent Skills;
el plugin es un envoltorio para quien usa Claude Code.

---

## Agregar una responsabilidad nueva

Se justifica cuando hay un tipo de trabajo recurrente cuyo criterio **no** entra en
ninguna responsabilidad existente sin desdibujarla. "Sería lindo tenerlo" no alcanza.

El procedimiento no toca lo que ya está:

1. Crear `skills/<verbo>/SKILL.md`, con `name` y una `description` que diga qué hace y cuándo
   se usa. El nombre es lo que el agente **hace**, no un área
   temática — un sustantivo temático atrae conocimiento de stack.
2. Agregar una fila a la tabla de routing de `dev-workflow.md`.
3. Agregar la sección "Fuera de alcance" del documento nuevo, y revisar si alguna
   responsabilidad existente debe nombrarlo en la suya.
4. Verificar que no se duplicó nada: lo que el documento nuevo cubre, se borra de donde
   estuviera.

Modificar documentos existentes al agregar uno nuevo sólo es válido para **quitar**
contenido que se mudó, o para nombrar el borde nuevo.

---

## Al terminar un cambio acá

Releé el diff buscando duplicación y contenido específico de stack. Confirmá que
`dev-workflow.md` sigue dentro de presupuesto. Subí la versión en `.claude-plugin/plugin.json`
(SemVer: mayor si una regla cambia de sentido o se borra, menor si se agrega una, parche si
es redacción) y anotá el cambio en `CHANGELOG.md`, bajo esa versión, con su
motivo y su fuente; si salió de un paper, el PDF va a `referencias/`. No hay lint, build
ni tests que correr: la verificación de este repo es esa lectura.
