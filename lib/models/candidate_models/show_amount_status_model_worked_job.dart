class ShowAmountStatusRes {
  String? message;
  String? status;
  int? code;
  int? data;

  ShowAmountStatusRes({this.message, this.status, this.code, this.data});

  ShowAmountStatusRes.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    data = json['data'];
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