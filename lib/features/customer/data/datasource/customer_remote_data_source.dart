import '../../../../config/api/api_services.dart';
import '../../../../config/constants/app_constants.dart';
import '../models/customer_model.dart';

abstract class CustomerRemoteDataSource {
  Future<List<CustomerModel>> getCustomers(String routeId, String storeId);
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final ApiServices apiServices;

  CustomerRemoteDataSourceImpl(this.apiServices);

  @override
  Future<List<CustomerModel>> getCustomers(String routeId, String storeId) async {
    final response = await apiServices.getRequest(
      UrlConstants.getCustomer,
      queryParams: {'route_id': routeId, 'store_id': storeId},
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
       } else if (response['customers'] is List) {
         list = response['customers'];
       }
       return list.map((e) => CustomerModel.fromJson(e)).toList();
    } else {
      throw 'Failed to fetch customers';
    }
  }
}
