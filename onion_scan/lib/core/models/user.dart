class User {
  final int userid;
  final String name;
  final String? email;
  final String? phonenumber;
  final String gender;
  final String usertype;
  final String region;
  final String province;
  final String department;
  final String cityvillage;

  User({
    required this.userid,
    required this.name,
    this.email,
    this.phonenumber,
    required this.gender,
    required this.usertype,
    required this.region,
    required this.province,
    required this.department,
    required this.cityvillage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userid: json['userid'],
      name: json['name'],
      email: json['email'],
      phonenumber: json['phonenumber'],
      gender: json['gender'],
      usertype: json['usertype'],
      region: json['region'],
      province: json['province'],
      department: json['department'],
      cityvillage: json['cityvillage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'name': name,
      'email': email,
      'phonenumber': phonenumber,
      'gender': gender,
      'usertype': usertype,
      'region': region,
      'province': province,
      'department': department,
      'cityvillage': cityvillage,
    };
  }
}