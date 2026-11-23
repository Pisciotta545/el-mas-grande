import Link from "next/link";
import { MastheadShell } from "./MastheadShell";
import { Menu } from "./Menu";
import { UserSlot } from "./UserSlot";

export function Masthead() {
  return (
    <MastheadShell>
      {/* La banda: cruza el encabezado de arriba a la izquierda hacia abajo a la derecha */}
      <svg className="masthead__band" viewBox="0 0 100 100" preserveAspectRatio="none" aria-hidden>
        <polygon points="0,18 0,52 100,100 100,66" />
      </svg>
      <div className="wrap masthead__inner">
        <div className="masthead__bar">
          <Menu />
          <UserSlot />
        </div>
        <Link href="/" className="wordmark display" aria-label="El más grande, inicio">
          El más grande
        </Link>
      </div>
    </MastheadShell>
  );
}
