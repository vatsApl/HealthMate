class PersonalDetailsResponse {
  String? message;
  String? status;
  int? code;
  Data? data;

  PersonalDetailsResponse({this.message, this.status, this.code, this.data});

  PersonalDetailsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? avatar;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? gender;

  Data(
      {this.avatar,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.gender});

  Data.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avatar'] = avatar;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['gender'] = gender;
    return data;
  }
}
