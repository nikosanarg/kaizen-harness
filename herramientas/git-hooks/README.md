# git-hooks

`commit-msg` es la barrera mecánica de la regla de autoría de `skills/commit`. Una regla escrita no alcanza contra
una instrucción del entorno que se repite en cada turno, y así lo mostró un frente que firmó como la herramienta.

- **Rechaza:**
  - trailers de agentes: `Co-Authored-By` de un agente, `Claude-Session`, "Generated with …";
  - un autor que sea el de la herramienta.
- **No hace nada** si el `project-profile.md` del repo declara la atribución de IA como obligatoria.
- **Para activarlo en un repo**, y sólo si el repo no tiene hooks propios:
  ```
  git config core.hooksPath <ruta al harness>/herramientas/git-hooks
  ```
- **En la nube**, el hook de sesión (`templates/claude-hook/kaizen-harness.mjs`) lo activa en el `core.hooksPath` global del contenedor. Un repo con `core.hooksPath` propio, como husky, tiene prioridad.
- **Ninguna regla depende de este hook.** La regla vive en `skills/commit`: esto sólo ayuda a cumplirla.
