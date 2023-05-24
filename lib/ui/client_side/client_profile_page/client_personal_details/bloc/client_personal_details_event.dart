import 'dart:io';

abstract class ClientPersonalDetailsEvent {}

class ShowClientPersonalDetails extends ClientPersonalDetailsEvent {
  String uId;
  ShowClientPersonalDetails({required this.uId});
}

class UpdateClientDetails extends ClientPersonalDetailsEvent {
  Map<String, dynamic> params;
  UpdateClientDetails({required this.params});
}

class UploadFileToServer extends ClientPersonalDetailsEvent {
  String uId;
  File? imageFile;
  UploadFileToServer({
    required this.uId,
    this.imageFile,
  });
}
