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

class uploadFileToServer extends ClientPersonalDetailsEvent {
  String uId;
  File? imageFile;
  uploadFileToServer({
    required this.uId,
    this.imageFile,
  });
}
