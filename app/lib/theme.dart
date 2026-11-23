import 'package:flutter/material.dart';

/// Los mismos tokens que la web (ver DESIGN.md): blanco, tinta y un solo rojo.
abstract final class Palette {
  static const paper = Color(0xFFFFFFFF);
  static const sheet = Color(0xFFF2F3F4);
  static const ink = Color(0xFF111214);
  static const ink2 = Color(0xFF4A4E54);
  static const ruleSoft = Color(0xFFD3D6DA);
  static const red = Color(0xFFD2102A);
  static const redDeep = Color(0xFFA50C20);
}

/// Grilla de 8 px.
abstract final class Space {
  static const u = 8.0;
  static const gutter = 16.0;
  static const band = 10.0;
}

/// Archivo es variable: el ancho (wdth) marca la jerarquía, como en la web.
abstract final class Txt {
  static TextStyle display(double size, {Color color = Palette.ink}) => TextStyle(
        fontFamily: 'Archivo',
        fontSize: size,
        height: 0.92,
        color: color,
        fontWeight: FontWeight.w900,
        fontVariations: const [FontVariation('wdth', 62), FontVariation('wght', 900)],
      );

  static TextStyle heading(double size, {Color color = Palette.ink}) => TextStyle(
        fontFamily: 'Archivo',
        fontSize: size,
        height: 1.0,
        color: color,
        fontWeight: FontWeight.w800,
        fontVariations: const [FontVariation('wdth', 75), FontVariation('wght', 800)],
      );

  static TextStyle ui(double size, {FontWeight weight = FontWeight.w400, Color color = Palette.ink, double height = 1.4}) =>
      TextStyle(
        fontFamily: 'Archivo',
        fontSize: size,
        height: height,
        color: color,
        fontWeight: weight,
        fontVariations: [const FontVariation('wdth', 100), FontVariation('wght', weight.value.toDouble())],
      );

  /// Etiquetas cortas en mayúsculas (meses, encabezados de tabla, botones).
  static TextStyle label(double size, {Color color = Palette.ink2}) =>
      ui(size, weight: FontWeight.w700, color: color, height: 1.2).copyWith(letterSpacing: 0.5);

  static TextStyle read(double size, {Color color = Palette.ink, double height = 1.6}) => TextStyle(
        fontFamily: 'SourceSerif',
        fontSize: size,
        height: height,
        color: color,
        fontVariations: const [FontVariation('wght', 400), FontVariation('opsz', 20)],
      );
}

const _square = RoundedRectangleBorder(borderRadius: BorderRadius.zero);

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.red,
      primary: Palette.red,
      onPrimary: Colors.white,
      secondary: Palette.ink,
      surface: Palette.paper,
      onSurface: Palette.ink,
      error: Palette.redDeep,
    ),
    scaffoldBackgroundColor: Palette.paper,
    fontFamily: 'Archivo',
    splashFactory: InkRipple.splashFactory,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(fontFamily: 'Archivo', bodyColor: Palette.ink, displayColor: Palette.ink),
    dividerTheme: const DividerThemeData(color: Palette.ruleSoft, thickness: 1, space: 1),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Palette.red,
      selectionColor: Color(0x55D2102A),
      selectionHandleColor: Palette.red,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: _square,
        minimumSize: const Size(0, 48),
        backgroundColor: Palette.red,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Palette.sheet,
        disabledForegroundColor: Palette.ink2,
        textStyle: Txt.label(15, color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: _square,
        minimumSize: const Size(0, 48),
        foregroundColor: Palette.ink,
        side: const BorderSide(color: Palette.ink),
        textStyle: Txt.label(15, color: Palette.ink),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(shape: _square, foregroundColor: Palette.ink, textStyle: Txt.label(14)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.paper,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Palette.ink)),
      enabledBorder:
          const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Palette.ink)),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Palette.red, width: 2)),
      errorBorder:
          const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Palette.red, width: 2)),
      focusedErrorBorder:
          const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Palette.red, width: 2)),
      hintStyle: Txt.ui(16, color: Palette.ink2),
      labelStyle: Txt.ui(15, weight: FontWeight.w700),
      errorStyle: Txt.ui(14, weight: FontWeight.w600, color: Palette.redDeep),
      helperStyle: Txt.ui(13, color: Palette.ink2),
      helperMaxLines: 3,
      errorMaxLines: 3,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Palette.paper,
      surfaceTintColor: Colors.transparent,
      indicatorColor: Palette.red,
      indicatorShape: _square,
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => Txt.label(11, color: states.contains(WidgetState.selected) ? Palette.ink : Palette.ink2),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(color: states.contains(WidgetState.selected) ? Colors.white : Palette.ink, size: 24),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Palette.ink,
      contentTextStyle: Txt.ui(15, color: Colors.white),
      shape: _square,
      behavior: SnackBarBehavior.floating,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: Palette.red),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Colors.white : Palette.ink2),
      trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Palette.red : Palette.sheet),
      trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Palette.red : Palette.ink2),
    ),
  );
}
