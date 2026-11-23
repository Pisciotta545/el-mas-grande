import 'package:el_mas_grande/updater.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('compara versiones número por número, no como texto', () {
    expect(compareVersions('1.10.0', '1.9.3'), 1);
    expect(compareVersions('v1.1.0', '1.1.0'), 0);
    expect(compareVersions('1.1.0+7', '1.1.0'), 0);
    expect(compareVersions('1.1.1', '1.1.0'), 1);
    expect(compareVersions('1.0.9', '1.1.0'), -1);
    expect(compareVersions('2.0', '1.9.9'), 1);
  });
}
