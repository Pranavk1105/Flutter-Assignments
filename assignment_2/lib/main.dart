import 'app_controller.dart';

void main() async {
  final appController = AsyncDemoController();
  await appController.executeAllDemos();
}
