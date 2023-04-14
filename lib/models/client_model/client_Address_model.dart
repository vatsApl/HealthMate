class ClientAddressesResponse {
  List<Address>? address;

  ClientAddressesResponse({this.address});

  ClientAddressesResponse.fromJson(Map<String, dynamic> json) {
    if (json['address'] != null) {
      address = <Address>[];
      json['address'].forEach((v) {
        address!.add(new Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  int? id;
  int? clientId;
  String? address;
  String? area;
  int? postCode;
  String? createdAt;
  String? updatedAt;
  Client? client;

  Address(
      {this.id,
        this.clientId,
        this.address,
        this.area,
        this.postCode,
        this.createdAt,
        this.updatedAt,
        this.client});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    address = json['address'];
    area = json['area'];
    postCode = json['post_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    client =
    json['client'] != null ? new Client.fromJson(json['client']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['client_id'] = this.clientId;
    data['address'] = this.address;
    data['area'] = this.area;
    data['post_code'] = this.postCode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.client != null) {
      data['client'] = this.client!.toJson();
    }
    return data;
  }
}

class Client {
  int? id;
  Null? avatar;
  String? practiceName;
  String? email;
  String? phone;
  int? addressId;
  String? createdAt;
  String? updatedAt;

  Client(
      {this.id,
        this.avatar,
        this.practiceName,
        this.email,
        this.phone,
        this.addressId,
        this.createdAt,
        this.updatedAt});

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    practiceName = json['practice_name'];
    email = json['email'];
    phone = json['phone'];
    addressId = json['address_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['practice_name'] = this.practiceName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address_id'] = this.addressId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}