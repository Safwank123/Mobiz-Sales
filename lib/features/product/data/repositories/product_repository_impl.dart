import 'package:mobiz_sales_app/features/product/domain/entities/product.dart';

import '../../domain/entities/product_detail_unit.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasource/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Product>> getProducts(String storeId) async {
    return await remoteDataSource.getProducts(storeId);
  }

  @override
  Future<List<ProductDetailUnit>> getProductDetail(String productId) async {
    return await remoteDataSource.getProductDetail(productId);
  }
}
