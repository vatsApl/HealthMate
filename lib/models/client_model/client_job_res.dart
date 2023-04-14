class ClientJobModelResponse {
  String? message;
  bool? success;
  int? code;
  List<JobModel>? data;
  int? curentPage;
  int? lastPage;
  bool? isLastPage;
  int? contractCount;
  int? timesheetCount;
  int? invoiceCount;
  int? allPayment;

  ClientJobModelResponse(
      {this.message,
      this.success,
      this.code,
      this.data,
      this.curentPage,
      this.lastPage,
      this.isLastPage,
      this.contractCount,
      this.timesheetCount,
      this.invoiceCount,
      this.allPayment,
      });

  ClientJobModelResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    code = json['code'];
    if (json['data'] != null) {
      data = <JobModel>[];
      json['data'].forEach((v) {
        data!.add(JobModel.fromJson(v));
      });
    }
    curentPage = json['curent_page'];
    lastPage = json['last_page'];
    isLastPage = json['is_last_page'];
    contractCount = json['ContractCount'];
    timesheetCount = json['TimesheetCount'];
    invoiceCount = json['InvoiceCount'];
    allPayment = json['AllPayment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['success'] = success;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['curent_page'] = curentPage;
    data['last_page'] = lastPage;
    data['is_last_page'] = isLastPage;
    data['ContractCount'] = this.contractCount;
    data['TimesheetCount'] = this.timesheetCount;
    data['InvoiceCount'] = this.invoiceCount;
    data['AllPayment'] = this.allPayment;
    return data;
  }
}

class JobModel {
  int? id;
  int? jobApplicationId;
  String? refNo;
  String? jobTitle;
  String? jobLocation;
  String? jobSalary;
  String? jobCategory;
  String? jobStartTime;
  String? jobEndTime;
  int? jobVisit;
  String? jobDescription;
  String? jobParking;
  double? jobUnit;
  String? jobStatus;
  String? timesheetStatus;
  int? timesheetId;
  int? extraCount;
  int? totalApplications;
  String? breakTime;
  String? jobDate;

  JobModel({
    this.id,
    this.jobApplicationId,
    this.refNo,
    this.jobTitle,
    this.jobLocation,
    this.jobSalary,
    this.jobCategory,
    this.jobStartTime,
    this.jobEndTime,
    this.jobVisit = 0,
    this.jobStatus,
    this.timesheetStatus,
    this.timesheetId,
    this.jobDescription,
    this.jobParking,
    this.jobUnit,
    this.extraCount,
    this.totalApplications,
    this.breakTime,
    this.jobDate,
  });

  JobModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobApplicationId = json['application_id'];
    jobStatus = json['Job_status'];
    timesheetStatus = json['timesheet_status'];
    timesheetId = json['timesheet_id'];
    refNo = json['ref_no'];
    jobTitle = json['job_title'];
    jobLocation = json['job_location'];
    jobSalary = json['job_salary'];
    jobCategory = json['job_category'];
    jobStartTime = json['job_start_time'];
    jobEndTime = json['job_end_time'];
    jobVisit = json['visits'];
    jobDescription = json['job_description'];
    jobParking = json['parking'];
    jobUnit = json['unit'];
    extraCount = json['extra_count'];
    totalApplications = json['total_applications'];
    breakTime = json['break_time'];
    jobDate = json['job_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['application_id'] = jobApplicationId;
    data['ref_no'] = refNo;
    data['Job_status'] = this.jobStatus;
    data['timesheet_status'] = this.timesheetStatus;
    data['timesheet_id'] = this.timesheetId;
    data['job_title'] = jobTitle;
    data['job_location'] = jobLocation;
    data['job_salary'] = jobSalary;
    data['job_category'] = jobCategory;
    data['job_start_time'] = jobStartTime;
    data['job_end_time'] = jobEndTime;
    data['visits'] = jobVisit;
    data['job_description'] = jobDescription;
    data['parking'] = jobParking;
    data['unit'] = jobUnit;
    data['extra_count'] = extraCount;
    data['total_applications'] = totalApplications;
    data['break_time'] = breakTime;
    data['job_date'] = this.jobDate;
    return data;
  }
}

