import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:restobillsplitter/main.dart' as app;
import 'package:restobillsplitter/widgets/guest_list_tile.dart';

// flutter test integration_test/app_test.dart --dart-define=ENVIRONMENT=dev --flavor dev
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify guest is added', (tester) async {
          app.main();
          await tester.pumpAndSettle(const Duration(seconds: 1));

          // Verify the message 'Please add a guest first' is displayed.
          expect(find.text('Please add a guest first'), findsOneWidget);

          // Finds the floating action button to tap on.
          final Finder fab = find.byTooltip('Add a guest');

          // Emulate a tap on the floating action button.
          await tester.tap(fab);

          // Trigger a frame.
          await tester.pumpAndSettle(const Duration(seconds: 1));

          // Verify the message 'Please add a guest first' is not displayed anymore.
          expect(find.text('Please add a guest first'), findsNothing);

          // Verify the GuestListTile for Guest1 is present.
          expect(find.widgetWithText(GuestListTile, 'Guest1'), findsOneWidget);
        });
  });
}

