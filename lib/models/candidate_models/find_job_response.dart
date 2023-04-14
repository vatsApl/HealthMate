class FindJobResponse {
  String? message;
  String? status;
  int? code;
  List<JobModel>? data;
  int? curentPage;
  int? lastPage;
  bool? isLastPage;
  int? appliedCount;
  int? bookedCount;
  int? workedCount;
  int? totalPayment;

  FindJobResponse(
      {this.message,
      this.status,
      this.code,
      this.data,
      this.curentPage,
      this.lastPage,
      this.isLastPage,
      this.appliedCount,
      this.bookedCount,
      this.workedCount,
      this.totalPayment,
      });

  FindJobResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
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
    appliedCount = json['AppliedCount'];
    bookedCount = json['BookedCount'];
    workedCount = json['WorkedCount'];
    totalPayment = json['totalPayment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['curent_page'] = curentPage;
    data['last_page'] = lastPage;
    data['is_last_page'] = isLastPage;
    data['AppliedCount'] = this.appliedCount;
    data['BookedCount'] = this.bookedCount;
    data['WorkedCount'] = this.workedCount;
    data['totalPayment'] = this.totalPayment;
    return data;
  }
}

class JobModel {
  int? id;
  List<Candidates>? candidates;
  int? jobApplicationId;
  String? refNo;
  String? jobTitle;
  String? jobLocation;
  String? jobSalary;
  String? jobCategory;
  String? jobStartTime;
  String? jobEndTime;
  Cordinates? cordinates;
  int? jobVisit;
  String? jobDescription;
  String? jobParking;
  dynamic jobUnit;
  String? jobStatus;
  String? timesheetStatus;
  int? timesheetId;
  String? timesheetStartTime;
  String? timesheetEndTime;
  String? timesheetBreakTime;
  int? extraCount;
  int? totalApplications;
  String? breakTime;
  String? jobDate;
  String? workingStatus;
  String? candidateWorkingStatus;
  int? invoiceId;
  String? rejectReason;

  JobModel({
    this.id,
    this.candidates,
    this.jobApplicationId,
    this.refNo,
    this.jobTitle,
    this.jobLocation,
    this.jobSalary,
    this.jobCategory,
    this.jobStartTime,
    this.jobEndTime,
    this.cordinates,
    this.jobVisit = 0,
    this.jobStatus,
    this.timesheetStatus,
    this.timesheetId,
    this.timesheetStartTime,
    this.timesheetEndTime,
    this.timesheetBreakTime,
    this.jobDescription,
    this.jobParking,
    this.jobUnit,
    this.extraCount,
    this.totalApplications,
    this.breakTime,
    this.jobDate,
    this.workingStatus,
    this.candidateWorkingStatus,
    this.invoiceId,
    this.rejectReason,
  });

  JobModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['candidates'] != null) {
      candidates = <Candidates>[];
      json['candidates'].forEach((v) {
        candidates!.add(Candidates.fromJson(v));
      });
    }
    cordinates = json['cordinates'] != null
        ? new Cordinates.fromJson(json['cordinates'])
        : null;
    jobApplicationId = json['application_id'];
    jobStatus = json['Job_status'];
    timesheetStatus = json['timesheet_status'];
    timesheetId = json['timesheet_id'];
    timesheetStartTime = json['timesheet_start_time'];
    timesheetEndTime = json['timesheet_end_time'];
    timesheetBreakTime = json['timesheet_break_time'];
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
    workingStatus = json['working_status'];
    candidateWorkingStatus = json['candidate_working_status'];
    invoiceId = json['invoice_id'];
    rejectReason = json['reject_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (candidates != null) {
      data['candidates'] = candidates!.map((v) => v.toJson()).toList();
    }
    if (this.cordinates != null) {
      data['cordinates'] = this.cordinates!.toJson();
    }
    data['application_id'] = jobApplicationId;
    data['ref_no'] = refNo;
    data['Job_status'] = this.jobStatus;
    data['timesheet_status'] = this.timesheetStatus;
    data['timesheet_id'] = this.timesheetId;
    data['timesheet_start_time'] = this.timesheetStartTime;
    data['timesheet_end_time'] = this.timesheetEndTime;
    data['timesheet_break_time'] = this.timesheetBreakTime;
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
    data['working_status'] = this.workingStatus;
    data['candidate_working_status'] = this.candidateWorkingStatus;
    data['invoice_id'] = this.invoiceId;
    data['reject_reason'] = this.rejectReason;
    return data;
  }
}

class Candidates {
  int? candidateId;
  int? applicationId;
  String? avatar;
  String? fullName;
  String? role;

  Candidates({this.candidateId, this.applicationId, this.avatar, this.fullName, this.role});

  Candidates.fromJson(Map<String, dynamic> json) {
    candidateId = json['candidate_id'];
    applicationId = json['application_id'];
    avatar = json['avatar'];
    fullName = json['full_name'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['candidate_id'] = candidateId;
    data['application_id'] = applicationId;
    data['avatar'] = avatar;
    data['full_name'] = fullName;
    data['role'] = role;
    return data;
  }
}

class Cordinates {
  double? latitude;
  double? longtitude;

  Cordinates({this.latitude, this.longtitude});

  Cordinates.fromJson(Map<String, dynamic> json) {
    latitude = json['Latitude'];
    longtitude = json['Longtitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Latitude'] = this.latitude;
    data['Longtitude'] = this.longtitude;
    return data;
  }
}