import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasource/customer_remote_data_source.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;

  CustomerRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Customer>> getCustomers(String routeId, String storeId) async {
    return await remoteDataSource.getCustomers(routeId, storeId);
  }
}
