import 'package:flutter/foundation.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:rxdart/rxdart.dart';

// TODO: check ordering on prices, it is not working

class SortBy {
  SortBy(this.value, this.text, this.sortOrder);

  String value;
  String text;
  String sortOrder;
}

enum LoadingState { INITIAL, LOADING, STABLE }

class ProductsBloc {
  ProductsBloc({
    @required this.woocommerce,
  });

  final WoocommerceServiceBase woocommerce;
  final int _pageSize = 10;

  final _isLoadingController = BehaviorSubject<LoadingState>();
  final _productsController = BehaviorSubject<List<Product>>();
  final _sortByController = BehaviorSubject<SortBy>.seeded(
      SortBy("modified", "El más nuevo", "desc"));

  /// Fetch data from stream
  Stream<LoadingState> get isLoadingStream => _isLoadingController.stream;
  Stream<List<Product>> get productsStream => _productsController.stream;
  Stream<SortBy> get sortByStream => _sortByController.stream;

  /// Insert values to the stream
  Function(LoadingState) get changeIsLoading => _isLoadingController.sink.add;
  Function(List<Product>) get changeProductsList =>
      _productsController.sink.add;
  Function(SortBy) get changeSortBy => _sortByController.sink.add;

  /// Get last value of the streams
  LoadingState get isLoading => _isLoadingController.value;
  List<Product> get productsList => _productsController.value;
  SortBy get sortByValues => _sortByController.value;

  /// Dispose streams
  dispose() {
    _productsController.close();
    _isLoadingController.close();
    _sortByController.close();
  }

  void _setIsLoading(LoadingState isLoading) {
    changeIsLoading(isLoading);
  }

  Future<List<Product>> _getProducts(
      Future<List<Product>> Function() getProductsMethod) async {
    try {
      final _fetchedProducts = await getProductsMethod();
      if (!(productsList == null)) {
        if (_fetchedProducts.length > 0) {
          final _newProductsList = productsList;
          _newProductsList.addAll(_fetchedProducts);
          return changeProductsList(_newProductsList);
        } else {
          /// This line does nothing, that is the expected behavior
          return _fetchedProducts;
        }
      }
      return changeProductsList(_fetchedProducts);
    } catch (e) {
      rethrow;
    } finally {
      _setIsLoading(LoadingState.STABLE);
    }
  }

  Future<List<Product>> getProducts({
    int pageNumber,
    int pageSize,
    String strSearch,
    String tagId,
    String categoryId,
    List<int> productsIds,
    String sortBy,
    String sortOrder = "asc",
  }) async =>
      await _getProducts(() => woocommerce.getProducts(
            pageNumber: pageNumber,
            pageSize: this._pageSize,
            strSearch: strSearch,
            tagId: tagId,
            categoryId: categoryId,
            productsIds: productsIds,
            sortBy: this.sortByValues.value,
            sortOrder: this.sortByValues.sortOrder,
          ));
}
