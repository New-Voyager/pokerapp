///
//  Generated code. Do not modify.
//  source: enums.proto
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
    const {'1': 'SIX_CARD_PLO', '2': 6},
    const {'1': 'SIX_CARD_PLO_HILO', '2': 7},
  ],
};

/// Descriptor for `GameType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List gameTypeDescriptor = $convert.base64Decode('CghHYW1lVHlwZRILCgdVTktOT1dOEAASCgoGSE9MREVNEAESBwoDUExPEAISDAoIUExPX0hJTE8QAxIRCg1GSVZFX0NBUkRfUExPEAQSFgoSRklWRV9DQVJEX1BMT19ISUxPEAUSEAoMU0lYX0NBUkRfUExPEAYSFQoRU0lYX0NBUkRfUExPX0hJTE8QBw==');
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
@$core.Deprecated('Use chipUnitDescriptor instead')
const ChipUnit$json = const {
  '1': 'ChipUnit',
  '2': const [
    const {'1': 'DOLLAR', '2': 0},
    const {'1': 'CENT', '2': 1},
  ],
};

/// Descriptor for `ChipUnit`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List chipUnitDescriptor = $convert.base64Decode('CghDaGlwVW5pdBIKCgZET0xMQVIQABIICgRDRU5UEAE=');
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
