import 'package:flutter/cupertino.dart';
import 'package:go_to_laser_store/models/product_model.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';

class SortBy {
  SortBy(this.value, this.text, this.sortOrder);

  String value;
  String text;
  String sortOrder;
}

// TODO: refactor LoadMoreStatus related names to something less ugly (LoadingState)
enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class ProductsProvider with ChangeNotifier {
  WoocommerceService _woocommerceService;
  List<Product> _productsList;
  SortBy _sortBy;

  int pageSize = 10;

  List<Product> get allProducts => _productsList;
  double get totalRecords => _productsList.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  ProductsProvider() {
    resetStreams();
    _sortBy = SortBy("modified", "El más nuevo", "asc");
  }

  void resetStreams() {
    _woocommerceService = WoocommerceService();
    _productsList = List<Product>();
  }

  setLoadingState(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

  setSortOrder(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  fetchProducts(
    int pageNumber, {
    int pageSize,
    String strSearch,
    String tagId,
    String categoryId,
    List<int> productsIds,
    String sortBy,
    String sortOrder = "asc",
  }) async {
    List<Product> products = await _woocommerceService.getProducts(
      strSearch: strSearch,
      tagId: tagId,
      categoryId: categoryId,
      pageNumber: pageNumber,
      productsIds: productsIds,
      pageSize: pageSize ?? this.pageSize,
      sortBy: this._sortBy.value,
      sortOrder: this._sortBy.sortOrder,
    );

    if (products.length > 0) _productsList.addAll(products);

    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();
  }
}
