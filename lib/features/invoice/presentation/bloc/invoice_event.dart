import 'package:equatable/equatable.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object> get props => [];
}

class FetchInvoices extends InvoiceEvent {}

class CreateInvoice extends InvoiceEvent {
  final Map<String, dynamic> invoiceData;

  const CreateInvoice(this.invoiceData);

  @override
  List<Object> get props => [invoiceData];
}
