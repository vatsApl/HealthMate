abstract class InvoiceEvent {}

class ShowInvoiceEvent extends InvoiceEvent {
  int pageValue;
  String status;
  ShowInvoiceEvent({
    required this.pageValue,
    required this.status,
  });
}

class MarkAsPaidEvent extends InvoiceEvent {
  int? invoiceId;
  MarkAsPaidEvent({this.invoiceId});
}
