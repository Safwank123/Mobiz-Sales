import '../entities/invoice.dart';

abstract class InvoiceRepository {
  Future<List<Invoice>> getInvoices();
  Future<bool> createInvoice(Map<String, dynamic> invoiceData);
}
