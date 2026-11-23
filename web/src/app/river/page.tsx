import type { Metadata } from "next";

export const metadata: Metadata = { title: "Info de River" };

const FACTS = [
  { label: "Fundación", value: "25 de mayo de 1901" },
  { label: "Barrio", value: "Núñez, Buenos Aires" },
  { label: "Estadio", value: "Monumental" },
  { label: "Apodo", value: "El Millonario" },
];

const LIBERTADORES = [
  { title: "Copa Libertadores", years: "1986 · 1996 · 2015 · 2018" },
  { title: "Copa Intercontinental", years: "1986" },
  { title: "Copa Sudamericana", years: "2014" },
  { title: "Supercopa Sudamericana", years: "1997" },
];

const IDOLS = [
  { name: "Ángel Labruna", note: "Máximo goleador de la historia del club." },
  { name: "Amadeo Carrizo", note: "El arquero que cambió el puesto." },
  { name: "Norberto Alonso", note: "El Beto, zurda y camiseta número 10." },
  { name: "Enzo Francescoli", note: "El Príncipe." },
  { name: "Marcelo Gallardo", note: "Campeón de América como jugador en 1996 y como técnico en 2015 y 2018." },
];

export default function RiverPage() {
  return (
    <div className="wrap">
      <header className="page-head">
        <h1 className="page-head__title display">Info de River</h1>
        <p className="page-head__lede">De La Boca a Núñez: la historia corta del club más ganador del fútbol argentino.</p>
      </header>

      <section className="section">
        <dl className="facts">
          {FACTS.map((f) => (
            <div key={f.label} className="fact">
              <dt>{f.label}</dt>
              <dd>{f.value}</dd>
            </div>
          ))}
        </dl>

        <div className="prose">
          <h2 className="heading">Cómo empezó</h2>
          <div className="prose__body">
            <p>
              River Plate se fundó el 25 de mayo de 1901 en La Boca, de la unión de dos clubes del barrio, Santa Rosa y
              La Rosales. El nombre, según la historia más contada, salió de unos cajones del puerto que decían “The
              River Plate”: el nombre en inglés del Río de la Plata.
            </p>
            <p>
              El club se mudó varias veces hasta llegar a Núñez, donde en 1938 inauguró el Monumental. Desde entonces, la
              banda roja cruzada sobre la camiseta blanca es la marca de la casa.
            </p>
          </div>
        </div>

        <div className="prose">
          <h2 className="heading">Por qué Millonario</h2>
          <div className="prose__body">
            <p>
              A principios de los años 30, River pagó cifras récord por Carlos Peucelle y Bernabé Ferreyra. La prensa
              empezó a llamarlo “el Millonario” y el apodo quedó para siempre.
            </p>
            <p>
              En los 40 llegó La Máquina, la delantera de Muñoz, Moreno, Pedernera, Labruna y Loustau, todavía hoy una
              de las más recordadas del fútbol mundial.
            </p>
          </div>
        </div>

        <div className="prose">
          <h2 className="heading">El Monumental</h2>
          <div className="prose__body">
            <p>
              Es el estadio más grande de la Argentina. Tras la última remodelación entran más de 84.000 personas, en
              cuatro tribunas: Sívori, Centenario, San Martín y Belgrano.
            </p>
            <p>Ahí se jugó la final del Mundial 1978, que la Selección le ganó 3 a 1 a Países Bajos.</p>
          </div>
        </div>

        <div className="prose">
          <h2 className="heading">Copas internacionales</h2>
          <div className="prose__body">
            <ul className="trophies">
              {LIBERTADORES.map((t) => (
                <li key={t.title}>
                  {t.title}
                  <span>{t.years}</span>
                </li>
              ))}
            </ul>
            <p>
              La Libertadores 2018 se ganó en Madrid, en el estadio Santiago Bernabéu, contra Boca: una final que ningún
              hincha de River va a olvidar.
            </p>
          </div>
        </div>

        <div className="prose">
          <h2 className="heading">Ídolos</h2>
          <div className="prose__body">
            <ul className="trophies">
              {IDOLS.map((i) => (
                <li key={i.name}>
                  <strong>{i.name}</strong>
                  <span>{i.note}</span>
                </li>
              ))}
            </ul>
          </div>
        </div>
      </section>
    </div>
  );
}
