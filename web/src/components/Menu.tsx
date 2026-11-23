"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useId, useRef, useState } from "react";
import { Check, ChevronDown, Menu as MenuIcon, X } from "lucide-react";
import { NAV } from "@/lib/nav";

export function Menu() {
  const [open, setOpen] = useState(false);
  const pathname = usePathname();
  const panelId = useId();
  const root = useRef<HTMLDivElement>(null);
  const button = useRef<HTMLButtonElement>(null);

  // Cerrar al navegar.
  const [lastPath, setLastPath] = useState(pathname);
  if (lastPath !== pathname) {
    setLastPath(pathname);
    setOpen(false);
  }

  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") {
        setOpen(false);
        button.current?.focus();
      }
    };
    const onClick = (e: MouseEvent) => {
      if (!root.current?.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener("keydown", onKey);
    document.addEventListener("mousedown", onClick);
    return () => {
      document.removeEventListener("keydown", onKey);
      document.removeEventListener("mousedown", onClick);
    };
  }, [open]);

  return (
    <div className="menu" ref={root}>
      <button
        ref={button}
        type="button"
        className="btn"
        aria-expanded={open}
        aria-controls={panelId}
        onClick={() => setOpen((v) => !v)}
      >
        {open ? <X aria-hidden /> : <MenuIcon aria-hidden />}
        Menú
        <ChevronDown aria-hidden style={{ transform: open ? "rotate(180deg)" : undefined }} />
      </button>

      {open && (
        <ul className="menu__panel" id={panelId}>
          {NAV.map((item) => {
            const current = pathname === item.href || pathname.startsWith(item.href + "/");
            return (
              <li key={item.href} className="menu__item">
                <Link
                  href={item.href}
                  className="menu__link"
                  aria-current={current ? "page" : undefined}
                >
                  <span className={current ? "box box--on" : "box"} aria-hidden>
                    {current && <Check strokeWidth={3} />}
                  </span>
                  <span className="menu__label">{item.label}</span>
                  <span className="menu__hint">{item.hint}</span>
                </Link>
              </li>
            );
          })}
        </ul>
      )}
    </div>
  );
}
