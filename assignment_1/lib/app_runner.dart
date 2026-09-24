import 'catalog_item.dart';
import 'book_item.dart';
import 'periodical_item.dart';
import 'library_member.dart';
import 'library_service.dart';
import 'fine_calculator.dart';

void runLibraryApp() {
  final cityLib = LibraryService('Metropolis Public Library');

  cityLib.addItem(BookItem(
    id: 'BK-101',
    title: 'Design Patterns',
    author: 'Erich Gamma et al.',
    pageCount: 395,
    category: 'Software Engineering',
  ));

  cityLib.addItem(BookItem(
    id: 'BK-102',
    title: 'Flutter in Action',
    author: 'Eric Windmill',
    pageCount: 360,
    category: 'Mobile Development',
  ));

  cityLib.addItem(PeriodicalItem(
    id: 'MG-201',
    title: 'Tech Horizons',
    issueNo: 142,
    publicationDate: 'September 2026',
  ));

  final member1 = LibraryMember(id: 'MEM-001', fullName: 'Sarah Connor');
  final member2 = LibraryMember(id: 'MEM-002', fullName: 'John Doe');
  cityLib.enrollMember(member1);
  cityLib.enrollMember(member2);

  cityLib.printCatalog();

  print('\n>>> PROCESSING CHECKOUTS <<<');
  cityLib.issueItem(itemId: 'BK-101', memberId: 'MEM-001');
  cityLib.issueItem(itemId: 'MG-201', memberId: 'MEM-002');
  cityLib.issueItem(itemId: 'BK-101', memberId: 'MEM-002');

  print('\n>>> MEMBER LOANS SUMMARY <<<');
  member1.listActiveLoans();
  member2.listActiveLoans();

  print('\n>>> SEARCHING CATALOG FOR "Flutter" <<<');
  List<CatalogItem> searchResults = cityLib.findItemsByKeyword('Flutter');
  for (final item in searchResults) {
    item.displayInfo();
  }

  print('\n>>> PROCESSING ITEM RETURN & FINE CALCULATION <<<');
  cityLib.receiveReturn(itemId: 'BK-101', memberId: 'MEM-001');

  int daysLate = 5;
  double fineAmount = computeFine(overdueDays: daysLate, dailyRate: 1.75);
  print('Late penalty for $daysLate overdue day(s): \$${fineAmount.toStringAsFixed(2)}');

  cityLib.printCatalog();
}
