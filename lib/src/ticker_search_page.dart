import 'package:flutter/material.dart';
import 'package:ticker_search/src/model/search_result.dart';
import 'package:ticker_search/src/model/ticker_suggestion.dart';
import 'package:ticker_search/src/ticker_search.dart';

/// A full‑screen page that wraps TickerSearchWidget.
/// When tickers are selected, it pops with a SearchResult containing the tickers and, if applicable,
/// the suggestion button event.
class TickerSearchPage extends StatefulWidget {
  final String initialQuery;
  final ScrollController scrollController;
  final List<TickerSuggestion> suggestions;

  const TickerSearchPage({
    Key? key,
    required this.initialQuery,
    required this.scrollController,
    required this.suggestions,
  }) : super(key: key);

  @override
  _TickerSearchPageState createState() => _TickerSearchPageState();
}

class _TickerSearchPageState extends State<TickerSearchPage> {
  // This variable will capture the suggestion button pressed (if any).
  String? selectedSuggestion;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Search Ticker'),
      ),
      body: TickerSearchWidget(
        suggestions: widget.suggestions,
        initialQuery: widget.initialQuery,
        scrollController: widget.scrollController,
        onSuggestionButtonPressed: (suggestion) {
          setState(() {
            selectedSuggestion = suggestion;
          });
        },
        onTickersSelected: (tickers) {
          // Return a SearchResult with the selected tickers and the suggestion (if any).
          Navigator.pop(context, SearchResult(tickers, selectedSuggestion));
        },
      ),
    );
}