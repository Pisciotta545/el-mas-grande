import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { getInterview, getInterviews } from "@/lib/data";
import { fullDate } from "@/lib/format";

// Sitio estático: solo existen las entrevistas publicadas al generar el sitio.
export const dynamicParams = false;

export async function generateStaticParams() {
  const interviews = await getInterviews();
  return interviews.map((i) => ({ slug: i.slug }));
}

export async function generateMetadata({ params }: PageProps<"/entrevistas/[slug]">): Promise<Metadata> {
  const { slug } = await params;
  const interview = await getInterview(slug);
  return interview ? { title: interview.interviewee, description: interview.dek } : {};
}

export default async function InterviewPage({ params }: PageProps<"/entrevistas/[slug]">) {
  const { slug } = await params;
  const [interview, all] = await Promise.all([getInterview(slug), getInterviews()]);
  if (!interview) notFound();

  const index = all.findIndex((i) => i.slug === slug);
  const newer = index > 0 ? all[index - 1] : null;
  const older = index < all.length - 1 ? all[index + 1] : null;

  return (
    <article className="wrap article">
      <h1 className="article__title heading">{interview.title}</h1>
      <p className="article__dek">{interview.dek}</p>
      <p className="byline article__byline">
        <span>
          <strong>{interview.interviewee}</strong>, {interview.interviewee_role}
        </span>
        <span>Por {interview.author}</span>
        <span>{fullDate(interview.published_at)}</span>
      </p>
      {interview.is_sample && (
        <p>
          <span className="sample-flag">Entrevista de ejemplo: la persona es ficticia</span>
        </p>
      )}

      <div className="qa">
        {interview.body.map((item, n) => (
          <div key={n}>
            <p className="qa__q">{item.q}</p>
            <p className="qa__a">{item.a}</p>
          </div>
        ))}
      </div>

      <nav className="pager" aria-label="Otras entrevistas">
        {older ? (
          <Link href={`/entrevistas/${older.slug}`}>
            <small>Anterior</small>
            {older.interviewee}
          </Link>
        ) : (
          <span />
        )}
        {newer ? (
          <Link href={`/entrevistas/${newer.slug}`}>
            <small>Siguiente</small>
            {newer.interviewee}
          </Link>
        ) : (
          <Link href="/entrevistas">
            <small>Volver</small>
            Todas las entrevistas
          </Link>
        )}
      </nav>
    </article>
  );
}
