import 'package:flutter/material.dart';

class Participant2 {
  num id;
  String display;
  bool setup;
  bool muted;
  bool talking;

  Participant2({
    @required this.id,
    this.display = '',
    this.setup = false,
    this.muted = false,
    this.talking = false,
  });

  Participant2 copyWith({
    num id,
    String display,
    bool setup,
    bool muted,
    bool talking,
  }) {
    return new Participant2(
      id: id ?? this.id,
      display: display ?? this.display,
      setup: setup ?? this.setup,
      muted: muted ?? this.muted,
      talking: talking ?? this.talking,
    );
  }

  @override
  String toString() {
    return 'Participant{id: $id, display: $display, setup: $setup, muted: $muted, talking: $talking}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Participant2 &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          display == other.display &&
          setup == other.setup &&
          muted == other.muted &&
          talking == other.talking);

  @override
  int get hashCode =>
      id.hashCode ^
      display.hashCode ^
      setup.hashCode ^
      muted.hashCode ^
      talking.hashCode;

  factory Participant2.fromMap(Map<String, dynamic> map) {
    return new Participant2(
      id: map['id'] as num,
      display: map['display'] as String,
      setup: map['setup'] as bool,
      muted: map['muted'] as bool,
      talking: map['talking'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'display': this.display,
      'setup': this.setup,
      'muted': this.muted,
      'talking': this.talking,
    } as Map<String, dynamic>;
  }
}

class Participants extends ChangeNotifier {
  List<Participant2> participants = [];

  void add(Participant2 participant) {
    var index =
        participants.indexWhere((element) => element.id == participant.id);
    if (index > -1) {
      participants[index] = participant;
    } else {
      participants.add(participant);
    }
  }

  Participant2 getById(int playerId) {
    var index = participants.indexWhere((element) => element.id == playerId);
    if (index == -1) {
      return null;
    }
    return participants[index];
  }
}
