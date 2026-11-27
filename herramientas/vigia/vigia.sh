#!/usr/bin/env bash
# vigia.sh — escucha las líneas de trabajo de los frentes sin gastar contexto, y termina
# (despertando a quien coordina) apenas uno publica su cambio de cierre: un commit cuyo
# asunto empieza con "HANDOFF:" en la punta de su rama. Sólo usa git.
#
# Uso:   vigia.sh [-i SEGUNDOS] [-m MINUTOS] <repo>:<rama> [<repo>:<rama> ...]
#   <repo>  ruta a un clon con remoto "origin" (el repo donde el frente deja su feedback)
#   -i      intervalo entre vueltas (default 90)
#   -m      tope de espera; al vencer sale con "SIN NOVEDAD" (default 110)
#
# Salida (una línea) y código:
#   LISTO <repo> <rama> <sha> <asunto>   0  un frente cerró: integrarlo y relanzar el vigía
#                                           con los que siguen abiertos
#   SIN NOVEDAD ...                      3  venció el tope: revisar que los frentes sigan vivos
#   uso incorrecto                       2
set -u

INTERVALO=90
MAX_MIN=110
while getopts "i:m:" o; do
  case $o in
    i) INTERVALO=$OPTARG ;;
    m) MAX_MIN=$OPTARG ;;
    *) exit 2 ;;
  esac
done
shift $((OPTIND - 1))
if [ $# -lt 1 ]; then
  echo "uso: vigia.sh [-i SEGUNDOS] [-m MINUTOS] <repo>:<rama> [<repo>:<rama> ...]" >&2
  exit 2
fi

pares=("$@")
ultimo=()   # último sha visto por par (arrays indexados: anda con bash 3)
fin=$(( $(date +%s) + MAX_MIN * 60 ))

while :; do
  i=0
  for par in "${pares[@]}"; do
    repo=${par%%:*}
    rama=${par#*:}
    sha=$(git -C "$repo" ls-remote origin "refs/heads/$rama" 2>/dev/null | cut -f1)
    if [ -n "$sha" ] && [ "${ultimo[$i]:-}" != "$sha" ]; then
      ultimo[$i]=$sha
      # Ref propia y sin FETCH_HEAD: no pisa lo que quien coordina esté haciendo en el clon.
      if git -C "$repo" fetch -q --no-write-fetch-head origin "+refs/heads/$rama:refs/vigia/$rama" 2>/dev/null; then
        asunto=$(git -C "$repo" log -1 --format=%s "refs/vigia/$rama")
        case $asunto in
          HANDOFF:*) echo "LISTO $repo $rama $sha $asunto"; exit 0 ;;
        esac
      fi
    fi
    i=$((i + 1))
  done
  if [ "$(date +%s)" -ge "$fin" ]; then
    echo "SIN NOVEDAD tras $MAX_MIN min: revisar que los frentes sigan vivos (${pares[*]})"
    exit 3
  fi
  sleep "$INTERVALO"
done
