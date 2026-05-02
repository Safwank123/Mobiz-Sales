import '../entities/product_detail_unit.dart';
import '../repositories/product_repository.dart';

class GetProductDetailUseCase {
  final ProductRepository repository;

  GetProductDetailUseCase(this.repository);

  Future<List<ProductDetailUnit>> execute(String productId) {
    return repository.getProductDetail(productId);
  }
}
