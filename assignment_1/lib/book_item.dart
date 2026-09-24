import 'catalog_item.dart';

class BookItem extends CatalogItem {
  final String author;
  final int pageCount;
  final String category;

  BookItem({
    required super.id,
    required super.title,
    required this.author,
    required this.pageCount,
    required this.category,
    super.isAvailable = true,
  });

  @override
  void displayInfo() {
    final status = isAvailable ? 'Available' : 'Checked Out';
    print('[Book] ID: $id | "$title" by $author ($pageCount pp., $category) -> $status');
  }
}
