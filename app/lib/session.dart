import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data.dart';

class CurrentUser {
  const CurrentUser(this.id, this.username);

  final String id;
  final String username;
}

/// Quién está logueado, para toda la app. Se actualiza solo al entrar o salir.
class AppSession extends ChangeNotifier {
  AppSession() {
    _sub = db.auth.onAuthStateChange.listen((state) => _load(state.session?.user));
    _load(db.auth.currentUser);
  }

  late final StreamSubscription<AuthState> _sub;
  CurrentUser? user;
  bool ready = false;

  Future<void> _load(User? authUser) async {
    if (authUser == null) {
      user = null;
    } else {
      String? name;
      try {
        name = await Repo.username(authUser.id);
      } catch (_) {
        name = null;
      }
      user = CurrentUser(authUser.id, name ?? authUser.email?.split('@').first ?? 'hincha');
    }
    ready = true;
    notifyListeners();
  }

  Future<void> signOut() => db.auth.signOut();

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

/// Acceso a la sesión desde cualquier pantalla: `SessionScope.of(context)`.
class SessionScope extends InheritedNotifier<AppSession> {
  const SessionScope({super.key, required AppSession session, required super.child}) : super(notifier: session);

  static AppSession of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<SessionScope>()!.notifier!;
}
