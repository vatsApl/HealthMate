class SigninClientResponse {
  String? message;
  int? type;
  int? code;
  List<Data>? data;

  SigninClientResponse({this.message, this.type, this.code, this.data});

  SigninClientResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    type = json['type'];
    code = json['code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['type'] = type;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? avatar;
  String? practiceName; //
  String? email;
  String? phone;
  String? address; //
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.avatar,
      this.practiceName,
      this.email,
      this.phone,
      this.address,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    practiceName = json['practice_name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['avatar'] = avatar;
    data['practice_name'] = practiceName;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
