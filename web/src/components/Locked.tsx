import Link from "next/link";
import { Lock } from "lucide-react";

export function Locked({ next, children }: { next: string; children: React.ReactNode }) {
  return (
    <Link href={`/ingresar?next=${encodeURIComponent(next)}`} className="locked">
      <Lock aria-hidden />
      {children}
    </Link>
  );
}
