"use client";

import { usePathname } from "next/navigation";
import type { ReactNode } from "react";

// En la portada el wordmark va grande; en el resto de las secciones, compacto.
export function MastheadShell({ children }: { children: ReactNode }) {
  const pathname = usePathname();
  return <header className={pathname === "/" ? "masthead" : "masthead masthead--compact"}>{children}</header>;
}
