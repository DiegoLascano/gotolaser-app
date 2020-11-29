import 'package:flutter/foundation.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:rxdart/rxdart.dart';

class ProductsBloc {
  ProductsBloc({
    @required this.woocommerce,
    // @required this.isLoading,
  });

  final WoocommerceServiceBase woocommerce;
  // final ValueNotifier<bool> isLoading;
  final int _pageSize = 6;

  final _isLoadingController = BehaviorSubject<bool>();
  final _productsController = BehaviorSubject<List<Product>>();

  /// Fetch data from stream
  Stream<bool> get isLoadingStream => _isLoadingController.stream;
  Stream<List<Product>> get productsStream => _productsController.stream;

  /// Insert values to the stream
  Function(bool) get changeIsLoading => _isLoadingController.sink.add;
  Function(List<Product>) get changeProductsList =>
      _productsController.sink.add;

  /// Get last value of the streams
  bool get isLoading => _isLoadingController.value;
  List<Product> get productsList => _productsController.value;

  /// Dispose streams
  dispose() {
    _productsController.close();
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) {
    changeIsLoading(isLoading);
  }

  Future<List<Product>> _getProducts(
      Future<List<Product>> Function() getProductsMethod) async {
    try {
      _setIsLoading(true);
      final _fetchedProducts = await getProductsMethod();
      if (!(productsList == null) && _fetchedProducts.length > 0) {
        final _newProductsList = productsList;
        _newProductsList.addAll(_fetchedProducts);
        return changeProductsList(_newProductsList);
      }
      return changeProductsList(_fetchedProducts);
    } catch (e) {
      rethrow;
    } finally {
      _setIsLoading(false);
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
            sortBy: sortBy,
            sortOrder: sortOrder,
          ));
}
