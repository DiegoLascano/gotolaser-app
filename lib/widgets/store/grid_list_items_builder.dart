import 'package:flutter/material.dart';
import 'package:go_to_laser_store/widgets/store/empty_content.dart';
import 'package:go_to_laser_store/widgets/store/product_card_skeleton_widget.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class GridListItemsBuilder<T> extends StatelessWidget {
  const GridListItemsBuilder({
    Key key,
    @required this.itemsList,
    @required this.scrollController,
    @required this.itemBuilder,
    @required this.isLoading,
  }) : super(key: key);

  final List<T> itemsList;
  final bool isLoading;
  final ScrollController scrollController;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (itemsList != null) {
      final List<T> items = itemsList;
      if (itemsList.isNotEmpty) {
        return _buildContent(items);
      } else if (items.isEmpty && isLoading == true) {
        return _buildLoadingAnimation();
      } else {
        return EmptyContent();
      }
    } else {
      return _buildLoadingAnimation();
    }
  }

  Widget _buildContent(List<T> items) {
    // TODO: try Gridview.builder to simplify logic
    return ListView.builder(
      itemCount: items.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index % 2 == 0) {
          return Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Flexible(flex: 1, child: itemBuilder(context, items[index])),
                  SizedBox(width: 10),
                  items.length % 2 != 0 && index == items.length - 1
                      ? Flexible(flex: 1, child: Container())
                      : Flexible(
                          flex: 1,
                          child: itemBuilder(context, items[index + 1]))
                ],
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildLoadingAnimation() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SizedBox(height: 10.0),
            Row(
              children: [
                Flexible(flex: 1, child: ProductCardSkeleton()),
                SizedBox(width: 10),
                Flexible(flex: 1, child: ProductCardSkeleton()),
              ],
            ),
          ],
        );
      },
    );
  }
}
