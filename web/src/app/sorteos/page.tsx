import type { Metadata } from "next";
import { RaffleAction } from "@/components/RaffleAction";
import { getRaffles } from "@/lib/data";
import { hour, longDay } from "@/lib/format";

export const metadata: Metadata = { title: "Entradas y sorteos" };

export default async function RafflesPage() {
  const raffles = await getRaffles();

  return (
    <div className="wrap">
      <header className="page-head">
        <h1 className="page-head__title display">Entradas y sorteos</h1>
        <p className="page-head__lede">
          Sorteamos entradas entre los que tienen cuenta. Te anotás con un toque y, si ganás, te escribimos al correo.
        </p>
      </header>

      <section className="section">
        <ul className="rows">
          {raffles.map((r) => (
            <li key={r.id} className="perk">
              <div>
                <h2 className="perk__title">{r.title}</h2>
                <p className="perk__desc">{r.description}</p>
                <p className="perk__merchant">
                  {r.prize_count} {r.prize_count === 1 ? "entrada" : "entradas"}
                  {r.match ? <span> · {r.match.stage}</span> : null}
                </p>
              </div>
              <div className="perk__slot">
                <RaffleAction raffleId={r.id} closesAt={r.closes_at} />
                <span className="perk__valid">
                  Cierra el {longDay(r.closes_at)}, {hour(r.closes_at)} h
                </span>
              </div>
            </li>
          ))}
        </ul>
        <p className="note">Sorteos de ejemplo: todavía no se entregan entradas reales.</p>
      </section>
    </div>
  );
}
