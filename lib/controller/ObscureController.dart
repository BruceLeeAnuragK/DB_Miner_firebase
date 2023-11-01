import 'package:get/get.dart';

class ObscureController extends GetxController {
  RxBool obscureText = true.obs;
  showText() {
    obscureText.value != obscureText.value;
    update();
  }
}
