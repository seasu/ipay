import 'package:flutter_test/flutter_test.dart';

import 'package:ipay/main.dart';

void main() {
  testWidgets('App renders game page', (WidgetTester tester) async {
    await tester.pumpWidget(const IPayApp());

    expect(find.text('I-Pay 終極密碼'), findsOneWidget);
    expect(find.text('猜測範圍'), findsOneWidget);
    expect(find.text('猜！'), findsOneWidget);
  });
}
