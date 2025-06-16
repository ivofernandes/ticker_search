import 'package:stock_market_data/stock_market_data.dart';

/// Helper class to return both the selected tickers and, if applicable, the suggestion button value.
class SearchResult {
  final List<StockTicker> tickers;
  final String? suggestion;
  SearchResult(this.tickers, this.suggestion);

  StockTicker get getTicker =>
      tickers.reduce((value, element) => value.copyWith(
            symbol: value.symbol.isEmpty
                ? element.symbol
                : '${value.symbol}, ${element.symbol}',
            description: '',
          ));
}
