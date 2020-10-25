class Quote {
  String authorName;
  String quote;

  Quote.fromArray(List array)
      : this.authorName = array[0] ?? "",
        this.quote = array[1] ?? "";

  Map<String, dynamic> toJSON() {
    return {'author': authorName, 'quote': quote};
  }

  int millisNeedToRead() {
    return authorName.split(" ").length * 500 + quote.split(" ").length * 500;
  }
}
