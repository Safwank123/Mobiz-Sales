import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_customers_usecase.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomersUseCase getCustomersUseCase;

  CustomerBloc(this.getCustomersUseCase) : super(CustomerInitial()) {
    on<FetchCustomers>(_onFetchCustomers);
  }

  Future<void> _onFetchCustomers(FetchCustomers event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    try {
      final customers = await getCustomersUseCase.execute(event.routeId, event.storeId);
      emit(CustomerLoaded(customers));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }
}
