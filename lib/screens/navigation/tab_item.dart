import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem {
  store,
  coupons,
  about,
  // loved,
  // cart,
  // account,
}

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allData = {
    TabItem.store:
        TabItemData(title: 'Catálogo', icon: Icons.storefront_outlined),
    TabItem.coupons:
        TabItemData(title: 'Cupones', icon: Icons.local_offer_outlined),
    TabItem.about: TabItemData(title: 'Información', icon: Icons.info_outlined),
    // TabItem.loved:
    //     TabItemData(title: 'Favorito', icon: Icons.favorite_border_outlined),
    // TabItem.cart:
    //     TabItemData(title: 'Carrito', icon: Icons.shopping_cart_outlined),
    // TabItem.account: TabItemData(title: 'Cuenta', icon: Icons.person_outline),
  };
}
