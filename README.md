# El más grande

Sitio de hinchas de River: entrevistas, próximos partidos con buscador y filtro por copa, tabla de posiciones, prode con ranking, descuentos exclusivos y sorteos de entradas.

Publicado en https://pisciotta545.github.io/el-mas-grande/

- `web/`: el sitio (Next.js, exportado como estático para GitHub Pages).
- `app/`: la app Android (Flutter), con las mismas cuentas y datos de Supabase.
- `supabase/`: esquema de la base (`migrations/`) y datos de prueba (`seed.sql`).
- `DESIGN.md`: sistema de diseño. `PRODUCT.md`: qué es el producto.

## Desarrollo

```sh
cd web
npm install
npm run dev   # http://localhost:3100
```

Necesita `web/.env.local` con `NEXT_PUBLIC_SUPABASE_URL` y `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` (la clave publicable de Supabase, que es pública).

## App Android

```powershell
cd app
flutter pub get
.uild_apk.ps1          # build/app/outputs/flutter-apk/ElMasGrande-v<versión>.apk
.uild_apk.ps1 -Debug   # ElMasGrande-v<versión>-debug.apk
```

El nombre del APK sale de `android:label` y la versión de `pubspec.yaml`. La versión final se firma con `app/android/keys/el-mas-grande-upload.jks` y `app/android/key.properties`, que no están en git: sin ellos no se pueden publicar actualizaciones de la app, así que hay que guardarlos en un lugar seguro.

## Publicación

Cada push a `main` publica el sitio con GitHub Actions, y además se vuelve a generar cada hora para traer los datos nuevos de Supabase. La URL y la clave publicable de Supabase están en las variables del repositorio (`SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`).

Los partidos, tablas, entrevistados, comercios y sorteos cargados son datos de prueba.
