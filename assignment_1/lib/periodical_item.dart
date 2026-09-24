import 'catalog_item.dart';

class PeriodicalItem extends CatalogItem {
  final int issueNo;
  final String publicationDate;

  PeriodicalItem({
    required super.id,
    required super.title,
    required this.issueNo,
    required this.publicationDate,
    super.isAvailable = true,
  });

  @override
  void displayInfo() {
    final status = isAvailable ? 'Available' : 'Checked Out';
    print('[Periodical] ID: $id | "$title" (Issue #$issueNo, $publicationDate) -> $status');
  }
}
