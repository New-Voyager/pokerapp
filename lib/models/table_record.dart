class TableRecord {
  List<TableRecordRow> rows;

  TableRecord() {
    rows = new List<TableRecordRow>();
  }

  TableRecord.fromJson(List<dynamic> data) {
    rows = List<TableRecordRow>.from(
        data.map((record) => TableRecordRow.fromJson(record)));
  }

  String toString() {
    String ret = "TableRecord<";
    for (var i = 0; i < rows.length; i++) {
      if (i > 0) {
        ret = ret + ", ";
      }
      ret = ret + rows[i].toString();
    }
    ret = ret + ">";
    return ret;
  }
}

class TableRecordRow {
  String playerName;
  int sessionTimeSec;
  String sessionTimeStr;
  int handsPlayed;
  double buyIn;
  double profit;
  double rakePaid;

  TableRecordRow.fromJson(Map<String, dynamic> data) {
    this.playerName = data['playerName'];
    this.sessionTimeSec = data['sessionTime'];
    this.sessionTimeStr = data['sessionTimeStr'];
    this.handsPlayed = data['handsPlayed'];
    this.buyIn = data['buyIn'].toDouble();
    this.profit = data['profit'].toDouble();
    this.rakePaid = data['rakePaid'].toDouble();
  }

  String toString() {
    String ret =
        'TableRecordRow<${this.playerName}, ${this.sessionTimeStr}, ${this.handsPlayed}, ${this.buyIn}, ${this.profit}, ${this.rakePaid}>';
    return ret;
  }
}
