// SessionStart de Claude Code: en la nube, el harness no llega como plugin (las sesiones
// en la nube no instalan plugins del repo). Este hook lo clona al lado del repo y carga
// dev-workflow.md como contexto, y activa el commit-msg de herramientas/git-hooks (la regla de autoría de
// skills/commit) en el core.hooksPath global del contenedor, si no hay uno. En una máquina local no hace
// nada: ahí lo carga el plugin.
// Si algo falla, sale sin error: el AGENTS.md del repo dice cómo seguir sin harness.
import { existsSync, readFileSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { join, resolve } from 'node:path';

if (process.env.CLAUDE_CODE_REMOTE !== 'true') process.exit(0);
const dir = resolve(process.env.CLAUDE_PROJECT_DIR || process.cwd(), '..', 'kaizen-harness');
try {
  if (!existsSync(join(dir, 'dev-workflow.md'))) {
    execFileSync('git', ['clone', '--quiet', '--depth', '1', 'https://github.com/nikosanarg/kaizen-harness', dir], { stdio: 'ignore', timeout: 60_000 });
  }
  try {
    const hooks = join(dir, 'herramientas', 'git-hooks');
    let current = '';
    try { current = execFileSync('git', ['config', '--global', '--get', 'core.hooksPath'], { encoding: 'utf8' }).trim(); } catch { /* sin valor */ }
    if (!current && existsSync(join(hooks, 'commit-msg'))) execFileSync('git', ['config', '--global', 'core.hooksPath', hooks], { stdio: 'ignore' });
  } catch { /* sin el hook, la regla sigue en skills/commit */ }
  process.stdout.write(readFileSync(join(dir, 'dev-workflow.md'), 'utf8'));
} catch {
  process.exit(0);
}
