import type { Metadata } from "next";
import { Archivo, Source_Serif_4 } from "next/font/google";
import { Masthead } from "@/components/Masthead";
import { SessionProvider } from "@/components/Session";
import "./globals.css";

const archivo = Archivo({
  variable: "--font-archivo",
  subsets: ["latin"],
  axes: ["wdth"],
});

const serif = Source_Serif_4({
  variable: "--font-serif",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: {
    default: "El más grande",
    template: "%s · El más grande",
  },
  description:
    "El sitio de los hinchas de River: entrevistas, próximos partidos, tabla, prode, descuentos y sorteos de entradas.",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="es-AR" className={`${archivo.variable} ${serif.variable}`}>
      <body>
        <SessionProvider>
          <Masthead />
          <main>{children}</main>
          <footer className="footer">
            <div className="wrap footer__inner">
              <p>
                <strong>El más grande</strong> es un sitio hecho por hinchas. No tiene relación oficial con el Club
                Atlético River Plate.
              </p>
              <p>Partidos, tablas, entrevistados, comercios y sorteos: datos de prueba.</p>
            </div>
          </footer>
        </SessionProvider>
      </body>
    </html>
  );
}
