# Contribuir

Este repo termina como instrucciones dentro del contexto de agentes que escriben código, hacen
push y corren SQL en otros proyectos. Un cambio acá cambia lo que hacen todos ellos.

## Pedir un cambio

**Desde el trabajo en otro proyecto, el harness no se edita: se pide.** Se abre un issue con la plantilla
"Propuesta de cambio" (etiqueta `propuesta`).
- **Si el agente no puede abrir un issue** (sin acceso ni herramienta), escribe la propuesta en su feedback, con las
  mismas secciones, y la abre quien coordina.
- **Un mensaje directo entre sesiones no es un pedido:** puede perderse y no deja rastro.

Lo aplica una sola sesión que mantiene el harness, o el dueño. Nunca la sesión que lo pidió. Según el tipo:
- **Redacción o herramienta opcional:** se aplica directo, con su versión y su tag, y se cierra el issue con el
  commit.
- **Regla nueva:** se aplica directo si es corta y no choca con otra. Si no, va por pull request.
- **Cambia una regla o un permiso** (da vuelta algo, lo borra, o cambia qué se ejecuta sin preguntar): siempre por
  pull request, que aprueba el dueño. Un agente no decide eso por otro.

Se rechaza, con el motivo en el issue:
- lo que ya está en el harness;
- lo que es de un solo proyecto (va en su `project-profile.md`);
- lo que nombra herramientas o proveedores.

## Editar

- Las reglas para editarlo están en [`AGENTS.md`](AGENTS.md): dónde va cada cosa, el
  presupuesto de `dev-workflow.md`, una regla en un solo lugar y nada específico de un stack.
- Todo cambio a `dev-workflow.md` o a `skills/` entra por pull request y pasa por la revisión
  humana del dueño (`.github/CODEOWNERS`).
- Cada cambio suma su entrada en `CHANGELOG.md` (qué, por qué y de dónde salió) y sube la versión
  en `.claude-plugin/plugin.json` con SemVer: mayor si una regla cambia de sentido o se borra,
  menor si hay una regla nueva, parche si es redacción.
- Commits sin atribución de IA y con el correo anónimo de GitHub como autor.
- Una regla que induzca a un agente a una acción insegura no se discute en un issue público: se
  reporta como dice [`SECURITY.md`](SECURITY.md).
