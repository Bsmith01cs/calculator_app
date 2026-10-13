import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_app/main.dart';

Future<void> press(WidgetTester tester, String label) async {
  await tester.tap(find.byKey(Key('key_$label')));
  await tester.pumpAndSettle();
}

String display(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('display_text'))).data!;

void main() {
  testWidgets('running total follows left-to-right evaluation', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['2', '+', '3']) {
      await press(tester, key);
    }
    expect(display(tester), '3');
    await press(tester, '×');
    expect(display(tester), '5');
    await press(tester, '4');
    await press(tester, '=');
    expect(display(tester), '20');
  });

  testWidgets('repeated operator replaces rather than evaluates', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['9', '+', '×', '2', '=']) {
      await press(tester, key);
    }
    expect(display(tester), '18');
  });

  testWidgets('equals while awaiting a number keeps the pending operation', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['7', '+', '=']) {
      await press(tester, key);
    }
    expect(display(tester), '7');
    await press(tester, '3');
    await press(tester, '=');
    expect(display(tester), '10');
  });

  testWidgets('digit after equals starts a new calculation', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['2', '+', '3', '=', '7']) {
      await press(tester, key);
    }
    expect(display(tester), '7');
  });

  testWidgets('AC resets the full calculation state', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['7', '+', '3', 'AC']) {
      await press(tester, key);
    }
    expect(display(tester), '0');
    for (final key in ['2', '×', '4', '=']) {
      await press(tester, key);
    }
    expect(display(tester), '8');
  });

  testWidgets('divide by zero is recoverable with a digit', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['8', '÷', '0', '=']) {
      await press(tester, key);
    }
    expect(display(tester), 'Error');
    await press(tester, '4');
    expect(display(tester), '4');
  });

  testWidgets('subtraction and division calculate correctly', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['9', '−', '4', '=']) {
      await press(tester, key);
    }
    expect(display(tester), '5');
    for (final key in ['AC', '6', '÷', '2', '=']) {
      await press(tester, key);
    }
    expect(display(tester), '3');
  });

  testWidgets('button labels and press effects are present', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['AC', '÷', '×', '−', '+', '=']) {
      expect(find.byKey(Key('key_$key')), findsOneWidget);
    }
    for (var digit = 0; digit <= 9; digit++) {
      expect(find.byKey(Key('key_$digit')), findsOneWidget);
    }
    expect(find.byType(InkWell), findsNWidgets(16));
  });

  testWidgets('all four operations chain using left-to-right totals', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['8', '÷', '2', '+']) {
      await press(tester, key);
    }
    expect(display(tester), '4');
    for (final key in ['3', '×']) {
      await press(tester, key);
    }
    expect(display(tester), '7');
    for (final key in ['2', '−']) {
      await press(tester, key);
    }
    expect(display(tester), '14');
    await press(tester, '5');
    await press(tester, '=');
    expect(display(tester), '9');
  });

  testWidgets('incomplete input shows guidance but preserves calculation', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['7', '+', '=']) {
      await press(tester, key);
    }
    expect(display(tester), '7');
    final message = tester
        .widget<Text>(find.byKey(const Key('message_text')))
        .data!;
    expect(message, contains('Enter a number'));
    await press(tester, '2');
    await press(tester, '=');
    expect(display(tester), '9');
  });

  testWidgets('AC clears a pending operation even before second operand', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['9', '×', 'AC', '2', '+', '3', '=']) {
      await press(tester, key);
    }
    expect(display(tester), '5');
  });

  testWidgets('division by zero during a chained operator is recoverable', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    for (final key in ['8', '÷', '0', '+']) {
      await press(tester, key);
    }
    expect(display(tester), 'Error');
    for (final key in ['AC', '4', '×', '2', '=']) {
      await press(tester, key);
    }
    expect(display(tester), '8');
  });
}
