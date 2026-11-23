import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data.dart';
import '../format.dart';
import '../models.dart';
import '../session.dart';
import '../theme.dart';
import '../widgets.dart';
import 'auth_screen.dart';

typedef _ProdeData = ({List<Match> matches, List<Competition> competitions, List<RankingRow> ranking});

class ProdeScreen extends StatefulWidget {
  const ProdeScreen({super.key});

  @override
  State<ProdeScreen> createState() => _ProdeScreenState();
}

class _ProdeScreenState extends State<ProdeScreen> {
  late Future<_ProdeData> _future = _load();
  Future<Map<int, Pick>>? _picks;
  String? _picksFor;

  Future<_ProdeData> _load() async {
    final r = await (Repo.matches(), Repo.competitions(), Repo.ranking()).wait;
    return (matches: r.$1, competitions: r.$2, ranking: r.$3);
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _load();
      _picksFor = null;
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final user = session.user;
    // Los pronósticos se vuelven a pedir cuando cambia quién está logueado.
    if (user?.id != _picksFor) {
      _picksFor = user?.id;
      _picks = user == null ? null : Repo.myPicks(user.id);
    }

    return TabPage(
      header: const Masthead(title: 'Prode'),
      onRefresh: _refresh,
      children: [
        Wrap(spacing: Space.u * 3, runSpacing: Space.u, children: [
          _rule('3', 'puntos por resultado exacto'),
          _rule('1', 'punto por acertar ganador o empate'),
        ]),
        const SizedBox(height: Space.u * 3),
        if (session.ready && user == null)
          Gate(
            title: 'Ingresá para jugar',
            text: 'Con tu cuenta guardás los pronósticos y sumás puntos en el ranking.',
            onLogin: () => openAuth(context),
          ),
        Loaded<_ProdeData>(
          future: _future,
          onRetry: _refresh,
          builder: (context, d) => FutureBuilder<Map<int, Pick>>(
            future: _picks,
            builder: (context, snap) {
              final picks = snap.data;
              final loadingPicks = user != null && picks == null;
              return _board(d, user?.id, picks, loadingPicks || !session.ready);
            },
          ),
        ),
      ],
    );
  }

  Widget _rule(String n, String text) => Row(mainAxisSize: MainAxisSize.min, children: [
        Text(n, style: Txt.display(26, color: Palette.red)),
        const SizedBox(width: 6),
        Text(text, style: Txt.ui(14)),
      ]);

  Widget _board(_ProdeData d, String? userId, Map<int, Pick>? picks, bool loading) {
    final names = {for (final c in d.competitions) c.id: c.name};
    final upcoming = d.matches.where((m) => m.scheduled).toList();
    final finished = d.matches.where((m) => m.finished).toList().reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Palette.ink, height: 1),
        for (final m in upcoming)
          _PickCard(
            key: ValueKey('${m.id}-$userId-${picks?[m.id]?.home}-${picks?[m.id]?.away}'),
            match: m,
            competition: names[m.competitionId] ?? '',
            userId: loading ? null : userId,
            saved: picks?[m.id],
          ),
        const SizedBox(height: Space.u * 5),
        const SectionHead('Jugados'),
        for (final m in finished) _played(m, picks),
        const SizedBox(height: Space.u * 5),
        const SectionHead('Ranking'),
        _ranking(d.ranking),
      ],
    );
  }

  Widget _played(Match m, Map<int, Pick>? picks) {
    final pick = picks?[m.id];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Space.u * 1.75),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.ruleSoft))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 60, child: DateBlock(m.kickoff, struck: true)),
          const SizedBox(width: Space.u * 1.5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${m.home.name} ${m.homeGoals}–${m.awayGoals} ${m.away.name}',
                    style: Txt.ui(17, weight: FontWeight.w700, height: 1.25)),
                const SizedBox(height: 4),
                Text(
                  pick != null
                      ? 'Tu pronóstico: ${pick.home}–${pick.away}'
                      : (picks != null ? 'No pronosticaste' : m.stage),
                  style: Txt.ui(14, color: Palette.ink2),
                ),
              ],
            ),
          ),
          if (pick != null) Text('+${pick.pointsFor(m)}', style: Txt.display(28)),
        ],
      ),
    );
  }

  Widget _ranking(List<RankingRow> rows) {
    if (rows.isEmpty) {
      return const EmptyNote('Todavía no hay puntos.', 'El ranking arranca cuando termine el primer partido con pronósticos.');
    }
    final num = Txt.ui(15).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
    return Table(
      columnWidths: const {0: FixedColumnWidth(32), 1: FlexColumnWidth(), 2: FixedColumnWidth(70), 3: FixedColumnWidth(44)},
      children: [
        TableRow(
          decoration: const BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Palette.ink))),
          children: [
            for (final (t, a) in [('#', TextAlign.left), ('HINCHA', TextAlign.left), ('EXACTOS', TextAlign.right), ('PTS', TextAlign.right)])
              Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(t, textAlign: a, style: Txt.label(11))),
          ],
        ),
        for (final (i, r) in rows.indexed)
          TableRow(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.ruleSoft))),
            children: [
              for (final (t, a, s) in [
                ('${i + 1}', TextAlign.left, num),
                (r.username, TextAlign.left, Txt.ui(15, weight: FontWeight.w600)),
                ('${r.exactHits}', TextAlign.right, num),
                ('${r.points}', TextAlign.right, num.copyWith(fontWeight: FontWeight.w800)),
              ])
                Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(t, textAlign: a, style: s)),
            ],
          ),
      ],
    );
  }
}

/// Un renglón de la boleta: los dos casilleros de goles y guardar.
class _PickCard extends StatefulWidget {
  const _PickCard({super.key, required this.match, required this.competition, required this.userId, required this.saved});

  final Match match;
  final String competition;
  final String? userId;
  final Pick? saved;

  @override
  State<_PickCard> createState() => _PickCardState();
}

class _PickCardState extends State<_PickCard> {
  late final _home = TextEditingController(text: widget.saved?.home.toString() ?? '');
  late final _away = TextEditingController(text: widget.saved?.away.toString() ?? '');
  late Pick? _saved = widget.saved;
  bool _pending = false;
  String? _message;
  bool _ok = false;

  @override
  void dispose() {
    _home.dispose();
    _away.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final h = int.tryParse(_home.text), a = int.tryParse(_away.text);
    if (h == null || a == null || h > 20 || a > 20) {
      setState(() {
        _ok = false;
        _message = 'Completá los dos casilleros con un número de 0 a 20.';
      });
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _pending = true);
    try {
      // Las reglas de la base solo aceptan pronósticos propios y antes de que empiece el partido.
      await Repo.savePick(widget.userId!, widget.match.id, Pick(h, a));
      setState(() {
        _pending = false;
        _saved = Pick(h, a);
        _ok = true;
        _message = 'Guardado: $h a $a.';
      });
    } on PostgrestException {
      setState(() {
        _pending = false;
        _ok = false;
        _message = 'No se pudo guardar: el partido ya empezó o se cerró.';
      });
    } catch (_) {
      setState(() {
        _pending = false;
        _ok = false;
        _message = 'No hay conexión. Probá de nuevo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.match;
    final enabled = widget.userId != null;
    Widget team(TeamRef t, TextAlign align) => Expanded(
          child: Text(t.name,
              textAlign: align,
              style: Txt.ui(16, weight: FontWeight.w700, color: t.isRiver ? Palette.red : Palette.ink, height: 1.2)),
        );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Space.u * 2.5),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.ruleSoft))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(child: Text('${widget.competition} · ${m.stage}', style: Txt.ui(13, color: Palette.ink2))),
            Text('${shortDay(m.kickoff)} · ', style: Txt.ui(13, color: Palette.ink2)),
            TimeTag(m),
          ]),
          const SizedBox(height: Space.u * 1.5),
          Row(children: [
            team(m.home, TextAlign.left),
            const SizedBox(width: Space.u),
            _GoalBox(controller: _home, enabled: enabled, label: 'Goles de ${m.home.name}'),
            const SizedBox(width: 6),
            _GoalBox(controller: _away, enabled: enabled, label: 'Goles de ${m.away.name}'),
            const SizedBox(width: Space.u),
            team(m.away, TextAlign.right),
          ]),
          if (enabled || _saved != null) ...[
            const SizedBox(height: Space.u * 1.5),
            Row(children: [
              Expanded(
                child: _message != null
                    ? Text(_message!,
                        style: Txt.ui(14, weight: FontWeight.w600, color: _ok ? Palette.ink : Palette.redDeep))
                    : (_saved != null ? const Align(alignment: Alignment.centerLeft, child: Stamp('Pronóstico cargado')) : const SizedBox()),
              ),
              if (enabled)
                _saved != null
                    ? OutlinedButton(onPressed: _pending ? null : _save, child: Text(_pending ? 'GUARDANDO…' : 'CAMBIAR'))
                    : FilledButton(onPressed: _pending ? null : _save, child: Text(_pending ? 'GUARDANDO…' : 'GUARDAR')),
            ]),
          ],
        ],
      ),
    );
  }
}

class _GoalBox extends StatelessWidget {
  const _GoalBox({required this.controller, required this.enabled, required this.label});

  final TextEditingController controller;
  final bool enabled;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 52,
      child: Semantics(
        label: label,
        child: TextField(
          controller: controller,
          enabled: enabled,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
          style: Txt.display(28).copyWith(fontFeatures: const [FontFeature.tabularFigures()], height: 1),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            filled: true,
            fillColor: enabled ? Palette.paper : Palette.sheet,
            disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Palette.ruleSoft)),
          ),
        ),
      ),
    );
  }
}
