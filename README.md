# Ticker Search Flutter Package

A Flutter package for searching stock tickers in your app.

## Features

- Easy-to-use search widget for stock tickers.
- Customizable ticker suggestions with icons.
- Light and dark theme support.
- Material 3 design.
- Returns a `StockTicker` object with the selected ticker symbol.

### Prerequisites
Before you begin, ensure you have Flutter installed on your development machine. If you haven't, visit [Flutter's official website](https://flutter.dev/) to get started.

### Installation

Add `ticker_search` to your `pubspec.yaml` file:

```yaml
dependencies:
  ticker_search: ^0.0.1
  stock_market_data: ^0.0.9
```

### Usage

Import the package:

```dart
import 'package:ticker_search/ticker_search.dart';
```

Use the `TickerSearch` widget:

```dart
final List<StockTicker>? tickers = await showSearch(
  context: context,
  delegate: TickerSearch(
    searchFieldLabel: 'Add',
    suggestions: [
      TickerSuggestion(const Icon(Icons.view_headline), 'Main', TickersList.main),
      TickerSuggestion(const Icon(Icons.business_sharp), 'Companies', TickersList.companies),
      TickerSuggestion(const Icon(Icons.precision_manufacturing_outlined), 'Sectors', TickersList.sectors),
      TickerSuggestion(const Icon(Icons.workspaces_outline), 'Futures', TickersList.futures),
      TickerSuggestion(const Icon(Icons.computer), 'Cryptos', TickersList.cryptoCurrencies),
      TickerSuggestion(const Icon(Icons.language), 'Countries', TickersList.countries),
      TickerSuggestion(const Icon(Icons.account_balance_outlined), 'Bonds', TickersList.bonds),
      TickerSuggestion(const Icon(Icons.architecture_sharp), 'Sizes', TickersList.sizes),
    ],
  ),
);
```

### Example

You can check the example application and see how to use the package.

![Pluralize demo](https://raw.githubusercontent.com/ivofernandes/ticker_search/main/doc/search_ticker_search.png)

