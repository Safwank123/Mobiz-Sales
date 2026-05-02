import '../repositories/invoice_repository.dart';

class CreateInvoiceUseCase {
  final InvoiceRepository repository;

  CreateInvoiceUseCase(this.repository);

  Future<bool> execute(Map<String, dynamic> invoiceData) {
    return repository.createInvoice(invoiceData);
  }
}
