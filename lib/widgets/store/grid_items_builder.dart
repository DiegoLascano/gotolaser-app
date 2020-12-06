import 'package:flutter/material.dart';
import 'package:go_to_laser_store/widgets/store/empty_content.dart';

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
    if (itemsList != null) {
      final List<T> items = itemsList;
      if (items.isNotEmpty) {
        return _buildGrid(context, items);
      } else if (items.isEmpty && isLoading == true) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return EmptyContent();
      }
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildGrid(BuildContext context, List<T> items) {
    return GridView.count(
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      controller: scrollController,
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      childAspectRatio: 0.52,
      children: items.map((item) => itemBuilder(context, item)).toList(),
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
