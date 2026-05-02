import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class GetCustomersUseCase {
  final CustomerRepository repository;

  GetCustomersUseCase(this.repository);

  Future<List<Customer>> execute(String routeId, String storeId) {
    return repository.getCustomers(routeId, storeId);
  }
}
