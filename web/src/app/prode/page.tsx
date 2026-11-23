import type { Metadata } from "next";
import { ProdeBoard, Ranking } from "@/components/ProdeBoard";
import { getCompetitions, getMatches, getRanking } from "@/lib/data";

export const metadata: Metadata = { title: "Prode y puntos" };

export default async function ProdePage() {
  const [matches, competitions, ranking] = await Promise.all([getMatches(), getCompetitions(), getRanking()]);
  const upcoming = matches.filter((m) => m.status === "scheduled");
  const finished = matches.filter((m) => m.status === "finished").reverse();

  return (
    <div className="wrap">
      <header className="page-head">
        <h1 className="page-head__title display">Prode y puntos</h1>
        <p className="page-head__lede">
          Pronosticá el resultado de cada partido de River. Se puede cambiar hasta que empieza el partido.
        </p>
      </header>

      <section className="section prode">
        <div>
          <p className="rules">
            <span>
              <b>3</b> puntos por resultado exacto
            </span>
            <span>
              <b>1</b> punto por acertar ganador o empate
            </span>
          </p>
          <ProdeBoard upcoming={upcoming} finished={finished} competitions={competitions} />
        </div>

        <aside aria-labelledby="ranking">
          <div className="section__head">
            <h2 id="ranking" className="section__title heading">
              Ranking
            </h2>
          </div>
          <Ranking initial={ranking} />
        </aside>
      </section>
    </div>
  );
}
