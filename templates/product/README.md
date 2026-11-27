# .product — contexto de producto

Plantilla. Se copia a la raíz del repo donde vive el roadmap del producto (si el producto
son varios repos, en uno solo, y los demás lo apuntan desde su `AGENTS.md`).

Guarda lo que una sesión necesita saber **antes de contestar o trabajar** y que no está en
el código: el estado, lo que decidió el dueño del producto y cómo se trabaja. Vive en el
repo, versionado, para que lo lean igual una sesión local, una en la nube o un chat
conectado al repositorio. Si el repo es público, se evalúa qué decisiones pueden quedar a la
vista.

## Archivos

| Archivo | Qué tiene | Qué no tiene |
|---|---|---|
| `README.md` | Este índice: orden de lectura y cómo se mantiene | — |
| `estado.md` | Versiones publicadas, versión abierta, trabajo en curso, ramas por integrar, preguntas abiertas al dueño del producto | El detalle de lo hecho (changelog) |
| `decisiones.md` | Decisiones de producto vigentes, con fecha; lo rechazado | Reglas técnicas (`AGENTS.md`, `project-profile.md`) |
| `orquestacion.md` | El método de trabajo propio del proyecto que no está en `project-profile.md` § Entrega (roles, sesiones, quién integra) | Comandos y flujo de entrega |
| `charlas/` | Una idea en discusión por archivo: contexto, lo decidido, lo abierto | Lo ya priorizado (roadmap) |

## Reglas

- Orden de lectura: `estado.md` siempre; `decisiones.md` antes de proponer algo visible;
  `orquestacion.md` antes de delegar o integrar; la charla que toque.
- Lo actualiza quien integra, en el mismo cambio. Los frentes en paralelo no lo editan:
  dejan en su reporte lo que cambiaría (se pisarían).
- Una decisión superada se reemplaza, no se apila.
- Una charla que se vuelve trabajo pasa al roadmap y sale de `charlas/`.
- Nada de secretos: se nombran por su variable.
