import '../../../../config/api/api_services.dart';
import '../../../../config/constants/app_constants.dart';
import '../models/product_model.dart';

import '../models/product_detail_unit_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts(String storeId);
  Future<List<ProductDetailUnitModel>> getProductDetail(String productId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiServices apiServices;

  ProductRemoteDataSourceImpl(this.apiServices);

  @override
  Future<List<ProductModel>> getProducts(String storeId) async {
    final response = await apiServices.getRequest(
      UrlConstants.getProduct,
      queryParams: {'store_id': storeId},
    );
    
    if (response != null) {
       final data = response['data'] ?? response;
       List list = [];
       if (data is List) {
         list = data;
       } else if (data is Map && data['data'] is List) {
         list = data['data'];
       } else if (data is Map && data['rows'] is List) {
         list = data['rows'];
       } else if (response['products'] is List) {
         list = response['products'];
       }
       return list.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw 'Failed to fetch products';
    }
  }

  @override
  Future<List<ProductDetailUnitModel>> getProductDetail(String productId) async {
    final response = await apiServices.getRequest(
      UrlConstants.getProductDetail,
      queryParams: {'product_id': productId},
    );
    if (response != null) {
      final data = response['data'] ?? response;
      List list = [];
      if (data is List) {
        list = data;
      } else if (data is Map && data['data'] is List) {
        list = data['data'];
      }
      return list.map((e) => ProductDetailUnitModel.fromJson(e)).toList();
    }
    throw 'Failed to fetch product details';
  }
}
