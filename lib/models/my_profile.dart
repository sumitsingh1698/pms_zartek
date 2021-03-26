
class Myprofile {
  int id;
  String firstName;
  String lastName;
  String email;
  String mobile;
  Null image;

  Myprofile(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.mobile,
        this.image});

  Myprofile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobile = json['mobile'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['image'] = this.image;
    return data;
  }
}
