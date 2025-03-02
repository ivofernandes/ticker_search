import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:ticker_search/src/model/ticker_suggestion.dart';
import 'package:ticker_search/ticker_search.dart';

void main() {
  runApp(const MyApp());
}

/// Helper class to return both the selected tickers and, if applicable, the suggestion button value.
class SearchResult {
  final List<StockTicker> tickers;
  final String? suggestion;
  SearchResult(this.tickers, this.suggestion);
}

/// The root widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Ticker Search Demo',
    theme: ThemeData.dark(),
    home: const MyHomePage(title: 'Ticker search demo'),
  );
}

/// The home page displays the last selected ticker and an add button.
/// Tapping the add button navigates to the search page.
class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// State for MyHomePage.
class _MyHomePageState extends State<MyHomePage> {
  // Currently selected ticker.
  StockTicker selected = const StockTicker(symbol: '', description: '');
  // Holds the last query text (e.g. a suggestion button like "Companies" or a custom ticker).
  String lastQuery = '';
  // A shared scroll controller to preserve scroll position.
  final ScrollController scrollController = ScrollController();

  // List of suggestions used by the search widget.
  final List<TickerSuggestion> suggestions = [
    TickerSuggestion(const Icon(Icons.view_headline), 'Main', TickersList.main),
    TickerSuggestion(const Icon(Icons.euro), 'Euro ETFs', TickersList.europeanEtfs),
    TickerSuggestion(const Icon(Icons.business_sharp), 'Companies', TickersList.companies),
    TickerSuggestion(const Icon(Icons.precision_manufacturing_outlined), 'Sectors', TickersList.sectors),
    TickerSuggestion(const Icon(Icons.workspaces_outline), 'Futures', TickersList.futures),
    TickerSuggestion(const Icon(Icons.computer), 'Cryptos', TickersList.cryptoCurrencies),
    TickerSuggestion(const Icon(Icons.language), 'Countries', TickersList.countries),
    TickerSuggestion(const Icon(Icons.account_balance_outlined), 'Bonds', TickersList.bonds),
    TickerSuggestion(const Icon(Icons.architecture_sharp), 'Sizes', TickersList.sizes),
  ];

  @override
  Widget build(BuildContext context) {
    final String ticketDescription = TickerResolve.getTickerDescription(selected);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display the currently selected ticker.
            Text('Selected: ${selected.symbol} > $ticketDescription'),
            const SizedBox(height: 20),
            // Tap this area to navigate to the search page.
            InkWell(
              child: Container(
                color: Colors.lightBlue.withOpacity(0),
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 40,
                  bottom: 30,
                ),
                child: const Icon(
                  Icons.add,
                  size: 40,
                ),
              ),
              onTap: () async {
                // Navigate to TickerSearchPage.
                final SearchResult? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TickerSearchPage(
                      initialQuery: lastQuery,
                      scrollController: scrollController,
                      suggestions: suggestions,
                    ),
                  ),
                );
                if (result != null && result.tickers.isNotEmpty) {
                  setState(() {
                    // For demonstration, join all selected ticker symbols.
                    selected = result.tickers.reduce((value, element) => value.copyWith(
                      symbol: value.symbol.isEmpty
                          ? element.symbol
                          : '${value.symbol}, ${element.symbol}',
                      description: '',
                    ));
                    // Update lastQuery only if a suggestion button was pressed.
                    if (result.suggestion != null) {
                      lastQuery = result.suggestion!;
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Ticker'),
      ),
      body: TickerSearchWidget(
        suggestions: widget.suggestions,
        initialQuery: widget.initialQuery,
        scrollController: widget.scrollController,
        onGeneralQueryChanged: (newQuery) {
          // General text field changes.
          print("General query changed: $newQuery");
        },
        onSuggestionButtonPressed: (suggestion) {
          // When a suggestion button is pressed, store its value.
          print("Suggestion button pressed: $suggestion");
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
}