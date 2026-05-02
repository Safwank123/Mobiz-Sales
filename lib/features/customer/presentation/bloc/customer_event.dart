import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class FetchCustomers extends CustomerEvent {
  final String routeId;
  final String storeId;

  const FetchCustomers({required this.routeId, required this.storeId});

  @override
  List<Object> get props => [routeId, storeId];
}
