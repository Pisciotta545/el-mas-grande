// Prefijo del sitio publicado (GitHub Pages lo sirve en /el-mas-grande). En local es "".
export const BASE = process.env.NEXT_PUBLIC_BASE_PATH ?? "";

/** Ruta absoluta para window.location; <Link> agrega el prefijo solo. */
export const withBase = (path: string) => `${BASE}${path}`;

/** Solo rutas internas, para no redirigir a otro sitio. */
export function safeNext(value: string | null) {
  return value && value.startsWith("/") && !value.startsWith("//") ? value : "/";
}
