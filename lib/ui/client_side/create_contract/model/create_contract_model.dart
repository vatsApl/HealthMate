class CreateContractModel {
  String? message;
  String? status;
  int? code;
  Data? data;

  CreateContractModel({this.message, this.status, this.code, this.data});

  CreateContractModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Job? job;

  Data({this.job});

  Data.fromJson(Map<String, dynamic> json) {
    job = json['job'] != null ? new Job.fromJson(json['job']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.job != null) {
      data['job'] = this.job!.toJson();
    }
    return data;
  }
}

class Job {
  String? jobTitle;
  String? jobDescription;
  String? jobSalary;
  String? jobDate;
  String? jobCategory;
  String? jobStartTime;
  String? jobEndTime;
  String? breakTime;
  String? addressId;
  int? clientId;
  String? parking;
  String? unit;
  String? createdAt;
  String? updatedAt;
  int? id;
  String? refNo;

  Job(
      {this.jobTitle,
      this.jobDescription,
      this.jobSalary,
      this.jobDate,
      this.jobCategory,
      this.jobStartTime,
      this.jobEndTime,
      this.breakTime,
      this.addressId,
      this.clientId,
      this.parking,
      this.unit,
      this.createdAt,
      this.updatedAt,
      this.id,
      this.refNo});

  Job.fromJson(Map<String, dynamic> json) {
    jobTitle = json['job_title'];
    jobDescription = json['job_description'];
    jobSalary = json['job_salary'];
    jobDate = json['job_date'];
    jobCategory = json['job_category'];
    jobStartTime = json['job_start_time'];
    jobEndTime = json['job_end_time'];
    breakTime = json['break_time'];
    addressId = json['address_id'];
    clientId = json['client_id'];
    parking = json['parking'];
    unit = json['unit'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    id = json['id'];
    refNo = json['ref_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_title'] = this.jobTitle;
    data['job_description'] = this.jobDescription;
    data['job_salary'] = this.jobSalary;
    data['job_date'] = this.jobDate;
    data['job_category'] = this.jobCategory;
    data['job_start_time'] = this.jobStartTime;
    data['job_end_time'] = this.jobEndTime;
    data['break_time'] = this.breakTime;
    data['address_id'] = this.addressId;
    data['client_id'] = this.clientId;
    data['parking'] = this.parking;
    data['unit'] = this.unit;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    data['ref_no'] = this.refNo;
    return data;
  }
}
