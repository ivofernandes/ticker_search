import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:ticker_search/src/ticker_widget_ui.dart';

void main() {
  // Helper function to create the TickerWidget with a mock callback
  Widget createTickerWidget(Function(StockTicker)? onSelection) => MaterialApp(
        home: Scaffold(
          body: TickerWidget(
            symbol: 'AAPL',
            description: 'Apple Inc.',
            onSelection: onSelection,
          ),
        ),
      );

  testWidgets('TickerWidget builds with correct symbol and description',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTickerWidget(null));

    // Verify that the symbol and description are displayed correctly
    expect(find.text('AAPL'), findsOneWidget);
    expect(find.text('Apple Inc.'), findsOneWidget);
  });

  testWidgets('onSelection callback is called when TickerWidget is tapped',
      (WidgetTester tester) async {
    bool callbackCalled = false;
    StockTicker? selectedTicker;

    // Define the mock callback
    void mockCallback(StockTicker ticker) {
      callbackCalled = true;
      selectedTicker = ticker;
    }

    await tester.pumpWidget(createTickerWidget(mockCallback));

    // Tap on the widget
    await tester.tap(find.byType(TickerWidget));
    await tester.pumpAndSettle();

    // Verify that the callback is called and the correct data is passed
    expect(callbackCalled, isTrue);
    expect(selectedTicker?.symbol, equals('AAPL'));
    expect(selectedTicker?.description, equals('Apple Inc.'));
  });
}
