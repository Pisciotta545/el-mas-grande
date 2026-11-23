import 'package:flutter/material.dart';

import '../data.dart';
import '../format.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'interview_screen.dart';

typedef _HomeData = ({List<Interview> interviews, List<Match> matches, List<Competition> competitions});

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onOpenProde});

  final VoidCallback onOpenProde;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<_HomeData> _future = _load();

  Future<_HomeData> _load() async {
    final r = await (Repo.interviews(), Repo.matches(), Repo.competitions()).wait;
    return (interviews: r.$1, matches: r.$2, competitions: r.$3);
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return TabPage(
      header: const Masthead(),
      onRefresh: _refresh,
      children: [
        Loaded<_HomeData>(
          future: _future,
          onRetry: _refresh,
          builder: (context, d) {
            final lead = d.interviews.where((i) => i.featured).firstOrNull ?? d.interviews.firstOrNull;
            final more = d.interviews.where((i) => i != lead).take(3).toList();
            final next = d.matches.where((m) => m.scheduled).firstOrNull;
            final comp = d.competitions.where((c) => c.id == next?.competitionId).firstOrNull;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (next != null) _NextMatch(match: next, competition: comp, onProde: widget.onOpenProde),
                if (lead != null) ...[const SizedBox(height: Space.u * 5), _Lead(lead)],
                if (more.isNotEmpty) ...[
                  const SizedBox(height: Space.u * 5),
                  SectionHead(
                    'Más entrevistas',
                    action: 'Ver todas',
                    onAction: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => InterviewsScreen(d.interviews))),
                  ),
                  InterviewList(more),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Próximo partido como renglón de boleta: franja roja, día grande, rival, copa y la acción del prode.
class _NextMatch extends StatelessWidget {
  const _NextMatch({required this.match, required this.competition, required this.onProde});

  final Match match;
  final Competition? competition;
  final VoidCallback onProde;

  @override
  Widget build(BuildContext context) {
    final teamStyle = Txt.heading(30);
    Text team(TeamRef t) => Text(t.name.toUpperCase(), style: t.isRiver ? teamStyle.copyWith(color: Palette.red) : teamStyle);
    return Container(
      padding: const EdgeInsets.only(top: Space.u * 2),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.red, width: Space.band))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: Space.u * 1.5),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.ink))),
            child: Text('PRÓXIMO PARTIDO', style: Txt.heading(22)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: Space.u * 2.5),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.ruleSoft))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 84, child: DateBlock(match.kickoff, size: 72)),
                const SizedBox(width: Space.u * 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      team(match.home),
                      Text('contra', style: Txt.ui(14, weight: FontWeight.w700, color: Palette.ink2)),
                      team(match.away),
                      const SizedBox(height: Space.u * 1.5),
                      TimeTag(match),
                      const SizedBox(height: 6),
                      Text('${competition?.name ?? ''} · ${match.stage}', style: Txt.ui(14, color: Palette.ink2)),
                      Text(match.venue ?? 'Estadio a confirmar', style: Txt.ui(14, color: Palette.ink2)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Space.u * 2),
          OutlinedButton.icon(
            onPressed: onProde,
            icon: const Icon(Icons.arrow_forward, size: 18),
            iconAlignment: IconAlignment.end,
            label: const Text('PRONOSTICAR EN EL PRODE'),
          ),
        ],
      ),
    );
  }
}

class _Lead extends StatelessWidget {
  const _Lead(this.interview);

  final Interview interview;

  @override
  Widget build(BuildContext context) {
    final i = interview;
    void open() => Navigator.of(context).push(MaterialPageRoute(builder: (_) => InterviewScreen(i)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(onTap: open, child: Text(i.title.toUpperCase(), style: Txt.heading(36))),
        const SizedBox(height: Space.u * 2),
        Text(i.dek, style: Txt.read(18, height: 1.5)),
        const SizedBox(height: Space.u * 2),
        Text.rich(TextSpan(style: Txt.ui(14, color: Palette.ink2), children: [
          TextSpan(text: i.interviewee, style: Txt.ui(14, weight: FontWeight.w700)),
          TextSpan(text: ', ${i.intervieweeRole} · ${fullDate(i.publishedAt)}'),
        ])),
        const SizedBox(height: Space.u * 2.5),
        FilledButton.icon(
          onPressed: open,
          icon: const Icon(Icons.arrow_forward, size: 18),
          iconAlignment: IconAlignment.end,
          label: const Text('LEER LA ENTREVISTA'),
        ),
      ],
    );
  }
}
