import 'package:clg_project/allAPIs/allAPIs.dart';

class ApiUrl {
  static String signIn = "${DataURL.baseUrl}/api/login";
  static String forgotPassword = "${DataURL.baseUrl}/api/forgotPassword";
  static String verifyOtpForgotPassword =
      "${DataURL.baseUrl}/api/verifyforgototp";
  static String forgotPasswordResendOtp =
      "${DataURL.baseUrl}/api/resendforgotpasswordotp";
  static String resetPassword = "${DataURL.baseUrl}/api/resetPassword";
  static String signUpCandidate = "${DataURL.baseUrl}/api/candidate/register";
  static String signupOtpVerify = "${DataURL.baseUrl}/api/otpVerify";
  static String resendOtpSignup = "${DataURL.baseUrl}/api/resendOtp";
  static String signUpClient = "${DataURL.baseUrl}/api/client/register";
  static String homePageCandidateApi(String id) {
    return "${DataURL.baseUrl}/api/job/$id/specific/candidate/dashboard";
  }

  static String jobDescriptionApi(int? jobId) {
    return "${DataURL.baseUrl}/api/job/$jobId";
  }

  static String RemoveContractApi(int? jobId) {
    return "${DataURL.baseUrl}/api/job/$jobId";
  }

  static String applyJob = "${DataURL.baseUrl}/api/application";
  static String findJobCandidateApi(String uId) {
    return "${DataURL.baseUrl}/api/job/$uId/specific/candidate";
  }

  static String myJobsApi = "${DataURL.baseUrl}/api/application/status/jobs";
  static String jobWithdrawApi(int? appId) {
    return "${DataURL.baseUrl}/api/application/$appId";
  }

  static String editTimesheetApi(int? timeSheetId) {
    return "${DataURL.baseUrl}/api/timesheet/$timeSheetId/edit";
  }

  static String updateTimesheetApi(int? timeSheetId) {
    return "${DataURL.baseUrl}/api/timesheet/$timeSheetId";
  }

  static String personalDetailsApi(String uId) {
    return "${DataURL.baseUrl}/api/candidate/$uId/index";
  }

  static String editProfileApi = "${DataURL.baseUrl}/api/candidate/editprofile";
  static String roleAndSkillsApi(String uId) {
    return "${DataURL.baseUrl}/api/edit/candidate/$uId/role";
  }

  static String onchangeSkillsApi(int? selectedRoleIndexOnchangeSkills) {
    return "${DataURL.baseUrl}/api/onchange/get/skills/$selectedRoleIndexOnchangeSkills";
  }

  static String updateRoleApi(String uId) {
    return "${DataURL.baseUrl}/api/update/candidate/$uId/role";
  }

  static String uploadCv = "${DataURL.baseUrl}/api/upload/cv";

  //client side:
  static String createContractApi = "${DataURL.baseUrl}/api/job";
  static String showContractHomeApi(String uId) {
    return "${DataURL.baseUrl}/api/job/index/$uId/client";
  }

  static String showContractApi(String uId) {
    return "${DataURL.baseUrl}/api/job/index/$uId/client";
  }

  static String clientVerificationsPageApi =
      "${DataURL.baseUrl}/api/application/client/index";
  static String clientPersonalDetailsApi(String uId) {
    return "${DataURL.baseUrl}/api/client/$uId/index";
  }

  static String clientPersonalDetailsUpdateApi =
      "${DataURL.baseUrl}/api/client/editprofile";
  static String clientUploadFileToServerApi =
      "${DataURL.baseUrl}/api/client/upload/image";
  static String allAddressesApi(String uId) {
    return "${DataURL.baseUrl}/api/address/$uId/index";
  }

  static String setAsDefaultAddressApiApi =
      "${DataURL.baseUrl}/api/setas/default";
  static String removeAddressApi(var addressId) {
    return "${DataURL.baseUrl}/api/address/$addressId/delete";
  }

  static String addNewAddressApi = "${DataURL.baseUrl}/api/address/store";
  static String markAsPaidApi = "${DataURL.baseUrl}/api/mark/as/paid";
  // below two api is used in one method
  static String approveApplicationApi =
      "${DataURL.baseUrl}/api/application/approve";
  static String GenerateTimesheetApi = "${DataURL.baseUrl}/api/timesheet";
  //
  static String approveTimeSheetApi =
      "${DataURL.baseUrl}/api/timesheet/approve";
  static String editAddressApi(String addId) {
    return "${DataURL.baseUrl}/api/edit/$addId/address";
  }

  static String updateAddressApi = "${DataURL.baseUrl}/api/address/update";
}
