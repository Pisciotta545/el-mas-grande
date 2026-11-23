"use client";

import { useState } from "react";
import { useSearchParams } from "next/navigation";
import { BASE, safeNext, withBase } from "@/lib/base";
import { createBrowserDb } from "@/lib/supabase/browser";

type Mode = "login" | "signup";

const ERRORS: Record<string, string> = {
  "Invalid login credentials": "El correo o la contraseña no coinciden. Revisalos y probá de nuevo.",
  "Email not confirmed": "Todavía no confirmaste el correo. Buscá el mail que te mandamos y tocá el enlace.",
  "User already registered": "Ya hay una cuenta con ese correo. Probá ingresar.",
};

export function AuthForm() {
  const params = useSearchParams();
  const next = safeNext(params.get("next"));
  const [mode, setMode] = useState<Mode>("login");
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(
    params.get("error") === "enlace" ? "El enlace venció o ya se usó. Ingresá con tu correo y contraseña." : null,
  );
  const [sentTo, setSentTo] = useState<string | null>(null);

  async function onSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const form = new FormData(e.currentTarget);
    const email = String(form.get("email")).trim();
    const password = String(form.get("password"));
    const db = createBrowserDb();

    setPending(true);
    setError(null);

    if (mode === "login") {
      const { error } = await db.auth.signInWithPassword({ email, password });
      setPending(false);
      if (error) return setError(ERRORS[error.message] ?? error.message);
      // Recarga completa: así el encabezado (que vive en el layout) se dibuja con la sesión nueva.
      window.location.assign(withBase(next));
      return;
    }

    const username = String(form.get("username")).trim();
    const { data, error } = await db.auth.signUp({
      email,
      password,
      options: {
        data: { username },
        emailRedirectTo: `${window.location.origin}${BASE}/auth/callback/?next=${encodeURIComponent(next)}`,
      },
    });
    setPending(false);
    if (error) return setError(ERRORS[error.message] ?? error.message);
    if (data.session) {
      window.location.assign(withBase(next));
    } else {
      setSentTo(email);
    }
  }

  if (sentTo) {
    return (
      <div className="gate" style={{ marginTop: 24 }}>
        <p className="gate__title">Revisá tu correo</p>
        <p>
          Te mandamos un enlace a <strong>{sentTo}</strong>. Tocalo para confirmar la cuenta y entrar.
        </p>
      </div>
    );
  }

  return (
    <>
      <div className="tabs" role="tablist" aria-label="Elegí cómo entrar">
        <button type="button" role="tab" aria-selected={mode === "login"} onClick={() => setMode("login")}>
          Ingresar
        </button>
        <button type="button" role="tab" aria-selected={mode === "signup"} onClick={() => setMode("signup")}>
          Crear cuenta
        </button>
      </div>

      <form onSubmit={onSubmit} noValidate={false}>
        {mode === "signup" && (
          <div className="field">
            <label htmlFor="username">Nombre de hincha</label>
            <input
              id="username"
              name="username"
              required
              minLength={3}
              maxLength={24}
              pattern="[A-Za-z0-9_.]+"
              autoComplete="nickname"
            />
            <small>Es el que aparece en el ranking del prode. Letras, números, punto o guion bajo.</small>
          </div>
        )}
        <div className="field">
          <label htmlFor="email">Correo</label>
          <input id="email" name="email" type="email" required autoComplete="email" aria-invalid={!!error} />
        </div>
        <div className="field">
          <label htmlFor="password">Contraseña</label>
          <input
            id="password"
            name="password"
            type="password"
            required
            minLength={6}
            autoComplete={mode === "login" ? "current-password" : "new-password"}
            aria-invalid={!!error}
          />
          {mode === "signup" && <small>Mínimo 6 caracteres.</small>}
        </div>

        {error && (
          <p className="form-msg form-msg--error" role="alert" style={{ marginBottom: 16 }}>
            {error}
          </p>
        )}

        <button type="submit" className="btn btn--red" disabled={pending}>
          {pending ? "Un momento…" : mode === "login" ? "Ingresar" : "Crear cuenta"}
        </button>
      </form>
    </>
  );
}
