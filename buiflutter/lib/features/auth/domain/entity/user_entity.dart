// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// import 'package:talab/features/batch/domain/entity/batch_entity.dart';
// import 'package:talab/features/course/domain/entity/course_entity.dart';

class UserEntity {
  final String id;
  final String username;
  final String fullname;
  final String password;
  final String gender;
  final String dob;
  final String address;
  final String email;
  final String phone;
  final String? image;
  final String documentImage;
  final String documentIdNumber;
  final String? photo;
  final String accountType;
  final String walletId;

  UserEntity({
    required this.id,
    required this.username,
    required this.fullname,
    required this.password,
    required this.gender,
    required this.dob,
    required this.address,
    required this.email,
    required this.phone,
    this.image,
    required this.documentImage,
    required this.documentIdNumber,
    this.photo,
    required this.accountType,
    required this.walletId,
  });

  UserEntity copyWith({
    String? id,
    String? username,
    String? fullname,
    String? password,
    String? gender,
    String? dob,
    String? address,
    String? email,
    String? phone,
    String? image,
    String? documentImage,
    String? documentIdNumber,
    String? photo,
    String? accountType,
    String? walletId,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      address: address ?? this.address,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      documentImage: documentImage ?? this.documentImage,
      documentIdNumber: documentIdNumber ?? this.documentIdNumber,
      photo: photo ?? this.photo,
      accountType: accountType ?? this.accountType,
      walletId: walletId ?? this.walletId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'fullname': fullname,
      'password': password,
      'gender': gender,
      'dob': dob,
      'address': address,
      'email': email,
      'phone': phone,
      'image': image,
      'documentImage': documentImage,
      'documentIdNumber': documentIdNumber,
      'photo': photo,
      'accountType': accountType,
      'walletId': walletId,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'] as String,
      username: map['username'] as String,
      fullname: map['fullname'] as String,
      password: map['password'] as String,
      gender: map['gender'] as String,
      dob: map['dob'] as String,
      address: map['address'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      documentImage: map['documentImage'] as String,
      documentIdNumber: map['documentIdNumber'] as String,
      photo: map['photo'] != null ? map['photo'] as String : null,
      accountType: map['accountType'] as String,
      walletId: map['walletId'] as String,
    );
  }
  factory UserEntity.fromApiMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['_id'] as String,
      username: map['username'] as String,
      fullname: map['fullname'] as String,
      password: map['password'] as String,
      gender: map['gender'] as String,
      dob: map['dob'] as String,
      address: map['address'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      documentImage:
          map['document_image'] != null ? map['document_image'] as String : "",
      documentIdNumber: map['document_id_number'] as String,
      photo: map['photo'] != null ? map['photo'] as String : null,
      accountType: map['role'] as String,
      walletId: map['wallet'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserEntity.fromJson(String source) =>
      UserEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserEntity(id: $id, username: $username, fullname: $fullname, password: $password, gender: $gender, dob: $dob, address: $address, email: $email, phone: $phone, image: $image, documentImage: $documentImage, documentIdNumber: $documentIdNumber, photo: $photo, accountType: $accountType, walletId: $walletId)';
  }

  @override
  bool operator ==(covariant UserEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.username == username &&
        other.fullname == fullname &&
        other.password == password &&
        other.gender == gender &&
        other.dob == dob &&
        other.address == address &&
        other.email == email &&
        other.phone == phone &&
        other.image == image &&
        other.documentImage == documentImage &&
        other.documentIdNumber == documentIdNumber &&
        other.photo == photo &&
        other.accountType == accountType &&
        other.walletId == walletId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        fullname.hashCode ^
        password.hashCode ^
        gender.hashCode ^
        dob.hashCode ^
        address.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        image.hashCode ^
        documentImage.hashCode ^
        documentIdNumber.hashCode ^
        photo.hashCode ^
        accountType.hashCode ^
        walletId.hashCode;
  }
}
