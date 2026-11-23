import 'package:flutter/material.dart';

import '../data.dart';
import '../format.dart';
import '../models.dart';
import '../session.dart';
import '../theme.dart';
import '../updater.dart';
import '../widgets.dart';
import 'auth_screen.dart';
import 'interview_screen.dart';

/// Lo que en la web está en el menú y no tiene pestaña propia.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final user = session.user;

    void push(Widget screen) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

    return TabPage(
      header: const Masthead(title: 'Más'),
      onRefresh: () async {},
      children: [
        const SectionHead('Tu cuenta'),
        if (!session.ready)
          const SizedBox(height: 48)
        else if (user == null) ...[
          Text('Con la cuenta jugás al prode, participás de los sorteos y ves los códigos de descuento.',
              style: Txt.ui(16, color: Palette.ink2)),
          const SizedBox(height: Space.u * 2),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: () => openAuth(context), child: const Text('INGRESAR O CREAR CUENTA')),
          ),
        ] else ...[
          Row(children: [
            const Icon(Icons.person_outline, color: Palette.ink),
            const SizedBox(width: Space.u),
            Expanded(child: Text(user.username, style: Txt.ui(20, weight: FontWeight.w800))),
            OutlinedButton.icon(
              onPressed: session.signOut,
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('SALIR'),
            ),
          ]),
        ],
        const SizedBox(height: Space.u * 5),
        const SectionHead('El club y los rivales'),
        _Row('Entrevistas', 'Charlas con la gente de River', () async {
          push(const _InterviewsLoader());
        }),
        _Row('Info de River', 'Historia, estadio y títulos', () => push(const RiverScreen())),
        _Row('Otros equipos', 'Los rivales, uno por uno', () => push(const TeamsScreen())),
        const SizedBox(height: Space.u * 5),
        const SectionHead('La app'),
        FutureBuilder<String>(
          future: installedVersion(),
          builder: (context, snap) => Text(
            snap.hasData ? 'Tenés la versión ${snap.data}.' : ' ',
            style: Txt.ui(16, color: Palette.ink2),
          ),
        ),
        const SizedBox(height: Space.u * 2),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => offerUpdate(context, quiet: false),
            icon: const Icon(Icons.system_update_alt, size: 18),
            label: const Text('BUSCAR ACTUALIZACIONES'),
          ),
        ),
        const SizedBox(height: Space.u * 5),
        Text(
          'El más grande es una app hecha por hinchas. No tiene relación oficial con el Club Atlético River Plate. '
          'Partidos, tablas, entrevistados, comercios y sorteos: datos de prueba.',
          style: Txt.ui(13, color: Palette.ink2),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.hint, this.onTap);

  final String label;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Space.u * 2),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.ruleSoft))),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: Txt.ui(18, weight: FontWeight.w700)),
              Text(hint, style: Txt.ui(14, color: Palette.ink2)),
            ]),
          ),
          const Icon(Icons.chevron_right, color: Palette.ink),
        ]),
      ),
    );
  }
}

Widget _back(BuildContext context) => IconButton(
      tooltip: 'Volver',
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back, color: Palette.ink),
    );

class _InterviewsLoader extends StatefulWidget {
  const _InterviewsLoader();

  @override
  State<_InterviewsLoader> createState() => _InterviewsLoaderState();
}

class _InterviewsLoaderState extends State<_InterviewsLoader> {
  late Future<List<Interview>> _future = Repo.interviews();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Loaded<List<Interview>>(
        future: _future,
        onRetry: () => setState(() => _future = Repo.interviews()),
        builder: (context, list) => InterviewsScreen(list),
      ),
    );
  }
}

class RiverScreen extends StatelessWidget {
  const RiverScreen({super.key});

  static const _facts = [
    ('Fundación', '25 de mayo de 1901'),
    ('Barrio', 'Núñez, Buenos Aires'),
    ('Estadio', 'Monumental'),
    ('Apodo', 'El Millonario'),
  ];

  static const _cups = [
    ('Copa Libertadores', '1986 · 1996 · 2015 · 2018'),
    ('Copa Intercontinental', '1986'),
    ('Copa Sudamericana', '2014'),
    ('Supercopa Sudamericana', '1997'),
  ];

  static const _idols = [
    ('Ángel Labruna', 'Máximo goleador de la historia del club.'),
    ('Amadeo Carrizo', 'El arquero que cambió el puesto.'),
    ('Norberto Alonso', 'El Beto, zurda y camiseta número 10.'),
    ('Enzo Francescoli', 'El Príncipe.'),
    ('Marcelo Gallardo', 'Campeón de América como jugador en 1996 y como técnico en 2015 y 2018.'),
  ];

  @override
  Widget build(BuildContext context) {
    Widget prose(String title, List<Widget> body) => Padding(
          padding: const EdgeInsets.only(top: Space.u * 4),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title.toUpperCase(), style: Txt.heading(28)),
            const SizedBox(height: Space.u * 1.5),
            ...body,
          ]),
        );
    Widget p(String text) => Padding(
          padding: const EdgeInsets.only(bottom: Space.u * 1.5),
          child: Text(text, style: Txt.read(17, height: 1.65)),
        );
    Widget list(List<(String, String)> rows, {bool boldLeft = false}) => Container(
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.ink))),
          child: Column(children: [
            for (final (a, b) in rows)
              Container(
                padding: const EdgeInsets.symmetric(vertical: Space.u),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.ruleSoft))),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Text(a, style: Txt.ui(15, weight: boldLeft ? FontWeight.w700 : FontWeight.w400))),
                  const SizedBox(width: Space.u * 2),
                  Expanded(child: Text(b, textAlign: TextAlign.right, style: Txt.ui(14, color: Palette.ink2))),
                ]),
              ),
          ]),
        );

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Masthead(title: 'Info de River', trailing: _back(context)),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.gutter, Space.u * 3, Space.gutter, Space.u * 6),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('De La Boca a Núñez: la historia corta del club más ganador del fútbol argentino.',
                  style: Txt.ui(18, color: Palette.ink2)),
              const SizedBox(height: Space.u * 3),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Palette.red, width: Space.band),
                    bottom: BorderSide(color: Palette.ink),
                  ),
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.2,
                  children: [
                    for (final (label, value) in _facts)
                      Padding(
                        padding: const EdgeInsets.all(Space.u * 1.5),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(label.toUpperCase(), style: Txt.label(11)),
                          const SizedBox(height: 4),
                          Text(value, style: Txt.ui(17, weight: FontWeight.w800, height: 1.2)),
                        ]),
                      ),
                  ],
                ),
              ),
              prose('Cómo empezó', [
                p('River Plate se fundó el 25 de mayo de 1901 en La Boca, de la unión de dos clubes del barrio, '
                    'Santa Rosa y La Rosales. El nombre, según la historia más contada, salió de unos cajones del '
                    'puerto que decían “The River Plate”: el nombre en inglés del Río de la Plata.'),
                p('El club se mudó varias veces hasta llegar a Núñez, donde en 1938 inauguró el Monumental. Desde '
                    'entonces, la banda roja cruzada sobre la camiseta blanca es la marca de la casa.'),
              ]),
              prose('Por qué Millonario', [
                p('A principios de los años 30, River pagó cifras récord por Carlos Peucelle y Bernabé Ferreyra. La '
                    'prensa empezó a llamarlo “el Millonario” y el apodo quedó para siempre.'),
                p('En los 40 llegó La Máquina, la delantera de Muñoz, Moreno, Pedernera, Labruna y Loustau, todavía '
                    'hoy una de las más recordadas del fútbol mundial.'),
              ]),
              prose('El Monumental', [
                p('Es el estadio más grande de la Argentina. Tras la última remodelación entran más de 84.000 '
                    'personas, en cuatro tribunas: Sívori, Centenario, San Martín y Belgrano.'),
                p('Ahí se jugó la final del Mundial 1978, que la Selección le ganó 3 a 1 a Países Bajos.'),
              ]),
              prose('Copas internacionales', [
                list(_cups),
                const SizedBox(height: Space.u * 1.5),
                p('La Libertadores 2018 se ganó en Madrid, en el estadio Santiago Bernabéu, contra Boca: una final '
                    'que ningún hincha de River va a olvidar.'),
              ]),
              prose('Ídolos', [list(_idols, boldLeft: true)]),
            ]),
          ),
        ],
      ),
    );
  }
}

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  late Future<(List<Team>, List<Match>, List<Competition>)> _future = _load();

  Future<(List<Team>, List<Match>, List<Competition>)> _load() =>
      (Repo.teams(), Repo.matches(), Repo.competitions()).wait;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Masthead(title: 'Otros equipos', trailing: _back(context)),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.gutter, Space.u * 3, Space.gutter, Space.u * 6),
            child: Loaded(
              future: _future,
              onRetry: () => setState(() => _future = _load()),
              builder: (context, d) {
                final (teams, matches, comps) = d;
                final names = {for (final c in comps) c.id: c.name};
                final next = <String, Match>{};
                for (final m in matches.where((m) => m.scheduled)) {
                  next.putIfAbsent(m.rival.id, () => m);
                }
                final rivals = teams.where((t) => !t.isRiver);
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SectionHead('Argentina'),
                  for (final t in rivals.where((t) => t.country == 'Argentina')) _team(t, next[t.id], names),
                  const SizedBox(height: Space.u * 5),
                  const SectionHead('Copa Libertadores'),
                  for (final t in rivals.where((t) => t.country != 'Argentina')) _team(t, next[t.id], names),
                ]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _team(Team t, Match? next, Map<String, String> names) {
    Widget fact(String k, String v) => Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 76, child: Text(k, style: Txt.ui(14, color: Palette.ink2))),
            Expanded(child: Text(v, style: Txt.ui(14))),
          ]),
        );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Space.u * 2),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.ruleSoft))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 64, child: Text(t.shortName, style: Txt.display(30))),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.name, style: Txt.ui(18, weight: FontWeight.w800, height: 1.2)),
            const SizedBox(height: 4),
            if (t.nickname != null) fact('Apodo', t.nickname!),
            fact('Ciudad', t.country == 'Argentina' ? t.city : '${t.city}, ${t.country}'),
            if (t.founded != null) fact('Fundado', '${t.founded}'),
            if (t.stadium != null) fact('Estadio', t.stadium!),
            if (next != null) ...[
              const SizedBox(height: Space.u),
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 6, runSpacing: 4, children: [
                Text('Contra River: ${shortDay(next.kickoff)} ·', style: Txt.ui(14, weight: FontWeight.w600)),
                TimeTag(next),
                Text('· ${names[next.competitionId] ?? ''}', style: Txt.ui(14, weight: FontWeight.w600)),
              ]),
            ],
          ]),
        ),
      ]),
    );
  }
}
