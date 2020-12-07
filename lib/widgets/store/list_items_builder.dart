import 'package:flutter/material.dart';
import 'package:go_to_laser_store/styles/dimensions.dart';
import 'package:go_to_laser_store/widgets/common/skeleton_loader_widget.dart';
import 'package:go_to_laser_store/widgets/store/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
    this.loadingAnimation: const CircularProgressIndicator(),
    this.nativeAd,
  }) : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final Widget loadingAnimation;
  final Widget nativeAd;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Alga salió mal',
        message:
            'No se pueden cargar la información por ahora. Vuelve más tarde.',
      );
    }
    return Center(
      child: loadingAnimation,
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      // shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => SizedBox(height: 10.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        if (index % 4 == 0) {
          return Column(
            children: [
              index == 0 ? SizedBox(height: 10.0) : Container(),
              nativeAd,
              SizedBox(height: 10.0),
              itemBuilder(context, items[index]),
            ],
          );
        }
        ;
        return itemBuilder(context, items[index]);
      },
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
