import 'package:flutter/material.dart';
import 'package:lacasadeltonero/home/cart/cart_tab_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/ui_status.dart';
import 'cart_item.dart';

class CartTabWidget extends StatefulWidget {
  const CartTabWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CartTabWidgetState();
}

class CartTabWidgetState extends State<CartTabWidget> {
  @override
  Widget build(BuildContext context) {
    CartTabController controller = CartTabController();
    return FutureBuilder(
        future: controller.getUiStatus(),
        builder: (content, snapshoot) {
          if (snapshoot.hasData) {
            switch (snapshoot.data.runtimeType) {
              case UiLoading:
                return const CircularProgressIndicator();
              case UiListing<CartItem>:
                UiListing uiListing = snapshoot.data as UiListing<CartItem>;
                return ListView.builder(
                    itemCount: uiListing.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CartListWidget(cartItem: uiListing.list[index]);
                    });
              default:
                return const Text("unkonw error");
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class CartListWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartListWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(10.0),
        elevation: 20,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.network(
                        width: 200, height: 200, cartItem.urlImage)),
                Flexible(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10),
                        child: Text(
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            cartItem.title)),
                    Padding(
                        padding: const EdgeInsets.only(right: 10, top: 5),
                        child: Text(cartItem.description)),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(cartItem.price))
                  ],
                ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: goToWhatsapp,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.whatsapp),
                    Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text("Consultar!"))
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future<void> goToWhatsapp() async {
    await launchUrl(
        mode: LaunchMode.externalApplication,
        Uri(
            scheme: "https",
            path: "api.whatsapp.com/send",
            queryParameters: <String, String>{
              'text': "hola me interesa este producto ${cartItem.title}",
              'phone': "5491159964199"
            }));
  }
}
