import 'package:clg_project/ui/candidate_side/find_job/model/find_job_response.dart';

class JobDescriptionResponse {
  String? message;
  String? status;
  int? code;
  JobModel? data;

  JobDescriptionResponse({this.message, this.status, this.code, this.data});

  JobDescriptionResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? JobModel.fromJson(json['data']) : null;
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
