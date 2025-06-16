import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:ticker_search/src/model/search_result.dart';
import 'package:ticker_search/src/model/ticker_suggestion.dart';
import 'package:ticker_search/src/ticker_search.dart';

/// A full‑screen page that wraps TickerSearchWidget.
/// When tickers are selected, it pops with a SearchResult containing the tickers and, if applicable,
/// the suggestion button event.
class TickerSearchPage extends StatefulWidget {
  /// The initial query to prefill the search field.
  final String initialQuery;

  /// External scroll controller to preserve scroll state.
  final ScrollController? scrollController;

  /// A list of [TickerSuggestion] that provides icon, title, and ticker information.
  final List<TickerSuggestion>? suggestions;

  const TickerSearchPage({
    this.initialQuery = '',
    this.scrollController,
    this.suggestions,
    super.key,
  });

  @override
  _TickerSearchPageState createState() => _TickerSearchPageState();
}

class _TickerSearchPageState extends State<TickerSearchPage> {
  // This variable will capture the suggestion button pressed (if any).
  String? selectedSuggestion;

  final List<TickerSuggestion> suggestions = [
    TickerSuggestion(const Icon(Icons.view_headline), 'Main', TickersList.main),
    TickerSuggestion(
        const Icon(Icons.euro), 'Euro ETFs', TickersList.europeanEtfs),
    TickerSuggestion(
        const Icon(Icons.business_sharp), 'Companies', TickersList.companies),
    TickerSuggestion(const Icon(Icons.precision_manufacturing_outlined),
        'Sectors', TickersList.sectors),
    TickerSuggestion(
        const Icon(Icons.workspaces_outline), 'Futures', TickersList.futures),
    TickerSuggestion(
        const Icon(Icons.computer), 'Cryptos', TickersList.cryptoCurrencies),
    TickerSuggestion(
        const Icon(Icons.language), 'Countries', TickersList.countries),
    TickerSuggestion(
        const Icon(Icons.account_balance_outlined), 'Bonds', TickersList.bonds),
    TickerSuggestion(
        const Icon(Icons.architecture_sharp), 'Sizes', TickersList.sizes),
  ];

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: TickerSearch(
            suggestions: widget.suggestions ?? suggestions,
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
        ),
      );
}
