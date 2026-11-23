import type { Metadata } from "next";
import { Suspense } from "react";
import { AuthForm } from "@/components/AuthForm";

export const metadata: Metadata = { title: "Ingresar" };

export default function SignInPage() {
  return (
    <div className="wrap auth">
      <h1 className="page-head__title display" style={{ fontSize: "var(--t-3xl)" }}>
        Tu cuenta
      </h1>
      <p className="page-head__lede" style={{ fontSize: "var(--t-md)" }}>
        Con la cuenta jugás al prode, participás de los sorteos y ves los códigos de descuento.
      </p>
      <Suspense>
        <AuthForm />
      </Suspense>
    </div>
  );
}
