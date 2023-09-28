class ChatModel {
  int? senderId;
  int? receiverId;
  String? messageType;
  String? message;
  String? senderType;
  String? receiverType;

  ChatModel(
      {this.senderId,
      this.receiverId,
      this.messageType,
      this.message,
      this.senderType,
      this.receiverType});

  ChatModel.fromJson(Map<String, dynamic> json) {
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    messageType = json['message_type'];
    message = json['message'];
    senderType = json['sender_type'];
    receiverType = json['receiver_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['message_type'] = this.messageType;
    data['message'] = this.message;
    data['sender_type'] = this.senderType;
    data['receiver_type'] = this.receiverType;
    return data;
  }
}
