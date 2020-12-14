class UserModel {
  String role;
  String name;
  String phone;
  bool isVerified;
  String docID;

  UserModel({
    this.name,
    this.phone,
    this.isVerified,
    this.role,
    this.docID,
  });
}