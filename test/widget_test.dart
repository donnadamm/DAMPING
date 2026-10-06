import 'package:flutter_test/flutter_test.dart';
import 'package:damping_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build aplikasi DAMPING
    await tester.pumpWidget(const DampingApp());

    // Cek apakah teks setup awal muncul di layar
    expect(find.text('DAMPING Project Setup Ready'), findsOneWidget);
  });
}
