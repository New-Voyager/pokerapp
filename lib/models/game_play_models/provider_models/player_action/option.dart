class Option {
  String text;
  int amount;

  Option.fromJson(var data) {
    this.text = data['text'];
    this.amount = data['amount'];
  }
}
