///
//  Generated code. Do not modify.
//  source: hand.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use aCTIONDescriptor instead')
const ACTION$json = const {
  '1': 'ACTION',
  '2': const [
    const {'1': 'ACTION_UNKNOWN', '2': 0},
    const {'1': 'EMPTY_SEAT', '2': 1},
    const {'1': 'NOT_ACTED', '2': 2},
    const {'1': 'SB', '2': 3},
    const {'1': 'BB', '2': 4},
    const {'1': 'STRADDLE', '2': 5},
    const {'1': 'CHECK', '2': 6},
    const {'1': 'CALL', '2': 7},
    const {'1': 'FOLD', '2': 8},
    const {'1': 'BET', '2': 9},
    const {'1': 'RAISE', '2': 10},
    const {'1': 'ALLIN', '2': 11},
    const {'1': 'RUN_IT_TWICE_YES', '2': 12},
    const {'1': 'RUN_IT_TWICE_NO', '2': 13},
    const {'1': 'RUN_IT_TWICE_PROMPT', '2': 14},
    const {'1': 'POST_BLIND', '2': 15},
    const {'1': 'BOMB_POT_BET', '2': 16},
  ],
};

/// Descriptor for `ACTION`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List aCTIONDescriptor = $convert.base64Decode('CgZBQ1RJT04SEgoOQUNUSU9OX1VOS05PV04QABIOCgpFTVBUWV9TRUFUEAESDQoJTk9UX0FDVEVEEAISBgoCU0IQAxIGCgJCQhAEEgwKCFNUUkFERExFEAUSCQoFQ0hFQ0sQBhIICgRDQUxMEAcSCAoERk9MRBAIEgcKA0JFVBAJEgkKBVJBSVNFEAoSCQoFQUxMSU4QCxIUChBSVU5fSVRfVFdJQ0VfWUVTEAwSEwoPUlVOX0lUX1RXSUNFX05PEA0SFwoTUlVOX0lUX1RXSUNFX1BST01QVBAOEg4KClBPU1RfQkxJTkQQDxIQCgxCT01CX1BPVF9CRVQQEA==');
@$core.Deprecated('Use handStatusDescriptor instead')
const HandStatus$json = const {
  '1': 'HandStatus',
  '2': const [
    const {'1': 'HandStatus_UNKNOWN', '2': 0},
    const {'1': 'DEAL', '2': 1},
    const {'1': 'PREFLOP', '2': 2},
    const {'1': 'FLOP', '2': 3},
    const {'1': 'TURN', '2': 4},
    const {'1': 'RIVER', '2': 5},
    const {'1': 'SHOW_DOWN', '2': 6},
    const {'1': 'EVALUATE_HAND', '2': 7},
    const {'1': 'RESULT', '2': 8},
    const {'1': 'HAND_CLOSED', '2': 9},
  ],
};

/// Descriptor for `HandStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List handStatusDescriptor = $convert.base64Decode('CgpIYW5kU3RhdHVzEhYKEkhhbmRTdGF0dXNfVU5LTk9XThAAEggKBERFQUwQARILCgdQUkVGTE9QEAISCAoERkxPUBADEggKBFRVUk4QBBIJCgVSSVZFUhAFEg0KCVNIT1dfRE9XThAGEhEKDUVWQUxVQVRFX0hBTkQQBxIKCgZSRVNVTFQQCBIPCgtIQU5EX0NMT1NFRBAJ');
@$core.Deprecated('Use flowStateDescriptor instead')
const FlowState$json = const {
  '1': 'FlowState',
  '2': const [
    const {'1': 'DEAL_HAND', '2': 0},
    const {'1': 'WAIT_FOR_NEXT_ACTION', '2': 1},
    const {'1': 'PREPARE_NEXT_ACTION', '2': 2},
    const {'1': 'MOVE_TO_NEXT_HAND', '2': 3},
    const {'1': 'WAIT_FOR_PENDING_UPDATE', '2': 4},
  ],
};

/// Descriptor for `FlowState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List flowStateDescriptor = $convert.base64Decode('CglGbG93U3RhdGUSDQoJREVBTF9IQU5EEAASGAoUV0FJVF9GT1JfTkVYVF9BQ1RJT04QARIXChNQUkVQQVJFX05FWFRfQUNUSU9OEAISFQoRTU9WRV9UT19ORVhUX0hBTkQQAxIbChdXQUlUX0ZPUl9QRU5ESU5HX1VQREFURRAE');
@$core.Deprecated('Use handActionDescriptor instead')
const HandAction$json = const {
  '1': 'HandAction',
  '2': const [
    const {'1': 'seat_no', '3': 1, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'action', '3': 2, '4': 1, '5': 14, '6': '.game.ACTION', '10': 'action'},
    const {'1': 'amount', '3': 3, '4': 1, '5': 1, '10': 'amount'},
    const {'1': 'timed_out', '3': 4, '4': 1, '5': 8, '10': 'timedOut'},
    const {'1': 'action_time', '3': 5, '4': 1, '5': 13, '10': 'actionTime'},
    const {'1': 'stack', '3': 6, '4': 1, '5': 1, '10': 'stack'},
    const {'1': 'pot_updates', '3': 7, '4': 1, '5': 1, '10': 'potUpdates'},
    const {'1': 'action_id', '3': 8, '4': 1, '5': 9, '10': 'actionId'},
  ],
};

/// Descriptor for `HandAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handActionDescriptor = $convert.base64Decode('CgpIYW5kQWN0aW9uEhcKB3NlYXRfbm8YASABKA1SBnNlYXRObxIkCgZhY3Rpb24YAiABKA4yDC5nYW1lLkFDVElPTlIGYWN0aW9uEhYKBmFtb3VudBgDIAEoAVIGYW1vdW50EhsKCXRpbWVkX291dBgEIAEoCFIIdGltZWRPdXQSHwoLYWN0aW9uX3RpbWUYBSABKA1SCmFjdGlvblRpbWUSFAoFc3RhY2sYBiABKAFSBXN0YWNrEh8KC3BvdF91cGRhdGVzGAcgASgBUgpwb3RVcGRhdGVzEhsKCWFjdGlvbl9pZBgIIAEoCVIIYWN0aW9uSWQ=');
@$core.Deprecated('Use handActionLogDescriptor instead')
const HandActionLog$json = const {
  '1': 'HandActionLog',
  '2': const [
    const {'1': 'pot_start', '3': 1, '4': 1, '5': 1, '10': 'potStart'},
    const {'1': 'pots', '3': 2, '4': 3, '5': 1, '10': 'pots'},
    const {'1': 'actions', '3': 3, '4': 3, '5': 11, '6': '.game.HandAction', '10': 'actions'},
    const {'1': 'seats_pots', '3': 4, '4': 3, '5': 11, '6': '.game.SeatsInPots', '10': 'seatsPots'},
  ],
};

/// Descriptor for `HandActionLog`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handActionLogDescriptor = $convert.base64Decode('Cg1IYW5kQWN0aW9uTG9nEhsKCXBvdF9zdGFydBgBIAEoAVIIcG90U3RhcnQSEgoEcG90cxgCIAMoAVIEcG90cxIqCgdhY3Rpb25zGAMgAygLMhAuZ2FtZS5IYW5kQWN0aW9uUgdhY3Rpb25zEjAKCnNlYXRzX3BvdHMYBCADKAsyES5nYW1lLlNlYXRzSW5Qb3RzUglzZWF0c1BvdHM=');
@$core.Deprecated('Use extendTimerDescriptor instead')
const ExtendTimer$json = const {
  '1': 'ExtendTimer',
  '2': const [
    const {'1': 'seat_no', '3': 1, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'extend_by_sec', '3': 2, '4': 1, '5': 13, '10': 'extendBySec'},
    const {'1': 'remaining_sec', '3': 3, '4': 1, '5': 13, '10': 'remainingSec'},
    const {'1': 'action_id', '3': 4, '4': 1, '5': 9, '10': 'actionId'},
  ],
};

/// Descriptor for `ExtendTimer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List extendTimerDescriptor = $convert.base64Decode('CgtFeHRlbmRUaW1lchIXCgdzZWF0X25vGAEgASgNUgZzZWF0Tm8SIgoNZXh0ZW5kX2J5X3NlYxgCIAEoDVILZXh0ZW5kQnlTZWMSIwoNcmVtYWluaW5nX3NlYxgDIAEoDVIMcmVtYWluaW5nU2VjEhsKCWFjdGlvbl9pZBgEIAEoCVIIYWN0aW9uSWQ=');
@$core.Deprecated('Use resetTimerDescriptor instead')
const ResetTimer$json = const {
  '1': 'ResetTimer',
  '2': const [
    const {'1': 'seat_no', '3': 1, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'remaining_sec', '3': 2, '4': 1, '5': 13, '10': 'remainingSec'},
    const {'1': 'action_id', '3': 3, '4': 1, '5': 9, '10': 'actionId'},
  ],
};

/// Descriptor for `ResetTimer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetTimerDescriptor = $convert.base64Decode('CgpSZXNldFRpbWVyEhcKB3NlYXRfbm8YASABKA1SBnNlYXRObxIjCg1yZW1haW5pbmdfc2VjGAIgASgNUgxyZW1haW5pbmdTZWMSGwoJYWN0aW9uX2lkGAMgASgJUghhY3Rpb25JZA==');
@$core.Deprecated('Use betRaiseOptionDescriptor instead')
const BetRaiseOption$json = const {
  '1': 'BetRaiseOption',
  '2': const [
    const {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 1, '10': 'amount'},
  ],
};

/// Descriptor for `BetRaiseOption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List betRaiseOptionDescriptor = $convert.base64Decode('Cg5CZXRSYWlzZU9wdGlvbhISCgR0ZXh0GAEgASgJUgR0ZXh0EhYKBmFtb3VudBgCIAEoAVIGYW1vdW50');
@$core.Deprecated('Use nextSeatActionDescriptor instead')
const NextSeatAction$json = const {
  '1': 'NextSeatAction',
  '2': const [
    const {'1': 'seat_no', '3': 1, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'available_actions', '3': 2, '4': 3, '5': 14, '6': '.game.ACTION', '10': 'availableActions'},
    const {'1': 'straddleAmount', '3': 3, '4': 1, '5': 1, '10': 'straddleAmount'},
    const {'1': 'callAmount', '3': 4, '4': 1, '5': 1, '10': 'callAmount'},
    const {'1': 'raiseAmount', '3': 5, '4': 1, '5': 1, '10': 'raiseAmount'},
    const {'1': 'minBetAmount', '3': 6, '4': 1, '5': 1, '10': 'minBetAmount'},
    const {'1': 'maxBetAmount', '3': 7, '4': 1, '5': 1, '10': 'maxBetAmount'},
    const {'1': 'minRaiseAmount', '3': 8, '4': 1, '5': 1, '10': 'minRaiseAmount'},
    const {'1': 'maxRaiseAmount', '3': 9, '4': 1, '5': 1, '10': 'maxRaiseAmount'},
    const {'1': 'allInAmount', '3': 10, '4': 1, '5': 1, '10': 'allInAmount'},
    const {'1': 'betOptions', '3': 11, '4': 3, '5': 11, '6': '.game.BetRaiseOption', '10': 'betOptions'},
    const {'1': 'actionTimesoutAt', '3': 12, '4': 1, '5': 3, '10': 'actionTimesoutAt'},
    const {'1': 'secondsTillTimesout', '3': 13, '4': 1, '5': 13, '10': 'secondsTillTimesout'},
    const {'1': 'seatInSoFar', '3': 14, '4': 1, '5': 1, '10': 'seatInSoFar'},
    const {'1': 'actionId', '3': 15, '4': 1, '5': 9, '10': 'actionId'},
    const {'1': 'potAmount', '3': 16, '4': 1, '5': 1, '10': 'potAmount'},
  ],
};

/// Descriptor for `NextSeatAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nextSeatActionDescriptor = $convert.base64Decode('Cg5OZXh0U2VhdEFjdGlvbhIXCgdzZWF0X25vGAEgASgNUgZzZWF0Tm8SOQoRYXZhaWxhYmxlX2FjdGlvbnMYAiADKA4yDC5nYW1lLkFDVElPTlIQYXZhaWxhYmxlQWN0aW9ucxImCg5zdHJhZGRsZUFtb3VudBgDIAEoAVIOc3RyYWRkbGVBbW91bnQSHgoKY2FsbEFtb3VudBgEIAEoAVIKY2FsbEFtb3VudBIgCgtyYWlzZUFtb3VudBgFIAEoAVILcmFpc2VBbW91bnQSIgoMbWluQmV0QW1vdW50GAYgASgBUgxtaW5CZXRBbW91bnQSIgoMbWF4QmV0QW1vdW50GAcgASgBUgxtYXhCZXRBbW91bnQSJgoObWluUmFpc2VBbW91bnQYCCABKAFSDm1pblJhaXNlQW1vdW50EiYKDm1heFJhaXNlQW1vdW50GAkgASgBUg5tYXhSYWlzZUFtb3VudBIgCgthbGxJbkFtb3VudBgKIAEoAVILYWxsSW5BbW91bnQSNAoKYmV0T3B0aW9ucxgLIAMoCzIULmdhbWUuQmV0UmFpc2VPcHRpb25SCmJldE9wdGlvbnMSKgoQYWN0aW9uVGltZXNvdXRBdBgMIAEoA1IQYWN0aW9uVGltZXNvdXRBdBIwChNzZWNvbmRzVGlsbFRpbWVzb3V0GA0gASgNUhNzZWNvbmRzVGlsbFRpbWVzb3V0EiAKC3NlYXRJblNvRmFyGA4gASgBUgtzZWF0SW5Tb0ZhchIaCghhY3Rpb25JZBgPIAEoCVIIYWN0aW9uSWQSHAoJcG90QW1vdW50GBAgASgBUglwb3RBbW91bnQ=');
@$core.Deprecated('Use playerInSeatStateDescriptor instead')
const PlayerInSeatState$json = const {
  '1': 'PlayerInSeatState',
  '2': const [
    const {'1': 'player_id', '3': 1, '4': 1, '5': 4, '10': 'playerId'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'status', '3': 3, '4': 1, '5': 14, '6': '.game.PlayerStatus', '10': 'status'},
    const {'1': 'stack', '3': 4, '4': 1, '5': 1, '10': 'stack'},
    const {'1': 'round', '3': 5, '4': 1, '5': 14, '6': '.game.HandStatus', '10': 'round'},
    const {'1': 'playerReceived', '3': 6, '4': 1, '5': 1, '10': 'playerReceived'},
    const {'1': 'buy_in_exp_time', '3': 7, '4': 1, '5': 9, '10': 'buyInExpTime'},
    const {'1': 'break_exp_time', '3': 8, '4': 1, '5': 9, '10': 'breakExpTime'},
    const {'1': 'inhand', '3': 9, '4': 1, '5': 8, '10': 'inhand'},
    const {'1': 'open_seat', '3': 10, '4': 1, '5': 8, '10': 'openSeat'},
    const {'1': 'posted_blind', '3': 11, '4': 1, '5': 8, '10': 'postedBlind'},
    const {'1': 'seat_no', '3': 12, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'run_it_twice', '3': 13, '4': 1, '5': 8, '10': 'runItTwice'},
    const {'1': 'missed_blind', '3': 14, '4': 1, '5': 8, '10': 'missedBlind'},
    const {'1': 'auto_straddle', '3': 15, '4': 1, '5': 8, '10': 'autoStraddle'},
    const {'1': 'button_straddle', '3': 16, '4': 1, '5': 8, '10': 'buttonStraddle'},
    const {'1': 'muck_losing_hand', '3': 17, '4': 1, '5': 8, '10': 'muckLosingHand'},
    const {'1': 'button_straddle_bet', '3': 18, '4': 1, '5': 13, '10': 'buttonStraddleBet'},
  ],
};

/// Descriptor for `PlayerInSeatState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerInSeatStateDescriptor = $convert.base64Decode('ChFQbGF5ZXJJblNlYXRTdGF0ZRIbCglwbGF5ZXJfaWQYASABKARSCHBsYXllcklkEhIKBG5hbWUYAiABKAlSBG5hbWUSKgoGc3RhdHVzGAMgASgOMhIuZ2FtZS5QbGF5ZXJTdGF0dXNSBnN0YXR1cxIUCgVzdGFjaxgEIAEoAVIFc3RhY2sSJgoFcm91bmQYBSABKA4yEC5nYW1lLkhhbmRTdGF0dXNSBXJvdW5kEiYKDnBsYXllclJlY2VpdmVkGAYgASgBUg5wbGF5ZXJSZWNlaXZlZBIlCg9idXlfaW5fZXhwX3RpbWUYByABKAlSDGJ1eUluRXhwVGltZRIkCg5icmVha19leHBfdGltZRgIIAEoCVIMYnJlYWtFeHBUaW1lEhYKBmluaGFuZBgJIAEoCFIGaW5oYW5kEhsKCW9wZW5fc2VhdBgKIAEoCFIIb3BlblNlYXQSIQoMcG9zdGVkX2JsaW5kGAsgASgIUgtwb3N0ZWRCbGluZBIXCgdzZWF0X25vGAwgASgNUgZzZWF0Tm8SIAoMcnVuX2l0X3R3aWNlGA0gASgIUgpydW5JdFR3aWNlEiEKDG1pc3NlZF9ibGluZBgOIAEoCFILbWlzc2VkQmxpbmQSIwoNYXV0b19zdHJhZGRsZRgPIAEoCFIMYXV0b1N0cmFkZGxlEicKD2J1dHRvbl9zdHJhZGRsZRgQIAEoCFIOYnV0dG9uU3RyYWRkbGUSKAoQbXVja19sb3NpbmdfaGFuZBgRIAEoCFIObXVja0xvc2luZ0hhbmQSLgoTYnV0dG9uX3N0cmFkZGxlX2JldBgSIAEoDVIRYnV0dG9uU3RyYWRkbGVCZXQ=');
@$core.Deprecated('Use playerBalanceDescriptor instead')
const PlayerBalance$json = const {
  '1': 'PlayerBalance',
  '2': const [
    const {'1': 'seat_no', '3': 1, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'player_id', '3': 2, '4': 1, '5': 4, '10': 'playerId'},
    const {'1': 'balance', '3': 3, '4': 1, '5': 1, '10': 'balance'},
  ],
};

/// Descriptor for `PlayerBalance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerBalanceDescriptor = $convert.base64Decode('Cg1QbGF5ZXJCYWxhbmNlEhcKB3NlYXRfbm8YASABKA1SBnNlYXRObxIbCglwbGF5ZXJfaWQYAiABKARSCHBsYXllcklkEhgKB2JhbGFuY2UYAyABKAFSB2JhbGFuY2U=');
@$core.Deprecated('Use highHandWinnerDescriptor instead')
const HighHandWinner$json = const {
  '1': 'HighHandWinner',
  '2': const [
    const {'1': 'player_id', '3': 1, '4': 1, '5': 4, '10': 'playerId'},
    const {'1': 'player_name', '3': 2, '4': 1, '5': 9, '10': 'playerName'},
    const {'1': 'hh_rank', '3': 3, '4': 1, '5': 13, '10': 'hhRank'},
    const {'1': 'hh_cards', '3': 4, '4': 3, '5': 13, '10': 'hhCards'},
    const {'1': 'player_cards', '3': 5, '4': 3, '5': 13, '10': 'playerCards'},
    const {'1': 'seat_no', '3': 6, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'board_no', '3': 7, '4': 1, '5': 13, '10': 'boardNo'},
  ],
};

/// Descriptor for `HighHandWinner`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List highHandWinnerDescriptor = $convert.base64Decode('Cg5IaWdoSGFuZFdpbm5lchIbCglwbGF5ZXJfaWQYASABKARSCHBsYXllcklkEh8KC3BsYXllcl9uYW1lGAIgASgJUgpwbGF5ZXJOYW1lEhcKB2hoX3JhbmsYAyABKA1SBmhoUmFuaxIZCghoaF9jYXJkcxgEIAMoDVIHaGhDYXJkcxIhCgxwbGF5ZXJfY2FyZHMYBSADKA1SC3BsYXllckNhcmRzEhcKB3NlYXRfbm8YBiABKA1SBnNlYXRObxIZCghib2FyZF9ubxgHIAEoDVIHYm9hcmRObw==');
@$core.Deprecated('Use highHandDescriptor instead')
const HighHand$json = const {
  '1': 'HighHand',
  '2': const [
    const {'1': 'gameCode', '3': 1, '4': 1, '5': 9, '10': 'gameCode'},
    const {'1': 'hand_num', '3': 2, '4': 1, '5': 13, '10': 'handNum'},
    const {'1': 'winners', '3': 3, '4': 3, '5': 11, '6': '.game.HighHandWinner', '10': 'winners'},
  ],
};

/// Descriptor for `HighHand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List highHandDescriptor = $convert.base64Decode('CghIaWdoSGFuZBIaCghnYW1lQ29kZRgBIAEoCVIIZ2FtZUNvZGUSGQoIaGFuZF9udW0YAiABKA1SB2hhbmROdW0SLgoHd2lubmVycxgDIAMoCzIULmdhbWUuSGlnaEhhbmRXaW5uZXJSB3dpbm5lcnM=');
@$core.Deprecated('Use playerActRoundDescriptor instead')
const PlayerActRound$json = const {
  '1': 'PlayerActRound',
  '2': const [
    const {'1': 'action', '3': 1, '4': 1, '5': 14, '6': '.game.ACTION', '10': 'action'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 1, '10': 'amount'},
    const {'1': 'raiseAmount', '3': 3, '4': 1, '5': 1, '10': 'raiseAmount'},
    const {'1': 'acted_bet_index', '3': 4, '4': 1, '5': 13, '10': 'actedBetIndex'},
    const {'1': 'bet_amount', '3': 5, '4': 1, '5': 1, '10': 'betAmount'},
  ],
};

/// Descriptor for `PlayerActRound`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerActRoundDescriptor = $convert.base64Decode('Cg5QbGF5ZXJBY3RSb3VuZBIkCgZhY3Rpb24YASABKA4yDC5nYW1lLkFDVElPTlIGYWN0aW9uEhYKBmFtb3VudBgCIAEoAVIGYW1vdW50EiAKC3JhaXNlQW1vdW50GAMgASgBUgtyYWlzZUFtb3VudBImCg9hY3RlZF9iZXRfaW5kZXgYBCABKA1SDWFjdGVkQmV0SW5kZXgSHQoKYmV0X2Ftb3VudBgFIAEoAVIJYmV0QW1vdW50');
@$core.Deprecated('Use seatsInPotsDescriptor instead')
const SeatsInPots$json = const {
  '1': 'SeatsInPots',
  '2': const [
    const {'1': 'seats', '3': 1, '4': 3, '5': 13, '10': 'seats'},
    const {'1': 'pot', '3': 2, '4': 1, '5': 1, '10': 'pot'},
  ],
};

/// Descriptor for `SeatsInPots`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seatsInPotsDescriptor = $convert.base64Decode('CgtTZWF0c0luUG90cxIUCgVzZWF0cxgBIAMoDVIFc2VhdHMSEAoDcG90GAIgASgBUgNwb3Q=');
@$core.Deprecated('Use seatBettingDescriptor instead')
const SeatBetting$json = const {
  '1': 'SeatBetting',
  '2': const [
    const {'1': 'seat_bet', '3': 1, '4': 3, '5': 1, '10': 'seatBet'},
  ],
};

/// Descriptor for `SeatBetting`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seatBettingDescriptor = $convert.base64Decode('CgtTZWF0QmV0dGluZxIZCghzZWF0X2JldBgBIAMoAVIHc2VhdEJldA==');
@$core.Deprecated('Use roundStateDescriptor instead')
const RoundState$json = const {
  '1': 'RoundState',
  '2': const [
    const {'1': 'betting', '3': 1, '4': 1, '5': 11, '6': '.game.SeatBetting', '10': 'betting'},
    const {'1': 'player_balance', '3': 2, '4': 3, '5': 11, '6': '.game.RoundState.PlayerBalanceEntry', '10': 'playerBalance'},
    const {'1': 'bet_index', '3': 3, '4': 1, '5': 13, '10': 'betIndex'},
  ],
  '3': const [RoundState_PlayerBalanceEntry$json],
};

@$core.Deprecated('Use roundStateDescriptor instead')
const RoundState_PlayerBalanceEntry$json = const {
  '1': 'PlayerBalanceEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `RoundState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roundStateDescriptor = $convert.base64Decode('CgpSb3VuZFN0YXRlEisKB2JldHRpbmcYASABKAsyES5nYW1lLlNlYXRCZXR0aW5nUgdiZXR0aW5nEkoKDnBsYXllcl9iYWxhbmNlGAIgAygLMiMuZ2FtZS5Sb3VuZFN0YXRlLlBsYXllckJhbGFuY2VFbnRyeVINcGxheWVyQmFsYW5jZRIbCgliZXRfaW5kZXgYAyABKA1SCGJldEluZGV4GkAKElBsYXllckJhbGFuY2VFbnRyeRIQCgNrZXkYASABKA1SA2tleRIUCgV2YWx1ZRgCIAEoAVIFdmFsdWU6AjgB');
@$core.Deprecated('Use playerMovedTableDescriptor instead')
const PlayerMovedTable$json = const {
  '1': 'PlayerMovedTable',
  '2': const [
    const {'1': 'tournament_id', '3': 10, '4': 1, '5': 13, '10': 'tournamentId'},
    const {'1': 'old_table_no', '3': 20, '4': 1, '5': 13, '10': 'oldTableNo'},
    const {'1': 'new_table_no', '3': 30, '4': 1, '5': 13, '10': 'newTableNo'},
    const {'1': 'new_table_seat_no', '3': 31, '4': 1, '5': 13, '10': 'newTableSeatNo'},
    const {'1': 'game_code', '3': 40, '4': 1, '5': 9, '10': 'gameCode'},
    const {'1': 'player_id', '3': 60, '4': 1, '5': 4, '10': 'playerId'},
    const {'1': 'game_info', '3': 70, '4': 1, '5': 9, '10': 'gameInfo'},
  ],
};

/// Descriptor for `PlayerMovedTable`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerMovedTableDescriptor = $convert.base64Decode('ChBQbGF5ZXJNb3ZlZFRhYmxlEiMKDXRvdXJuYW1lbnRfaWQYCiABKA1SDHRvdXJuYW1lbnRJZBIgCgxvbGRfdGFibGVfbm8YFCABKA1SCm9sZFRhYmxlTm8SIAoMbmV3X3RhYmxlX25vGB4gASgNUgpuZXdUYWJsZU5vEikKEW5ld190YWJsZV9zZWF0X25vGB8gASgNUg5uZXdUYWJsZVNlYXRObxIbCglnYW1lX2NvZGUYKCABKAlSCGdhbWVDb2RlEhsKCXBsYXllcl9pZBg8IAEoBFIIcGxheWVySWQSGwoJZ2FtZV9pbmZvGEYgASgJUghnYW1lSW5mbw==');
@$core.Deprecated('Use currentHandStateDescriptor instead')
const CurrentHandState$json = const {
  '1': 'CurrentHandState',
  '2': const [
    const {'1': 'game_id', '3': 1, '4': 1, '5': 4, '10': 'gameId'},
    const {'1': 'hand_num', '3': 2, '4': 1, '5': 13, '10': 'handNum'},
    const {'1': 'game_type', '3': 3, '4': 1, '5': 14, '6': '.game.GameType', '10': 'gameType'},
    const {'1': 'current_round', '3': 4, '4': 1, '5': 14, '6': '.game.HandStatus', '10': 'currentRound'},
    const {'1': 'button_pos', '3': 5, '4': 1, '5': 13, '10': 'buttonPos'},
    const {'1': 'small_blind_pos', '3': 6, '4': 1, '5': 13, '10': 'smallBlindPos'},
    const {'1': 'big_blind_pos', '3': 7, '4': 1, '5': 13, '10': 'bigBlindPos'},
    const {'1': 'big_blind', '3': 8, '4': 1, '5': 1, '10': 'bigBlind'},
    const {'1': 'small_blind', '3': 9, '4': 1, '5': 1, '10': 'smallBlind'},
    const {'1': 'straddle', '3': 10, '4': 1, '5': 1, '10': 'straddle'},
    const {'1': 'players_acted', '3': 12, '4': 3, '5': 11, '6': '.game.CurrentHandState.PlayersActedEntry', '10': 'playersActed'},
    const {'1': 'board_cards', '3': 13, '4': 3, '5': 13, '10': 'boardCards'},
    const {'1': 'board_cards_2', '3': 14, '4': 3, '5': 13, '10': 'boardCards2'},
    const {'1': 'cardsStr', '3': 15, '4': 1, '5': 9, '10': 'cardsStr'},
    const {'1': 'cards2Str', '3': 16, '4': 1, '5': 9, '10': 'cards2Str'},
    const {'1': 'player_cards', '3': 17, '4': 1, '5': 9, '10': 'playerCards'},
    const {'1': 'player_seat_no', '3': 18, '4': 1, '5': 13, '10': 'playerSeatNo'},
    const {'1': 'players_stack', '3': 19, '4': 3, '5': 11, '6': '.game.CurrentHandState.PlayersStackEntry', '10': 'playersStack'},
    const {'1': 'next_seat_to_act', '3': 20, '4': 1, '5': 13, '10': 'nextSeatToAct'},
    const {'1': 'remaining_action_time', '3': 21, '4': 1, '5': 13, '10': 'remainingActionTime'},
    const {'1': 'next_seat_action', '3': 22, '4': 1, '5': 11, '6': '.game.NextSeatAction', '10': 'nextSeatAction'},
    const {'1': 'pots', '3': 23, '4': 3, '5': 1, '10': 'pots'},
    const {'1': 'pot_updates', '3': 24, '4': 1, '5': 1, '10': 'potUpdates'},
    const {'1': 'no_cards', '3': 25, '4': 1, '5': 13, '10': 'noCards'},
    const {'1': 'bomb_pot', '3': 36, '4': 1, '5': 8, '10': 'bombPot'},
    const {'1': 'double_board', '3': 37, '4': 1, '5': 8, '10': 'doubleBoard'},
    const {'1': 'bomb_pot_bet', '3': 38, '4': 1, '5': 1, '10': 'bombPotBet'},
  ],
  '3': const [CurrentHandState_PlayersActedEntry$json, CurrentHandState_PlayersStackEntry$json],
};

@$core.Deprecated('Use currentHandStateDescriptor instead')
const CurrentHandState_PlayersActedEntry$json = const {
  '1': 'PlayersActedEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.game.PlayerActRound', '10': 'value'},
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use currentHandStateDescriptor instead')
const CurrentHandState_PlayersStackEntry$json = const {
  '1': 'PlayersStackEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 4, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `CurrentHandState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List currentHandStateDescriptor = $convert.base64Decode('ChBDdXJyZW50SGFuZFN0YXRlEhcKB2dhbWVfaWQYASABKARSBmdhbWVJZBIZCghoYW5kX251bRgCIAEoDVIHaGFuZE51bRIrCglnYW1lX3R5cGUYAyABKA4yDi5nYW1lLkdhbWVUeXBlUghnYW1lVHlwZRI1Cg1jdXJyZW50X3JvdW5kGAQgASgOMhAuZ2FtZS5IYW5kU3RhdHVzUgxjdXJyZW50Um91bmQSHQoKYnV0dG9uX3BvcxgFIAEoDVIJYnV0dG9uUG9zEiYKD3NtYWxsX2JsaW5kX3BvcxgGIAEoDVINc21hbGxCbGluZFBvcxIiCg1iaWdfYmxpbmRfcG9zGAcgASgNUgtiaWdCbGluZFBvcxIbCgliaWdfYmxpbmQYCCABKAFSCGJpZ0JsaW5kEh8KC3NtYWxsX2JsaW5kGAkgASgBUgpzbWFsbEJsaW5kEhoKCHN0cmFkZGxlGAogASgBUghzdHJhZGRsZRJNCg1wbGF5ZXJzX2FjdGVkGAwgAygLMiguZ2FtZS5DdXJyZW50SGFuZFN0YXRlLlBsYXllcnNBY3RlZEVudHJ5UgxwbGF5ZXJzQWN0ZWQSHwoLYm9hcmRfY2FyZHMYDSADKA1SCmJvYXJkQ2FyZHMSIgoNYm9hcmRfY2FyZHNfMhgOIAMoDVILYm9hcmRDYXJkczISGgoIY2FyZHNTdHIYDyABKAlSCGNhcmRzU3RyEhwKCWNhcmRzMlN0chgQIAEoCVIJY2FyZHMyU3RyEiEKDHBsYXllcl9jYXJkcxgRIAEoCVILcGxheWVyQ2FyZHMSJAoOcGxheWVyX3NlYXRfbm8YEiABKA1SDHBsYXllclNlYXRObxJNCg1wbGF5ZXJzX3N0YWNrGBMgAygLMiguZ2FtZS5DdXJyZW50SGFuZFN0YXRlLlBsYXllcnNTdGFja0VudHJ5UgxwbGF5ZXJzU3RhY2sSJwoQbmV4dF9zZWF0X3RvX2FjdBgUIAEoDVINbmV4dFNlYXRUb0FjdBIyChVyZW1haW5pbmdfYWN0aW9uX3RpbWUYFSABKA1SE3JlbWFpbmluZ0FjdGlvblRpbWUSPgoQbmV4dF9zZWF0X2FjdGlvbhgWIAEoCzIULmdhbWUuTmV4dFNlYXRBY3Rpb25SDm5leHRTZWF0QWN0aW9uEhIKBHBvdHMYFyADKAFSBHBvdHMSHwoLcG90X3VwZGF0ZXMYGCABKAFSCnBvdFVwZGF0ZXMSGQoIbm9fY2FyZHMYGSABKA1SB25vQ2FyZHMSGQoIYm9tYl9wb3QYJCABKAhSB2JvbWJQb3QSIQoMZG91YmxlX2JvYXJkGCUgASgIUgtkb3VibGVCb2FyZBIgCgxib21iX3BvdF9iZXQYJiABKAFSCmJvbWJQb3RCZXQaVQoRUGxheWVyc0FjdGVkRW50cnkSEAoDa2V5GAEgASgNUgNrZXkSKgoFdmFsdWUYAiABKAsyFC5nYW1lLlBsYXllckFjdFJvdW5kUgV2YWx1ZToCOAEaPwoRUGxheWVyc1N0YWNrRW50cnkSEAoDa2V5GAEgASgEUgNrZXkSFAoFdmFsdWUYAiABKAFSBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use handWinnerDescriptor instead')
const HandWinner$json = const {
  '1': 'HandWinner',
  '2': const [
    const {'1': 'seat_no', '3': 1, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'lo_card', '3': 2, '4': 1, '5': 8, '10': 'loCard'},
    const {'1': 'amount', '3': 3, '4': 1, '5': 1, '10': 'amount'},
    const {'1': 'winning_cards', '3': 4, '4': 3, '5': 13, '10': 'winningCards'},
    const {'1': 'winning_cards_str', '3': 5, '4': 1, '5': 9, '10': 'winningCardsStr'},
    const {'1': 'rank_str', '3': 6, '4': 1, '5': 9, '10': 'rankStr'},
    const {'1': 'rank', '3': 7, '4': 1, '5': 13, '10': 'rank'},
    const {'1': 'player_cards', '3': 8, '4': 3, '5': 13, '10': 'playerCards'},
    const {'1': 'board_cards', '3': 9, '4': 3, '5': 13, '10': 'boardCards'},
  ],
};

/// Descriptor for `HandWinner`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handWinnerDescriptor = $convert.base64Decode('CgpIYW5kV2lubmVyEhcKB3NlYXRfbm8YASABKA1SBnNlYXRObxIXCgdsb19jYXJkGAIgASgIUgZsb0NhcmQSFgoGYW1vdW50GAMgASgBUgZhbW91bnQSIwoNd2lubmluZ19jYXJkcxgEIAMoDVIMd2lubmluZ0NhcmRzEioKEXdpbm5pbmdfY2FyZHNfc3RyGAUgASgJUg93aW5uaW5nQ2FyZHNTdHISGQoIcmFua19zdHIYBiABKAlSB3JhbmtTdHISEgoEcmFuaxgHIAEoDVIEcmFuaxIhCgxwbGF5ZXJfY2FyZHMYCCADKA1SC3BsYXllckNhcmRzEh8KC2JvYXJkX2NhcmRzGAkgAygNUgpib2FyZENhcmRz');
@$core.Deprecated('Use potWinnersDescriptor instead')
const PotWinners$json = const {
  '1': 'PotWinners',
  '2': const [
    const {'1': 'pot_no', '3': 1, '4': 1, '5': 13, '10': 'potNo'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 1, '10': 'amount'},
    const {'1': 'hi_winners', '3': 3, '4': 3, '5': 11, '6': '.game.HandWinner', '10': 'hiWinners'},
    const {'1': 'low_winners', '3': 4, '4': 3, '5': 11, '6': '.game.HandWinner', '10': 'lowWinners'},
    const {'1': 'pause_time', '3': 5, '4': 1, '5': 13, '10': 'pauseTime'},
  ],
};

/// Descriptor for `PotWinners`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List potWinnersDescriptor = $convert.base64Decode('CgpQb3RXaW5uZXJzEhUKBnBvdF9ubxgBIAEoDVIFcG90Tm8SFgoGYW1vdW50GAIgASgBUgZhbW91bnQSLwoKaGlfd2lubmVycxgDIAMoCzIQLmdhbWUuSGFuZFdpbm5lclIJaGlXaW5uZXJzEjEKC2xvd193aW5uZXJzGAQgAygLMhAuZ2FtZS5IYW5kV2lubmVyUgpsb3dXaW5uZXJzEh0KCnBhdXNlX3RpbWUYBSABKA1SCXBhdXNlVGltZQ==');
@$core.Deprecated('Use boardCardRankDescriptor instead')
const BoardCardRank$json = const {
  '1': 'BoardCardRank',
  '2': const [
    const {'1': 'board_no', '3': 1, '4': 1, '5': 13, '10': 'boardNo'},
    const {'1': 'seat_no', '3': 2, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'hi_rank', '3': 3, '4': 1, '5': 13, '10': 'hiRank'},
    const {'1': 'hi_cards', '3': 4, '4': 3, '5': 13, '10': 'hiCards'},
    const {'1': 'low_found', '3': 5, '4': 1, '5': 8, '10': 'lowFound'},
    const {'1': 'lo_rank', '3': 6, '4': 1, '5': 13, '10': 'loRank'},
    const {'1': 'lo_cards', '3': 7, '4': 3, '5': 13, '10': 'loCards'},
    const {'1': 'hh_rank', '3': 8, '4': 1, '5': 13, '10': 'hhRank'},
    const {'1': 'hh_cards', '3': 9, '4': 3, '5': 13, '10': 'hhCards'},
  ],
};

/// Descriptor for `BoardCardRank`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List boardCardRankDescriptor = $convert.base64Decode('Cg1Cb2FyZENhcmRSYW5rEhkKCGJvYXJkX25vGAEgASgNUgdib2FyZE5vEhcKB3NlYXRfbm8YAiABKA1SBnNlYXRObxIXCgdoaV9yYW5rGAMgASgNUgZoaVJhbmsSGQoIaGlfY2FyZHMYBCADKA1SB2hpQ2FyZHMSGwoJbG93X2ZvdW5kGAUgASgIUghsb3dGb3VuZBIXCgdsb19yYW5rGAYgASgNUgZsb1JhbmsSGQoIbG9fY2FyZHMYByADKA1SB2xvQ2FyZHMSFwoHaGhfcmFuaxgIIAEoDVIGaGhSYW5rEhkKCGhoX2NhcmRzGAkgAygNUgdoaENhcmRz');
@$core.Deprecated('Use boardDescriptor instead')
const Board$json = const {
  '1': 'Board',
  '2': const [
    const {'1': 'board_no', '3': 1, '4': 1, '5': 13, '10': 'boardNo'},
    const {'1': 'cards', '3': 2, '4': 3, '5': 13, '10': 'cards'},
    const {'1': 'player_rank', '3': 3, '4': 3, '5': 11, '6': '.game.Board.PlayerRankEntry', '10': 'playerRank'},
  ],
  '3': const [Board_PlayerRankEntry$json],
};

@$core.Deprecated('Use boardDescriptor instead')
const Board_PlayerRankEntry$json = const {
  '1': 'PlayerRankEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.game.BoardCardRank', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `Board`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List boardDescriptor = $convert.base64Decode('CgVCb2FyZBIZCghib2FyZF9ubxgBIAEoDVIHYm9hcmRObxIUCgVjYXJkcxgCIAMoDVIFY2FyZHMSPAoLcGxheWVyX3JhbmsYAyADKAsyGy5nYW1lLkJvYXJkLlBsYXllclJhbmtFbnRyeVIKcGxheWVyUmFuaxpSCg9QbGF5ZXJSYW5rRW50cnkSEAoDa2V5GAEgASgNUgNrZXkSKQoFdmFsdWUYAiABKAsyEy5nYW1lLkJvYXJkQ2FyZFJhbmtSBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use winnerDescriptor instead')
const Winner$json = const {
  '1': 'Winner',
  '2': const [
    const {'1': 'seat_no', '3': 1, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 1, '10': 'amount'},
  ],
};

/// Descriptor for `Winner`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List winnerDescriptor = $convert.base64Decode('CgZXaW5uZXISFwoHc2VhdF9ubxgBIAEoDVIGc2VhdE5vEhYKBmFtb3VudBgCIAEoAVIGYW1vdW50');
@$core.Deprecated('Use boardWinnerDescriptor instead')
const BoardWinner$json = const {
  '1': 'BoardWinner',
  '2': const [
    const {'1': 'board_no', '3': 2, '4': 1, '5': 13, '10': 'boardNo'},
    const {'1': 'amount', '3': 3, '4': 1, '5': 1, '10': 'amount'},
    const {'1': 'hi_winners', '3': 4, '4': 3, '5': 11, '6': '.game.BoardWinner.HiWinnersEntry', '10': 'hiWinners'},
    const {'1': 'low_winners', '3': 5, '4': 3, '5': 11, '6': '.game.BoardWinner.LowWinnersEntry', '10': 'lowWinners'},
    const {'1': 'hi_rank_text', '3': 6, '4': 1, '5': 9, '10': 'hiRankText'},
  ],
  '3': const [BoardWinner_HiWinnersEntry$json, BoardWinner_LowWinnersEntry$json],
};

@$core.Deprecated('Use boardWinnerDescriptor instead')
const BoardWinner_HiWinnersEntry$json = const {
  '1': 'HiWinnersEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.game.Winner', '10': 'value'},
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use boardWinnerDescriptor instead')
const BoardWinner_LowWinnersEntry$json = const {
  '1': 'LowWinnersEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.game.Winner', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `BoardWinner`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List boardWinnerDescriptor = $convert.base64Decode('CgtCb2FyZFdpbm5lchIZCghib2FyZF9ubxgCIAEoDVIHYm9hcmRObxIWCgZhbW91bnQYAyABKAFSBmFtb3VudBI/CgpoaV93aW5uZXJzGAQgAygLMiAuZ2FtZS5Cb2FyZFdpbm5lci5IaVdpbm5lcnNFbnRyeVIJaGlXaW5uZXJzEkIKC2xvd193aW5uZXJzGAUgAygLMiEuZ2FtZS5Cb2FyZFdpbm5lci5Mb3dXaW5uZXJzRW50cnlSCmxvd1dpbm5lcnMSIAoMaGlfcmFua190ZXh0GAYgASgJUgpoaVJhbmtUZXh0GkoKDkhpV2lubmVyc0VudHJ5EhAKA2tleRgBIAEoDVIDa2V5EiIKBXZhbHVlGAIgASgLMgwuZ2FtZS5XaW5uZXJSBXZhbHVlOgI4ARpLCg9Mb3dXaW5uZXJzRW50cnkSEAoDa2V5GAEgASgNUgNrZXkSIgoFdmFsdWUYAiABKAsyDC5nYW1lLldpbm5lclIFdmFsdWU6AjgB');
@$core.Deprecated('Use potWinnersV2Descriptor instead')
const PotWinnersV2$json = const {
  '1': 'PotWinnersV2',
  '2': const [
    const {'1': 'pot_no', '3': 1, '4': 1, '5': 13, '10': 'potNo'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 1, '10': 'amount'},
    const {'1': 'board_winners', '3': 3, '4': 3, '5': 11, '6': '.game.BoardWinner', '10': 'boardWinners'},
    const {'1': 'seats_in_pots', '3': 4, '4': 3, '5': 13, '10': 'seatsInPots'},
  ],
};

/// Descriptor for `PotWinnersV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List potWinnersV2Descriptor = $convert.base64Decode('CgxQb3RXaW5uZXJzVjISFQoGcG90X25vGAEgASgNUgVwb3RObxIWCgZhbW91bnQYAiABKAFSBmFtb3VudBI2Cg1ib2FyZF93aW5uZXJzGAMgAygLMhEuZ2FtZS5Cb2FyZFdpbm5lclIMYm9hcmRXaW5uZXJzEiIKDXNlYXRzX2luX3BvdHMYBCADKA1SC3NlYXRzSW5Qb3Rz');
@$core.Deprecated('Use handResultV2Descriptor instead')
const HandResultV2$json = const {
  '1': 'HandResultV2',
  '2': const [
    const {'1': 'boards', '3': 1, '4': 3, '5': 11, '6': '.game.Board', '10': 'boards'},
    const {'1': 'pot_winners', '3': 2, '4': 3, '5': 11, '6': '.game.PotWinnersV2', '10': 'potWinners'},
  ],
};

/// Descriptor for `HandResultV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handResultV2Descriptor = $convert.base64Decode('CgxIYW5kUmVzdWx0VjISIwoGYm9hcmRzGAEgAygLMgsuZ2FtZS5Cb2FyZFIGYm9hcmRzEjMKC3BvdF93aW5uZXJzGAIgAygLMhIuZ2FtZS5Qb3RXaW5uZXJzVjJSCnBvdFdpbm5lcnM=');
@$core.Deprecated('Use handPlayerBalanceDescriptor instead')
const HandPlayerBalance$json = const {
  '1': 'HandPlayerBalance',
  '2': const [
    const {'1': 'before', '3': 1, '4': 1, '5': 1, '10': 'before'},
    const {'1': 'after', '3': 2, '4': 1, '5': 1, '10': 'after'},
  ],
};

/// Descriptor for `HandPlayerBalance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handPlayerBalanceDescriptor = $convert.base64Decode('ChFIYW5kUGxheWVyQmFsYW5jZRIWCgZiZWZvcmUYASABKAFSBmJlZm9yZRIUCgVhZnRlchgCIAEoAVIFYWZ0ZXI=');
@$core.Deprecated('Use playerHandInfoDescriptor instead')
const PlayerHandInfo$json = const {
  '1': 'PlayerHandInfo',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    const {'1': 'cards', '3': 2, '4': 3, '5': 13, '10': 'cards'},
    const {'1': 'played_until', '3': 5, '4': 1, '5': 14, '6': '.game.HandStatus', '10': 'playedUntil'},
    const {'1': 'balance', '3': 6, '4': 1, '5': 11, '6': '.game.HandPlayerBalance', '10': 'balance'},
    const {'1': 'hh_cards', '3': 7, '4': 3, '5': 13, '10': 'hhCards'},
    const {'1': 'hh_rank', '3': 8, '4': 1, '5': 13, '10': 'hhRank'},
    const {'1': 'received', '3': 9, '4': 1, '5': 1, '10': 'received'},
    const {'1': 'rake_paid', '3': 10, '4': 1, '5': 1, '10': 'rakePaid'},
    const {'1': 'pot_contribution', '3': 11, '4': 1, '5': 1, '10': 'potContribution'},
  ],
};

/// Descriptor for `PlayerHandInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerHandInfoDescriptor = $convert.base64Decode('Cg5QbGF5ZXJIYW5kSW5mbxIOCgJpZBgBIAEoBFICaWQSFAoFY2FyZHMYAiADKA1SBWNhcmRzEjMKDHBsYXllZF91bnRpbBgFIAEoDjIQLmdhbWUuSGFuZFN0YXR1c1ILcGxheWVkVW50aWwSMQoHYmFsYW5jZRgGIAEoCzIXLmdhbWUuSGFuZFBsYXllckJhbGFuY2VSB2JhbGFuY2USGQoIaGhfY2FyZHMYByADKA1SB2hoQ2FyZHMSFwoHaGhfcmFuaxgIIAEoDVIGaGhSYW5rEhoKCHJlY2VpdmVkGAkgASgBUghyZWNlaXZlZBIbCglyYWtlX3BhaWQYCiABKAFSCHJha2VQYWlkEikKEHBvdF9jb250cmlidXRpb24YCyABKAFSD3BvdENvbnRyaWJ1dGlvbg==');
