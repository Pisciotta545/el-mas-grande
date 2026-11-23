import Link from "next/link";

export default function NotFound() {
  return (
    <div className="wrap page-head" style={{ paddingBottom: 64 }}>
      <h1 className="page-head__title display">Fuera de juego</h1>
      <p className="page-head__lede">Esta página no existe o se mudó. Volvé a la portada y seguí desde ahí.</p>
      <p style={{ marginTop: 24 }}>
        <Link href="/" className="btn btn--red">
          Ir a la portada
        </Link>
      </p>
    </div>
  );
}
