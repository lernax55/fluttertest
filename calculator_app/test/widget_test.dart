// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculator_app/main.dart';

void main() {
  group('Hesap Makinesi Testleri', () {
    testWidgets('UI Elemanları Testi', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // Sayı tuşları kontrolü
      for (int i = 0; i <= 9; i++) {
        expect(find.text('$i'), findsOneWidget);
      }

      // Operatör tuşları kontrolü
      expect(find.text('+'), findsOneWidget);
      expect(find.text('-'), findsOneWidget);
      expect(find.text('×'), findsOneWidget);
      expect(find.text('÷'), findsOneWidget);
      expect(find.text('%'), findsOneWidget);
      expect(find.text('^'), findsOneWidget);

      // Özel tuşlar kontrolü
      expect(find.text('AC'), findsOneWidget);
      expect(find.text('⌫'), findsOneWidget);
      expect(find.text('='), findsOneWidget);
      expect(find.text('√'), findsOneWidget);
      expect(find.text('('), findsOneWidget);
      expect(find.text(')'), findsOneWidget);
      expect(find.text('!'), findsOneWidget);
    });

    testWidgets('Temel Matematik İşlemleri Testi', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // Toplama: 123 + 456 = 579
      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text('+'));
      await tester.pump();
      await tester.tap(find.text('4'));
      await tester.pump();
      await tester.tap(find.text('5'));
      await tester.pump();
      await tester.tap(find.text('6'));
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      expect(find.text('579'), findsWidgets);

      // Temizle
      await tester.tap(find.text('AC'));
      await tester.pump();

      // Çıkarma: 500 - 123 = 377
      await tester.tap(find.text('5'));
      await tester.tap(find.text('0'));
      await tester.tap(find.text('0'));
      await tester.tap(find.text('-'));
      await tester.tap(find.text('1'));
      await tester.tap(find.text('2'));
      await tester.tap(find.text('3'));
      await tester.tap(find.text('='));
      await tester.pump();

      expect(find.text('377'), findsWidgets);
    });

    testWidgets('Özel İşlemler Testi', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // Faktöriyel: 5! = 120
      await tester.tap(find.text('5'));
      await tester.pump();
      await tester.tap(find.text('!'));
      await tester.pump();

      expect(find.text('120'), findsWidgets);

      // Temizle
      await tester.tap(find.text('AC'));
      await tester.pump();

      // Kök alma: √16 = 4
      await tester.tap(find.text('1'));
      await tester.tap(find.text('6'));
      await tester.tap(find.text('√'));
      await tester.pump();

      expect(find.text('4'), findsWidgets);

      // Temizle
      await tester.tap(find.text('AC'));
      await tester.pump();

      // Yüzde: 800% = 8
      await tester.tap(find.text('8'));
      await tester.tap(find.text('0'));
      await tester.tap(find.text('0'));
      await tester.tap(find.text('%'));
      await tester.pump();

      expect(find.text('8'), findsWidgets);
    });

    testWidgets('Hata Durumları Testi', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // Negatif sayı faktöriyeli
      await tester.tap(find.text('-'));
      await tester.tap(find.text('5'));
      await tester.tap(find.text('!'));
      await tester.pump();

      expect(find.text('Hata'), findsWidgets);

      // Temizle
      await tester.tap(find.text('AC'));
      await tester.pump();

      // Negatif sayı kök alma
      await tester.tap(find.text('-'));
      await tester.tap(find.text('1'));
      await tester.tap(find.text('6'));
      await tester.tap(find.text('√'));
      await tester.pump();

      expect(find.text('Hata'), findsWidgets);

      // Temizle
      await tester.tap(find.text('AC'));
      await tester.pump();

      // Sıfıra bölme
      await tester.tap(find.text('1'));
      await tester.tap(find.text('÷'));
      await tester.tap(find.text('0'));
      await tester.tap(find.text('='));
      await tester.pump();

      expect(find.text('Hata'), findsWidgets);
    });

    testWidgets('Silme ve Düzenleme Testi', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // Sayı girişi ve silme
      await tester.tap(find.text('1'));
      await tester.tap(find.text('2'));
      await tester.tap(find.text('3'));
      await tester.tap(find.text('⌫'));
      await tester.pump();

      expect(find.text('12'), findsWidgets);

      // Operatör silme
      await tester.tap(find.text('+'));
      await tester.tap(find.text('⌫'));
      await tester.pump();

      expect(find.text('12'), findsWidgets);
    });

    testWidgets('Parantezli İşlem Testi', (WidgetTester tester) async {
      await tester.pumpWidget(const CalculatorApp());

      // (5+3)×2 = 16
      await tester.tap(find.text('('));
      await tester.pump();
      await tester.tap(find.text('5'));
      await tester.pump();
      await tester.tap(find.text('+'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();
      await tester.tap(find.text(')'));
      await tester.pump();
      await tester.tap(find.text('×'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('='));
      await tester.pump();

      expect(find.text('16'), findsWidgets);
    });
  });
}
