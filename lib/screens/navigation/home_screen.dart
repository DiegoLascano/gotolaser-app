// import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:go_to_laser_store/screens/about/about_home_screen.dart';

import 'package:go_to_laser_store/screens/account/account_screen.dart';
import 'package:go_to_laser_store/screens/cart/cart_screen.dart';
import 'package:go_to_laser_store/screens/coupons/coupons_home_screen.dart';
import 'package:go_to_laser_store/screens/navigation/cupertino_home_scaffold.dart';
import 'package:go_to_laser_store/screens/navigation/tab_item.dart';
import 'package:go_to_laser_store/screens/store/store_home_screen.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TODO: uncomment this bloc to enable AdMob Ads
  // TODO: refactor to move admob related code to an more appropiate place
  // @override
  // void initState() {
  //   super.initState();
  //   FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  // }

  TabItem _currentTab = TabItem.store;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.store: GlobalKey<NavigatorState>(),
    TabItem.coupons: GlobalKey<NavigatorState>(),
    TabItem.about: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.store: (_) => StoreHomeScreen.create(context),
      TabItem.coupons: (context) => CouponsHomeScreen.create(context),
      TabItem.about: (context) => AboutHomeScreen(),
      // TabItem.loved: (context) => Container(),
      // TabItem.cart: (_) => CartScreen(),
      // TabItem.account: (_) => AccountScreen(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectedTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
