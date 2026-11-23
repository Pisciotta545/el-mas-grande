import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

/// Abre la pantalla de cuenta. Devuelve true si el hincha quedó logueado.
Future<bool> openAuth(BuildContext context) async =>
    await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const AuthScreen())) ?? false;

const _errors = {
  'Invalid login credentials': 'El correo o la contraseña no coinciden. Revisalos y probá de nuevo.',
  'Email not confirmed': 'Todavía no confirmaste el correo. Buscá el mail que te mandamos y tocá el enlace.',
  'User already registered': 'Ya hay una cuenta con ese correo. Probá ingresar.',
  'Database error saving new user': 'No pudimos crear la cuenta. Probá con otro nombre de hincha.',
};

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _signup = false;
  bool _pending = false;
  bool _hidePassword = true;
  String? _error;
  String? _usernameError;
  String? _sentTo;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _usernameError = null;
    });
    if (!_form.currentState!.validate()) return;
    setState(() => _pending = true);

    final email = _email.text.trim();
    final password = _password.text;
    try {
      if (!_signup) {
        await db.auth.signInWithPassword(email: email, password: password);
        if (mounted) Navigator.of(context).pop(true);
        return;
      }

      final username = _username.text.trim();
      if (!await Repo.usernameAvailable(username)) {
        setState(() {
          _pending = false;
          _usernameError = 'Ese nombre de hincha ya está en uso. Probá con otro.';
        });
        return;
      }
      final res = await db.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
        emailRedirectTo: '${webUrl}auth/callback/?next=/prode',
      );
      if (!mounted) return;
      if (res.session != null) {
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          _pending = false;
          _sentTo = email;
        });
      }
    } on AuthException catch (e) {
      setState(() {
        _pending = false;
        _error = _errors[e.message] ?? e.message;
      });
    } catch (_) {
      setState(() {
        _pending = false;
        _error = 'No hay conexión. Revisala y probá de nuevo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Masthead(
            title: 'Tu cuenta',
            trailing: IconButton(
              tooltip: 'Volver',
              onPressed: () => Navigator.of(context).pop(false),
              icon: const Icon(Icons.close, color: Palette.ink),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.gutter, Space.u * 3, Space.gutter, Space.u * 6),
            child: _sentTo != null ? _sent() : _formView(),
          ),
        ],
      ),
    );
  }

  Widget _sent() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Revisá tu correo', style: Txt.ui(22, weight: FontWeight.w800)),
          const SizedBox(height: Space.u),
          Text.rich(
            TextSpan(style: Txt.ui(16), children: [
              const TextSpan(text: 'Te mandamos un enlace a '),
              TextSpan(text: _sentTo, style: Txt.ui(16, weight: FontWeight.w700)),
              const TextSpan(
                  text: '. Tocalo para confirmar la cuenta y después volvé acá a ingresar con tu correo y contraseña.'),
            ]),
          ),
          const SizedBox(height: Space.u * 3),
          FilledButton(
            onPressed: () => setState(() {
              _sentTo = null;
              _signup = false;
            }),
            child: const Text('YA LA CONFIRMÉ, INGRESAR'),
          ),
        ],
      );

  Widget _formView() {
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Con la cuenta jugás al prode, participás de los sorteos y ves los códigos de descuento.',
            style: Txt.ui(16, color: Palette.ink2),
          ),
          const SizedBox(height: Space.u * 3),
          _tabs(),
          const SizedBox(height: Space.u * 3),
          if (_signup) ...[
            TextFormField(
              controller: _username,
              decoration: InputDecoration(
                labelText: 'Nombre de hincha',
                helperText: 'Es el que aparece en el ranking del prode. Letras, números, punto o guion bajo.',
                errorText: _usernameError,
              ),
              autofillHints: const [AutofillHints.nickname],
              onChanged: (_) => _usernameError == null ? null : setState(() => _usernameError = null),
              validator: (v) {
                final s = v?.trim() ?? '';
                if (s.length < 3 || s.length > 24) return 'Tiene que tener entre 3 y 24 caracteres.';
                if (!RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(s)) return 'Solo letras, números, punto o guion bajo.';
                return null;
              },
            ),
            const SizedBox(height: Space.u * 2),
          ],
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Correo'),
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            validator: (v) => (v ?? '').contains('@') ? null : 'Escribí un correo válido.',
          ),
          const SizedBox(height: Space.u * 2),
          TextFormField(
            controller: _password,
            obscureText: _hidePassword,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              helperText: _signup ? 'Mínimo 6 caracteres.' : null,
              suffixIcon: IconButton(
                tooltip: _hidePassword ? 'Mostrar contraseña' : 'Ocultar contraseña',
                onPressed: () => setState(() => _hidePassword = !_hidePassword),
                icon: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              ),
            ),
            autofillHints: [_signup ? AutofillHints.newPassword : AutofillHints.password],
            validator: (v) => (v ?? '').length >= 6 ? null : 'Mínimo 6 caracteres.',
            onFieldSubmitted: (_) => _submit(),
          ),
          if (_error != null) ...[
            const SizedBox(height: Space.u * 2),
            Text(_error!, style: Txt.ui(15, weight: FontWeight.w600, color: Palette.redDeep)),
          ],
          const SizedBox(height: Space.u * 3),
          FilledButton(
            onPressed: _pending ? null : _submit,
            child: Text(_pending ? 'UN MOMENTO…' : (_signup ? 'CREAR CUENTA' : 'INGRESAR')),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
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
        tab('INGRESAR', !_signup, () => setState(() => _signup = false)),
        tab('CREAR CUENTA', _signup, () => setState(() => _signup = true)),
      ]),
    );
  }
}
