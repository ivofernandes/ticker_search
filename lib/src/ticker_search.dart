import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:ticker_search/src/model/ticker_suggestion.dart';
import 'package:ticker_search/src/ticker_widget_ui.dart';

/// A normal widget that provides ticker search functionality.
/// It features a text field for entering queries, horizontal selection buttons,
/// and a scrollable list of ticker suggestions.
class TickerSearchWidget extends StatefulWidget {
  /// A list of [TickerSuggestion] that provides icon, title, and ticker information.
  final List<TickerSuggestion> suggestions;

  /// Optional "Add all" button widget.
  final Widget? addAllButton;

  /// External scroll controller to preserve scroll state.
  final ScrollController? scrollController;

  /// The initial query to prefill the search field.
  final String initialQuery;

  /// Callback triggered when a suggestion button is pressed.
  final void Function(String)? onSuggestionButtonPressed;

  /// Callback to notify when one or more tickers are selected.
  final void Function(List<StockTicker>)? onTickersSelected;

  const TickerSearchWidget({
    required this.suggestions,
    this.addAllButton,
    this.scrollController,
    this.initialQuery = '',
    this.onSuggestionButtonPressed,
    this.onTickersSelected,
    super.key,
  });

  @override
  _TickerSearchWidgetState createState() => _TickerSearchWidgetState();
}

class _TickerSearchWidgetState extends State<TickerSearchWidget> {
  late TextEditingController _controller;
  late String query;
  late ScrollController _internalScrollController;

  @override
  void initState() {
    super.initState();
    query = widget.initialQuery;
    _controller = TextEditingController(text: query);
    _internalScrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.scrollController == null) {
      _internalScrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> allItems = _filterItems(context);
    return Column(
      children: [
        // Search text field
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Search ticker',
              suffixIcon: query.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    query = '';
                    _controller.clear();
                  });
                },
              )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
          ),
        ),
        // Horizontal selection buttons
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.suggestions.map((suggestion) {
              // Compare suggestion title to query in a case-insensitive way.
              final bool selected =
                  suggestion.title.toLowerCase() == query.toLowerCase();
              final Color color = selected
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.onSurface;
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
                      style: TextStyle(color: color),
                    ),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    query = suggestion.title;
                    _controller.text = suggestion.title;
                  });
                  // Fire the suggestion button pressed event.
                  widget.onSuggestionButtonPressed?.call(suggestion.title);
                },
              );
            }).toList(),
          ),
        ),
        const Divider(),
        // ListView with filtered ticker items and suggestion groups.
        Expanded(
          child: ListView.builder(
            controller: _internalScrollController,
            itemCount: allItems.length,
            itemBuilder: (context, index) => allItems[index],
          ),
        ),
      ],
    );
  }

  /// Returns a list of widgets based on the current query.
  List<Widget> _filterItems(BuildContext context) {
    final List<Widget> allItems = [];

    // Only add a ticker widget for the query if it's not an exact suggestion title.
    if (query.isNotEmpty &&
        !widget.suggestions
            .map((e) => e.title.toLowerCase())
            .contains(query.toLowerCase())) {
      allItems.add(
        TickerWidget(
          symbol: query.toUpperCase(),
          onSelection: (StockTicker ticker) {
            // Since this is not a suggestion group state, update the query.
            setState(() {
              query = ticker.symbol;
              _controller.text = ticker.symbol;
            });
            widget.onTickersSelected?.call([ticker]);
          },
        ),
      );
    }

    final List<String> suggestionTitles =
    widget.suggestions.map((e) => e.title.toLowerCase()).toList();

    if (suggestionTitles.contains(query.toLowerCase())) {
      final TickerSuggestion tickerSuggestion = widget.suggestions.firstWhere(
              (element) => element.title.toLowerCase() == query.toLowerCase());
      _addSuggestionToItems(tickerSuggestion, context, allItems, false);
    } else {
      // If not an exact match, show all suggestion groups.
      for (final suggestion in widget.suggestions) {
        _addSuggestionToItems(suggestion, context, allItems, true);
      }
    }
    return allItems;
  }

  /// Helper to add suggestion items (a title and list of ticker widgets) to [allItems].
  void _addSuggestionToItems(
      TickerSuggestion suggestion,
      BuildContext context,
      List<Widget> allItems,
      bool filterByText) {
    Iterable<MapEntry<String, String>> filteredTickers =
        suggestion.tickers.entries;
    final Widget titleWidget = _suggestionTitle(
      suggestion.icon,
      suggestion.title,
      context,
      filteredTickers,
    );
    allItems.add(titleWidget);

    if (filterByText) {
      filteredTickers = filteredTickers.where((entry) {
        final String lowerCaseQuery = query.toLowerCase();
        return entry.key.toLowerCase().contains(lowerCaseQuery) ||
            entry.value.toLowerCase().contains(lowerCaseQuery);
      });
    }

    allItems.addAll(
      filteredTickers.map(
            (entry) => TickerWidget(
          symbol: entry.key,
          description: entry.value,
          onSelection: (StockTicker ticker) {
            // When in a suggestion group state, do not update query.
            if (!widget.suggestions
                .map((s) => s.title.toLowerCase())
                .contains(query.toLowerCase())) {
              setState(() {
                query = ticker.symbol;
                _controller.text = ticker.symbol;
              });
            }
            widget.onTickersSelected?.call([ticker]);
          },
        ),
      ),
    );
  }

  /// Creates a title widget for a suggestion group with an "Add all" button.
  Widget _suggestionTitle(
      Widget icon,
      String title,
      BuildContext context,
      Iterable<MapEntry<String, String>> filteredTickers,
      ) {
    void onPressed() {
      final List<StockTicker> tickers = filteredTickers
          .map((entry) => StockTicker(
        symbol: entry.key,
        description: entry.value,
      ))
          .toList();
      widget.onTickersSelected?.call(tickers);
    }

    Widget addAllFinalButton = MaterialButton(
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onPressed: onPressed,
      child: const Text('Add all'),
    );

    if (widget.addAllButton != null) {
      addAllFinalButton = InkWell(
        onTap: onPressed,
        child: widget.addAllButton,
      );
    }

    final int size = filteredTickers.length;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListTile(
        leading: icon,
        title: Text('$title ($size)'),
        trailing: addAllFinalButton,
      ),
    );
  }
}
