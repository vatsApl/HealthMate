// import 'package:clg_project/models/candidate_models/find_job_response.dart';
//
// class HomePageResponse {
//   bool? success;
//   String? message;
//   List<JobModel>? data;
//   int? curentPage;
//   int? lastPage;
//   bool? isLastPage;
//
//   HomePageResponse(
//       {this.success,
//       this.message,
//       this.data,
//       this.curentPage,
//       this.lastPage,
//       this.isLastPage});
//
//   HomePageResponse.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <JobModel>[];
//       json['data'].forEach((v) {
//         data!.add(JobModel.fromJson(v));
//       });
//     }
//     curentPage = json['curent_page'];
//     lastPage = json['last_page'];
//     isLastPage = json['is_last_page'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['success'] = success;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['curent_page'] = curentPage;
//     data['last_page'] = lastPage;
//     data['is_last_page'] = isLastPage;
//     return data;
//   }
// }
//
// class HomePageJobModel {
//   int? jobId;
//   String? jobTitle;
//   String? jobLocation;
//   String? jobSalary;
//   String? jobDate;
//   String? jobStartTime;
//   String? jobEndTime;
//   String? jobCategory;
//
//   HomePageJobModel(
//       {this.jobId,
//       this.jobTitle,
//       this.jobLocation,
//       this.jobSalary,
//       this.jobDate,
//       this.jobStartTime,
//       this.jobEndTime,
//       this.jobCategory});
//
//   HomePageJobModel.fromJson(Map<String, dynamic> json) {
//     jobId = json['job_id'];
//     jobTitle = json['job_title'];
//     jobLocation = json['job_location'];
//     jobSalary = json['job_salary'];
//     jobDate = json['job_date'];
//     jobStartTime = json['job_start_time'];
//     jobEndTime = json['job_end_time'];
//     jobCategory = json['job_category'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['job_id'] = jobId;
//     data['job_title'] = jobTitle;
//     data['job_location'] = jobLocation;
//     data['job_salary'] = jobSalary;
//     data['job_date'] = jobDate;
//     data['job_start_time'] = jobStartTime;
//     data['job_end_time'] = jobEndTime;
//     data['job_category'] = jobCategory;
//     return data;
//   }
// }
//
// // class HomePageResponse {
// //   bool? success;
// //   List<HomePageJobModel>? data;
// //
// //   HomePageResponse({this.success, this.data});
// //
// //   HomePageResponse.fromJson(Map<String, dynamic> json) {
// //     success = json['success'];
// //     if (json['data'] != null) {
// //       data = <HomePageJobModel>[];
// //       json['data'].forEach((v) {
// //         data!.add(new HomePageJobModel.fromJson(v));
// //       });
// //     }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['success'] = this.success;
// //     if (this.data != null) {
// //       data['data'] = this.data!.map((v) => v.toJson()).toList();
// //     }
// //     return data;
// //   }
// // }
// //
// // class HomePageJobModel {
// //   int? jobId;
// //   String? jobTitle;
// //   String? jobLocation;
// //   String? jobSalary;
// //   String? jobDate;
// //   String? jobStartTime;
// //   String? jobEndTime;
// //   String? jobCategory;
// //
// //   HomePageJobModel(
// //       {this.jobId,
// //         this.jobTitle,
// //         this.jobLocation,
// //         this.jobSalary,
// //         this.jobDate,
// //         this.jobStartTime,
// //         this.jobEndTime,
// //         this.jobCategory});
// //
// //   HomePageJobModel.fromJson(Map<String, dynamic> json) {
// //     jobId = json['job_id'];
// //     jobTitle = json['job_title'];
// //     jobLocation = json['job_location'];
// //     jobSalary = json['job_salary'];
// //     jobDate = json['job_date'];
// //     jobStartTime = json['job_start_time'];
// //     jobEndTime = json['job_end_time'];
// //     jobCategory = json['job_category'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['job_id'] = this.jobId;
// //     data['job_title'] = this.jobTitle;
// //     data['job_location'] = this.jobLocation;
// //     data['job_salary'] = this.jobSalary;
// //     data['job_date'] = this.jobDate;
// //     data['job_start_time'] = this.jobStartTime;
// //     data['job_end_time'] = this.jobEndTime;
// //     data['job_category'] = this.jobCategory;
// //     return data;
// //   }
// // }
