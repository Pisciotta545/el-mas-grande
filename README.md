# El más grande

Sitio de hinchas de River: entrevistas, próximos partidos con buscador y filtro por copa, tabla de posiciones, prode con ranking, descuentos exclusivos y sorteos de entradas.

Publicado en https://pisciotta545.github.io/el-mas-grande/

- `web/`: el sitio (Next.js, exportado como estático para GitHub Pages).
- `supabase/`: esquema de la base (`migrations/`) y datos de prueba (`seed.sql`).
- `DESIGN.md`: sistema de diseño. `PRODUCT.md`: qué es el producto.

## Desarrollo

```sh
cd web
npm install
npm run dev   # http://localhost:3100
```

Necesita `web/.env.local` con `NEXT_PUBLIC_SUPABASE_URL` y `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` (la clave publicable de Supabase, que es pública).

## Publicación

Cada push a `main` publica el sitio con GitHub Actions, y además se vuelve a generar cada hora para traer los datos nuevos de Supabase. La URL y la clave publicable de Supabase están en las variables del repositorio (`SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`).

Los partidos, tablas, entrevistados, comercios y sorteos cargados son datos de prueba.
