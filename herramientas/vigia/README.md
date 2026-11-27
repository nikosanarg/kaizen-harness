# vigia

Escucha las líneas de trabajo de los frentes sin consumir contexto. Termina apenas un frente
publica su cambio de cierre, es decir, cuando la punta de su rama es un commit con asunto
`HANDOFF: ...`. Que el proceso termine es lo que despierta a quien coordina. La regla que
aplica está en `skills/parallelize` ("Esperar no es trabajo").

```bash
vigia.sh [-i SEGUNDOS] [-m MINUTOS] <repo>:<rama> [<repo>:<rama> ...]
```

- `<repo>` es un clon con remoto `origin`: el repositorio donde el frente deja su feedback.
- `-i` es el intervalo entre vueltas. Por defecto, 90 segundos.
- `-m` es el tope de espera. Por defecto, 110 minutos.

Lo que imprime al terminar, con su código de salida:

| Código | Salida | Qué sigue |
|---|---|---|
| 0 | `LISTO <repo> <rama> <sha> <asunto>` | Leer el feedback, integrar ese frente y relanzar el vigía con los que siguen abiertos. |
| 3 | `SIN NOVEDAD ...` | Venció el tope. Mirar si los frentes siguen vivos y relanzarlo. |
| 2 | — | Uso incorrecto. |

En cada vuelta usa `git ls-remote`. Sólo hace un fetch cuando la punta de una rama cambió. Ese
fetch va a `refs/vigia/<rama>`, sin escribir `FETCH_HEAD`, así que no pisa lo que quien
coordina esté haciendo en el mismo clon. Funciona con bash 3, el de macOS.

## Con Claude Code

- **Dónde está el script.** En una sesión en la nube, el hook del harness lo clona al lado del
  repo, en `../kaizen-harness/herramientas/vigia/vigia.sh`. Con el plugin instalado, está en
  `$CLAUDE_PLUGIN_ROOT/herramientas/vigia/vigia.sh`.
- **Cómo se corre.** Con Bash en segundo plano y un timeout mayor que `-m`. La notificación de
  que la tarea terminó es lo que despierta a la sesión. No se usan recordatorios programados.
- **Cómo se lanza cada frente.** Como una sesión en la nube propia:
  - se parte del punto común validado, con `source_revision`;
  - la rama de salida, `outcome_branch`, es `frente/<tema>`;
  - el encargo pide cerrar con `HANDOFF: <tema>`, un commit que agrega sólo
    `.handoff/<tema>.md`.
