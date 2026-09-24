/// Generic mapping function that converts a list of elements from type S to type U
/// Showcases generic higher-order functions as discussed in Advanced Functions
List<U> mapCollection<S, U>(List<S> source, U Function(S) mapFn) {
  List<U> result = [];
  for (var element in source) {
    result.add(mapFn(element));
  }
  return result;
}

/// Factory function that creates a stateful logger closure
/// Each invocation increments the internal counter, demonstrating closure state capture
void Function(String text) buildSequentialLogger({String tag = 'NET_LOG'}) {
  int counter = 0;
  return (String text) {
    counter++;
    print('  [$tag #$counter] $text');
  };
}
