class SearchResult {
  /*Si la persona cancela o no quiere buscar nada,
  si la persona quiere irse de manera manual
  */
  final bool cancel;
  final bool manual;

  SearchResult({required this.cancel, this.manual = false});

  @override
  String toString() {
    return '{ cancel: $cancel, manual: $manual}';
  }
}
