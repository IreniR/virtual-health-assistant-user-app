import 'package:flutter/cupertino.dart';

class AccountModel extends ChangeNotifier {
  bool _hasSubmittedHealthForm = false;

  set hasSubmittedHealthForm(bool value) {
    _hasSubmittedHealthForm = value;
    notifyListeners();
  }

  bool get hasSubmittedHealthForm => _hasSubmittedHealthForm;

  AccountModel({bool hasSubmittedHealthForm = true}) {
    _hasSubmittedHealthForm = hasSubmittedHealthForm;
  }
}
