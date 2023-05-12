abstract class InvoiceState {}

class InvoiceInitialState extends InvoiceState {}

class InvoiceLoadingState extends InvoiceState {}

class MarkAsPaidLoadingState extends InvoiceState {}

class InvoiceLoadedState extends InvoiceState {
  dynamic response;
  InvoiceLoadedState(this.response);
}

class MarkAsPaidLoadedState extends InvoiceState {
  dynamic response;
  MarkAsPaidLoadedState(this.response);
}

class InvoiceErrorState extends InvoiceState {
  final String error;
  InvoiceErrorState({required this.error});
}

class MarkAsPaidErrorState extends InvoiceState {
  final String error;
  MarkAsPaidErrorState({required this.error});
}
