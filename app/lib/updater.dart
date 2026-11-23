import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'theme.dart';

/// Las versiones nuevas se publican como Releases de GitHub con el APK adjunto (ver app/publicar.ps1).
const _releasesApi = 'https://api.github.com/repos/Pisciotta545/el-mas-grande/releases/latest';

class UpdateInfo {
  const UpdateInfo({required this.version, required this.notes, required this.apkUrl, this.sha256});

  final String version;
  final String notes;
  final String apkUrl;
  final String? sha256;
}

/// "1.10.0" > "1.9.3". Ignora el número de build (+N) y la "v" del tag.
int compareVersions(String a, String b) {
  List<int> parts(String v) =>
      v.replaceFirst(RegExp(r'^v'), '').split('+').first.split('.').map((p) => int.tryParse(p) ?? 0).toList();
  final x = parts(a), y = parts(b);
  for (var i = 0; i < 3; i++) {
    final d = (i < x.length ? x[i] : 0) - (i < y.length ? y[i] : 0);
    if (d != 0) return d.sign;
  }
  return 0;
}

Future<String> installedVersion() async => (await PackageInfo.fromPlatform()).version;

/// Devuelve la versión nueva si hay una publicada; null si la instalada está al día.
Future<UpdateInfo?> checkForUpdate() async {
  if (kIsWeb || !Platform.isAndroid) return null;
  final res = await http
      .get(Uri.parse(_releasesApi), headers: {'Accept': 'application/vnd.github+json'})
      .timeout(const Duration(seconds: 10));
  if (res.statusCode != 200) return null;

  final release = jsonDecode(res.body) as Map<String, dynamic>;
  final tag = release['tag_name'] as String? ?? '';
  final assets = (release['assets'] as List? ?? []).cast<Map<String, dynamic>>();
  final apk = assets.where((a) => (a['name'] as String).endsWith('.apk')).firstOrNull;
  if (apk == null || compareVersions(tag, await installedVersion()) <= 0) return null;

  final digest = apk['digest'] as String?;
  return UpdateInfo(
    version: tag.replaceFirst(RegExp(r'^v'), ''),
    notes: (release['body'] as String? ?? '').trim(),
    apkUrl: apk['browser_download_url'] as String,
    sha256: digest != null && digest.startsWith('sha256:') ? digest.substring(7) : null,
  );
}

/// Busca una versión nueva y, si la hay, ofrece instalarla. `quiet`: no avisa si ya está al día.
Future<void> offerUpdate(BuildContext context, {bool quiet = true}) async {
  UpdateInfo? info;
  try {
    info = await checkForUpdate();
  } catch (_) {
    info = null;
    if (!quiet && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No pudimos buscar actualizaciones. Revisá la conexión.')));
    }
    return;
  }
  if (!context.mounted) return;
  if (info == null) {
    if (!quiet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Ya tenés la última versión.')));
    }
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Palette.paper,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    builder: (_) => _UpdateSheet(info!),
  );
}

class _UpdateSheet extends StatefulWidget {
  const _UpdateSheet(this.info);

  final UpdateInfo info;

  @override
  State<_UpdateSheet> createState() => _UpdateSheetState();
}

class _UpdateSheetState extends State<_UpdateSheet> {
  bool _downloading = false;
  double? _progress;
  String? _error;

  void _start() {
    setState(() {
      _downloading = true;
      _progress = 0;
      _error = null;
    });
    try {
      OtaUpdate()
          .execute(
            widget.info.apkUrl,
            destinationFilename: 'ElMasGrande-v${widget.info.version}.apk',
            sha256checksum: widget.info.sha256,
          )
          .listen(_onEvent, onError: (_) => _fail('No se pudo descargar la actualización. Probá de nuevo.'));
    } catch (_) {
      _fail('No se pudo descargar la actualización. Probá de nuevo.');
    }
  }

  void _onEvent(OtaEvent e) {
    if (!mounted) return;
    switch (e.status) {
      case OtaStatus.DOWNLOADING:
        setState(() => _progress = (double.tryParse(e.value ?? '') ?? 0) / 100);
      case OtaStatus.INSTALLING:
      case OtaStatus.INSTALLATION_DONE:
        // Android muestra su instalador; la app se reinicia sola con la versión nueva.
        Navigator.of(context).maybePop();
      case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
        _fail('Android no dejó instalar. Permití "Instalar apps desconocidas" para El más grande en Ajustes y '
            'probá de nuevo.');
      case OtaStatus.CHECKSUM_ERROR:
        _fail('El archivo se descargó dañado. Probá de nuevo.');
      case OtaStatus.ALREADY_RUNNING_ERROR:
        break;
      default:
        _fail('No se pudo descargar la actualización. Probá de nuevo.');
    }
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() {
      _downloading = false;
      _progress = null;
      _error = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Palette.red, width: Space.band))),
        padding: const EdgeInsets.fromLTRB(Space.gutter, Space.u * 3, Space.gutter, Space.u * 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('HAY UNA VERSIÓN NUEVA', style: Txt.heading(30)),
            const SizedBox(height: Space.u),
            Text('Versión ${info.version}. Se descarga y la instala Android, sin perder tu cuenta ni tus pronósticos.',
                style: Txt.ui(16, color: Palette.ink2)),
            if (info.notes.isNotEmpty) ...[
              const SizedBox(height: Space.u * 2),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 180),
                child: SingleChildScrollView(child: Text(info.notes, style: Txt.ui(15))),
              ),
            ],
            if (_downloading) ...[
              const SizedBox(height: Space.u * 3),
              Text('Descargando… ${((_progress ?? 0) * 100).round()} %', style: Txt.ui(15, weight: FontWeight.w700)),
              const SizedBox(height: Space.u),
              LinearProgressIndicator(
                value: _progress,
                minHeight: 10,
                color: Palette.red,
                backgroundColor: Palette.sheet,
                borderRadius: BorderRadius.zero,
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: Space.u * 2),
              Text(_error!, style: Txt.ui(15, weight: FontWeight.w600, color: Palette.redDeep)),
            ],
            const SizedBox(height: Space.u * 3),
            FilledButton.icon(
              onPressed: _downloading ? null : _start,
              icon: const Icon(Icons.system_update_alt, size: 18),
              label: Text(_downloading ? 'DESCARGANDO…' : 'ACTUALIZAR'),
            ),
            const SizedBox(height: Space.u),
            OutlinedButton(
              onPressed: _downloading ? null : () => Navigator.of(context).pop(),
              child: const Text('MÁS TARDE'),
            ),
          ],
        ),
      ),
    );
  }
}
