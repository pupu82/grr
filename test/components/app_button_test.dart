import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grr/components/buttons/app_button.dart';
import 'package:grr/constants/app_theme.dart';

Widget _wrap(Widget child) {
  return CupertinoApp(
    theme: AppTheme.light(),
    home: CupertinoPageScaffold(child: Center(child: child)),
  );
}

void main() {
  testWidgets('renders its label and forwards taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(AppButton(label: 'Simpan', onPressed: () => taps++)),
    );

    expect(find.text('Simpan'), findsOneWidget);

    await tester.tap(find.text('Simpan'));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('shows a spinner and blocks taps while loading', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        AppButton(label: 'Simpan', isLoading: true, onPressed: () => taps++),
      ),
    );

    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);

    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(taps, 0);
  });

  testWidgets('does not call back when no handler is provided', (tester) async {
    await tester.pumpWidget(_wrap(const AppButton(label: 'Nonaktif')));

    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(find.text('Nonaktif'), findsOneWidget);
  });

  testWidgets('renders every variant', (tester) async {
    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final variant in AppButtonVariant.values)
              AppButton(
                label: variant.name,
                variant: variant,
                expand: false,
                onPressed: () {},
              ),
          ],
        ),
      ),
    );

    for (final variant in AppButtonVariant.values) {
      expect(find.text(variant.name), findsOneWidget);
    }
  });
}
