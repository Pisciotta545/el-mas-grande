"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { safeNext, withBase } from "@/lib/base";
import { createBrowserDb } from "@/lib/supabase/browser";

// Vuelta del enlace de confirmación de correo: canjea el código por una sesión en el navegador.
export default function AuthCallbackPage() {
  const [failed, setFailed] = useState(false);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const code = params.get("code");
    const next = safeNext(params.get("next"));
    if (!code) return setFailed(true);
    createBrowserDb()
      .auth.exchangeCodeForSession(code)
      .then(({ error }) => (error ? setFailed(true) : window.location.replace(withBase(next))));
  }, []);

  return (
    <div className="wrap page-head" style={{ paddingBottom: 64 }}>
      <h1 className="page-head__title display">{failed ? "Enlace vencido" : "Entrando…"}</h1>
      <p className="page-head__lede">
        {failed
          ? "El enlace ya se usó o venció. Ingresá con tu correo y contraseña."
          : "Estamos confirmando tu cuenta. Es un segundo."}
      </p>
      {failed && (
        <p style={{ marginTop: 24 }}>
          <Link href="/ingresar" className="btn btn--red">
            Ir a ingresar
          </Link>
        </p>
      )}
    </div>
  );
}
