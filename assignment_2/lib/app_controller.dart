import 'network_response.dart';
import 'collection_helpers.dart';
import 'simulated_api_client.dart';
import 'user_account.dart';

class AsyncDemoController {
  final SimulatedApiClient apiClient;

  AsyncDemoController({SimulatedApiClient? client})
      : apiClient = client ?? SimulatedApiClient(latencyMs: 350);

  /// Orchestrates and executes all async demonstration scenarios
  Future<void> executeAllDemos() async {
    final log = buildSequentialLogger(tag: 'ASYNC_RUNNER');

    print('================================================================');
    print('  🔧 DART ASYNC, FUTURE & NULL SAFETY SHOWCASE (ASSIGNMENT 2)');
    print('================================================================\n');

    // DEMO 1: Complete User Account Fetch
    print('>>> DEMO 1: Retrieving Complete User Account (ID: 101) <<<');
    log('Sending request for User #101...');
    NetworkResponse<UserAccount> completeResult = await apiClient.getUserAccount(101);
    _processUserResponse(completeResult);

    await Future.delayed(const Duration(milliseconds: 150));

    // DEMO 2: Partial Account with Null Fields (Null Safety in action)
    print('\n>>> DEMO 2: Retrieving Partial Account with Null Fields (ID: 102) <<<');
    log('Sending request for User #102...');
    NetworkResponse<UserAccount> partialResult = await apiClient.getUserAccount(102);
    _processUserResponse(partialResult);

    await Future.delayed(const Duration(milliseconds: 150));

    // DEMO 3: Resource Not Found / Null Payload (ID: 404)
    print('\n>>> DEMO 3: Retrieving Non-Existent User (ID: 404 / Not Found) <<<');
    log('Sending request for User #404...');
    NetworkResponse<UserAccount> missingResult = await apiClient.getUserAccount(404);
    _processUserResponse(missingResult);

    await Future.delayed(const Duration(milliseconds: 150));

    // DEMO 4: Simulated Server Error 500 (Exception Handling)
    print('\n>>> DEMO 4: Simulated Server Failure (ID: 500 / Exception) <<<');
    log('Sending request for User #500...');
    NetworkResponse<UserAccount> errorResult = await apiClient.getUserAccount(500);
    _processUserResponse(errorResult);

    await Future.delayed(const Duration(milliseconds: 150));

    // DEMO 5: Batch Async Fetch & Generic Collection Transformation
    print('\n>>> DEMO 5: Batch Async Fetch & Generic Collection Transform <<<');
    log('Fetching Gadget Inventory batch...');
    NetworkResponse<List<Map<String, dynamic>>> inventoryResult = await apiClient.getGadgetInventory();

    switch (inventoryResult) {
      case ResponseSuccess(:final payload):
        print('  [OK] Received ${payload.length} inventory items. Running generic mapper:');

        // Transform Map entries into formatted display lines via generic function
        List<String> itemLines = mapCollection<Map<String, dynamic>, String>(
          payload,
          (item) {
            String name = (item['title'] as String?) ?? 'Unnamed Item';
            double cost = (item['price'] as num?)?.toDouble() ?? 0.0;
            int qty = (item['stock'] as int?) ?? 0;
            String availability = qty > 0 ? '$qty available' : 'SOLD OUT';
            return '  ▸ $name — \$${cost.toStringAsFixed(2)} ($availability)';
          },
        );

        for (var line in itemLines) {
          print('  $line');
        }

        // Null-coalescing assignment demonstration
        String? activeCurrency;
        activeCurrency ??= 'INR (₹)';
        print('  Selected Currency (via ??= operator): $activeCurrency');
        break;

      case ResponseFailure(:final reason):
        print('  [FAIL] Inventory fetch error: $reason');
        break;

      case ResponseNoContent(:final description):
        print('  [EMPTY] $description');
        break;
    }

    print('\n================================================================');
    print('  ✅ ALL DEMONSTRATION SCENARIOS EXECUTED SUCCESSFULLY');
    print('================================================================');
  }

  /// Handles and displays User Account results using Dart 3 pattern matching
  void _processUserResponse(NetworkResponse<UserAccount> response) {
    // Dart 3 sealed class pattern matching with record destructuring
    switch (response) {
      case ResponseSuccess(:final payload, :final httpStatus):
        print('  [HTTP $httpStatus — OK] User account retrieved and parsed:');
        payload.printAccountInfo();

      case ResponseNoContent(:final description):
        print('  [HTTP 404 — NOT FOUND] No record available.');
        print('  Details: $description');

      case ResponseFailure(:final reason, :final httpStatus):
        print('  [HTTP ${httpStatus ?? "ERR"}] Request handled gracefully!');
        print('  Reason: $reason');
    }
  }
}
