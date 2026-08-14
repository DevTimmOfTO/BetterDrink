import 'package:betterdrink/widgets/countdown_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CountdownRing shows the time and sub label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CountdownRing(
            remaining: Duration(minutes: 23, seconds: 45),
            total: Duration(minutes: 45),
            timeLabel: '23:45',
            subLabel: 'until next reminder',
          ),
        ),
      ),
    );

    expect(find.text('23:45'), findsOneWidget);
    expect(find.text('until next reminder'), findsOneWidget);
  });
}
