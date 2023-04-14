class RoleAndSkillsResponse {
  String? message;
  String? status;
  int? code;
  List<String>? allRole;
  String? role;
  List<String>? data;

  RoleAndSkillsResponse(
      {this.message,
        this.status,
        this.code,
        this.allRole,
        this.role,
        this.data});

  RoleAndSkillsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    if (json['AllRole'] != null) { //
      allRole = <String>[];
      json['AllRole'].forEach((v) {
        allRole!.add(v);
      });
    }
    role = json['Role'];

    if (json['data'] != null) {
      data = <String>[];
      json['data'].forEach((v) {
        data!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['code'] = this.code;
    data['AllRole'] = this.allRole;
    if (this.allRole != null) {
      data['AllRole'] = this.allRole!.map((v) => v).toList();
    }
    data['Role'] = this.role;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v).toList();
    }
    return data;
  }
}

// class Data {
//   List<String>? l5;
//
//   Data({this.l5});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     l5 = json['5'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['5'] = this.l5;
//     return data;
//   }
// }