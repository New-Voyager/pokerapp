import 'package:pokerapp/utils/formatter.dart';

class TableRecord {
  List<TableRecordRow> rows;

  TableRecord() {
    rows = [];
  }

  // this sort the rows list in descending order of profit
  void sort() {
    rows.sort((a, b) => b.profit.compareTo(a.profit));
  }

  TableRecord.fromJson(List<dynamic> data) {
    rows = List<TableRecordRow>.from(
      data.map((record) => TableRecordRow.fromJson(record)),
    );
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

  String toCsv() {
    String ret = '';
    // headers
    ret = 'name,id,hands,buyin,profit,tips\n';
    for (var i = 0; i < rows.length; i++) {
      ret = ret + rows[i].toCsv() + '\n';
    }
    ret = ret + '\n';
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
  String externalId;

  TableRecordRow.fromJson(Map<String, dynamic> data) {
    this.playerName = data['playerName'];
    this.sessionTimeSec = data['sessionTime'];
    this.sessionTimeStr = data['sessionTimeStr'];
    this.handsPlayed = data['handsPlayed'];
    this.buyIn = data['buyIn'].toDouble();
    this.profit = data['profit'].toDouble();
    this.rakePaid = data['rakePaid'].toDouble();
    this.externalId = data['externalId'];
  }

  String toCsv() {
    List<String> cols = [
      playerName,
      externalId,
      handsPlayed.toString(),
      DataFormatter.chipsFormat(buyIn),
      DataFormatter.chipsFormat(profit),
      DataFormatter.chipsFormat(rakePaid),
    ];
    return cols.join(',');
  }

  String toString() {
    String ret =
        'TableRecordRow<${this.playerName}, ${this.sessionTimeStr}, ${this.handsPlayed}, ${this.buyIn}, ${this.profit}, ${this.rakePaid}>';
    return ret;
  }
}
