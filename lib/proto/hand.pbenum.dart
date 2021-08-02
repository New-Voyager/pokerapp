///
//  Generated code. Do not modify.
//  source: hand.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class ACTION extends $pb.ProtobufEnum {
  static const ACTION SB = ACTION._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SB');
  static const ACTION BB = ACTION._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BB');
  static const ACTION STRADDLE = ACTION._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'STRADDLE');
  static const ACTION CHECK = ACTION._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CHECK');
  static const ACTION CALL = ACTION._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CALL');
  static const ACTION FOLD = ACTION._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FOLD');
  static const ACTION BET = ACTION._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BET');
  static const ACTION RAISE = ACTION._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RAISE');
  static const ACTION ALLIN = ACTION._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ALLIN');
  static const ACTION RUN_IT_TWICE_YES = ACTION._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RUN_IT_TWICE_YES');
  static const ACTION RUN_IT_TWICE_NO = ACTION._(10, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RUN_IT_TWICE_NO');
  static const ACTION RUN_IT_TWICE_PROMPT = ACTION._(11, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RUN_IT_TWICE_PROMPT');
  static const ACTION POST_BLIND = ACTION._(12, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'POST_BLIND');

  static const $core.List<ACTION> values = <ACTION> [
    SB,
    BB,
    STRADDLE,
    CHECK,
    CALL,
    FOLD,
    BET,
    RAISE,
    ALLIN,
    RUN_IT_TWICE_YES,
    RUN_IT_TWICE_NO,
    RUN_IT_TWICE_PROMPT,
    POST_BLIND,
  ];

  static final $core.Map<$core.int, ACTION> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ACTION? valueOf($core.int value) => _byValue[value];

  const ACTION._($core.int v, $core.String n) : super(v, n);
}

class HandStatus extends $pb.ProtobufEnum {
  static const HandStatus DEAL = HandStatus._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DEAL');
  static const HandStatus PREFLOP = HandStatus._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PREFLOP');
  static const HandStatus FLOP = HandStatus._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FLOP');
  static const HandStatus TURN = HandStatus._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TURN');
  static const HandStatus RIVER = HandStatus._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RIVER');
  static const HandStatus SHOW_DOWN = HandStatus._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SHOW_DOWN');
  static const HandStatus EVALUATE_HAND = HandStatus._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EVALUATE_HAND');
  static const HandStatus RESULT = HandStatus._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RESULT');
  static const HandStatus HAND_CLOSED = HandStatus._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'HAND_CLOSED');

  static const $core.List<HandStatus> values = <HandStatus> [
    DEAL,
    PREFLOP,
    FLOP,
    TURN,
    RIVER,
    SHOW_DOWN,
    EVALUATE_HAND,
    RESULT,
    HAND_CLOSED,
  ];

  static final $core.Map<$core.int, HandStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static HandStatus? valueOf($core.int value) => _byValue[value];

  const HandStatus._($core.int v, $core.String n) : super(v, n);
}

class PlayerActState extends $pb.ProtobufEnum {
  static const PlayerActState PLAYER_ACT_EMPTY_SEAT = PlayerActState._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLAYER_ACT_EMPTY_SEAT');
  static const PlayerActState PLAYER_ACT_NOT_ACTED = PlayerActState._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLAYER_ACT_NOT_ACTED');
  static const PlayerActState PLAYER_ACT_FOLDED = PlayerActState._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLAYER_ACT_FOLDED');
  static const PlayerActState PLAYER_ACT_ALL_IN = PlayerActState._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLAYER_ACT_ALL_IN');
  static const PlayerActState PLAYER_ACT_BB = PlayerActState._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLAYER_ACT_BB');
  static const PlayerActState PLAYER_ACT_STRADDLE = PlayerActState._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLAYER_ACT_STRADDLE');
  static const PlayerActState PLAYER_ACT_BET = PlayerActState._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLAYER_ACT_BET');
  static const PlayerActState PLAYER_ACT_CALL = PlayerActState._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLAYER_ACT_CALL');
  static const PlayerActState PLAYER_ACT_RAISE = PlayerActState._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLAYER_ACT_RAISE');
  static const PlayerActState PLAYER_ACT_CHECK = PlayerActState._(10, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLAYER_ACT_CHECK');
  static const PlayerActState PLAYER_ACT_POST_BLIND = PlayerActState._(11, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLAYER_ACT_POST_BLIND');

  static const $core.List<PlayerActState> values = <PlayerActState> [
    PLAYER_ACT_EMPTY_SEAT,
    PLAYER_ACT_NOT_ACTED,
    PLAYER_ACT_FOLDED,
    PLAYER_ACT_ALL_IN,
    PLAYER_ACT_BB,
    PLAYER_ACT_STRADDLE,
    PLAYER_ACT_BET,
    PLAYER_ACT_CALL,
    PLAYER_ACT_RAISE,
    PLAYER_ACT_CHECK,
    PLAYER_ACT_POST_BLIND,
  ];

  static final $core.Map<$core.int, PlayerActState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PlayerActState? valueOf($core.int value) => _byValue[value];

  const PlayerActState._($core.int v, $core.String n) : super(v, n);
}

class FlowState extends $pb.ProtobufEnum {
  static const FlowState DEAL_HAND = FlowState._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DEAL_HAND');
  static const FlowState WAIT_FOR_NEXT_ACTION = FlowState._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WAIT_FOR_NEXT_ACTION');
  static const FlowState PREPARE_NEXT_ACTION = FlowState._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PREPARE_NEXT_ACTION');
  static const FlowState MOVE_TO_NEXT_ACTION = FlowState._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MOVE_TO_NEXT_ACTION');
  static const FlowState MOVE_TO_NEXT_ROUND = FlowState._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MOVE_TO_NEXT_ROUND');
  static const FlowState ALL_PLAYERS_ALL_IN = FlowState._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ALL_PLAYERS_ALL_IN');
  static const FlowState ONE_PLAYER_REMAINING = FlowState._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ONE_PLAYER_REMAINING');
  static const FlowState SHOWDOWN = FlowState._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SHOWDOWN');
  static const FlowState HAND_ENDED = FlowState._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'HAND_ENDED');
  static const FlowState MOVE_TO_NEXT_HAND = FlowState._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MOVE_TO_NEXT_HAND');
  static const FlowState RUNITTWICE_UP_PROMPT = FlowState._(10, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RUNITTWICE_UP_PROMPT');
  static const FlowState RUNITTWICE_PROMPT_RESPONSE = FlowState._(11, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RUNITTWICE_PROMPT_RESPONSE');

  static const $core.List<FlowState> values = <FlowState> [
    DEAL_HAND,
    WAIT_FOR_NEXT_ACTION,
    PREPARE_NEXT_ACTION,
    MOVE_TO_NEXT_ACTION,
    MOVE_TO_NEXT_ROUND,
    ALL_PLAYERS_ALL_IN,
    ONE_PLAYER_REMAINING,
    SHOWDOWN,
    HAND_ENDED,
    MOVE_TO_NEXT_HAND,
    RUNITTWICE_UP_PROMPT,
    RUNITTWICE_PROMPT_RESPONSE,
  ];

  static final $core.Map<$core.int, FlowState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FlowState? valueOf($core.int value) => _byValue[value];

  const FlowState._($core.int v, $core.String n) : super(v, n);
}

