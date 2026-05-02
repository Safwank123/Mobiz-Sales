import '../../domain/entities/customer.dart';

abstract class CustomerRepository {
  Future<List<Customer>> getCustomers(String routeId, String storeId);
}
