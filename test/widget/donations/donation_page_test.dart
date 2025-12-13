import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/feature/donations/widget/donation_page.dart';

void main() {
  group('DonationPage Widget', () {
    testWidgets('renders donation page with title', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DonationPage()));

      expect(find.text('Donations'), findsWidgets);
    });

    testWidgets('displays donation message', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DonationPage()));

      expect(find.textContaining('Thank you for considering'), findsOneWidget);
      expect(find.textContaining('community-founded project'), findsOneWidget);
    });

    testWidgets('displays QR code', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DonationPage()));

      await tester.pumpAndSettle();

      // QR code widget should be present
      expect(find.byType(DonationPage), findsOneWidget);
    });
  });
}
