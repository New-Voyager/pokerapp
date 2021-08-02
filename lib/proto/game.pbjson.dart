///
//  Generated code. Do not modify.
//  source: game.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use playerStatusDescriptor instead')
const PlayerStatus$json = const {
  '1': 'PlayerStatus',
  '2': const [
    const {'1': 'PLAYER_UNKNOWN_STATUS', '2': 0},
    const {'1': 'NOT_PLAYING', '2': 1},
    const {'1': 'PLAYING', '2': 2},
    const {'1': 'IN_QUEUE', '2': 3},
    const {'1': 'IN_BREAK', '2': 4},
    const {'1': 'STANDING_UP', '2': 5},
    const {'1': 'LEFT', '2': 6},
    const {'1': 'KICKED_OUT', '2': 7},
    const {'1': 'BLOCKED', '2': 8},
    const {'1': 'LOST_CONNECTION', '2': 9},
    const {'1': 'WAIT_FOR_BUYIN', '2': 10},
    const {'1': 'LEAVING_GAME', '2': 11},
    const {'1': 'TAKING_BREAK', '2': 12},
    const {'1': 'JOINING', '2': 13},
    const {'1': 'WAITLIST_SEATING', '2': 14},
    const {'1': 'PENDING_UPDATES', '2': 15},
    const {'1': 'WAIT_FOR_BUYIN_APPROVAL', '2': 16},
    const {'1': 'NEED_TO_POST_BLIND', '2': 17},
  ],
};

/// Descriptor for `PlayerStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playerStatusDescriptor = $convert.base64Decode('CgxQbGF5ZXJTdGF0dXMSGQoVUExBWUVSX1VOS05PV05fU1RBVFVTEAASDwoLTk9UX1BMQVlJTkcQARILCgdQTEFZSU5HEAISDAoISU5fUVVFVUUQAxIMCghJTl9CUkVBSxAEEg8KC1NUQU5ESU5HX1VQEAUSCAoETEVGVBAGEg4KCktJQ0tFRF9PVVQQBxILCgdCTE9DS0VEEAgSEwoPTE9TVF9DT05ORUNUSU9OEAkSEgoOV0FJVF9GT1JfQlVZSU4QChIQCgxMRUFWSU5HX0dBTUUQCxIQCgxUQUtJTkdfQlJFQUsQDBILCgdKT0lOSU5HEA0SFAoQV0FJVExJU1RfU0VBVElORxAOEhMKD1BFTkRJTkdfVVBEQVRFUxAPEhsKF1dBSVRfRk9SX0JVWUlOX0FQUFJPVkFMEBASFgoSTkVFRF9UT19QT1NUX0JMSU5EEBE=');
@$core.Deprecated('Use gameTypeDescriptor instead')
const GameType$json = const {
  '1': 'GameType',
  '2': const [
    const {'1': 'UNKNOWN', '2': 0},
    const {'1': 'HOLDEM', '2': 1},
    const {'1': 'PLO', '2': 2},
    const {'1': 'PLO_HILO', '2': 3},
    const {'1': 'FIVE_CARD_PLO', '2': 4},
    const {'1': 'FIVE_CARD_PLO_HILO', '2': 5},
  ],
};

/// Descriptor for `GameType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List gameTypeDescriptor = $convert.base64Decode('CghHYW1lVHlwZRILCgdVTktOT1dOEAASCgoGSE9MREVNEAESBwoDUExPEAISDAoIUExPX0hJTE8QAxIRCg1GSVZFX0NBUkRfUExPEAQSFgoSRklWRV9DQVJEX1BMT19ISUxPEAU=');
@$core.Deprecated('Use gameStatusDescriptor instead')
const GameStatus$json = const {
  '1': 'GameStatus',
  '2': const [
    const {'1': 'GAME_STATUS_UNKNOWN', '2': 0},
    const {'1': 'CONFIGURED', '2': 1},
    const {'1': 'ACTIVE', '2': 2},
    const {'1': 'PAUSED', '2': 3},
    const {'1': 'ENDED', '2': 4},
  ],
};

/// Descriptor for `GameStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List gameStatusDescriptor = $convert.base64Decode('CgpHYW1lU3RhdHVzEhcKE0dBTUVfU1RBVFVTX1VOS05PV04QABIOCgpDT05GSUdVUkVEEAESCgoGQUNUSVZFEAISCgoGUEFVU0VEEAMSCQoFRU5ERUQQBA==');
@$core.Deprecated('Use tableStatusDescriptor instead')
const TableStatus$json = const {
  '1': 'TableStatus',
  '2': const [
    const {'1': 'TABLE_STATUS_UNKNOWN', '2': 0},
    const {'1': 'WAITING_TO_BE_STARTED', '2': 1},
    const {'1': 'NOT_ENOUGH_PLAYERS', '2': 2},
    const {'1': 'GAME_RUNNING', '2': 3},
  ],
};

/// Descriptor for `TableStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List tableStatusDescriptor = $convert.base64Decode('CgtUYWJsZVN0YXR1cxIYChRUQUJMRV9TVEFUVVNfVU5LTk9XThAAEhkKFVdBSVRJTkdfVE9fQkVfU1RBUlRFRBABEhYKEk5PVF9FTk9VR0hfUExBWUVSUxACEhAKDEdBTUVfUlVOTklORxAD');
@$core.Deprecated('Use newUpdateDescriptor instead')
const NewUpdate$json = const {
  '1': 'NewUpdate',
  '2': const [
    const {'1': 'UNKNOWN_PLAYER_UPDATE', '2': 0},
    const {'1': 'NEW_PLAYER', '2': 1},
    const {'1': 'RELOAD_CHIPS', '2': 2},
    const {'1': 'SWITCH_SEAT', '2': 3},
    const {'1': 'TAKE_BREAK', '2': 4},
    const {'1': 'SIT_BACK', '2': 5},
    const {'1': 'LEFT_THE_GAME', '2': 6},
    const {'1': 'EMPTY_STACK', '2': 7},
    const {'1': 'NEW_BUYIN', '2': 8},
    const {'1': 'BUYIN_TIMEDOUT', '2': 9},
    const {'1': 'NEWUPDATE_WAIT_FOR_BUYIN_APPROVAL', '2': 10},
    const {'1': 'BUYIN_DENIED', '2': 11},
    const {'1': 'NEWUPDATE_NOT_PLAYING', '2': 12},
  ],
};

/// Descriptor for `NewUpdate`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List newUpdateDescriptor = $convert.base64Decode('CglOZXdVcGRhdGUSGQoVVU5LTk9XTl9QTEFZRVJfVVBEQVRFEAASDgoKTkVXX1BMQVlFUhABEhAKDFJFTE9BRF9DSElQUxACEg8KC1NXSVRDSF9TRUFUEAMSDgoKVEFLRV9CUkVBSxAEEgwKCFNJVF9CQUNLEAUSEQoNTEVGVF9USEVfR0FNRRAGEg8KC0VNUFRZX1NUQUNLEAcSDQoJTkVXX0JVWUlOEAgSEgoOQlVZSU5fVElNRURPVVQQCRIlCiFORVdVUERBVEVfV0FJVF9GT1JfQlVZSU5fQVBQUk9WQUwQChIQCgxCVVlJTl9ERU5JRUQQCxIZChVORVdVUERBVEVfTk9UX1BMQVlJTkcQDA==');
@$core.Deprecated('Use playerStateDescriptor instead')
const PlayerState$json = const {
  '1': 'PlayerState',
  '2': const [
    const {'1': 'buy_in', '3': 1, '4': 1, '5': 2, '10': 'buyIn'},
    const {'1': 'current_balance', '3': 2, '4': 1, '5': 2, '10': 'currentBalance'},
    const {'1': 'status', '3': 3, '4': 1, '5': 14, '6': '.game.PlayerStatus', '10': 'status'},
    const {'1': 'game_token', '3': 4, '4': 1, '5': 9, '10': 'gameToken'},
    const {'1': 'game_token_int', '3': 5, '4': 1, '5': 4, '10': 'gameTokenInt'},
  ],
};

/// Descriptor for `PlayerState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerStateDescriptor = $convert.base64Decode('CgtQbGF5ZXJTdGF0ZRIVCgZidXlfaW4YASABKAJSBWJ1eUluEicKD2N1cnJlbnRfYmFsYW5jZRgCIAEoAlIOY3VycmVudEJhbGFuY2USKgoGc3RhdHVzGAMgASgOMhIuZ2FtZS5QbGF5ZXJTdGF0dXNSBnN0YXR1cxIdCgpnYW1lX3Rva2VuGAQgASgJUglnYW1lVG9rZW4SJAoOZ2FtZV90b2tlbl9pbnQYBSABKARSDGdhbWVUb2tlbkludA==');
@$core.Deprecated('Use gamePlayerUpdateDescriptor instead')
const GamePlayerUpdate$json = const {
  '1': 'GamePlayerUpdate',
  '2': const [
    const {'1': 'player_id', '3': 1, '4': 1, '5': 4, '10': 'playerId'},
    const {'1': 'seat_no', '3': 2, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'stack', '3': 3, '4': 1, '5': 2, '10': 'stack'},
    const {'1': 'buy_in', '3': 4, '4': 1, '5': 2, '10': 'buyIn'},
    const {'1': 'game_token', '3': 5, '4': 1, '5': 9, '10': 'gameToken'},
    const {'1': 'status', '3': 6, '4': 1, '5': 14, '6': '.game.PlayerStatus', '10': 'status'},
    const {'1': 'reload_chips', '3': 7, '4': 1, '5': 2, '10': 'reloadChips'},
    const {'1': 'new_update', '3': 8, '4': 1, '5': 14, '6': '.game.NewUpdate', '10': 'newUpdate'},
    const {'1': 'old_seat', '3': 9, '4': 1, '5': 13, '10': 'oldSeat'},
    const {'1': 'break_exp_at', '3': 10, '4': 1, '5': 9, '10': 'breakExpAt'},
  ],
};

/// Descriptor for `GamePlayerUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gamePlayerUpdateDescriptor = $convert.base64Decode('ChBHYW1lUGxheWVyVXBkYXRlEhsKCXBsYXllcl9pZBgBIAEoBFIIcGxheWVySWQSFwoHc2VhdF9ubxgCIAEoDVIGc2VhdE5vEhQKBXN0YWNrGAMgASgCUgVzdGFjaxIVCgZidXlfaW4YBCABKAJSBWJ1eUluEh0KCmdhbWVfdG9rZW4YBSABKAlSCWdhbWVUb2tlbhIqCgZzdGF0dXMYBiABKA4yEi5nYW1lLlBsYXllclN0YXR1c1IGc3RhdHVzEiEKDHJlbG9hZF9jaGlwcxgHIAEoAlILcmVsb2FkQ2hpcHMSLgoKbmV3X3VwZGF0ZRgIIAEoDjIPLmdhbWUuTmV3VXBkYXRlUgluZXdVcGRhdGUSGQoIb2xkX3NlYXQYCSABKA1SB29sZFNlYXQSIAoMYnJlYWtfZXhwX2F0GAogASgJUgpicmVha0V4cEF0');
@$core.Deprecated('Use seatMoveDescriptor instead')
const SeatMove$json = const {
  '1': 'SeatMove',
  '2': const [
    const {'1': 'playerId', '3': 1, '4': 1, '5': 4, '10': 'playerId'},
    const {'1': 'playerUuid', '3': 2, '4': 1, '5': 9, '10': 'playerUuid'},
    const {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'stack', '3': 4, '4': 1, '5': 2, '10': 'stack'},
    const {'1': 'oldSeatNo', '3': 5, '4': 1, '5': 13, '10': 'oldSeatNo'},
    const {'1': 'newSeatNo', '3': 6, '4': 1, '5': 13, '10': 'newSeatNo'},
  ],
};

/// Descriptor for `SeatMove`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seatMoveDescriptor = $convert.base64Decode('CghTZWF0TW92ZRIaCghwbGF5ZXJJZBgBIAEoBFIIcGxheWVySWQSHgoKcGxheWVyVXVpZBgCIAEoCVIKcGxheWVyVXVpZBISCgRuYW1lGAMgASgJUgRuYW1lEhQKBXN0YWNrGAQgASgCUgVzdGFjaxIcCglvbGRTZWF0Tm8YBSABKA1SCW9sZFNlYXRObxIcCgluZXdTZWF0Tm8YBiABKA1SCW5ld1NlYXRObw==');
@$core.Deprecated('Use seatUpdateDescriptor instead')
const SeatUpdate$json = const {
  '1': 'SeatUpdate',
  '2': const [
    const {'1': 'seat_no', '3': 1, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'player_id', '3': 2, '4': 1, '5': 4, '10': 'playerId'},
    const {'1': 'player_uuid', '3': 3, '4': 1, '5': 9, '10': 'playerUuid'},
    const {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'stack', '3': 5, '4': 1, '5': 2, '10': 'stack'},
    const {'1': 'player_status', '3': 6, '4': 1, '5': 14, '6': '.game.PlayerStatus', '10': 'playerStatus'},
    const {'1': 'open_seat', '3': 7, '4': 1, '5': 8, '10': 'openSeat'},
  ],
};

/// Descriptor for `SeatUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seatUpdateDescriptor = $convert.base64Decode('CgpTZWF0VXBkYXRlEhcKB3NlYXRfbm8YASABKA1SBnNlYXRObxIbCglwbGF5ZXJfaWQYAiABKARSCHBsYXllcklkEh8KC3BsYXllcl91dWlkGAMgASgJUgpwbGF5ZXJVdWlkEhIKBG5hbWUYBCABKAlSBG5hbWUSFAoFc3RhY2sYBSABKAJSBXN0YWNrEjcKDXBsYXllcl9zdGF0dXMYBiABKA4yEi5nYW1lLlBsYXllclN0YXR1c1IMcGxheWVyU3RhdHVzEhsKCW9wZW5fc2VhdBgHIAEoCFIIb3BlblNlYXQ=');
@$core.Deprecated('Use tableUpdateDescriptor instead')
const TableUpdate$json = const {
  '1': 'TableUpdate',
  '2': const [
    const {'1': 'seat_no', '3': 1, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'seat_change_time', '3': 3, '4': 1, '5': 13, '10': 'seatChangeTime'},
    const {'1': 'waitlist_player_name', '3': 4, '4': 1, '5': 9, '10': 'waitlistPlayerName'},
    const {'1': 'waitlist_remaining_time', '3': 5, '4': 1, '5': 13, '10': 'waitlistRemainingTime'},
    const {'1': 'waitlist_player_id', '3': 6, '4': 1, '5': 4, '10': 'waitlistPlayerId'},
    const {'1': 'waitlist_player_uuid', '3': 7, '4': 1, '5': 9, '10': 'waitlistPlayerUuid'},
    const {'1': 'seat_change_players', '3': 8, '4': 3, '5': 4, '10': 'seatChangePlayers'},
    const {'1': 'seat_change_seat_no', '3': 9, '4': 3, '5': 4, '10': 'seatChangeSeatNo'},
    const {'1': 'seat_change_host', '3': 10, '4': 1, '5': 4, '10': 'seatChangeHost'},
    const {'1': 'seat_moves', '3': 11, '4': 3, '5': 11, '6': '.game.SeatMove', '10': 'seatMoves'},
    const {'1': 'seat_updates', '3': 12, '4': 3, '5': 11, '6': '.game.SeatUpdate', '10': 'seatUpdates'},
  ],
};

/// Descriptor for `TableUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tableUpdateDescriptor = $convert.base64Decode('CgtUYWJsZVVwZGF0ZRIXCgdzZWF0X25vGAEgASgNUgZzZWF0Tm8SEgoEdHlwZRgCIAEoCVIEdHlwZRIoChBzZWF0X2NoYW5nZV90aW1lGAMgASgNUg5zZWF0Q2hhbmdlVGltZRIwChR3YWl0bGlzdF9wbGF5ZXJfbmFtZRgEIAEoCVISd2FpdGxpc3RQbGF5ZXJOYW1lEjYKF3dhaXRsaXN0X3JlbWFpbmluZ190aW1lGAUgASgNUhV3YWl0bGlzdFJlbWFpbmluZ1RpbWUSLAoSd2FpdGxpc3RfcGxheWVyX2lkGAYgASgEUhB3YWl0bGlzdFBsYXllcklkEjAKFHdhaXRsaXN0X3BsYXllcl91dWlkGAcgASgJUhJ3YWl0bGlzdFBsYXllclV1aWQSLgoTc2VhdF9jaGFuZ2VfcGxheWVycxgIIAMoBFIRc2VhdENoYW5nZVBsYXllcnMSLQoTc2VhdF9jaGFuZ2Vfc2VhdF9ubxgJIAMoBFIQc2VhdENoYW5nZVNlYXRObxIoChBzZWF0X2NoYW5nZV9ob3N0GAogASgEUg5zZWF0Q2hhbmdlSG9zdBItCgpzZWF0X21vdmVzGAsgAygLMg4uZ2FtZS5TZWF0TW92ZVIJc2VhdE1vdmVzEjMKDHNlYXRfdXBkYXRlcxgMIAMoCzIQLmdhbWUuU2VhdFVwZGF0ZVILc2VhdFVwZGF0ZXM=');
@$core.Deprecated('Use playerConfigUpdateDescriptor instead')
const PlayerConfigUpdate$json = const {
  '1': 'PlayerConfigUpdate',
  '2': const [
    const {'1': 'player_id', '3': 1, '4': 1, '5': 4, '10': 'playerId'},
    const {'1': 'muck_losing_hand', '3': 2, '4': 1, '5': 8, '10': 'muckLosingHand'},
    const {'1': 'run_it_twice_prompt', '3': 3, '4': 1, '5': 8, '10': 'runItTwicePrompt'},
  ],
};

/// Descriptor for `PlayerConfigUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerConfigUpdateDescriptor = $convert.base64Decode('ChJQbGF5ZXJDb25maWdVcGRhdGUSGwoJcGxheWVyX2lkGAEgASgEUghwbGF5ZXJJZBIoChBtdWNrX2xvc2luZ19oYW5kGAIgASgIUg5tdWNrTG9zaW5nSGFuZBItChNydW5faXRfdHdpY2VfcHJvbXB0GAMgASgIUhBydW5JdFR3aWNlUHJvbXB0');
