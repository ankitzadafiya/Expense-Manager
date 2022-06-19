
class User {
  final String email;
  final String uid;
  bool firstRun;
  
  User({
    this.email,
    this.uid,
  });

  set updateFirstRun(bool value) {
    firstRun = value;
  }
}
