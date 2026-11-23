-- Datos de prueba. Todo lo marcado is_sample = true es ficticio:
-- partidos, resultados, tablas, entrevistados, comercios y sorteos.
-- Los datos de los clubes (ciudad, fundación, estadio) son reales.

insert into public.competitions (id, name, season, has_table, table_label, sort_order) values
  ('lpf', 'Liga Profesional', '2026', true, 'Zona B', 1),
  ('copa-argentina', 'Copa Argentina', '2026', false, null, 2),
  ('libertadores', 'Copa Libertadores', '2027', true, 'Grupo C', 3);

insert into public.teams (id, name, short_name, nickname, city, country, founded, stadium, is_river) values
  ('river', 'River Plate', 'RIV', 'El Millonario', 'Buenos Aires (Núñez)', 'Argentina', 1901, 'Estadio Monumental', true),
  ('boca', 'Boca Juniors', 'BOC', 'Xeneize', 'Buenos Aires (La Boca)', 'Argentina', 1905, 'La Bombonera', false),
  ('racing', 'Racing Club', 'RAC', 'La Academia', 'Avellaneda', 'Argentina', 1903, 'Presidente Perón (El Cilindro)', false),
  ('independiente', 'Independiente', 'IND', 'El Rojo', 'Avellaneda', 'Argentina', 1905, 'Libertadores de América', false),
  ('san-lorenzo', 'San Lorenzo', 'SLO', 'El Ciclón', 'Buenos Aires (Bajo Flores)', 'Argentina', 1908, 'Pedro Bidegain (Nuevo Gasómetro)', false),
  ('estudiantes', 'Estudiantes de La Plata', 'EST', 'El Pincha', 'La Plata', 'Argentina', 1905, 'Jorge Luis Hirschi', false),
  ('velez', 'Vélez Sarsfield', 'VEL', 'El Fortín', 'Buenos Aires (Liniers)', 'Argentina', 1910, 'José Amalfitani', false),
  ('talleres', 'Talleres', 'TAL', 'La T', 'Córdoba', 'Argentina', 1913, 'Mario Alberto Kempes', false),
  ('belgrano', 'Belgrano', 'BEL', 'El Pirata', 'Córdoba', 'Argentina', 1905, 'Julio César Villagra (Gigante de Alberdi)', false),
  ('rosario-central', 'Rosario Central', 'CEN', 'El Canalla', 'Rosario', 'Argentina', 1889, 'Gigante de Arroyito', false),
  ('newells', 'Newell''s Old Boys', 'NOB', 'La Lepra', 'Rosario', 'Argentina', 1903, 'Marcelo Bielsa', false),
  ('huracan', 'Huracán', 'HUR', 'El Globo', 'Buenos Aires (Parque Patricios)', 'Argentina', 1908, 'Tomás Adolfo Ducó', false),
  ('lanus', 'Lanús', 'LAN', 'El Granate', 'Lanús', 'Argentina', 1915, 'Ciudad de Lanús (La Fortaleza)', false),
  ('argentinos', 'Argentinos Juniors', 'ARG', 'El Bicho', 'Buenos Aires (La Paternal)', 'Argentina', 1904, 'Diego Armando Maradona', false),
  ('godoy-cruz', 'Godoy Cruz', 'GOD', 'El Tomba', 'Mendoza', 'Argentina', 1921, 'Malvinas Argentinas', false),
  ('platense', 'Platense', 'PLA', 'El Calamar', 'Vicente López', 'Argentina', 1905, 'Ciudad de Vicente López', false),
  ('tigre', 'Tigre', 'TIG', 'El Matador', 'Victoria', 'Argentina', 1902, 'José Dellagiovanna', false),
  ('gimnasia', 'Gimnasia y Esgrima La Plata', 'GEL', 'El Lobo', 'La Plata', 'Argentina', 1887, 'Juan Carmelo Zerillo', false),
  ('universitario', 'Universitario', 'UNI', 'La U', 'Lima', 'Perú', 1924, 'Monumental de Lima', false),
  ('nacional', 'Nacional', 'NAC', 'El Bolso', 'Montevideo', 'Uruguay', 1899, 'Gran Parque Central', false),
  ('barcelona-sc', 'Barcelona SC', 'BSC', 'El Ídolo', 'Guayaquil', 'Ecuador', 1925, 'Monumental Isidro Romero Carbo', false);

-- Horarios en UTC (Argentina = UTC-3).
insert into public.matches (competition_id, stage, home_team_id, away_team_id, kickoff, time_confirmed, venue, home_goals, away_goals, status) values
  ('lpf', 'Fecha 13', 'river', 'velez', '2026-11-09 00:00+00', true, 'Estadio Monumental', 2, 0, 'finished'),
  ('lpf', 'Fecha 14', 'lanus', 'river', '2026-11-15 22:00+00', true, 'Ciudad de Lanús', 1, 1, 'finished'),
  ('copa-argentina', 'Cuartos de final', 'river', 'huracan', '2026-11-19 00:10+00', true, 'Estadio Único de La Plata', 3, 1, 'finished'),
  ('lpf', 'Fecha 15', 'river', 'racing', '2026-11-29 20:00+00', true, 'Estadio Monumental', null, null, 'scheduled'),
  ('copa-argentina', 'Semifinal', 'river', 'talleres', '2026-12-04 00:10+00', false, null, null, null, 'scheduled'),
  ('lpf', 'Fecha 16', 'estudiantes', 'river', '2026-12-06 22:30+00', true, 'Jorge Luis Hirschi', null, null, 'scheduled'),
  ('lpf', 'Octavos de final', 'river', 'san-lorenzo', '2026-12-13 21:00+00', false, 'Estadio Monumental', null, null, 'scheduled'),
  ('libertadores', 'Grupo C · Fecha 1', 'river', 'universitario', '2027-04-09 00:30+00', true, 'Estadio Monumental', null, null, 'scheduled'),
  ('libertadores', 'Grupo C · Fecha 2', 'nacional', 'river', '2027-04-15 22:00+00', true, 'Gran Parque Central', null, null, 'scheduled'),
  ('libertadores', 'Grupo C · Fecha 3', 'river', 'barcelona-sc', '2027-04-23 00:30+00', true, 'Estadio Monumental', null, null, 'scheduled');

insert into public.standings (competition_id, team_id, position, played, won, drawn, lost, goals_for, goals_against, points) values
  ('lpf', 'river', 1, 14, 9, 3, 2, 24, 10, 30),
  ('lpf', 'racing', 2, 14, 8, 4, 2, 21, 11, 28),
  ('lpf', 'estudiantes', 3, 14, 7, 5, 2, 18, 10, 26),
  ('lpf', 'velez', 4, 14, 7, 3, 4, 17, 13, 24),
  ('lpf', 'talleres', 5, 14, 6, 5, 3, 19, 14, 23),
  ('lpf', 'lanus', 6, 14, 6, 4, 4, 16, 13, 22),
  ('lpf', 'rosario-central', 7, 14, 5, 6, 3, 15, 13, 21),
  ('lpf', 'argentinos', 8, 14, 5, 5, 4, 14, 13, 20),
  ('lpf', 'san-lorenzo', 9, 14, 5, 4, 5, 12, 13, 19),
  ('lpf', 'huracan', 10, 14, 4, 6, 4, 13, 14, 18),
  ('lpf', 'belgrano', 11, 14, 4, 4, 6, 14, 17, 16),
  ('lpf', 'platense', 12, 14, 3, 6, 5, 10, 14, 15),
  ('lpf', 'godoy-cruz', 13, 14, 3, 5, 6, 11, 17, 14),
  ('lpf', 'tigre', 14, 14, 2, 6, 6, 10, 18, 12),
  ('lpf', 'gimnasia', 15, 14, 2, 4, 8, 9, 21, 10),
  ('libertadores', 'river', 1, 0, 0, 0, 0, 0, 0, 0),
  ('libertadores', 'nacional', 2, 0, 0, 0, 0, 0, 0, 0),
  ('libertadores', 'barcelona-sc', 3, 0, 0, 0, 0, 0, 0, 0),
  ('libertadores', 'universitario', 4, 0, 0, 0, 0, 0, 0, 0);

insert into public.interviews (slug, title, dek, interviewee, interviewee_role, author, published_at, featured, body) values
(
  'marta-socia-desde-1968',
  '“Al Monumental se entra de la mano de alguien”',
  'Marta Ferreyra se hizo socia a los once años, cuando su papá la llevó por primera vez a la Centenario. Cincuenta y ocho años después sigue yendo al mismo escalón.',
  'Marta Ferreyra',
  'Socia vitalicia',
  'Redacción El más grande',
  '2026-11-20 13:00+00',
  true,
  '[
    {"q": "¿Te acordás del primer partido?", "a": "Del partido no, de la escalera sí. Mi viejo me agarraba tan fuerte de la mano que al salir tenía los dedos blancos. Subimos, se abrió la tribuna y vi la cancha entera de golpe. Eso no se olvida."},
    {"q": "¿Siempre en el mismo lugar?", "a": "Siempre. Fila de arriba, a la izquierda del túnel. Cambiaron las butacas, cambiaron los techos, cambió todo el estadio, pero yo busco el mismo escalón. Si alguien está sentado ahí le explico, y la gente entiende."},
    {"q": "¿Qué cambió en la forma de ir a la cancha?", "a": "Antes ibas y te enterabas de todo ahí. Hoy los chicos llegan sabiendo la formación, el árbitro, la estadística. Me gusta. Lo que no tiene que cambiar es que vengas temprano y te quedes al final a aplaudir."},
    {"q": "¿A quién llevás vos ahora?", "a": "A mi nieta Sofía. Tiene nueve. El otro día, subiendo, me agarró fuerte de la mano. No le dije nada, pero me acordé de mi papá en cada escalón."},
    {"q": "Un consejo para el que va por primera vez.", "a": "Que mire para arriba antes de mirar la cancha. La gente es la mitad del partido."}
  ]'::jsonb
),
(
  'julian-utilero-reserva',
  '“Cada botín tiene su lugar y cada lugar tiene su historia”',
  'Julián Sosa prepara el vestuario de la Reserva desde hace doce años. Habla de cábalas, de botines perdidos y de chicos que después vio debutar en Primera.',
  'Julián Sosa',
  'Utilero de la Reserva',
  'Redacción El más grande',
  '2026-11-17 13:00+00',
  false,
  '[
    {"q": "¿A qué hora empieza tu día de partido?", "a": "Cinco horas antes. Camisetas colgadas por número, botines limpios, cinta, vendas, agua. Si llega un pibe y no encuentra lo suyo, ya arrancó mal."},
    {"q": "¿Hay cábalas en el vestuario?", "a": "Todos tienen alguna. Uno entra con el pie derecho, otro se ata los cordones tres veces. Yo no me meto: si funciona, funciona."},
    {"q": "¿Qué se siente ver debutar a alguien que viste crecer?", "a": "Te emociona como si fuera de tu familia. Los conocés con quince años, llorando porque no quedaron en la lista. Después los ves en la tele y pensás: ese botín se lo até yo."},
    {"q": "¿Lo más raro que te pidieron?", "a": "Un arquero quería sus guantes viejos, rotos, porque con esos había atajado un penal. Los cosí como pude y los usó todo el torneo."}
  ]'::jsonb
),
(
  'lucia-entrenadora-inferiores',
  '“Las chicas llegan sabiendo más que nosotros a su edad”',
  'Lucía Benítez entrena a la categoría sub-14 del fútbol femenino. Cuenta cómo creció la convocatoria y qué busca en cada prueba.',
  'Lucía Benítez',
  'Entrenadora de inferiores',
  'Redacción El más grande',
  '2026-11-12 13:00+00',
  false,
  '[
    {"q": "¿Cuántas chicas se presentan a las pruebas?", "a": "Cada año más. Antes llenábamos una cancha, ahora necesitamos tres turnos. Vienen de todo el conurbano y del interior."},
    {"q": "¿Qué mirás primero?", "a": "Cómo reciben la pelota y qué hacen cuando la pierden. La técnica se trabaja; las ganas de ir a buscarla, no tanto."},
    {"q": "¿Qué querés que se lleven del club?", "a": "Que el escudo pesa, pero también abriga. Que acá se juega bien, se respeta al rival y se estudia. Las que terminan el secundario juegan mejor, te lo firmo."},
    {"q": "¿Un sueño para la categoría?", "a": "Que la próxima generación entrene en el mismo predio y con los mismos horarios que los varones. Vamos camino a eso."}
  ]'::jsonb
),
(
  'tano-garrapinada-puerta-monumental',
  '“El olor a garrapiñada es parte del partido”',
  'Ramón “el Tano” Iglesias vende garrapiñada en la esquina de Figueroa Alcorta desde los noventa. Su termómetro del resultado es la caja del entretiempo.',
  'Ramón Iglesias',
  'Vendedor en la puerta del estadio',
  'Redacción El más grande',
  '2026-11-05 13:00+00',
  false,
  '[
    {"q": "¿Cuántos partidos viste desde la vereda?", "a": "Perdí la cuenta. Partidos no veo, los escucho. Por el grito sé si fue gol nuestro o de ellos sin mirar la radio."},
    {"q": "¿Se vende más cuando se gana?", "a": "Se vende más a la salida cuando se gana. Cuando se pierde la gente se va rápido y con la cabeza gacha. A esos les regalo una bolsita, que es lo que puedo hacer."},
    {"q": "¿La mejor noche?", "a": "Una de copa, lloviendo. No quedó un maní. La gente salía cantando empapada y me pedía más. Me fui a casa con la olla vacía y la garganta rota."}
  ]'::jsonb
);

insert into public.discounts (merchant, category, title, description, valid_until) values
  ('Parrilla La Banda', 'Gastronomía', '15% en el menú del día de partido', 'Presentando el código en caja, los días que juega River. No acumulable con otras promociones.', '2027-03-31'),
  ('Indumentaria Núñez', 'Ropa', '20% en camperas y buzos', 'En la tienda online, ingresando el código al pagar. Hasta agotar stock.', '2027-01-31'),
  ('Librería del Tablón', 'Libros', '2x1 en libros de fútbol argentino', 'Llevás dos y pagás el de mayor precio. Válido en el local.', '2027-02-28'),
  ('Gimnasio Centenario', 'Deporte', 'Primer mes sin matrícula', 'Para nuevos socios del gimnasio que muestren el código en recepción.', '2026-12-31'),
  ('Cervecería Sívori', 'Gastronomía', 'Pinta de regalo con la segunda', 'De lunes a jueves. Mayores de 18.', '2027-04-30');

insert into public.discount_codes (discount_id, code)
select id, code from public.discounts d
join (values
  ('Parrilla La Banda', 'BANDA15'),
  ('Indumentaria Núñez', 'NUNEZ20'),
  ('Librería del Tablón', 'TABLON2X1'),
  ('Gimnasio Centenario', 'CENTENARIO0'),
  ('Cervecería Sívori', 'SIVORIPINTA')
) as c(merchant, code) on c.merchant = d.merchant;

insert into public.raffles (match_id, title, description, prize_count, closes_at)
select m.id, r.title, r.description, r.prize_count, r.closes_at::timestamptz
from (values
  ('velez', 'Dos plateas para River – Vélez', 'Sorteo cerrado. Los ganadores ya fueron avisados por correo.', 2, '2026-11-06 23:59+00'),
  ('racing', 'Dos entradas para River – Racing', 'Sorteamos dos entradas para la Sívori alta. Se avisa a los ganadores por correo 48 horas antes del partido.', 2, '2026-11-27 23:59+00'),
  ('san-lorenzo', 'Cuatro entradas para River – San Lorenzo', 'Dos ganadores, dos entradas cada uno, para la San Martín. Válido para los octavos de final.', 4, '2026-12-10 23:59+00')
) as r(rival, title, description, prize_count, closes_at)
join public.matches m on (m.home_team_id = 'river' and m.away_team_id = r.rival);
