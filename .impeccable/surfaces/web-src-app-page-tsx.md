---
version: 1
slug: "web-src-app-page-tsx"
primary_target: "web/src/app/page.tsx"
related_targets: ["web/src/app/layout.tsx"]
---

# Surface: Inicio (entrevistas + partidos + tabla)

Scope: `web/src/app/page.tsx` y el marco común (layout, menú) que heredan todas las secciones.
Mode: read (las entrevistas mandan); el bloque de partidos/tabla es operate dentro del mismo marco.
Audience/job: hincha de River que entra a leer la última entrevista y a ver cuándo juega River y cómo está la tabla de la copa que elija.
Constraints: banda roja diagonal sobre blanco (fijada por el usuario); sin escudo oficial; todo contenido de ejemplo marcado como tal.

## Direction contract

THESIS: El sitio es una boleta de prode impresa en blanco y cruzada por la banda: filas numeradas, casilleros que se marcan, sellos. Rechaza el portal deportivo genérico de tarjetas con foto y la "app de apuestas" oscura.

OWN-WORLD: Fondo blanco papel frío, tinta casi negra, un solo rojo River que ocupa franjas enteras (la banda diagonal del masthead y los separadores de sección). Archivo en ancho comprimido y peso negro para títulos y números, Archivo normal para la interfaz, Source Serif 4 para el texto de las entrevistas. Reglas de 1px, sin radios, casilleros cuadrados como controles (filtros, L/E/V), números tabulares.

STORY: El visitante ve primero la entrevista destacada, entiende de un vistazo cuándo es el próximo partido, filtra por copa y la tabla cambia con él; la boleta del prode le pide que inicie sesión para marcar.

FIRST VIEWPORT: Masthead blanco con el wordmark EL MÁS GRANDE en Archivo negro comprimido y la banda roja diagonal detrás, bajando de arriba-izquierda a abajo-derecha como se ve la banda de la camiseta de frente; entra cortando de izquierda a derecha al cargar. Botón Menú (desplegable) a la izquierda, Ingresar o el usuario a la derecha. Debajo, a dos columnas en desktop: izquierda la entrevista destacada (título grande, bajada en serif, firma, leer); derecha "Próximo partido" como renglón de boleta (día grande, rival, copa, estadio, hora en casillero) bajo una franja roja, con el prode como acción. En celular, apilado: masthead, próximo partido, entrevista.

FORM: Boleta de prode / fixture de kiosco, candidato 7 de 7 de mi lista (asignado), traducido al mundo blanco y rojo fijado por el usuario. seed:603d99160eabab78
- Raise from design-canon-swiss-grid-poster-wall (competitive): una sola grilla maestra gobierna todas las páginas; los tamaños de tipo escalan en unidades de la grilla.
- Raise from exhibition-museum-curation-provenance-ribbon (declined): lo confirmado y lo provisorio se distinguen siempre (horario "a confirmar" en trazo fino, confirmado en sólido).
- Raise from operate-a-cutting-bench-select-rail (declined): el estado es una marca, no un color (casillero tildado, fila tachada para partido jugado, sello para pronóstico cargado).
- Raise from rw-centre-rail-reference-setting (declined): sin radios en ningún lado; todas las reglas a 1px.

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
