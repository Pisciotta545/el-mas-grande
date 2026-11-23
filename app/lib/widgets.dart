import 'package:flutter/material.dart';

import 'format.dart';
import 'models.dart';
import 'theme.dart';

/// La banda roja: cruza de arriba a la izquierda hacia abajo a la derecha, como la camiseta vista de frente.
class BandPainter extends CustomPainter {
  const BandPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = Path()
      ..moveTo(0, h * 0.18)
      ..lineTo(0, h * 0.52)
      ..lineTo(w, h)
      ..lineTo(w, h * 0.66)
      ..close();
    canvas.drawPath(path, Paint()..color = Palette.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Encabezado con la banda. En Inicio va el wordmark grande; en las otras pestañas, el nombre de la sección.
class Masthead extends StatelessWidget {
  const Masthead({super.key, this.title, this.trailing});

  final String? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final isHome = title == null;
    return Container(
      decoration: const BoxDecoration(
        color: Palette.paper,
        border: Border(bottom: BorderSide(color: Palette.ink)),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: BandPainter())),
          Padding(
            padding: EdgeInsets.fromLTRB(Space.gutter, top + Space.u * 2, Space.gutter, Space.u * 2.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (title ?? 'El más grande').toUpperCase(),
                        style: Txt.display(isHome ? 56 : 44),
                      ),
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Título de sección con la franja roja de 10 px debajo.
class SectionHead extends StatelessWidget {
  const SectionHead(this.title, {super.key, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Space.u * 2),
      padding: const EdgeInsets.only(bottom: Space.u * 1.5),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.red, width: Space.band))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: Text(title.toUpperCase(), style: Txt.heading(34))),
          if (action != null)
            InkWell(
              onTap: onAction,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                child: Text(
                  action!.toUpperCase(),
                  style: Txt.label(14, color: Palette.ink).copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// El casillero cuadrado: vacío, o marcado en rojo.
class BoxMark extends StatelessWidget {
  const BoxMark({super.key, required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: on ? Palette.red : Palette.paper,
        border: Border.all(color: on ? Palette.red : Palette.ink),
      ),
      child: on ? const Icon(Icons.check, size: 15, color: Colors.white, weight: 800) : null,
    );
  }
}

/// Sello rojo inclinado: "Pronóstico cargado", "Estás participando".
class Stamp extends StatelessWidget {
  const Stamp(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.035,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(border: Border.all(color: Palette.red, width: 2)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, size: 14, color: Palette.red),
            const SizedBox(width: 6),
            Text(text.toUpperCase(), style: Txt.label(12, color: Palette.red).copyWith(letterSpacing: 0.8)),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Palette.ink2
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    const dash = 3.0, gap = 2.0;
    void line(Offset a, Offset b) {
      final total = (b - a).distance;
      final dir = (b - a) / total;
      for (var d = 0.0; d < total; d += dash + gap) {
        canvas.drawLine(a + dir * d, a + dir * (d + dash).clamp(0, total), paint);
      }
    }

    final r = Offset.zero & size;
    line(r.topLeft, r.topRight);
    line(r.topRight, r.bottomRight);
    line(r.bottomRight, r.bottomLeft);
    line(r.bottomLeft, r.topLeft);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Hora confirmada en trazo sólido; a confirmar, en punteado.
class TimeTag extends StatelessWidget {
  const TimeTag(this.match, {super.key});

  final Match match;

  @override
  Widget build(BuildContext context) {
    if (match.timeConfirmed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(border: Border.all(color: Palette.ink)),
        child: Text('${hour(match.kickoff)} h', style: Txt.label(12, color: Palette.ink)),
      );
    }
    return CustomPaint(
      painter: const _DashedBorderPainter(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text('HORA A CONFIRMAR', style: Txt.label(11)),
      ),
    );
  }
}

/// "River Plate – Racing Club", con River en rojo.
class Teams extends StatelessWidget {
  const Teams(this.match, {super.key, this.style});

  final Match match;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base = style ?? Txt.ui(18, weight: FontWeight.w700, height: 1.25);
    TextSpan team(TeamRef t) => TextSpan(text: t.name, style: t.isRiver ? base.copyWith(color: Palette.red) : base);
    return Text.rich(TextSpan(children: [team(match.home), TextSpan(text: ' – ', style: base), team(match.away)]));
  }
}

/// La fecha de la boleta: día grande, día de semana y mes apilados. Tachada en rojo si ya se jugó.
class DateBlock extends StatelessWidget {
  const DateBlock(this.date, {super.key, this.struck = false, this.size = 38});

  final DateTime date;
  final bool struck;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = dateParts(date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          p.day,
          style: Txt.display(size).copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
            decoration: struck ? TextDecoration.lineThrough : null,
            decorationColor: Palette.red,
            decorationThickness: 3,
          ),
        ),
        const SizedBox(height: 4),
        Text(p.weekday.toUpperCase(), style: Txt.label(11)),
        Text(p.month.toUpperCase(), style: Txt.label(11)),
      ],
    );
  }
}

/// Un renglón de la boleta de partidos.
class MatchRowTile extends StatelessWidget {
  const MatchRowTile(this.match, {super.key, this.competition});

  final Match match;
  final String? competition;

  @override
  Widget build(BuildContext context) {
    final meta = [?competition, match.stage, ?match.venue].join(' · ');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Space.u * 1.75),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.ruleSoft))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 60, child: DateBlock(match.kickoff, struck: match.finished)),
          const SizedBox(width: Space.u * 1.5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Teams(match),
                const SizedBox(height: 4),
                Text(meta, style: Txt.ui(14, color: Palette.ink2)),
                const SizedBox(height: Space.u),
                if (match.finished)
                  Text('${match.homeGoals}–${match.awayGoals}', style: Txt.display(28))
                else
                  TimeTag(match),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Aviso para lo que pide cuenta, con el botón para ingresar.
class Gate extends StatelessWidget {
  const Gate({super.key, required this.title, required this.text, required this.onLogin});

  final String title;
  final String text;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Space.u * 3),
      padding: const EdgeInsets.all(Space.u * 2.5),
      decoration: BoxDecoration(color: Palette.sheet, border: Border.all(color: Palette.ink)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Txt.ui(20, weight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: Space.u),
          Text(text, style: Txt.ui(15)),
          const SizedBox(height: Space.u * 2),
          FilledButton.icon(
            onPressed: onLogin,
            icon: const Icon(Icons.lock_outline, size: 18),
            label: const Text('INGRESAR O CREAR CUENTA'),
          ),
        ],
      ),
    );
  }
}

/// Botón con candado para lo que pide cuenta, en línea.
class LockedButton extends StatelessWidget {
  const LockedButton(this.text, {super.key, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CustomPaint(
        painter: const _DashedBorderPainter(),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 16, color: Palette.ink2),
              const SizedBox(width: Space.u),
              Text(text, style: Txt.ui(14, weight: FontWeight.w600, color: Palette.ink2)),
            ],
          ),
        ),
      ),
    );
  }
}

class Note extends StatelessWidget {
  const Note(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: Space.u * 2),
        child: Text(text, style: Txt.ui(13, color: Palette.ink2)),
      );
}

class EmptyNote extends StatelessWidget {
  const EmptyNote(this.title, this.text, {super.key});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: Space.u * 4, horizontal: Space.u * 2),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.ruleSoft))),
        child: Column(
          children: [
            Text(title, textAlign: TextAlign.center, style: Txt.ui(16, weight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(text, textAlign: TextAlign.center, style: Txt.ui(15, color: Palette.ink2)),
          ],
        ),
      );
}

/// Carga, error con reintento, o el contenido.
class Loaded<T> extends StatelessWidget {
  const Loaded({super.key, required this.future, required this.builder, required this.onRetry});

  final Future<T> future;
  final Widget Function(BuildContext, T) builder;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snap) {
        if (snap.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.u * 4),
            child: Column(
              children: [
                Text('No pudimos cargar los datos.', style: Txt.ui(16, weight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Revisá tu conexión y probá de nuevo.', style: Txt.ui(15, color: Palette.ink2)),
                const SizedBox(height: Space.u * 2),
                OutlinedButton(onPressed: onRetry, child: const Text('REINTENTAR')),
              ],
            ),
          );
        }
        if (!snap.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: Space.u * 6),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return builder(context, snap.data as T);
      },
    );
  }
}

/// Cuerpo con scroll estándar de cada pestaña: encabezado con banda y deslizar para actualizar.
class TabPage extends StatelessWidget {
  const TabPage({super.key, required this.header, required this.onRefresh, required this.children});

  final Widget header;
  final Future<void> Function() onRefresh;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Palette.red,
      onRefresh: onRefresh,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          header,
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.gutter, Space.u * 3, Space.gutter, Space.u * 4),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
          ),
        ],
      ),
    );
  }
}
