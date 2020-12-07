import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/screens/navigation/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectedTab,
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: Colors.white, //this changes the top statusbar bg color
      tabBar: CupertinoTabBar(
        border: Border(
          top: BorderSide(color: Colors.transparent),
        ),
        backgroundColor: greySwatch.shade50,
        items: [
          _buildItem(context, TabItem.store),
          _buildItem(context, TabItem.coupons),
          _buildItem(context, TabItem.about),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: (context) => widgetBuilders[item](context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(BuildContext context, TabItem tabItem) {
    final itemData = TabItemData.allData[tabItem];
    final color = currentTab == tabItem
        ? Theme.of(context).primaryColorDark
        : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(
        itemData.icon,
        color: color,
      ),
      title: Text(
        itemData.title,
        style: TextStyle(color: color),
      ),
    );
  }
}
