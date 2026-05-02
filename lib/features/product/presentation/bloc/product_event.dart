import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductEvent {
  final String storeId;

  const FetchProducts({required this.storeId});

  @override
  List<Object> get props => [storeId];
}

class FetchProductDetail extends ProductEvent {
  final String productId;

  const FetchProductDetail(this.productId);

  @override
  List<Object> get props => [productId];
}
