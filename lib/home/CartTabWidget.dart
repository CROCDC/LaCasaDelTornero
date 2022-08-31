import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CartTabWidget extends StatefulWidget {
  const CartTabWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CartTabWidgetState();
}

class CartTabWidgetState extends State<CartTabWidget> {
  final List<CartItem> cartItems = <CartItem>[
    CartItem(
        "Price: USD155.70",
        "Gubia 3/4 V",
        "These tools are made from the best steel on the market, CPM 10V® (A-11) a powder metal manufactured by Crucible Materials Corporation with a 9.75% vanadium content to hold the edge longer which has a proven history in wood turning. ",
        "https://cdn.shopify.com/s/files/1/0595/0533/products/12V_1024x1024.jpg?v=1606147643"),
    CartItem(
        "Price: USD91.40 ",
        "Thompson-U-Shaped Bowl Gouge 1/2",
        "Then is hardened to 60-62 Rockwell, triple cryogenic tempered treatment between the first and second temper",
        "https://cdn.shopify.com/s/files/1/0595/0533/products/a4fdadfc104d4d7b468013e2659972d5_1024x1024.png?v=1495579606")
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          return CartListWidget(cartItem: cartItems[index]);
        });
  }
}

class CartListWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartListWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Image.network(width: 200, height: 200, cartItem.image)),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(cartItem.title)),
                Padding(
                    padding: const EdgeInsets.only(right: 10),
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
    );
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

class CartItem {
  final String price;
  final String title;
  final String description;
  final String image;

  CartItem(this.price, this.title, this.description, this.image);
}
