class Validator {
  String? nullFieldValidate(String? value) =>
      value!.isEmpty ? 'This field is required' : null;

  String? validateEmail(String? value) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regex = RegExp(pattern);

    if (value!.isEmpty) {
      return 'Please enter an email';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid email';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    final _passwordRegExp = RegExp(
      '(?=.*?[0-9])(?=.*?[A-Za-z]).+',
    );
    if (value!.isEmpty) {
      return 'This field is required';
    } else if (value.length < 8) {
      return 'Please enter at least 8 characters';
    } else if (!_passwordRegExp.hasMatch(value)) {
      return 'Password requires at least one digit and one letter';
    } else {
      return null;
    }
  }

  String? notValidate(String value) {
    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (password != confirmPassword) {
      return 'Password does not match';
    } else {
      return null;
    }
  }

  String? validateEmptyPassword(String value) {
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      return null;
    }
  }
}