"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import type { EmailOtpType } from "@supabase/supabase-js";
import { safeNext, withBase } from "@/lib/base";
import { createBrowserDb } from "@/lib/supabase/browser";

// Vuelta de los enlaces de los mails (confirmar cuenta, recuperar contraseña, etc.).
// Los mails traen un token_hash que se verifica en cualquier navegador o dispositivo;
// el ?code= solo funciona en el navegador donde se pidió, así que queda como respaldo.
export default function AuthCallbackPage() {
  const [failed, setFailed] = useState(false);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const tokenHash = params.get("token_hash");
    const type = params.get("type") as EmailOtpType | null;
    const code = params.get("code");
    const next = safeNext(params.get("next"));
    const db = createBrowserDb();

    const verify =
      tokenHash && type
        ? db.auth.verifyOtp({ token_hash: tokenHash, type })
        : code
          ? db.auth.exchangeCodeForSession(code)
          : null;

    if (!verify) return setFailed(true);
    verify.then(({ error }) => (error ? setFailed(true) : window.location.replace(withBase(next))));
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
