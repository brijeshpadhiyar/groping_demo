import 'dart:convert';

class DataModel {
  final int id;
  final String name;
  final String email;
  final String profilePic;
  final String hireDt;

  DataModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.hireDt,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'hireDt': hireDt,
    };
  }

  factory DataModel.fromMap(Map<String, dynamic> map) {
    return DataModel(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      profilePic: map['profilePic'] as String,
      hireDt: map['hireDt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataModel.fromJson(String source) => DataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
