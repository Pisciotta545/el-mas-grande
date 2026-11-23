const TZ = "America/Argentina/Buenos_Aires";

const dayFmt = new Intl.DateTimeFormat("es-AR", { timeZone: TZ, weekday: "short", day: "numeric", month: "short" });
const longFmt = new Intl.DateTimeFormat("es-AR", { timeZone: TZ, weekday: "long", day: "numeric", month: "long" });
const timeFmt = new Intl.DateTimeFormat("es-AR", { timeZone: TZ, hour: "2-digit", minute: "2-digit", hour12: false });
const dateFmt = new Intl.DateTimeFormat("es-AR", { timeZone: TZ, day: "numeric", month: "long", year: "numeric" });

const clean = (s: string) => s.replace(/[.,]/g, "");

/** "sáb 29 nov" */
export const shortDay = (iso: string) => clean(dayFmt.format(new Date(iso)));
/** "sábado 29 de noviembre" */
export const longDay = (iso: string) => longFmt.format(new Date(iso));
/** "17:00" */
export const hour = (iso: string) => timeFmt.format(new Date(iso));
/** "20 de noviembre de 2026" */
export const fullDate = (iso: string) => dateFmt.format(new Date(iso));
