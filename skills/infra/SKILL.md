---
name: infra
description: "Cambiar cómo el sistema se construye, configura o despliega: configuración, secretos, CI, despliegue. Usar en cambios de infraestructura, antes de implement."
---

# Infra

Cómo se cambia la forma en que el sistema se construye, configura y despliega.

Se carga cuando el cambio toca eso. La diferencia con un cambio común: el efecto se ve en
el entorno donde corre, no en la aplicación, y suele descubrirse tarde.

Corto a propósito: no asume plataforma, proveedor ni herramienta de despliegue.

---

## Reproducibilidad

El entorno se define en archivos versionados, no en el estado de una máquina. Lo que hoy
se ejecuta a mano para que funcione se automatiza o se escribe donde el proyecto documenta
su operación.

Fijá las versiones de lo que instalás. Una construcción que mañana da otro resultado sin
que nadie cambiara nada es un defecto.

---

## Configuración y secretos

Lo que cambia entre ambientes se inyecta desde afuera: ni en la imagen, ni en el
manifiesto, ni en el código.

Ningún secreto se versiona, en ninguna forma, ni de ejemplo con valor real. Se usan los
placeholders y el mecanismo del proyecto.

Una variable nueva se declara en **todos** los ambientes que el proyecto define. Una que
existe sólo en desarrollo es una falla de producción diferida.

---

## Paridad entre ambientes

Los ambientes difieren sólo en configuración. Una diferencia estructural —otra versión de
una dependencia, otro camino de arranque— es riesgo, y se declara.

---

## Cambios que no se revierten solos

Un cambio de infraestructura puede afectar un sistema vivo antes de que nadie lo revise.
Borrar recursos, cambiar permisos, alterar red o tocar almacenamiento persistente se
identifica como riesgoso y se plantea, no se ejecuta por iniciativa propia.

Antes de cerrar, tiene que quedar claro cómo se vuelve atrás.

---

## Verificación

Se verifica construyendo y levantando lo tocado, no leyendo el archivo. Si el perfil
declara cómo, se sigue; si no, se pregunta antes de tocar un ambiente compartido.

---

## Fuera de alcance

Acá no hay conocimiento de proveedores, orquestadores ni plataformas de CI, ni se asume un
pipeline. Si aplica, está en el perfil.
