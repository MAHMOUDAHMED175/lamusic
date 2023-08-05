

class SocialCreateUserModel{
  String? name;
  String? email;
  String? password;
  String? uid;

  SocialCreateUserModel({
    required this.email,
    required this.uid,
    required this.name,
    required this.password,
});

  SocialCreateUserModel.fromJson(Map<String,dynamic>json){
    email=json['email'];
    uid=json['uid'];
    name=json['name'];
    password=json['password'];
  }

  /* علشان احول الداتا اللى جايالى الى Map*/
  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'password':password,
      'email':email,
      'uid':uid,
    };

  }
}