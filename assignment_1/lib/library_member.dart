import 'catalog_item.dart';

class LibraryMember {
  final String id;
  final String fullName;
  final List<CatalogItem> activeLoans = [];

  LibraryMember({
    required this.id,
    required this.fullName,
  });

  void listActiveLoans() {
    print('Current loans for $fullName (ID: $id):');
    if (activeLoans.isEmpty) {
      print('  - No active loans.');
      return;
    }

    for (final item in activeLoans) {
      print('  - [${item.id}] ${item.title}');
    }
  }
}
