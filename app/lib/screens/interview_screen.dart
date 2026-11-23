import 'package:flutter/material.dart';

import '../format.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

/// La entrevista para leer: preguntas en Archivo, respuestas en serif.
class InterviewScreen extends StatelessWidget {
  const InterviewScreen(this.interview, {super.key});

  final Interview interview;

  @override
  Widget build(BuildContext context) {
    final i = interview;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Masthead(
            title: 'Entrevista',
            trailing: IconButton(
              tooltip: 'Volver',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Palette.ink),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.gutter, Space.u * 4, Space.gutter, Space.u * 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(i.title.toUpperCase(), style: Txt.heading(34)),
                const SizedBox(height: Space.u * 2.5),
                Text(i.dek, style: Txt.read(20, height: 1.45)),
                const SizedBox(height: Space.u * 2.5),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: Space.u * 1.5),
                  decoration: const BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide(color: Palette.ink)),
                  ),
                  child: Text.rich(
                    TextSpan(style: Txt.ui(14, color: Palette.ink2), children: [
                      TextSpan(text: i.interviewee, style: Txt.ui(14, weight: FontWeight.w700)),
                      TextSpan(text: ', ${i.intervieweeRole}\nPor ${i.author} · ${fullDate(i.publishedAt)}'),
                    ]),
                  ),
                ),
                if (i.isSample) ...[
                  const SizedBox(height: Space.u * 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(border: Border.all(color: Palette.ink2)),
                    child: Text('Entrevista de ejemplo: la persona es ficticia',
                        style: Txt.ui(13, weight: FontWeight.w600, color: Palette.ink2)),
                  ),
                ],
                for (final (n, qa) in i.body.indexed) ...[
                  SizedBox(height: n == 0 ? Space.u * 4 : Space.u * 4),
                  Text(qa.q, style: Txt.ui(19, weight: FontWeight.w800, height: 1.35)),
                  const SizedBox(height: Space.u * 1.5),
                  Text(qa.a, style: Txt.read(18, height: 1.65)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Lista de entrevistas, en filas.
class InterviewList extends StatelessWidget {
  const InterviewList(this.items, {super.key});

  final List<Interview> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final i in items)
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => InterviewScreen(i))),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: Space.u * 2.5),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.ruleSoft))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(i.title, style: Txt.ui(20, weight: FontWeight.w800, height: 1.2)),
                  const SizedBox(height: 6),
                  Text(i.dek, style: Txt.read(16, color: Palette.ink2, height: 1.5)),
                  const SizedBox(height: Space.u),
                  Text.rich(TextSpan(style: Txt.ui(14, color: Palette.ink2), children: [
                    TextSpan(text: i.interviewee, style: Txt.ui(14, weight: FontWeight.w700)),
                    TextSpan(text: ', ${i.intervieweeRole} · ${fullDate(i.publishedAt)}'),
                  ])),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class InterviewsScreen extends StatelessWidget {
  const InterviewsScreen(this.items, {super.key});

  final List<Interview> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Masthead(
            title: 'Entrevistas',
            trailing: IconButton(
              tooltip: 'Volver',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Palette.ink),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.gutter, Space.u * 2, Space.gutter, Space.u * 6),
            child: Column(children: [
              InterviewList(items),
              const Note('Las entrevistas publicadas por ahora son de ejemplo: las personas son ficticias.'),
            ]),
          ),
        ],
      ),
    );
  }
}
