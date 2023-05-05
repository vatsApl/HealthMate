// class ForgotPasswordResponse {
//   String? message;
//   int? type;
//   String? status;
//   int? code;
//   List<Data>? data;
//
//   ForgotPasswordResponse(
//       {this.message, this.type, this.status, this.code, this.data});
//
//   ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     type = json['type'];
//     status = json['status'];
//     code = json['code'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['message'] = message;
//     data['type'] = type;
//     data['status'] = status;
//     data['code'] = code;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   int? id;
//   String? avatar;
//   String? firstName;
//   String? lastName;
//   String? gender;
//   int? role;
//   String? email;
//   String? phone;
//   String? loginOtp;
//   String? loginOtpExpire;
//   String? createdAt;
//   String? updatedAt;
//
//   Data(
//       {this.id,
//       this.avatar,
//       this.firstName,
//       this.lastName,
//       this.gender,
//       this.role,
//       this.email,
//       this.phone,
//       this.loginOtp,
//       this.loginOtpExpire,
//       this.createdAt,
//       this.updatedAt});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     avatar = json['avatar'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     gender = json['gender'];
//     role = json['role'];
//     email = json['email'];
//     phone = json['phone'];
//     loginOtp = json['Login_otp'];
//     loginOtpExpire = json['Login_otp_expire'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['avatar'] = avatar;
//     data['first_name'] = firstName;
//     data['last_name'] = lastName;
//     data['gender'] = gender;
//     data['role'] = role;
//     data['email'] = email;
//     data['phone'] = phone;
//     data['Login_otp'] = loginOtp;
//     data['Login_otp_expire'] = loginOtpExpire;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }
