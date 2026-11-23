import Link from "next/link";
import type { Interview } from "@/lib/types";
import { fullDate } from "@/lib/format";

export function StoryList({ items }: { items: Interview[] }) {
  return (
    <ul className="stories">
      {items.map((i) => (
        <li key={i.id} className="story">
          <span className="story__date">{fullDate(i.published_at)}</span>
          <div>
            <h3 className="story__title">
              <Link href={`/entrevistas/${i.slug}`}>{i.title}</Link>
            </h3>
            <p className="story__dek">{i.dek}</p>
            <p className="story__who">
              <strong>{i.interviewee}</strong>, {i.interviewee_role}
            </p>
          </div>
        </li>
      ))}
    </ul>
  );
}
