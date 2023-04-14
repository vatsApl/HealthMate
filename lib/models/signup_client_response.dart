class SignUpClientResponse {
  Data? data;
  int? type;
  int? code;

  SignUpClientResponse({this.data, this.type, this.code});

  SignUpClientResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    type = json['type'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['type'] = type;
    data['code'] = code;
    return data;
  }
}

class Data {
  int? id;
  String? practiceName;
  String? email;
  String? phone;
  String? address;
  String? otp;
  String? otpExpire;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.practiceName,
      this.email,
      this.phone,
      this.address,
      this.otp,
      this.otpExpire,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    practiceName = json['practice_name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    otp = json['otp'];
    otpExpire = json['otp_expire'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['practice_name'] = practiceName;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['otp'] = otp;
    data['otp_expire'] = otpExpire;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
