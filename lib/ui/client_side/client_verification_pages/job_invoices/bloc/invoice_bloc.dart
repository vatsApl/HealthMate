import 'package:clg_project/ui/client_side/client_verification_pages/job_invoices/bloc/invoice_state.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_invoices/repo/invoice_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'invoice_event.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceRepository _invoiceRepository;
  InvoiceBloc(this._invoiceRepository) : super(InvoiceInitialState()) {
    on<InvoiceEvent>((event, emit) async {
      if (event is ShowInvoiceEvent) {
        emit(InvoiceLoadingState());
        try {
          var response = await _invoiceRepository.timesheetJobApi(
            pageValue: event.pageValue,
            status: event.status,
          );
          emit(InvoiceLoadedState(response));
        } catch (e) {
          emit(InvoiceErrorState(error: e.toString()));
        }
      }

      if (event is MarkAsPaidEvent) {
        emit(MarkAsPaidLoadingState());
        try {
          var response = await _invoiceRepository.markAsPaidApi(
              invoiceId: event.invoiceId);
          emit(MarkAsPaidLoadedState(response));
        } catch (e) {
          emit(MarkAsPaidErrorState(error: e.toString()));
        }
      }
    });
  }
}
