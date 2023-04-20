import 'package:clg_project/allAPIs/allAPIs.dart';

class ApiUrl{

  static String signIn = "${DataURL.baseUrl}/api/login";
  static String forgotPassword = "${DataURL.baseUrl}/api/forgotPassword";
  static String verifyOtpForgotPassword = "${DataURL.baseUrl}/api/verifyforgototp";
  static String forgotPasswordResendOtp = "${DataURL.baseUrl}/api/resendforgotpasswordotp";
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


  static String clientPersonalDetailsUpdate = "${DataURL.baseUrl}/api/client/editprofile";


}