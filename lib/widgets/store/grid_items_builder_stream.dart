import 'package:flutter/material.dart';
import 'package:go_to_laser_store/widgets/store/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class GridItemsBuilderStream<T> extends StatelessWidget {
  const GridItemsBuilderStream({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
    @required this.scrollController,
  }) : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final ScrollController scrollController;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildGrid(context, items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Alga salió mal',
        message: 'No se pueden cargar los productos ahora. Vuelve más tarde.',
      );
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
      childAspectRatio: 0.54,
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
