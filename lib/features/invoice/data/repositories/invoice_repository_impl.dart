import '../../domain/entities/invoice.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasource/invoice_remote_data_source.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource remoteDataSource;

  InvoiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Invoice>> getInvoices() async {
    return await remoteDataSource.getInvoices();
  }

  @override
  Future<bool> createInvoice(Map<String, dynamic> invoiceData) async {
    return await remoteDataSource.createInvoice(invoiceData);
  }
}
