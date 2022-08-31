import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lacasadeltonero/home/cart/cart_item.dart';

class FirebaseCartService {
  Future<List<CartItem>> fetchCartItems() async {
    Future<List<CartItem>> result = Future.value(List.empty());

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('cart').get();

    final data = querySnapshot.docs.map((doc) => doc.data()).toList();

    List<CartItem> cartItems = List.empty(growable: true);
    for (var element in data) {
      element = (element as LinkedHashMap<String, dynamic>);
      cartItems.add(CartItem(element["description"], element["urlImage"],
          element["price"], element["title"]));
    }
    result = Future.value(cartItems);
    return result;
  }
}
