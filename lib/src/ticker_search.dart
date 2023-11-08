import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:ticker_search/src/model/ticker_suggestion.dart';
import 'package:ticker_search/src/ticker_widget_ui.dart';
import 'package:ticker_search/src/tickers_block.dart';

class TickerSearch extends SearchDelegate<List<StockTicker>> {
  final List<TickerSuggestion> suggestions;

  TickerSearch({
    super.searchFieldLabel,
    required this.suggestions, // Receiving suggestions as a parameter.
  });

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              query = '';
            }),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, []);
      });

  @override
  Widget buildResults(BuildContext context) => InkWell(
      onTap: () => close(context, [
            StockTicker(
              symbol: query.toUpperCase(),
              description: query.toUpperCase(),
            )
          ]),
      child: TickerWidget(
        symbol: query.toUpperCase(),
        onSelection: (StockTicker ticker) {
          close(context, [ticker]);
        },
      ));

  @override
  Widget buildSuggestions(BuildContext context) {
    final Widget searchingWidget = query.isNotEmpty
        ? TickerWidget(
            symbol: query.toUpperCase(),
            onSelection: (StockTicker ticker) => close(context, [ticker]))
        : Container();

    List<Widget> suggestionWidgets = [searchingWidget];
    suggestionWidgets.addAll(suggestions
        .map((suggestion) => TickersBlock(
              icon: suggestion.icon,
              title: suggestion.title,
              tickers: suggestion.companies,
              query: query,
              close: close,
            ))
        .toList());

    return SingleChildScrollView(
      child: Column(
        children: suggestionWidgets,
      ),
    );
  }
}
