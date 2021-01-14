class SearchClub {
  String name;
  String ownerName;
  String status;

  SearchClub({this.name, this.ownerName, this.status});

  SearchClub.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ownerName = json['ownerName'];
    status = json['status'];
  }
}
