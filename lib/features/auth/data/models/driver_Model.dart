import 'package:hive/hive.dart';
part 'driver_Model.g.dart';

@HiveType(typeId: 1)
class DriverModel extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? email;
  @HiveField(2)
  String? password;
  @HiveField(3)
  String phone;
  @HiveField(4)
  String? gender;
  @HiveField(5)
  String? adress;
  @HiveField(6)
  String? imageUrl;
  @HiveField(7)
  String? oTp;
  @HiveField(8)
  String? city;
  @HiveField(9)
  String? fullName;
  @HiveField(10)
  String? carType;
  @HiveField(11)
  String? carColor;
  @HiveField(12)
  bool? status;
  @HiveField(13)
  String? uId;
  DriverModel(
      {this.name,
      this.fullName,
      this.city,
      this.oTp,
      this.email,
      this.password,
      required this.phone,
      this.gender,
      this.adress,
      this.imageUrl,
      this.carColor,
      this.carType,
      this.status,
      this.uId});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'gender': gender,
      'address': adress,
      'imageUrl': imageUrl,
      'oTp': oTp,
      'city': city,
      'fullName': fullName,
      'carType': carType,
      'carColor': carColor,
      'status': status,
      'UId': uId,
    };
  }

  factory DriverModel.fromFireStore(Map<String, dynamic> driver) {
    return DriverModel(
        adress: driver['address'],
        carColor: driver['carColor'],
        carType: driver['carType'],
        email: driver['email'],
        gender: driver['gender'],
        name: driver['name'],
        status: driver['status'],
        imageUrl: driver['imageUrl'],
        uId: driver['UId'],
        phone: '');
  }
}
