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
  static const ACTION ACTION_UNKNOWN = ACTION._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ACTION_UNKNOWN');
  static const ACTION EMPTY_SEAT = ACTION._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EMPTY_SEAT');
  static const ACTION NOT_ACTED = ACTION._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NOT_ACTED');
  static const ACTION SB = ACTION._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SB');
  static const ACTION BB = ACTION._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BB');
  static const ACTION STRADDLE = ACTION._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'STRADDLE');
  static const ACTION CHECK = ACTION._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CHECK');
  static const ACTION CALL = ACTION._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CALL');
  static const ACTION FOLD = ACTION._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FOLD');
  static const ACTION BET = ACTION._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BET');
  static const ACTION RAISE = ACTION._(10, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RAISE');
  static const ACTION ALLIN = ACTION._(11, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ALLIN');
  static const ACTION RUN_IT_TWICE_YES = ACTION._(12, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RUN_IT_TWICE_YES');
  static const ACTION RUN_IT_TWICE_NO = ACTION._(13, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RUN_IT_TWICE_NO');
  static const ACTION RUN_IT_TWICE_PROMPT = ACTION._(14, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RUN_IT_TWICE_PROMPT');
  static const ACTION POST_BLIND = ACTION._(15, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'POST_BLIND');
  static const ACTION BOMB_POT_BET = ACTION._(16, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BOMB_POT_BET');

  static const $core.List<ACTION> values = <ACTION> [
    ACTION_UNKNOWN,
    EMPTY_SEAT,
    NOT_ACTED,
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
    BOMB_POT_BET,
  ];

  static final $core.Map<$core.int, ACTION> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ACTION? valueOf($core.int value) => _byValue[value];

  const ACTION._($core.int v, $core.String n) : super(v, n);
}

class HandStatus extends $pb.ProtobufEnum {
  static const HandStatus HandStatus_UNKNOWN = HandStatus._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'HandStatus_UNKNOWN');
  static const HandStatus DEAL = HandStatus._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DEAL');
  static const HandStatus PREFLOP = HandStatus._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PREFLOP');
  static const HandStatus FLOP = HandStatus._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FLOP');
  static const HandStatus TURN = HandStatus._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TURN');
  static const HandStatus RIVER = HandStatus._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RIVER');
  static const HandStatus SHOW_DOWN = HandStatus._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SHOW_DOWN');
  static const HandStatus EVALUATE_HAND = HandStatus._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EVALUATE_HAND');
  static const HandStatus RESULT = HandStatus._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RESULT');
  static const HandStatus HAND_CLOSED = HandStatus._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'HAND_CLOSED');

  static const $core.List<HandStatus> values = <HandStatus> [
    HandStatus_UNKNOWN,
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

class FlowState extends $pb.ProtobufEnum {
  static const FlowState DEAL_HAND = FlowState._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DEAL_HAND');
  static const FlowState WAIT_FOR_NEXT_ACTION = FlowState._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WAIT_FOR_NEXT_ACTION');
  static const FlowState PREPARE_NEXT_ACTION = FlowState._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PREPARE_NEXT_ACTION');
  static const FlowState MOVE_TO_NEXT_HAND = FlowState._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MOVE_TO_NEXT_HAND');
  static const FlowState WAIT_FOR_PENDING_UPDATE = FlowState._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WAIT_FOR_PENDING_UPDATE');

  static const $core.List<FlowState> values = <FlowState> [
    DEAL_HAND,
    WAIT_FOR_NEXT_ACTION,
    PREPARE_NEXT_ACTION,
    MOVE_TO_NEXT_HAND,
    WAIT_FOR_PENDING_UPDATE,
  ];

  static final $core.Map<$core.int, FlowState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FlowState? valueOf($core.int value) => _byValue[value];

  const FlowState._($core.int v, $core.String n) : super(v, n);
}

