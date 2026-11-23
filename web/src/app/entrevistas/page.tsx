import type { Metadata } from "next";
import { StoryList } from "@/components/StoryList";
import { getInterviews } from "@/lib/data";

export const metadata: Metadata = { title: "Entrevistas" };

export default async function InterviewsPage() {
  const interviews = await getInterviews();

  return (
    <div className="wrap">
      <header className="page-head">
        <h1 className="page-head__title display">Entrevistas</h1>
        <p className="page-head__lede">
          Socios, laburantes del club, gente de las inferiores y de la puerta de la cancha. River contado por los que
          lo viven todos los días.
        </p>
      </header>
      <section className="section">
        <StoryList items={interviews} />
        <p className="note">Las entrevistas publicadas por ahora son de ejemplo: las personas son ficticias.</p>
      </section>
    </div>
  );
}
