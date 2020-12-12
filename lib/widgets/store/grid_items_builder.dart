import 'package:flutter/material.dart';
import 'package:go_to_laser_store/widgets/store/empty_content.dart';
import 'package:go_to_laser_store/widgets/store/product_card_skeleton_widget.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class GridItemsBuilder<T> extends StatelessWidget {
  const GridItemsBuilder({
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
    final _childAspectRatio = 0.514;
    if (itemsList != null) {
      final List<T> items = itemsList;
      if (items.isNotEmpty) {
        return _buildGrid(context, items, _childAspectRatio);
      } else if (items.isEmpty && isLoading == true) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: _buildLoadingSkeleton(_childAspectRatio),
        );
      } else {
        return EmptyContent();
      }
    }
    return _buildLoadingSkeleton(_childAspectRatio);
  }

  Widget _buildGrid(
      BuildContext context, List<T> items, double _childAspectRatio) {
    return GridView.builder(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index]);
      },
      // children: items.map((item) => itemBuilder(context, item)).toList(),
    );
  }

  Widget _buildLoadingSkeleton(double _childAspectRatio) {
    return GridView.count(
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      childAspectRatio: _childAspectRatio,
      children: [for (var i = 0; i < 6; i++) ProductCardSkeleton()],
    );
  }

// Widget _buildList(List<T> items) {
//   return ListView.separated(
//     itemCount: items.length + 2,
//     separatorBuilder: (_, __) => Divider(height: 1.5),
//     itemBuilder: (context, index) {
//       if (index == 0 || index == items.length + 1) return Container();
//       return itemBuilder(context, items[index - 1]);
//     },
//   );
// }
}
