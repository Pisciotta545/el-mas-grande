import 'package:flutter/material.dart';

import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

typedef _MatchData = ({List<Match> matches, List<StandingRow> standings, List<Competition> competitions});

String _fold(String s) {
  const from = 'áéíóúüñÁÉÍÓÚÜÑ', to = 'aeiouunAEIOUUN';
  final out = StringBuffer();
  for (final ch in s.split('')) {
    final i = from.indexOf(ch);
    out.write(i >= 0 ? to[i] : ch);
  }
  return out.toString().toLowerCase();
}

/// Partidos de River con buscador y filtro por copa; la tabla sigue a la copa elegida.
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  late Future<_MatchData> _future = _load();
  final _search = TextEditingController();
  String _comp = 'all';
  bool _showPlayed = false;

  Future<_MatchData> _load() async {
    final r = await (Repo.matches(), Repo.standings(), Repo.competitions()).wait;
    return (matches: r.$1, standings: r.$2, competitions: r.$3);
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabPage(
      header: const Masthead(title: 'Partidos'),
      onRefresh: _refresh,
      children: [
        Loaded<_MatchData>(future: _future, onRetry: _refresh, builder: _content),
      ],
    );
  }

  Widget _content(BuildContext context, _MatchData d) {
    final names = {for (final c in d.competitions) c.id: c.name};
    final q = _fold(_search.text.trim());
    var list = d.matches.where((m) {
      if (!_showPlayed && m.finished) return false;
      if (_comp != 'all' && m.competitionId != _comp) return false;
      if (q.isEmpty) return true;
      return _fold([m.home.name, m.away.name, m.stage, m.venue ?? '', names[m.competitionId] ?? ''].join(' '))
          .contains(q);
    }).toList();
    if (_showPlayed) {
      list = [...list.where((m) => m.finished).toList().reversed, ...list.where((m) => !m.finished)];
    }

    final tableComp = _comp == 'all'
        ? d.competitions.where((c) => c.hasTable).firstOrNull
        : d.competitions.where((c) => c.id == _comp).firstOrNull;
    final table = d.standings.where((s) => s.competitionId == tableComp?.id).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _search,
          onChanged: (_) => setState(() {}),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Buscar por rival, estadio o fase',
            prefixIcon: const Icon(Icons.search, color: Palette.ink2),
            suffixIcon: _search.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Borrar búsqueda',
                    icon: const Icon(Icons.close, color: Palette.ink2),
                    onPressed: () => setState(_search.clear),
                  ),
          ),
        ),
        const SizedBox(height: Space.u * 2),
        Wrap(
          spacing: Space.u,
          runSpacing: Space.u,
          children: [
            for (final c in [(id: 'all', name: 'Todas'), ...d.competitions.map((c) => (id: c.id, name: c.name))])
              _Filter(label: c.name, on: _comp == c.id, onTap: () => setState(() => _comp = c.id)),
          ],
        ),
        const SizedBox(height: Space.u),
        InkWell(
          onTap: () => setState(() => _showPlayed = !_showPlayed),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.u),
            child: Row(
              children: [
                BoxMark(on: _showPlayed),
                const SizedBox(width: Space.u),
                Text('Mostrar también los partidos jugados', style: Txt.ui(15, color: Palette.ink2)),
              ],
            ),
          ),
        ),
        const SizedBox(height: Space.u),
        const Divider(color: Palette.ink, height: 1),
        if (list.isEmpty)
          EmptyNote('No hay partidos con ese filtro.',
              _search.text.isEmpty ? 'Probá con otra copa.' : 'Probá con otro nombre o borrá la búsqueda.')
        else
          for (final m in list) MatchRowTile(m, competition: names[m.competitionId]),
        const SizedBox(height: Space.u * 5),
        SectionHead(tableComp == null ? 'Tabla' : 'Tabla · ${tableComp.name}'),
        if (tableComp == null || !tableComp.hasTable)
          EmptyNote('${tableComp?.name ?? 'Esta copa'} no tiene tabla.',
              'Se juega por eliminación directa: el que gana pasa.')
        else ...[
          Text('${tableComp.name} ${tableComp.season} · ${tableComp.tableLabel ?? ''}',
              style: Txt.ui(15, weight: FontWeight.w700)),
          const SizedBox(height: Space.u * 1.5),
          _StandingsTable(table),
          if (table.every((r) => r.played == 0)) const Note('El grupo todavía no empezó: todos arrancan en cero.'),
        ],
        const Note('Fixture, resultados y tablas de prueba hasta conectar los datos oficiales.'),
      ],
    );
  }
}

class _Filter extends StatelessWidget {
  const _Filter({required this.label, required this.on, required this.onTap});

  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: on,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(left: 8, right: 12),
          decoration: BoxDecoration(border: Border.all(color: on ? Palette.ink : Palette.ruleSoft)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BoxMark(on: on),
              const SizedBox(width: Space.u),
              Text(label, style: Txt.ui(14, weight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StandingsTable extends StatelessWidget {
  const _StandingsTable(this.rows);

  final List<StandingRow> rows;

  @override
  Widget build(BuildContext context) {
    final num = Txt.ui(14).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
    Widget cell(String text, {TextStyle? style, TextAlign align = TextAlign.right}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
          child: Text(text, textAlign: align, style: style ?? num),
        );
    Widget head(String text, {TextAlign align = TextAlign.right}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text(text, textAlign: align, style: Txt.label(11)),
        );

    return Table(
      columnWidths: const {
        0: FixedColumnWidth(28),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(32),
        3: FixedColumnWidth(26),
        4: FixedColumnWidth(26),
        5: FixedColumnWidth(26),
        6: FixedColumnWidth(38),
        7: FixedColumnWidth(36),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: const BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Palette.ink))),
          children: [
            head('#', align: TextAlign.left),
            head('EQUIPO', align: TextAlign.left),
            head('PJ'),
            head('G'),
            head('E'),
            head('P'),
            head('DG'),
            head('PTS'),
          ],
        ),
        for (final r in rows)
          () {
            final river = r.team.isRiver;
            final color = river ? Colors.white : Palette.ink;
            final s = num.copyWith(color: color);
            final dg = r.goalDiff > 0 ? '+${r.goalDiff}' : '${r.goalDiff}';
            return TableRow(
              decoration: BoxDecoration(
                color: river ? Palette.red : null,
                border: Border(bottom: BorderSide(color: river ? Palette.red : Palette.ruleSoft)),
              ),
              children: [
                cell('${r.position}', style: s, align: TextAlign.left),
                cell(r.team.name, style: Txt.ui(14, weight: FontWeight.w600, color: color), align: TextAlign.left),
                cell('${r.played}', style: s),
                cell('${r.won}', style: s),
                cell('${r.drawn}', style: s),
                cell('${r.lost}', style: s),
                cell(dg, style: s),
                cell('${r.points}', style: s.copyWith(fontWeight: FontWeight.w800)),
              ],
            );
          }(),
      ],
    );
  }
}
