# Contribuir

Este repo termina como instrucciones dentro del contexto de agentes que escriben código, hacen
push y corren SQL en otros proyectos. Un cambio acá cambia lo que hacen todos ellos.

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
