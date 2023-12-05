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
    final List<Widget> allItems = filterItems(context);

    return Column(
      children: [
        selectionButtons(context),
        Expanded(
          child: ListView.builder(
            itemCount: allItems.length,
            itemBuilder: (context, index) => allItems[index],
          ),
        ),
      ],
    );
  }

  // Helper method to create the title widget
  Widget suggestionTitle(Widget icon, String title, BuildContext context) => ListTile(
        leading: icon,
        title: Text(title),
      );

  Widget selectionButtons(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: suggestions.map((suggestion) {
            final selected = suggestion.title == query;
            final color =
                selected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onBackground;
            return MaterialButton(
              child: Row(
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    child: suggestion.icon,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    suggestion.title,
                    style: TextStyle(
                      color: color,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                // Update the query with the selected suggestion title
                query = suggestion.title;
              },
            );
          }).toList(),
        ),
      );

  List<Widget> filterItems(BuildContext context) {
    final List<Widget> allItems = [];

    if (query.isNotEmpty) {
      allItems.add(
        TickerWidget(symbol: query.toUpperCase(), onSelection: (StockTicker ticker) => close(context, [ticker])),
      );
    }

    final List<String> suggestionsTitles = suggestions.map((e) => e.title).toList();

    if (suggestionsTitles.contains(query)) {
      final TickerSuggestion tickerSuggestion = suggestions.where((element) => element.title == query).toList().first;

      addSuggestionToItems(tickerSuggestion, context, allItems, false);
    } else {
      // Flatten all ticker blocks into a single list of widgets
      suggestions.forEach((TickerSuggestion suggestion) {
        addSuggestionToItems(suggestion, context, allItems, true);
      });
    }

    return allItems;
  }

  void addSuggestionToItems(
      TickerSuggestion suggestion, BuildContext context, List<Widget> allItems, bool filterByText) {
    // Add title widget
    allItems.add(suggestionTitle(suggestion.icon, suggestion.title, context));

    // Filter and add ticker widgets
    var filteredTickers = suggestion.companies.entries;

    if (filterByText) {
      filteredTickers = filteredTickers.where((entry) {
        final String lowerCaseQuery = query.toLowerCase();
        return entry.key.toLowerCase().contains(lowerCaseQuery) || entry.value.toLowerCase().contains(lowerCaseQuery);
      });
    }

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
  }
}
