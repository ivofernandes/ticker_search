import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:ticker_search/src/model/ticker_suggestion.dart';
import 'package:ticker_search/src/ticker_widget_ui.dart';

/// A search delegate that allows users to search for stock tickers.
///
/// It uses the [SearchDelegate] class to manage the search state and build the UI based on
/// the current search query. It displays search results and suggestions as the user types.
class TickerSearch extends SearchDelegate<List<StockTicker>> {
  /// A list of [TickerSuggestion] that provides icon, title, and ticker information.
  final List<TickerSuggestion> suggestions;

  /// Constructs a [TickerSearch] with an optional search field label and required suggestions.
  TickerSearch({
    super.searchFieldLabel,
    required this.suggestions,
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
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Widget> allItems = [];

    if (query.isNotEmpty) {
      allItems.add(
        TickerWidget(symbol: query.toUpperCase(), onSelection: (StockTicker ticker) => close(context, [ticker])),
      );
    }

    // Flatten all ticker blocks into a single list of widgets
    suggestions.forEach((TickerSuggestion suggestion) {
      // Add title widget
      allItems.add(suggestionTitle(suggestion.icon, suggestion.title, context));

      // Filter and add ticker widgets
      final filteredTickers = suggestion.companies.entries.where((entry) {
        final String lowerCaseQuery = query.toLowerCase();
        return entry.key.toLowerCase().contains(lowerCaseQuery) || entry.value.toLowerCase().contains(lowerCaseQuery);
      });

      allItems.addAll(
        filteredTickers.map(
          (entry) => TickerWidget(
            symbol: entry.key,
            description: entry.value,
            onSelection: (StockTicker ticker) {
              close(context, [ticker]);
            },
          ),
        ),
      );
    });

    return ListView.builder(
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        return allItems[index];
      },
    );
  }

  // Helper method to create the title widget
  Widget suggestionTitle(Widget icon, String title, BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title),
      // Other properties and callbacks...
    );
  }
}
