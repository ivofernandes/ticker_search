import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';

/// A widget that displays a stock ticker symbol and its description.
/// When tapped, it calls the provided [onSelection] callback, if any, with the stock ticker data.
///
/// The widget uses an [InkWell] to respond to taps and a [Card] to display its contents.
class TickerWidget extends StatelessWidget {
  /// The stock ticker symbol, e.g., "AAPL" for Apple Inc.
  final String symbol;

  /// Optional description for the stock ticker, e.g., "Apple Inc."
  final String description;

  /// Callback function to be called when the ticker is selected.
  /// It passes a [StockTicker] object with the symbol and description.
  final void Function(StockTicker)? onSelection;

  /// Creates a [TickerWidget].
  ///
  /// Requires a [symbol] to be provided and optionally a [description],
  /// and an [onSelection] callback.
  const TickerWidget({
    required this.symbol,
    this.description = '',
    this.onSelection,
    super.key,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          if (onSelection != null) {
            onSelection!(
              StockTicker(
                symbol: symbol,
                description: description,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Card(
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 30,
                    minWidth: 80,
                    maxHeight: 30,
                  ),
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.surface.withAlpha(77),
                    child: Center(
                      child: Text(
                        symbol.toUpperCase(),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(description),
                ),
              ],
            ),
          ),
        ),
      );
}
