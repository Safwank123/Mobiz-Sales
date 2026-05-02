import '../../../../config/api/api_services.dart';
import '../../../../config/constants/app_constants.dart';
import '../models/invoice_model.dart';

abstract class InvoiceRemoteDataSource {
  Future<List<InvoiceModel>> getInvoices();
  Future<bool> createInvoice(Map<String, dynamic> invoiceData);
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final ApiServices apiServices;

  InvoiceRemoteDataSourceImpl(this.apiServices);

  @override
  Future<List<InvoiceModel>> getInvoices() async {
    final response = await apiServices.getRequest(
      UrlConstants.getInvoices,
      queryParams: {'user_id': '150', 'store_id': '112', 'van_id': '0'},
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
      }
      return list.map((e) => InvoiceModel.fromJson(e)).toList();
    }
    throw 'Failed to fetch invoices';
  }

  @override
  Future<bool> createInvoice(Map<String, dynamic> invoiceData) async {
    final response = await apiServices.postRequest(UrlConstants.createInvoice, body: invoiceData);
    if (response != null) {
      return response['success'] == true || response['status'] == 200 || response['status'] == 'success';
    }
    return false;
  }
}
