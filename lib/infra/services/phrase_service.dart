import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:neumodore/domain/data/quote_model.dart';
import 'package:neumodore/shared/helpers/lists.dart';
import 'dart:async' show Future;

class PhraseService {
  Future<List<Quote>> fetchPhrases() async {
    String fileString = await rootBundle.loadString('assets/csv/quotes.csv');
    List<List<dynamic>> rows = const CsvToListConverter().convert(
      fileString,
      eol: '\n',
      allowInvalid: true,
      textDelimiter: '"',
      textEndDelimiter: '"',
    );

    return rows
        .map((e) => Quote.fromArray(e))
        .where((element) => element.quote.isNotEmpty)
        .toList();
  }

  Future<Quote> fetchRandomPhrase() async {
    return (await this.fetchPhrases()).getRandom();
  }
}
