class CandidateChatListModel {
  String? message;
  bool? success;
  int? code;
  List<CandidateChatListData>? data;
  int curentPage = 0;
  int nextPage = 0;
  int? lastPage;
  bool? isLastPage;

  CandidateChatListModel(
      {this.message,
      this.success,
      this.code,
      this.data,
      this.curentPage = 0,
      this.nextPage = 0,
      this.lastPage,
      this.isLastPage});

  CandidateChatListModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    code = json['code'];
    if (json['data'] != null) {
      data = <CandidateChatListData>[];
      json['data'].forEach((v) {
        data!.add(new CandidateChatListData.fromJson(v));
      });
    }
    curentPage = json['curent_page'];
    nextPage = json['next_page'];
    lastPage = json['last_page'];
    isLastPage = json['is_last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['curent_page'] = this.curentPage;
    data['next_page'] = this.nextPage;
    data['last_page'] = this.lastPage;
    data['is_last_page'] = this.isLastPage;
    return data;
  }
}

class CandidateChatListData {
  int? id;
  String? avatar;
  String? practiceName;
  String? firstName;
  String? lastName;
  String? role;
  String? phone;

  CandidateChatListData(
      {this.id,
      this.avatar,
      this.practiceName,
      this.firstName,
      this.lastName,
      this.role,
      this.phone});

  CandidateChatListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    practiceName = json['practice_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    role = json['role'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['practice_name'] = this.practiceName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['role'] = this.role;
    data['phone'] = this.phone;
    return data;
  }
}
