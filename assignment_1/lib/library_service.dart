import 'catalog_item.dart';
import 'library_member.dart';

class LibraryService {
  final String libraryName;
  final List<CatalogItem> catalog = [];
  final Map<String, LibraryMember> members = {};

  LibraryService(this.libraryName);

  void addItem(CatalogItem item) {
    catalog.add(item);
  }

  void enrollMember(LibraryMember member) {
    members[member.id] = member;
  }

  void printCatalog() {
    print('\n================ $libraryName CATALOG ================');
    if (catalog.isEmpty) {
      print('The catalog is currently empty.');
      return;
    }

    for (int i = 0; i < catalog.length; i++) {
      catalog[i].displayInfo();
    }
  }

  bool issueItem({required String itemId, required String memberId}) {
    final member = members[memberId];
    if (member == null) {
      print('Error: Member "$memberId" is not registered.');
      return false;
    }

    CatalogItem? requestedItem;
    int idx = 0;
    while (idx < catalog.length) {
      if (catalog[idx].id == itemId) {
        requestedItem = catalog[idx];
        break;
      }
      idx++;
    }

    if (requestedItem == null) {
      print('Error: Item with ID "$itemId" was not found.');
      return false;
    }

    if (!requestedItem.isAvailable) {
      print('Notice: "${requestedItem.title}" is already checked out.');
      return false;
    }

    requestedItem.isAvailable = false;
    member.activeLoans.add(requestedItem);
    print('Success: "${requestedItem.title}" issued to ${member.fullName}.');
    return true;
  }

  bool receiveReturn({required String itemId, required String memberId}) {
    final member = members[memberId];
    if (member == null) {
      print('Error: Member "$memberId" is not registered.');
      return false;
    }

    CatalogItem? loanedItem;
    for (final item in member.activeLoans) {
      if (item.id == itemId) {
        loanedItem = item;
        break;
      }
    }

    if (loanedItem == null) {
      print('Error: ${member.fullName} does not hold item ID "$itemId".');
      return false;
    }

    loanedItem.isAvailable = true;
    member.activeLoans.remove(loanedItem);
    print('Success: "${loanedItem.title}" returned by ${member.fullName}.');
    return true;
  }

  List<CatalogItem> findItemsByKeyword(String keyword) {
    final List<CatalogItem> matched = [];
    final searchTerm = keyword.toLowerCase();

    for (final item in catalog) {
      if (item.title.toLowerCase().contains(searchTerm)) {
        matched.add(item);
      }
    }
    return matched;
  }
}
