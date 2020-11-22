class Validator{
  static String _email = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static String _password =  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  static String _phoneNumber = r'(^(?:[+0]9)?[0-9]{10,12}$)';


  // validate email
  static String emailValidator(String val){
    if(val.length != null && RegExp(_email).hasMatch(val) ){
      return null;
    }else{
      return 'Enter a valid Email';
    }
  }
  // validate password
  static String passwordValidator(String val){
    if(RegExp(_password).hasMatch(val)){
      return null;
    }else{
      return "Enter strong Passowrd";
    }
  }

  static String phoneNumberValidator(String val){
    if(RegExp(_phoneNumber).hasMatch(val)){
      return null;
    }else{
      return "Enter valid Phone Number";
    }
  }

  //Conform password
  static String conformPassowrd(previousPassword,val){
    if(val == previousPassword){
      return null;
    }else{
      return "Password do not match";
    }
  }


}