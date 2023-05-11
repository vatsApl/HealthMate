abstract class InvoiceEvent {}

class ShowInvoiceEvent extends InvoiceEvent {
  int pageValue;
  String status;
  ShowInvoiceEvent({
    required this.pageValue,
    required this.status,
  });
}
