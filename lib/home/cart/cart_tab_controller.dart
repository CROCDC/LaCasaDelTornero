import 'package:lacasadeltonero/home/cart/firebase_cart_service.dart';

import '../../util/ui_status.dart';

class CartTabController {
  final FirebaseCartService service = FirebaseCartService();

  Future<UiStatus> getUiStatus() async {
    Future<UiStatus> future = Future.value(UiLoading());
    try {
      future = Future.value(UiListing(await service.fetchCartItems()));
    } catch (e) {
      future = Future.value(UiError());
    }
    return future;
  }
}
