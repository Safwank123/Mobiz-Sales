import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_invoices_usecase.dart';
import '../../domain/usecases/create_invoice_usecase.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final GetInvoicesUseCase getInvoicesUseCase;
  final CreateInvoiceUseCase createInvoiceUseCase;

  InvoiceBloc({
    required this.getInvoicesUseCase,
    required this.createInvoiceUseCase,
  }) : super(InvoiceInitial()) {
    on<FetchInvoices>(_onFetchInvoices);
    on<CreateInvoice>(_onCreateInvoice);
  }

  Future<void> _onFetchInvoices(FetchInvoices event, Emitter<InvoiceState> emit) async {
    emit(InvoiceLoading());
    try {
      final invoices = await getInvoicesUseCase.execute();
      emit(InvoiceLoaded(invoices));
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  Future<void> _onCreateInvoice(CreateInvoice event, Emitter<InvoiceState> emit) async {
    emit(InvoiceLoading());
    try {
      final success = await createInvoiceUseCase.execute(event.invoiceData);
      if (success) {
        emit(InvoiceCreated());
        add(FetchInvoices()); 
      } else {
        emit(const InvoiceError('Failed to create invoice'));
      }
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }
}
