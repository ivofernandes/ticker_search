import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:ticker_search/src/ticker_widget_ui.dart';

/// A widget to display a list of stock tickers based on a search query.
class TickersBlock extends StatelessWidget {
  final Widget icon;
  final String title;
  final Map<String, String> tickers;
  final String query;
  final void Function(BuildContext, List<StockTicker>) close;

  /// Constructs a [TickersBlock] widget.
  ///
  /// [icon] - The icon displayed next to the title.
  /// [title] - The title of the tickers block.
  /// [tickers] - A map of ticker symbols to their descriptions.
  /// [query] - The search query to filter the tickers.
  /// [close] - The function to call when a ticker is selected.
  const TickersBlock({
    required this.icon,
    required this.title,
    required this.tickers,
    required this.query,
    required this.close,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> keys = tickers.keys.toList();
    final String lowerCaseQuery = query.toLowerCase();

    final List<String> filteredKeys = keys
        .where((element) =>
            element.toLowerCase().contains(lowerCaseQuery) ||
            tickers[element]!.toLowerCase().contains(lowerCaseQuery))
        .toList();

    return filteredKeys.isNotEmpty
        ? Column(
            children: [
              _suggestionTitle(icon, title, filteredKeys, tickers, context),
              _buildListView(context, filteredKeys),
            ],
          )
        : const SizedBox();
  }

  /// Creates a title widget with an 'Add all' button.
  Widget _suggestionTitle(
    Widget icon,
    String title,
    List<String> filteredKeys,
    Map<String, String> tickers,
    BuildContext context,
  ) =>
      ListTile(
        leading: icon,
        title: Text(title),
        trailing: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Theme.of(context).colorScheme.primary,
          child: const Text('Add all'),
          onPressed: () => _addAll(filteredKeys, tickers, context),
        ),
      );

  /// Builds a ListView of ticker widgets.
  Widget _buildListView(BuildContext context, List<String> filteredKeys) =>
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: filteredKeys.length,
        itemBuilder: (BuildContext context, int index) {
          final String symbol = filteredKeys[index];
          return TickerWidget(
            symbol: symbol,
            description: tickers[symbol]!,
            onSelection: (StockTicker ticker) =>
                close(context, <StockTicker>[ticker]),
          );
        },
      );

  /// Handles the 'Add all' button press.
  void _addAll(List<String> filteredKeys, Map<String, String> tickers,
      BuildContext context) {
    final List<StockTicker> result = filteredKeys
        .map((symbol) => StockTicker(
              symbol: symbol,
              description: tickers[symbol],
            ))
        .toList();
    close(context, result);
  }
}
