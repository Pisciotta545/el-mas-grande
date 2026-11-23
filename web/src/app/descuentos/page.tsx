import type { Metadata } from "next";
import { DiscountCode } from "@/components/DiscountCode";
import { getDiscounts } from "@/lib/data";
import { fullDate } from "@/lib/format";

export const metadata: Metadata = { title: "Descuentos exclusivos" };

export default async function DiscountsPage() {
  const discounts = await getDiscounts();

  return (
    <div className="wrap">
      <header className="page-head">
        <h1 className="page-head__title display">Descuentos exclusivos</h1>
        <p className="page-head__lede">
          Beneficios en comercios para los que tienen cuenta en El más grande. Mostrá o pegá el código y listo.
        </p>
      </header>

      <section className="section">
        <ul className="rows">
          {discounts.map((d) => (
            <li key={d.id} className="perk">
              <div>
                <h2 className="perk__title">{d.title}</h2>
                <p className="perk__desc">{d.description}</p>
                <p className="perk__merchant">
                  {d.merchant} <span>· {d.category}</span>
                </p>
              </div>
              <div className="perk__slot">
                <DiscountCode id={d.id} />
                <span className="perk__valid">Vale hasta el {fullDate(`${d.valid_until}T12:00:00Z`)}</span>
              </div>
            </li>
          ))}
        </ul>
        <p className="note">Comercios y códigos de ejemplo: todavía no hay convenios reales.</p>
      </section>
    </div>
  );
}
