import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:ticker_search/ticker_search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: const MyHomePage(title: 'Ticker search demo'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    required this.title,
    super.key,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SearchWidget(),
            ),
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  StockTicker selected = const StockTicker(symbol: '');

  @override
  Widget build(BuildContext context) {
    final String ticketDescription =
        TickerResolve.getTickerDescription(selected);

    return Column(
      children: [
        Text('Selected: ${selected.symbol} > $ticketDescription'),
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
            ),
          ),
          onTap: () async {
            final List<StockTicker>? tickers = await showSearch(
              context: context,
              delegate: TickerSearch(
                searchFieldLabel: 'Search ticker',
                suggestions: [
                  TickerSuggestion(
                    const Icon(Icons.view_headline),
                    'Main',
                    TickersList.main,
                  ),
                  TickerSuggestion(
                    const Icon(Icons.business_sharp),
                    'Companies',
                    TickersList.companies,
                  ),
                  TickerSuggestion(
                    const Icon(Icons.precision_manufacturing_outlined),
                    'Sectors',
                    TickersList.sectors,
                  ),
                  TickerSuggestion(
                    const Icon(Icons.workspaces_outline),
                    'Futures',
                    TickersList.futures,
                  ),
                  TickerSuggestion(
                    const Icon(Icons.computer),
                    'Cryptos',
                    TickersList.cryptoCurrencies,
                  ),
                  TickerSuggestion(
                    const Icon(Icons.language),
                    'Countries',
                    TickersList.countries,
                  ),
                  TickerSuggestion(
                    const Icon(Icons.account_balance_outlined),
                    'Bonds',
                    TickersList.bonds,
                  ),
                  TickerSuggestion(
                    const Icon(Icons.architecture_sharp),
                    'Sizes',
                    TickersList.sizes,
                  ),
                ],
              ),
            );

            if (tickers != null && tickers.isNotEmpty) {
              setState(() {
                selected = tickers.first;
              });
            }
          },
        ),
      ],
    );
  }
}
