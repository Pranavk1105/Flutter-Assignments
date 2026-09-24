abstract class CatalogItem {
  final String id;
  final String title;
  bool isAvailable;

  CatalogItem({
    required this.id,
    required this.title,
    this.isAvailable = true,
  });

  void displayInfo();
}
