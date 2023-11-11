import 'package:flutter/material.dart';

/// Represents a suggestion for a stock ticker, containing an icon, a title, and a map of company tickers.
///
/// This class is typically used to model data for a suggestion or search result in a financial application,
/// where users can choose from a list of tickers.
class TickerSuggestion {
  /// An icon representing the stock ticker or the market segment.
  final Widget icon;

  /// The title of the suggestion, which could be a market segment or category.
  final String title;

  /// A mapping of ticker symbols to company names.
  final Map<String, String> companies;

  /// Constructs a [TickerSuggestion] with the specified [icon], [title], and [companies].
  ///
  /// The [icon] is usually an image or an icon that represents the suggestion.
  /// The [title] is a string that represents the category or type of the tickers.
  /// The [companies] is a map where the key is the ticker symbol and the value is the company name.
  TickerSuggestion(
    this.icon,
    this.title,
    this.companies,
  );
}
