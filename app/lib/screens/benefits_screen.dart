import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data.dart';
import '../format.dart';
import '../models.dart';
import '../session.dart';
import '../theme.dart';
import '../widgets.dart';
import 'auth_screen.dart';

/// Descuentos exclusivos y sorteos de entradas, en una sola pestaña.
class BenefitsScreen extends StatefulWidget {
  const BenefitsScreen({super.key});

  @override
  State<BenefitsScreen> createState() => _BenefitsScreenState();
}

class _BenefitsScreenState extends State<BenefitsScreen> {
  bool _raffles = false;
  late Future<List<Discount>> _discounts = Repo.discounts();
  late Future<List<Raffle>> _raffleList = Repo.raffles();
  Future<Map<int, String>>? _codes;
  Future<Set<int>>? _entries;
  String? _loadedFor;

  Future<void> _refresh() async {
    setState(() {
      _discounts = Repo.discounts();
      _raffleList = Repo.raffles();
      _loadedFor = null;
    });
    await Future.wait([_discounts, _raffleList]);
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final user = session.user;
    if (user?.id != _loadedFor) {
      _loadedFor = user?.id;
      _codes = user == null ? null : Repo.discountCodes();
      _entries = user == null ? null : Repo.myRaffles(user.id);
    }

    return TabPage(
      header: const Masthead(title: 'Beneficios'),
      onRefresh: _refresh,
      children: [
        _toggle(),
        const SizedBox(height: Space.u * 3),
        if (!_raffles) ...[
          Text('Beneficios en comercios para los que tienen cuenta. Mostrá o pegá el código y listo.',
              style: Txt.ui(16, color: Palette.ink2)),
          const SizedBox(height: Space.u * 2),
          Loaded<List<Discount>>(
            future: _discounts,
            onRetry: _refresh,
            builder: (context, list) => FutureBuilder<Map<int, String>>(
              future: _codes,
              builder: (context, snap) => Column(children: [
                for (final d in list) _discount(d, user != null, snap.data, session.ready),
              ]),
            ),
          ),
          const Note('Comercios y códigos de ejemplo: todavía no hay convenios reales.'),
        ] else ...[
          Text('Sorteamos entradas entre los que tienen cuenta. Te anotás con un toque y, si ganás, te escribimos.',
              style: Txt.ui(16, color: Palette.ink2)),
          const SizedBox(height: Space.u * 2),
          Loaded<List<Raffle>>(
            future: _raffleList,
            onRetry: _refresh,
            builder: (context, list) => FutureBuilder<Set<int>>(
              future: _entries,
              builder: (context, snap) => Column(children: [
                for (final r in list)
                  _RaffleRow(
                    key: ValueKey('${r.id}-${user?.id}-${snap.data?.contains(r.id)}'),
                    raffle: r,
                    userId: user?.id,
                    joined: snap.data?.contains(r.id),
                    ready: session.ready && (user == null || snap.hasData),
                  ),
              ]),
            ),
          ),
          const Note('Sorteos de ejemplo: todavía no se entregan entradas reales.'),
        ],
      ],
    );
  }

  Widget _toggle() {
    Widget tab(String text, bool selected, VoidCallback onTap) => Expanded(
          child: Semantics(
            selected: selected,
            button: true,
            child: InkWell(
              onTap: onTap,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                color: selected ? Palette.ink : Palette.paper,
                child: Text(text, style: Txt.label(14, color: selected ? Palette.paper : Palette.ink)),
              ),
            ),
          ),
        );
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Palette.ink)),
      child: Row(children: [
        tab('DESCUENTOS', !_raffles, () => setState(() => _raffles = false)),
        tab('SORTEOS', _raffles, () => setState(() => _raffles = true)),
      ]),
    );
  }

  Widget _discount(Discount d, bool loggedIn, Map<int, String>? codes, bool ready) {
    Widget slot;
    if (!ready || (loggedIn && codes == null)) {
      slot = Text('Cargando código…', style: Txt.ui(14, color: Palette.ink2));
    } else if (!loggedIn) {
      slot = LockedButton('Ingresá para ver el código', onTap: () => openAuth(context));
    } else if (codes![d.id] case final code?) {
      slot = _CodeBox(code);
    } else {
      slot = Text('Código no disponible', style: Txt.ui(14, color: Palette.ink2));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: Space.u * 2.5),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.ruleSoft))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(d.title, style: Txt.ui(21, weight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: 6),
          Text(d.description, style: Txt.ui(15, color: Palette.ink2)),
          const SizedBox(height: Space.u),
          Text.rich(TextSpan(style: Txt.ui(14, weight: FontWeight.w700), children: [
            TextSpan(text: d.merchant),
            TextSpan(text: ' · ${d.category}', style: Txt.ui(14, color: Palette.ink2)),
          ])),
          const SizedBox(height: Space.u * 1.5),
          slot,
          const SizedBox(height: 6),
          Text('Vale hasta el ${plainDate(d.validUntil)}', style: Txt.ui(13, color: Palette.ink2)),
        ],
      ),
    );
  }
}

class _CodeBox extends StatelessWidget {
  const _CodeBox(this.code);

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Palette.ink)),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SelectableText(code, style: Txt.heading(22).copyWith(letterSpacing: 1)),
            ),
          ),
          Container(
            decoration: const BoxDecoration(border: Border(left: BorderSide(color: Palette.ink))),
            child: TextButton.icon(
              style: TextButton.styleFrom(minimumSize: const Size(0, 48), padding: const EdgeInsets.symmetric(horizontal: 14)),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: code));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Código $code copiado')));
                }
              },
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('COPIAR'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RaffleRow extends StatefulWidget {
  const _RaffleRow({super.key, required this.raffle, required this.userId, required this.joined, required this.ready});

  final Raffle raffle;
  final String? userId;
  final bool? joined;
  final bool ready;

  @override
  State<_RaffleRow> createState() => _RaffleRowState();
}

class _RaffleRowState extends State<_RaffleRow> {
  late bool? _joined = widget.joined;
  bool _pending = false;
  String? _error;

  Future<void> _toggle(bool join) async {
    setState(() {
      _pending = true;
      _error = null;
    });
    try {
      join
          ? await Repo.joinRaffle(widget.userId!, widget.raffle.id)
          : await Repo.leaveRaffle(widget.userId!, widget.raffle.id);
      setState(() {
        _pending = false;
        _joined = join;
      });
    } catch (_) {
      setState(() {
        _pending = false;
        _error = 'No se pudo: el sorteo ya cerró o no hay conexión.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.raffle;
    Widget action;
    if (!widget.ready) {
      action = Text('Cargando…', style: Txt.ui(14, color: Palette.ink2));
    } else if (!r.open) {
      action = Text(_joined == true ? 'Participaste. Sorteo cerrado.' : 'Sorteo cerrado',
          style: Txt.ui(15, weight: FontWeight.w600, color: Palette.ink2));
    } else if (widget.userId == null) {
      action = LockedButton('Ingresá para participar', onTap: () => openAuth(context));
    } else if (_joined == true) {
      action = Row(children: [
        const Expanded(child: Align(alignment: Alignment.centerLeft, child: Stamp('Estás participando'))),
        OutlinedButton(onPressed: _pending ? null : () => _toggle(false), child: const Text('BAJARME')),
      ]);
    } else {
      action = SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: _pending ? null : () => _toggle(true),
          icon: const Icon(Icons.confirmation_number_outlined, size: 18),
          label: const Text('PARTICIPAR'),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: Space.u * 2.5),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Palette.ruleSoft))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(r.title, style: Txt.ui(21, weight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: 6),
          Text(r.description, style: Txt.ui(15, color: Palette.ink2)),
          const SizedBox(height: Space.u),
          Text.rich(TextSpan(style: Txt.ui(14, weight: FontWeight.w700), children: [
            TextSpan(text: '${r.prizeCount} ${r.prizeCount == 1 ? 'entrada' : 'entradas'}'),
            if (r.stage != null) TextSpan(text: ' · ${r.stage}', style: Txt.ui(14, color: Palette.ink2)),
          ])),
          const SizedBox(height: Space.u * 1.5),
          action,
          if (_error != null) ...[
            const SizedBox(height: 6),
            Text(_error!, style: Txt.ui(14, weight: FontWeight.w600, color: Palette.redDeep)),
          ],
          const SizedBox(height: 6),
          Text('Cierra el ${longDay(r.closesAt)}, ${hour(r.closesAt)} h', style: Txt.ui(13, color: Palette.ink2)),
        ],
      ),
    );
  }
}
