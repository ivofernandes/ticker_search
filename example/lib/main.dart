import 'package:flutter/material.dart';
import 'package:stock_market_data/stock_market_data.dart';
import 'package:ticker_search/ticker_search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SearchWidget(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SearchWidget extends StatefulWidget {
  static List<TickerSuggestion> suggestions = [
    TickerSuggestion(const Icon(Icons.view_headline), 'Main', TickersList.main),
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

  const SearchWidget();

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  StockTicker selected = StockTicker(symbol: '');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final String ticketDescription =
        TickerResolve.getTickerDescription(selected);

    final TickerSearch tickerSearch = TickerSearch(
        searchFieldLabel: 'Add', suggestions: SearchWidget.suggestions);

    return Column(
      children: [
        Text('Selected: ${selected.symbol} > $ticketDescription'),
        InkWell(
          child: Container(
              color: Colors.lightBlue.withOpacity(0),
              padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
              child: const Icon(
                Icons.add,
              )),
          onTap: () async {
            final List<StockTicker>? tickers =
                await showSearch(context: context, delegate: tickerSearch);

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
