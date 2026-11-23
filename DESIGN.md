---
name: El más grande
description: El sitio de los hinchas de River, impreso como una boleta de prode blanca cruzada por la banda roja.
colors:
  paper: "#ffffff"
  sheet: "#f2f3f4"
  ink: "#111214"
  ink-2: "#4a4e54"
  rule: "#111214"
  rule-soft: "#d3d6da"
  red: "#d2102a"
  red-deep: "#a50c20"
  on-red: "#ffffff"
typography:
  display:
    fontFamily: "Archivo, system-ui, sans-serif"
    fontSize: "clamp(48px, 8.5vw, 96px)"
    fontWeight: 900
    lineHeight: 0.92
    letterSpacing: "-0.01em"
    fontVariation: "'wdth' 62"
  headline:
    fontFamily: "Archivo, system-ui, sans-serif"
    fontSize: "clamp(36px, 5vw, 56px)"
    fontWeight: 800
    lineHeight: 1
    fontVariation: "'wdth' 75"
  title:
    fontFamily: "Archivo, system-ui, sans-serif"
    fontSize: "24px"
    fontWeight: 800
    lineHeight: 1.2
  body:
    fontFamily: "Archivo, system-ui, sans-serif"
    fontSize: "17px"
    fontWeight: 400
    lineHeight: 1.5
  reading:
    fontFamily: "Source Serif 4, Georgia, serif"
    fontSize: "19px"
    fontWeight: 400
    lineHeight: 1.65
  label:
    fontFamily: "Archivo, system-ui, sans-serif"
    fontSize: "13px"
    fontWeight: 700
    letterSpacing: "0.04em"
  numeral:
    fontFamily: "Archivo, system-ui, sans-serif"
    fontSize: "40px"
    fontWeight: 900
    lineHeight: 0.95
    fontFeature: "'tnum'"
    fontVariation: "'wdth' 62"
rounded:
  none: "0px"
spacing:
  u-half: "4px"
  u: "8px"
  u-1-5: "12px"
  u-2: "16px"
  u-2-5: "20px"
  u-3: "24px"
  u-4: "32px"
  u-6: "48px"
  u-8: "64px"
  band: "10px"
  gutter: "clamp(16px, 4vw, 48px)"
  max: "1280px"
components:
  button:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    typography: "{typography.label}"
    rounded: "{rounded.none}"
    padding: "0 16px"
    height: "44px"
  button-hover:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.paper}"
  button-red:
    backgroundColor: "{colors.red}"
    textColor: "{colors.on-red}"
    rounded: "{rounded.none}"
    padding: "0 16px"
    height: "44px"
  button-red-hover:
    backgroundColor: "{colors.red-deep}"
    textColor: "{colors.on-red}"
  button-disabled:
    backgroundColor: "{colors.sheet}"
    textColor: "{colors.ink-2}"
  input-field:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    typography: "{typography.body}"
    rounded: "{rounded.none}"
    padding: "0 12px"
    height: "48px"
  goal-box:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    rounded: "{rounded.none}"
    size: "48px"
  check-box:
    backgroundColor: "{colors.paper}"
    rounded: "{rounded.none}"
    size: "20px"
  check-box-on:
    backgroundColor: "{colors.red}"
    textColor: "{colors.on-red}"
    size: "20px"
  filter:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    rounded: "{rounded.none}"
    padding: "0 12px 0 8px"
    height: "40px"
  time-confirmed:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    padding: "1px 6px"
  time-provisional:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink-2}"
    padding: "1px 6px"
  stamp:
    textColor: "{colors.red}"
    padding: "4px 10px"
  gate:
    backgroundColor: "{colors.sheet}"
    textColor: "{colors.ink}"
    padding: "24px"
---

# Design System: El más grande

## Overview

**Creative North Star: "La boleta de prode cruzada por la banda"**

El producto entero se imprime como una boleta de prode o un fixture de kiosco: papel blanco frío, tinta casi negra, filas numeradas separadas por reglas finas, casilleros cuadrados que se tildan y sellos que certifican. Sobre ese papel pasa un solo rojo, el de River, que nunca decora: ocupa franjas enteras. La banda diagonal del encabezado baja de arriba a la izquierda hacia abajo a la derecha, como la banda de la camiseta vista de frente, y la misma franja (10px) vuelve como separador de cada sección y del pie.

La densidad es la de un impreso deportivo: mucha información tabular, alineada a una grilla de 8px, sin tarjetas con foto, sin fondos oscuros, sin brillos. La jerarquía la dan el ancho y el peso de Archivo (comprimido y negro para títulos y números, normal para la interfaz) y la Source Serif 4 para lo que se lee con calma. El estado se expresa con una marca y no con un color: un casillero tildado, una fecha tachada, un sello, un trazo sólido o punteado.

Este sistema es compartido: la app móvil del mismo producto reutiliza estos tokens, la banda, las filas de boleta, los casilleros cuadrados, los sellos y la distinción sólido/punteado entre lo confirmado y lo provisorio.

**Key Characteristics:**
- Blanco papel, tinta casi negra y un solo rojo usado en franjas enteras.
- Banda diagonal en el encabezado; franja roja de 10px como separador de sección.
- Filas de boleta con número grande comprimido a la izquierda y reglas de 1px.
- Cero radios: botones, campos, casilleros y paneles son rectángulos.
- Estado como marca: tilde, tachado, sello, trazo sólido vs. punteado.
- Números tabulares en todo lo que se compara (fechas, goles, tablas, horarios).

## Colors

Papel blanco frío con tinta casi negra y un único acento rojo River que aparece en bloques sólidos, no en matices.

### Primary
- **Rojo Banda** (`red`): la banda diagonal del encabezado, las franjas separadoras de sección, la acción principal de cada pantalla, el casillero marcado, el sello, el nombre de River dentro de un partido, la fila de River en la tabla de posiciones, el anillo de foco y la selección de texto.
- **Rojo Banda Hondo** (`red-deep`): hover de la acción roja y texto de mensajes de error (más contraste que el rojo sobre blanco).
- **Blanco sobre Rojo** (`on-red`): texto e íconos sobre cualquier superficie roja.

### Neutral
- **Papel** (`paper`): fondo de toda la interfaz y de los controles en reposo.
- **Hoja Gris** (`sheet`): superficies apagadas: controles deshabilitados, hover de ítems del menú y el recuadro que pide iniciar sesión.
- **Tinta** (`ink`): texto principal, bordes de controles y el fondo del botón en hover o abierto.
- **Tinta Media** (`ink-2`): metadatos, fechas, ayudas, notas, cabeceras de tabla y el trazo punteado de lo provisorio.
- **Regla** (`rule`): reglas de 1px que abren y cierran bloques (borde inferior del encabezado, tope de las listas, cabeceras de tabla).
- **Regla Suave** (`rule-soft`): separadores de 1px entre filas dentro de una lista o tabla.

### Named Rules
**The Una Sola Tinta de Color Rule.** El rojo es el único color del sistema. No se agregan verdes de "éxito", amarillos de alerta ni azules de enlace: el éxito es un sello rojo, el error es rojo hondo, el enlace se subraya.

**The Franja Entera Rule.** El rojo aparece como bloque sólido (banda, franja, botón, casillero lleno, fila de tabla) o como texto de nombre propio de River. Nunca como degradé, tinte, transparencia o sombra de color.

## Typography

**Display Font:** Archivo variable, eje `wdth` (con system-ui, sans-serif)
**Body Font:** Archivo variable al 100% de ancho (con system-ui, sans-serif)
**Reading Font:** Source Serif 4 (con Georgia, serif)

**Character:** Archivo comprimido y negro hace de encabezado de boleta y de cifra de fixture; a ancho normal es la tipografía funcional de la interfaz. La serif aparece sólo donde hay que leer de corrido (bajadas y respuestas de entrevistas, textos de Info de River), para que la lectura se distinga del dato.

### Hierarchy
- **Display** (900, ancho 62%, `clamp(48px, 8.5vw, 96px)`, interlínea 0.92, mayúsculas): el wordmark EL MÁS GRANDE y el título de cada página. En el encabezado compacto el wordmark baja a `clamp(40px, 6vw, 64px)`.
- **Headline** (800, ancho 75%, `clamp(36px, 5vw, 56px)`, interlínea 1, mayúsculas): títulos de sección sobre la franja roja, título de la entrevista destacada y de la entrevista abierta. Bloques secundarios usan el mismo estilo a 32px o 24px ("Próximo partido", equipos del próximo partido).
- **Title** (800, 24px, interlínea 1.2, caja normal, ancho 100%): títulos de entrevistas en lista, de beneficios, del recuadro de ingreso, datos destacados.
- **Body** (400, 17px, interlínea 1.5): interfaz general. Equipos en fila a 20px/700; metadatos a 15px en tinta media.
- **Reading** (400, 19px, interlínea 1.65, máx. 68ch): respuestas de entrevistas. Bajadas a 20–24px con interlínea 1.45–1.5; textos de Info de River a 18px. Lista de entrevistas: bajada serif a 17px, máx. 70ch.
- **Label** (700, 13–15px, tracking 0.02–0.04em, mayúsculas): botones (15px), meses y días bajo el número de fecha, cabeceras de tabla, términos de datos. Es etiqueta de dato o de control, nunca un rótulo sobre un título.
- **Numeral** (900, ancho 62%, tabular): el día en las filas (40px, 34px en celular; 80px en el próximo partido), resultados (32px), goles del prode (32px), siglas de equipos, cifras de puntos.

### Named Rules
**The Ancho Manda Rule.** La jerarquía se arma con el eje de ancho de Archivo: 62% para display y cifras, 75% para encabezados, 100% para interfaz. No se cambia de familia para jerarquizar.

**The Cifra Tabular Rule.** Todo número que se compara con otro (fechas, goles, horarios, columnas de tabla, puntos) va con `tabular-nums`.

**The Serif Es Lectura Rule.** Source Serif 4 sólo para texto de lectura corrida. Nunca en botones, etiquetas, tablas ni títulos.

## Layout

Una sola grilla maestra en unidades de 8px (`--u`) gobierna todas las páginas; todo margen, relleno y separación es un múltiplo de 8px o de media unidad (4px, 12px, 20px). El contenedor mide hasta 1280px más un margen lateral fluido de `clamp(16px, 4vw, 48px)`.

- **Dos columnas 7/5** en desktop para portada (entrevista destacada + próximo partido), centro de partidos (fixture + tabla) y prode (boletas + ranking), con separación de 48px. Por debajo de 960px se apilan con 32px de separación; en la portada el próximo partido pasa arriba de la entrevista.
- **Columna de lectura** centrada de 68ch para la entrevista; formularios de ingreso en una columna central de 440px.
- **Secciones** con 48px de aire vertical (32px en celular); una sección seguida de otra no duplica el aire superior.
- **Filas de boleta**: columna fija para la fecha (76px, 56px en celular), columna flexible para el partido y una columna al final para hora o resultado; en celular esa última baja debajo del partido.
- **Grillas de datos**: datos de River a 4 columnas (2 en tablet), equipos a 3 columnas (2 en tablet, 1 en celular).
- Breakpoints observados: 960px y 640px. Controles con altura mínima de 44px (campos y pestañas 48px).

**The Grilla Única Rule.** Ningún valor de espaciado fuera de la escala de 8px; si un bloque necesita aire, se suma una unidad, no un valor suelto.

## Elevation & Depth

El sistema es plano: la profundidad se expresa con reglas de 1px y con el cambio a Hoja Gris, no con sombras. La única sombra del sistema pertenece a lo que flota sobre el contenido, el panel desplegable del menú, y es ambiental y hacia abajo para despegarlo del papel.

### Shadow Vocabulary
- **Panel flotante** (`box-shadow: 0 12px 32px -12px rgb(17 18 20 / 0.35)`): sólo en paneles que se abren sobre el contenido (menú desplegable).

### Named Rules
**The Papel Plano Rule.** Nada en reposo tiene sombra. Filas, tarjetas de equipo, recuadros y botones son planos; se separan con reglas o con Hoja Gris.

## Shapes

Rectángulos puros: radio 0 en todo (botones, campos, casilleros, filtros, pestañas, paneles, códigos de descuento). Las reglas de estructura son de 1px; las excepciones son marcas de estado, no estructura: el sello lleva borde de 2px, el campo inválido sube a 2px rojo, la fecha de un partido jugado se tacha con 3px rojo. La franja de sección mide 10px (`--band`). La única forma oblicua es la banda diagonal del encabezado (un polígono que cruza el ancho completo) y la leve inclinación del sello (−2°).

**The Sin Radios Rule.** `border-radius: 0` siempre. El casillero es cuadrado porque es un casillero de boleta.

**The Sólido o Punteado Rule.** Lo confirmado lleva trazo sólido; lo provisorio, trazo punteado en tinta media (hora a confirmar, contenido de ejemplo, beneficio bloqueado hasta iniciar sesión). Al pasar el cursor sobre algo bloqueado, el trazo se vuelve sólido rojo.

## Components

### Buttons
Casilleros rectangulares de tinta, firmes y de impresión.
- **Shape:** rectángulo sin radio, borde de 1px, alto mínimo 44px, relleno lateral 16px, ícono de 18px con 8px de separación.
- **Default:** fondo Papel, borde y texto Tinta, etiqueta en mayúsculas 15px/700. En hover o abierto (`aria-expanded`) se invierte: fondo Tinta, texto Papel.
- **Rojo:** fondo y borde Rojo Banda, texto Blanco sobre Rojo; hover a Rojo Banda Hondo. Una sola acción roja por bloque (leer la entrevista, ingresar, guardar el pronóstico).
- **Disabled:** borde Regla Suave, fondo Hoja Gris, texto Tinta Media.
- **Transición:** color y fondo a 160ms con `cubic-bezier(0.16, 1, 0.3, 1)`.

### Casillero (check box)
La marca básica del sistema.
- 20px cuadrado, borde Tinta 1px, fondo Papel. Marcado: fondo y borde Rojo Banda con tilde blanca de 14px (trazo 3).
- Se usa en el menú (sección actual) y en los filtros de copa. La app móvil lo reutiliza para cualquier selección.

### Chips (filtros)
- **Style:** casillero + etiqueta 15px/600, alto 40px, borde Regla Suave; el input nativo se oculta y el casillero hace de control.
- **State:** hover o seleccionado pasan el borde a Tinta y el casillero se llena de rojo. Foco: anillo rojo de 2px.

### Inputs / Fields
- **Style:** borde Tinta 1px, sin radio, fondo Papel, alto 48px, cursor de texto rojo. La búsqueda lleva ícono de 18px a la izquierda en Tinta Media.
- **Focus:** contorno rojo de 2px (en la búsqueda, pegado al borde).
- **Error:** borde Rojo Banda de 2px y mensaje en Rojo Banda Hondo 15px/600.
- **Casillero de goles:** 48px cuadrado (44px en celular), cifra centrada en Numeral 32px; deshabilitado en Hoja Gris con borde Regla Suave.

### Fila de boleta (signature)
- Fecha a la izquierda: día en Numeral con día de semana y mes debajo en Label, Tinta Media. Partido jugado: el día tachado con 3px rojo y el resultado en Numeral a la derecha.
- Centro: equipos 20px/700 (River siempre en rojo) y metadatos 15px en Tinta Media.
- Derecha: hora en casillero sólido (confirmada) o "Hora a confirmar" en casillero punteado.
- Listas abiertas con regla Tinta y filas separadas por Regla Suave. Las filas entran con un leve desplazamiento de 4px (280ms).

### Franja de sección
- Encabezado de sección: título Headline a la izquierda, enlace "Ver todas" en Label a la derecha, y debajo la franja roja de 10px. La misma franja abre el próximo partido, los datos de River, la paginación entre entrevistas y el pie.

### Banda del encabezado (signature)
- Polígono rojo que cruza todo el ancho del encabezado, de arriba-izquierda a abajo-derecha, detrás del wordmark. Entra cortando de izquierda a derecha (700ms) al cargar. Botón Menú a la izquierda, Ingresar o usuario a la derecha, wordmark Display debajo, regla de 1px al pie.

### Sello
- Borde Rojo Banda de 2px, texto rojo 13px/800 en mayúsculas con tracking 0.06em, ícono de 14px, rotado −2°. Certifica una acción hecha (pronóstico cargado, inscripto en el sorteo).

### Horario confirmado / provisorio
- Casillero de 13px/600, relleno 1px 6px. Confirmado: borde sólido Tinta, texto Tinta, cifras tabulares. Provisorio: borde punteado Tinta Media, texto Tinta Media en mayúsculas.

### Cards / Containers
- **Recuadro de ingreso (gate):** borde Tinta 1px, fondo Hoja Gris, relleno 24px, título Title y una acción roja.
- **Código de descuento:** caja de borde Tinta con el código en Archivo 75%/800 y botón de copiar pegado a la derecha con sólo un borde izquierdo.
- **Beneficio bloqueado:** caja punteada en Tinta Media con candado de 16px; hover a sólido rojo.
- **Tarjeta de equipo / dato:** sin borde propio, separada por reglas suaves de una grilla.

### Navigation
- Menú desplegable desde un botón default ("Menú" con ícono y flecha). Panel de hasta 380px, borde Tinta, sombra de panel flotante, entrada de 6px hacia abajo en 220ms. Cada ítem: casillero (marcado si es la sección actual), nombre 17px/700 y ayuda 15px en Tinta Media, separados por Regla Suave; hover en Hoja Gris.
- Pestañas de ingreso: dos mitades dentro de un borde Tinta, la seleccionada invertida en Tinta.

### Tabla de posiciones
- 15px tabular, cabecera en Label entre dos reglas Tinta, filas separadas por Regla Suave, puntos en 800. La fila de River se pinta entera en Rojo Banda con texto blanco.

## Do's and Don'ts

### Do:
- **Do** usar el rojo en bloques enteros: banda, franja de 10px, botón principal, casillero lleno, fila de River.
- **Do** escribir el nombre de River en rojo dentro de cualquier partido, fila o pronóstico.
- **Do** mostrar el estado con una marca: casillero tildado, día tachado, sello rotado, trazo sólido vs. punteado.
- **Do** marcar como punteado todo lo provisorio o bloqueado, y como sólido todo lo confirmado.
- **Do** usar Archivo 62%/900 con cifras tabulares para fechas, goles y puntos.
- **Do** espaciar en múltiplos de 8px y mantener controles de al menos 44px.
- **Do** marcar el contenido de ejemplo como tal con el aviso punteado o una nota en Tinta Media.

### Don't:
- **Don't** redondear ninguna esquina.
- **Don't** agregar un segundo color de acento ni colores semánticos (verde, amarillo, azul).
- **Don't** poner sombras en elementos en reposo; la sombra es sólo para paneles que flotan.
- **Don't** usar el escudo oficial ni marcas registradas del club; la identidad es la banda y el wordmark.
- **Don't** armar portadas con tarjetas con foto ni pasar a fondo oscuro tipo app de apuestas.
- **Don't** poner rótulos en mayúsculas encima de los títulos; las etiquetas en mayúsculas son sólo de datos y controles.
- **Don't** usar la serif fuera del texto de lectura.
