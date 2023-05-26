abstract class InvoiceEvent {}

class ShowInvoiceEvent extends InvoiceEvent {
  int pageValue;
  ShowInvoiceEvent({
    required this.pageValue,
  });
}

class MarkAsPaidEvent extends InvoiceEvent {
  int? invoiceId;
  MarkAsPaidEvent({this.invoiceId});
}
