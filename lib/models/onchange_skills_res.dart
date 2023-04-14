class OnchangeSkillResponse {
  String? message;
  String? status;
  int? code;
  List<String>? data;

  OnchangeSkillResponse({this.message, this.status, this.code, this.data});

  OnchangeSkillResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['code'] = this.code;
    data['data'] = this.data;
    return data;
  }
}