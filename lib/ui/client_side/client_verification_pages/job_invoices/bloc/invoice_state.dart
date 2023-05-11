abstract class InvoiceState {}

class InvoiceInitialState extends InvoiceState {}

class InvoiceLoadingState extends InvoiceState {}

class InvoiceLoadedState extends InvoiceState {
  dynamic response;
  InvoiceLoadedState(this.response);
}

class InvoiceErrorState extends InvoiceState {
  final String error;
  InvoiceErrorState({required this.error});
}
