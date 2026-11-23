import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config.dart';
import 'screens/benefits_screen.dart';
import 'screens/home_screen.dart';
import 'screens/matches_screen.dart';
import 'screens/more_screen.dart';
import 'screens/prode_screen.dart';
import 'session.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_AR');
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabasePublishableKey);
  runApp(ElMasGrandeApp(session: AppSession()));
}

class ElMasGrandeApp extends StatelessWidget {
  const ElMasGrandeApp({super.key, required this.session});

  final AppSession session;

  @override
  Widget build(BuildContext context) {
    return SessionScope(
      session: session,
      child: MaterialApp(
        title: 'El más grande',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        locale: const Locale('es', 'AR'),
        supportedLocales: const [Locale('es', 'AR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: const AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Palette.paper,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Shell(),
        ),
      ),
    );
  }
}

/// Las cinco pestañas. Cada una conserva su scroll y sus filtros al cambiar.
class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [
          HomeScreen(onOpenProde: () => setState(() => _tab = 2)),
          const MatchesScreen(),
          const ProdeScreen(),
          const BenefitsScreen(),
          const MoreScreen(),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.ink))),
        child: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.article_outlined), selectedIcon: Icon(Icons.article), label: 'INICIO'),
            NavigationDestination(
                icon: Icon(Icons.sports_soccer_outlined), selectedIcon: Icon(Icons.sports_soccer), label: 'PARTIDOS'),
            NavigationDestination(
                icon: Icon(Icons.edit_note_outlined), selectedIcon: Icon(Icons.edit_note), label: 'PRODE'),
            NavigationDestination(
                icon: Icon(Icons.local_offer_outlined), selectedIcon: Icon(Icons.local_offer), label: 'BENEFICIOS'),
            NavigationDestination(icon: Icon(Icons.menu), selectedIcon: Icon(Icons.menu), label: 'MÁS'),
          ],
        ),
      ),
    );
  }
}
