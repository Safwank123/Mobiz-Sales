import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

class GetInvoicesUseCase {
  final InvoiceRepository repository;

  GetInvoicesUseCase(this.repository);

  Future<List<Invoice>> execute() {
    return repository.getInvoices();
  }
}
