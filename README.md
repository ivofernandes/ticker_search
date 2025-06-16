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
  ticker_search: ^0.0.8
  stock_market_data: ^0.1.3
```

### Usage

Import the package:

```dart
import 'package:ticker_search/ticker_search.dart';
```

Use the `TickerSearch` widget:

```dart
final SearchResult? result = await Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => TickerSearchPage(),
        ),
    );
    if (result != null) {
        setState(() {
        simplerExampleSelected = result.getTicker;
    });
}
```

### Example

You can check the example application and see how to use the package.

![Ticker search demo](https://raw.githubusercontent.com/ivofernandes/ticker_search/main/doc/search_ticker_search.png)

