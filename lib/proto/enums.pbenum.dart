///
//  Generated code. Do not modify.
//  source: enums.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class PlayerStatus extends $pb.ProtobufEnum {
  static const PlayerStatus PLAYER_UNKNOWN_STATUS = PlayerStatus._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLAYER_UNKNOWN_STATUS');
  static const PlayerStatus NOT_PLAYING = PlayerStatus._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NOT_PLAYING');
  static const PlayerStatus PLAYING = PlayerStatus._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLAYING');
  static const PlayerStatus IN_QUEUE = PlayerStatus._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'IN_QUEUE');
  static const PlayerStatus IN_BREAK = PlayerStatus._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'IN_BREAK');
  static const PlayerStatus STANDING_UP = PlayerStatus._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'STANDING_UP');
  static const PlayerStatus LEFT = PlayerStatus._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LEFT');
  static const PlayerStatus KICKED_OUT = PlayerStatus._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'KICKED_OUT');
  static const PlayerStatus BLOCKED = PlayerStatus._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BLOCKED');
  static const PlayerStatus LOST_CONNECTION = PlayerStatus._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LOST_CONNECTION');
  static const PlayerStatus WAIT_FOR_BUYIN = PlayerStatus._(10, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WAIT_FOR_BUYIN');
  static const PlayerStatus LEAVING_GAME = PlayerStatus._(11, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LEAVING_GAME');
  static const PlayerStatus TAKING_BREAK = PlayerStatus._(12, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TAKING_BREAK');
  static const PlayerStatus JOINING = PlayerStatus._(13, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'JOINING');
  static const PlayerStatus WAITLIST_SEATING = PlayerStatus._(14, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WAITLIST_SEATING');
  static const PlayerStatus PENDING_UPDATES = PlayerStatus._(15, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PENDING_UPDATES');
  static const PlayerStatus WAIT_FOR_BUYIN_APPROVAL = PlayerStatus._(16, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WAIT_FOR_BUYIN_APPROVAL');
  static const PlayerStatus NEED_TO_POST_BLIND = PlayerStatus._(17, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NEED_TO_POST_BLIND');

  static const $core.List<PlayerStatus> values = <PlayerStatus> [
    PLAYER_UNKNOWN_STATUS,
    NOT_PLAYING,
    PLAYING,
    IN_QUEUE,
    IN_BREAK,
    STANDING_UP,
    LEFT,
    KICKED_OUT,
    BLOCKED,
    LOST_CONNECTION,
    WAIT_FOR_BUYIN,
    LEAVING_GAME,
    TAKING_BREAK,
    JOINING,
    WAITLIST_SEATING,
    PENDING_UPDATES,
    WAIT_FOR_BUYIN_APPROVAL,
    NEED_TO_POST_BLIND,
  ];

  static final $core.Map<$core.int, PlayerStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PlayerStatus? valueOf($core.int value) => _byValue[value];

  const PlayerStatus._($core.int v, $core.String n) : super(v, n);
}

class GameType extends $pb.ProtobufEnum {
  static const GameType UNKNOWN = GameType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNKNOWN');
  static const GameType HOLDEM = GameType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'HOLDEM');
  static const GameType PLO = GameType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLO');
  static const GameType PLO_HILO = GameType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLO_HILO');
  static const GameType FIVE_CARD_PLO = GameType._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FIVE_CARD_PLO');
  static const GameType FIVE_CARD_PLO_HILO = GameType._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FIVE_CARD_PLO_HILO');

  static const $core.List<GameType> values = <GameType> [
    UNKNOWN,
    HOLDEM,
    PLO,
    PLO_HILO,
    FIVE_CARD_PLO,
    FIVE_CARD_PLO_HILO,
  ];

  static final $core.Map<$core.int, GameType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static GameType? valueOf($core.int value) => _byValue[value];

  const GameType._($core.int v, $core.String n) : super(v, n);
}

class GameStatus extends $pb.ProtobufEnum {
  static const GameStatus GAME_STATUS_UNKNOWN = GameStatus._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GAME_STATUS_UNKNOWN');
  static const GameStatus CONFIGURED = GameStatus._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CONFIGURED');
  static const GameStatus ACTIVE = GameStatus._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ACTIVE');
  static const GameStatus PAUSED = GameStatus._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PAUSED');
  static const GameStatus ENDED = GameStatus._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ENDED');

  static const $core.List<GameStatus> values = <GameStatus> [
    GAME_STATUS_UNKNOWN,
    CONFIGURED,
    ACTIVE,
    PAUSED,
    ENDED,
  ];

  static final $core.Map<$core.int, GameStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static GameStatus? valueOf($core.int value) => _byValue[value];

  const GameStatus._($core.int v, $core.String n) : super(v, n);
}

class TableStatus extends $pb.ProtobufEnum {
  static const TableStatus TABLE_STATUS_UNKNOWN = TableStatus._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TABLE_STATUS_UNKNOWN');
  static const TableStatus WAITING_TO_BE_STARTED = TableStatus._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WAITING_TO_BE_STARTED');
  static const TableStatus NOT_ENOUGH_PLAYERS = TableStatus._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NOT_ENOUGH_PLAYERS');
  static const TableStatus GAME_RUNNING = TableStatus._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GAME_RUNNING');

  static const $core.List<TableStatus> values = <TableStatus> [
    TABLE_STATUS_UNKNOWN,
    WAITING_TO_BE_STARTED,
    NOT_ENOUGH_PLAYERS,
    GAME_RUNNING,
  ];

  static final $core.Map<$core.int, TableStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TableStatus? valueOf($core.int value) => _byValue[value];

  const TableStatus._($core.int v, $core.String n) : super(v, n);
}

class ChipUnit extends $pb.ProtobufEnum {
  static const ChipUnit DOLLAR = ChipUnit._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DOLLAR');
  static const ChipUnit CENT = ChipUnit._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CENT');

  static const $core.List<ChipUnit> values = <ChipUnit> [
    DOLLAR,
    CENT,
  ];

  static final $core.Map<$core.int, ChipUnit> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ChipUnit? valueOf($core.int value) => _byValue[value];

  const ChipUnit._($core.int v, $core.String n) : super(v, n);
}

class NewUpdate extends $pb.ProtobufEnum {
  static const NewUpdate UNKNOWN_PLAYER_UPDATE = NewUpdate._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNKNOWN_PLAYER_UPDATE');
  static const NewUpdate NEW_PLAYER = NewUpdate._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NEW_PLAYER');
  static const NewUpdate RELOAD_CHIPS = NewUpdate._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RELOAD_CHIPS');
  static const NewUpdate SWITCH_SEAT = NewUpdate._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SWITCH_SEAT');
  static const NewUpdate TAKE_BREAK = NewUpdate._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TAKE_BREAK');
  static const NewUpdate SIT_BACK = NewUpdate._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SIT_BACK');
  static const NewUpdate LEFT_THE_GAME = NewUpdate._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LEFT_THE_GAME');
  static const NewUpdate EMPTY_STACK = NewUpdate._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EMPTY_STACK');
  static const NewUpdate NEW_BUYIN = NewUpdate._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NEW_BUYIN');
  static const NewUpdate BUYIN_TIMEDOUT = NewUpdate._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BUYIN_TIMEDOUT');
  static const NewUpdate NEWUPDATE_WAIT_FOR_BUYIN_APPROVAL = NewUpdate._(10, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NEWUPDATE_WAIT_FOR_BUYIN_APPROVAL');
  static const NewUpdate BUYIN_DENIED = NewUpdate._(11, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BUYIN_DENIED');
  static const NewUpdate NEWUPDATE_NOT_PLAYING = NewUpdate._(12, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NEWUPDATE_NOT_PLAYING');

  static const $core.List<NewUpdate> values = <NewUpdate> [
    UNKNOWN_PLAYER_UPDATE,
    NEW_PLAYER,
    RELOAD_CHIPS,
    SWITCH_SEAT,
    TAKE_BREAK,
    SIT_BACK,
    LEFT_THE_GAME,
    EMPTY_STACK,
    NEW_BUYIN,
    BUYIN_TIMEDOUT,
    NEWUPDATE_WAIT_FOR_BUYIN_APPROVAL,
    BUYIN_DENIED,
    NEWUPDATE_NOT_PLAYING,
  ];

  static final $core.Map<$core.int, NewUpdate> _byValue = $pb.ProtobufEnum.initByValue(values);
  static NewUpdate? valueOf($core.int value) => _byValue[value];

  const NewUpdate._($core.int v, $core.String n) : super(v, n);
}

