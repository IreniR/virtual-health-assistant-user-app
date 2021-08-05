abstract class LocalStorage {
  Future openStorage();
  Future closeStorage();

  bool loadHealthForm();
  Future saveSubmittedHealthForm(bool submitted);
}
