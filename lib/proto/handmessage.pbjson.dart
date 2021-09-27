///
//  Generated code. Do not modify.
//  source: handmessage.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use playerStatsDescriptor instead')
const PlayerStats$json = const {
  '1': 'PlayerStats',
  '2': const [
    const {'1': 'preflop_raise', '3': 1, '4': 1, '5': 8, '10': 'preflopRaise'},
    const {
      '1': 'postflop_raise',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'postflopRaise'
    },
    const {'1': 'three_bet', '3': 5, '4': 1, '5': 8, '10': 'threeBet'},
    const {'1': 'cbet', '3': 3, '4': 1, '5': 8, '10': 'cbet'},
    const {'1': 'vpip', '3': 4, '4': 1, '5': 8, '10': 'vpip'},
    const {'1': 'allin', '3': 6, '4': 1, '5': 8, '10': 'allin'},
    const {
      '1': 'went_to_showdown',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'wentToShowdown'
    },
    const {
      '1': 'won_chips_at_showdown',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'wonChipsAtShowdown'
    },
    const {'1': 'headsup', '3': 9, '4': 1, '5': 8, '10': 'headsup'},
    const {
      '1': 'headsup_player',
      '3': 10,
      '4': 1,
      '5': 4,
      '10': 'headsupPlayer'
    },
    const {'1': 'won_headsup', '3': 11, '4': 1, '5': 8, '10': 'wonHeadsup'},
    const {'1': 'badbeat', '3': 12, '4': 1, '5': 8, '10': 'badbeat'},
    const {'1': 'in_preflop', '3': 13, '4': 1, '5': 8, '10': 'inPreflop'},
    const {'1': 'in_flop', '3': 14, '4': 1, '5': 8, '10': 'inFlop'},
    const {'1': 'in_turn', '3': 15, '4': 1, '5': 8, '10': 'inTurn'},
    const {'1': 'in_river', '3': 16, '4': 1, '5': 8, '10': 'inRiver'},
  ],
};

/// Descriptor for `PlayerStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerStatsDescriptor = $convert.base64Decode(
    'CgtQbGF5ZXJTdGF0cxIjCg1wcmVmbG9wX3JhaXNlGAEgASgIUgxwcmVmbG9wUmFpc2USJQoOcG9zdGZsb3BfcmFpc2UYAiABKAhSDXBvc3RmbG9wUmFpc2USGwoJdGhyZWVfYmV0GAUgASgIUgh0aHJlZUJldBISCgRjYmV0GAMgASgIUgRjYmV0EhIKBHZwaXAYBCABKAhSBHZwaXASFAoFYWxsaW4YBiABKAhSBWFsbGluEigKEHdlbnRfdG9fc2hvd2Rvd24YByABKAhSDndlbnRUb1Nob3dkb3duEjEKFXdvbl9jaGlwc19hdF9zaG93ZG93bhgIIAEoCFISd29uQ2hpcHNBdFNob3dkb3duEhgKB2hlYWRzdXAYCSABKAhSB2hlYWRzdXASJQoOaGVhZHN1cF9wbGF5ZXIYCiABKARSDWhlYWRzdXBQbGF5ZXISHwoLd29uX2hlYWRzdXAYCyABKAhSCndvbkhlYWRzdXASGAoHYmFkYmVhdBgMIAEoCFIHYmFkYmVhdBIdCgppbl9wcmVmbG9wGA0gASgIUglpblByZWZsb3ASFwoHaW5fZmxvcBgOIAEoCFIGaW5GbG9wEhcKB2luX3R1cm4YDyABKAhSBmluVHVybhIZCghpbl9yaXZlchgQIAEoCFIHaW5SaXZlcg==');
@$core.Deprecated('Use timeoutStatsDescriptor instead')
const TimeoutStats$json = const {
  '1': 'TimeoutStats',
  '2': const [
    const {
      '1': 'consecutive_action_timeouts',
      '3': 1,
      '4': 1,
      '5': 13,
      '10': 'consecutiveActionTimeouts'
    },
    const {
      '1': 'acted_at_least_once',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'actedAtLeastOnce'
    },
  ],
};

/// Descriptor for `TimeoutStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeoutStatsDescriptor = $convert.base64Decode(
    'CgxUaW1lb3V0U3RhdHMSPgobY29uc2VjdXRpdmVfYWN0aW9uX3RpbWVvdXRzGAEgASgNUhljb25zZWN1dGl2ZUFjdGlvblRpbWVvdXRzEi0KE2FjdGVkX2F0X2xlYXN0X29uY2UYAiABKAhSEGFjdGVkQXRMZWFzdE9uY2U=');
@$core.Deprecated('Use handStatsDescriptor instead')
const HandStats$json = const {
  '1': 'HandStats',
  '2': const [
    const {
      '1': 'ended_at_preflop',
      '3': 1,
      '4': 1,
      '5': 8,
      '10': 'endedAtPreflop'
    },
    const {'1': 'ended_at_flop', '3': 2, '4': 1, '5': 8, '10': 'endedAtFlop'},
    const {'1': 'ended_at_turn', '3': 3, '4': 1, '5': 8, '10': 'endedAtTurn'},
    const {'1': 'ended_at_river', '3': 4, '4': 1, '5': 8, '10': 'endedAtRiver'},
    const {
      '1': 'ended_at_showdown',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'endedAtShowdown'
    },
  ],
};

/// Descriptor for `HandStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handStatsDescriptor = $convert.base64Decode(
    'CglIYW5kU3RhdHMSKAoQZW5kZWRfYXRfcHJlZmxvcBgBIAEoCFIOZW5kZWRBdFByZWZsb3ASIgoNZW5kZWRfYXRfZmxvcBgCIAEoCFILZW5kZWRBdEZsb3ASIgoNZW5kZWRfYXRfdHVybhgDIAEoCFILZW5kZWRBdFR1cm4SJAoOZW5kZWRfYXRfcml2ZXIYBCABKAhSDGVuZGVkQXRSaXZlchIqChFlbmRlZF9hdF9zaG93ZG93bhgFIAEoCFIPZW5kZWRBdFNob3dkb3du');
@$core.Deprecated('Use newHandDescriptor instead')
const NewHand$json = const {
  '1': 'NewHand',
  '2': const [
    const {'1': 'hand_num', '3': 1, '4': 1, '5': 13, '10': 'handNum'},
    const {'1': 'button_pos', '3': 2, '4': 1, '5': 13, '10': 'buttonPos'},
    const {'1': 'sb_pos', '3': 3, '4': 1, '5': 13, '10': 'sbPos'},
    const {'1': 'bb_pos', '3': 4, '4': 1, '5': 13, '10': 'bbPos'},
    const {
      '1': 'next_action_seat',
      '3': 5,
      '4': 1,
      '5': 13,
      '10': 'nextActionSeat'
    },
    const {
      '1': 'player_cards',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.game.NewHand.PlayerCardsEntry',
      '10': 'playerCards'
    },
    const {
      '1': 'game_type',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.game.GameType',
      '10': 'gameType'
    },
    const {'1': 'no_cards', '3': 8, '4': 1, '5': 13, '10': 'noCards'},
    const {'1': 'small_blind', '3': 9, '4': 1, '5': 2, '10': 'smallBlind'},
    const {'1': 'big_blind', '3': 10, '4': 1, '5': 2, '10': 'bigBlind'},
    const {'1': 'bring_in', '3': 11, '4': 1, '5': 2, '10': 'bringIn'},
    const {'1': 'straddle', '3': 12, '4': 1, '5': 2, '10': 'straddle'},
    const {
      '1': 'players_in_seats',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.game.NewHand.PlayersInSeatsEntry',
      '10': 'playersInSeats'
    },
    const {
      '1': 'players_acted',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.game.NewHand.PlayersActedEntry',
      '10': 'playersActed'
    },
    const {'1': 'bomb_pot', '3': 15, '4': 1, '5': 8, '10': 'bombPot'},
    const {'1': 'double_board', '3': 16, '4': 1, '5': 8, '10': 'doubleBoard'},
    const {'1': 'bomb_pot_bet', '3': 17, '4': 1, '5': 2, '10': 'bombPotBet'},
  ],
  '3': const [
    NewHand_PlayerCardsEntry$json,
    NewHand_PlayersInSeatsEntry$json,
    NewHand_PlayersActedEntry$json
  ],
};

@$core.Deprecated('Use newHandDescriptor instead')
const NewHand_PlayerCardsEntry$json = const {
  '1': 'PlayerCardsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use newHandDescriptor instead')
const NewHand_PlayersInSeatsEntry$json = const {
  '1': 'PlayersInSeatsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.game.PlayerInSeatState',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use newHandDescriptor instead')
const NewHand_PlayersActedEntry$json = const {
  '1': 'PlayersActedEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.game.PlayerActRound',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

/// Descriptor for `NewHand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List newHandDescriptor = $convert.base64Decode(
    'CgdOZXdIYW5kEhkKCGhhbmRfbnVtGAEgASgNUgdoYW5kTnVtEh0KCmJ1dHRvbl9wb3MYAiABKA1SCWJ1dHRvblBvcxIVCgZzYl9wb3MYAyABKA1SBXNiUG9zEhUKBmJiX3BvcxgEIAEoDVIFYmJQb3MSKAoQbmV4dF9hY3Rpb25fc2VhdBgFIAEoDVIObmV4dEFjdGlvblNlYXQSQQoMcGxheWVyX2NhcmRzGAYgAygLMh4uZ2FtZS5OZXdIYW5kLlBsYXllckNhcmRzRW50cnlSC3BsYXllckNhcmRzEisKCWdhbWVfdHlwZRgHIAEoDjIOLmdhbWUuR2FtZVR5cGVSCGdhbWVUeXBlEhkKCG5vX2NhcmRzGAggASgNUgdub0NhcmRzEh8KC3NtYWxsX2JsaW5kGAkgASgCUgpzbWFsbEJsaW5kEhsKCWJpZ19ibGluZBgKIAEoAlIIYmlnQmxpbmQSGQoIYnJpbmdfaW4YCyABKAJSB2JyaW5nSW4SGgoIc3RyYWRkbGUYDCABKAJSCHN0cmFkZGxlEksKEHBsYXllcnNfaW5fc2VhdHMYDSADKAsyIS5nYW1lLk5ld0hhbmQuUGxheWVyc0luU2VhdHNFbnRyeVIOcGxheWVyc0luU2VhdHMSRAoNcGxheWVyc19hY3RlZBgOIAMoCzIfLmdhbWUuTmV3SGFuZC5QbGF5ZXJzQWN0ZWRFbnRyeVIMcGxheWVyc0FjdGVkEhkKCGJvbWJfcG90GA8gASgIUgdib21iUG90EiEKDGRvdWJsZV9ib2FyZBgQIAEoCFILZG91YmxlQm9hcmQSIAoMYm9tYl9wb3RfYmV0GBEgASgCUgpib21iUG90QmV0Gj4KEFBsYXllckNhcmRzRW50cnkSEAoDa2V5GAEgASgNUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4ARpaChNQbGF5ZXJzSW5TZWF0c0VudHJ5EhAKA2tleRgBIAEoDVIDa2V5Ei0KBXZhbHVlGAIgASgLMhcuZ2FtZS5QbGF5ZXJJblNlYXRTdGF0ZVIFdmFsdWU6AjgBGlUKEVBsYXllcnNBY3RlZEVudHJ5EhAKA2tleRgBIAEoDVIDa2V5EioKBXZhbHVlGAIgASgLMhQuZ2FtZS5QbGF5ZXJBY3RSb3VuZFIFdmFsdWU6AjgB');
@$core.Deprecated('Use handDealCardsDescriptor instead')
const HandDealCards$json = const {
  '1': 'HandDealCards',
  '2': const [
    const {'1': 'seat_no', '3': 1, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'cards', '3': 2, '4': 1, '5': 9, '10': 'cards'},
    const {'1': 'cardsStr', '3': 3, '4': 1, '5': 9, '10': 'cardsStr'},
  ],
};

/// Descriptor for `HandDealCards`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handDealCardsDescriptor = $convert.base64Decode(
    'Cg1IYW5kRGVhbENhcmRzEhcKB3NlYXRfbm8YASABKA1SBnNlYXRObxIUCgVjYXJkcxgCIAEoCVIFY2FyZHMSGgoIY2FyZHNTdHIYAyABKAlSCGNhcmRzU3Ry');
@$core.Deprecated('Use actionChangeDescriptor instead')
const ActionChange$json = const {
  '1': 'ActionChange',
  '2': const [
    const {'1': 'seat_no', '3': 1, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'pots', '3': 2, '4': 3, '5': 2, '10': 'pots'},
    const {'1': 'pot_updates', '3': 3, '4': 1, '5': 2, '10': 'potUpdates'},
    const {
      '1': 'seats_pots',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.game.SeatsInPots',
      '10': 'seatsPots'
    },
    const {'1': 'bet_amount', '3': 5, '4': 1, '5': 2, '10': 'betAmount'},
  ],
};

/// Descriptor for `ActionChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actionChangeDescriptor = $convert.base64Decode(
    'CgxBY3Rpb25DaGFuZ2USFwoHc2VhdF9ubxgBIAEoDVIGc2VhdE5vEhIKBHBvdHMYAiADKAJSBHBvdHMSHwoLcG90X3VwZGF0ZXMYAyABKAJSCnBvdFVwZGF0ZXMSMAoKc2VhdHNfcG90cxgEIAMoCzIRLmdhbWUuU2VhdHNJblBvdHNSCXNlYXRzUG90cxIdCgpiZXRfYW1vdW50GAUgASgCUgliZXRBbW91bnQ=');
@$core.Deprecated('Use flopDescriptor instead')
const Flop$json = const {
  '1': 'Flop',
  '2': const [
    const {'1': 'board', '3': 1, '4': 3, '5': 13, '10': 'board'},
    const {'1': 'cardsStr', '3': 2, '4': 1, '5': 9, '10': 'cardsStr'},
    const {'1': 'pots', '3': 3, '4': 3, '5': 2, '10': 'pots'},
    const {
      '1': 'seats_pots',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.game.SeatsInPots',
      '10': 'seatsPots'
    },
    const {
      '1': 'player_balance',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.game.Flop.PlayerBalanceEntry',
      '10': 'playerBalance'
    },
    const {
      '1': 'player_card_ranks',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.game.Flop.PlayerCardRanksEntry',
      '10': 'playerCardRanks'
    },
    const {
      '1': 'boards',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.game.Board',
      '10': 'boards'
    },
  ],
  '3': const [Flop_PlayerBalanceEntry$json, Flop_PlayerCardRanksEntry$json],
};

@$core.Deprecated('Use flopDescriptor instead')
const Flop_PlayerBalanceEntry$json = const {
  '1': 'PlayerBalanceEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 2, '10': 'value'},
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use flopDescriptor instead')
const Flop_PlayerCardRanksEntry$json = const {
  '1': 'PlayerCardRanksEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `Flop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List flopDescriptor = $convert.base64Decode(
    'CgRGbG9wEhQKBWJvYXJkGAEgAygNUgVib2FyZBIaCghjYXJkc1N0chgCIAEoCVIIY2FyZHNTdHISEgoEcG90cxgDIAMoAlIEcG90cxIwCgpzZWF0c19wb3RzGAQgAygLMhEuZ2FtZS5TZWF0c0luUG90c1IJc2VhdHNQb3RzEkQKDnBsYXllcl9iYWxhbmNlGAUgAygLMh0uZ2FtZS5GbG9wLlBsYXllckJhbGFuY2VFbnRyeVINcGxheWVyQmFsYW5jZRJLChFwbGF5ZXJfY2FyZF9yYW5rcxgGIAMoCzIfLmdhbWUuRmxvcC5QbGF5ZXJDYXJkUmFua3NFbnRyeVIPcGxheWVyQ2FyZFJhbmtzEiMKBmJvYXJkcxgHIAMoCzILLmdhbWUuQm9hcmRSBmJvYXJkcxpAChJQbGF5ZXJCYWxhbmNlRW50cnkSEAoDa2V5GAEgASgNUgNrZXkSFAoFdmFsdWUYAiABKAJSBXZhbHVlOgI4ARpCChRQbGF5ZXJDYXJkUmFua3NFbnRyeRIQCgNrZXkYASABKA1SA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');
@$core.Deprecated('Use turnDescriptor instead')
const Turn$json = const {
  '1': 'Turn',
  '2': const [
    const {'1': 'board', '3': 1, '4': 3, '5': 13, '10': 'board'},
    const {'1': 'turn_card', '3': 2, '4': 1, '5': 13, '10': 'turnCard'},
    const {'1': 'cardsStr', '3': 3, '4': 1, '5': 9, '10': 'cardsStr'},
    const {'1': 'pots', '3': 4, '4': 3, '5': 2, '10': 'pots'},
    const {
      '1': 'seats_pots',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.game.SeatsInPots',
      '10': 'seatsPots'
    },
    const {
      '1': 'player_balance',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.game.Turn.PlayerBalanceEntry',
      '10': 'playerBalance'
    },
    const {
      '1': 'player_card_ranks',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.game.Turn.PlayerCardRanksEntry',
      '10': 'playerCardRanks'
    },
    const {
      '1': 'boards',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.game.Board',
      '10': 'boards'
    },
  ],
  '3': const [Turn_PlayerBalanceEntry$json, Turn_PlayerCardRanksEntry$json],
};

@$core.Deprecated('Use turnDescriptor instead')
const Turn_PlayerBalanceEntry$json = const {
  '1': 'PlayerBalanceEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 2, '10': 'value'},
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use turnDescriptor instead')
const Turn_PlayerCardRanksEntry$json = const {
  '1': 'PlayerCardRanksEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `Turn`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnDescriptor = $convert.base64Decode(
    'CgRUdXJuEhQKBWJvYXJkGAEgAygNUgVib2FyZBIbCgl0dXJuX2NhcmQYAiABKA1SCHR1cm5DYXJkEhoKCGNhcmRzU3RyGAMgASgJUghjYXJkc1N0chISCgRwb3RzGAQgAygCUgRwb3RzEjAKCnNlYXRzX3BvdHMYBSADKAsyES5nYW1lLlNlYXRzSW5Qb3RzUglzZWF0c1BvdHMSRAoOcGxheWVyX2JhbGFuY2UYBiADKAsyHS5nYW1lLlR1cm4uUGxheWVyQmFsYW5jZUVudHJ5Ug1wbGF5ZXJCYWxhbmNlEksKEXBsYXllcl9jYXJkX3JhbmtzGAcgAygLMh8uZ2FtZS5UdXJuLlBsYXllckNhcmRSYW5rc0VudHJ5Ug9wbGF5ZXJDYXJkUmFua3MSIwoGYm9hcmRzGAggAygLMgsuZ2FtZS5Cb2FyZFIGYm9hcmRzGkAKElBsYXllckJhbGFuY2VFbnRyeRIQCgNrZXkYASABKA1SA2tleRIUCgV2YWx1ZRgCIAEoAlIFdmFsdWU6AjgBGkIKFFBsYXllckNhcmRSYW5rc0VudHJ5EhAKA2tleRgBIAEoDVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');
@$core.Deprecated('Use riverDescriptor instead')
const River$json = const {
  '1': 'River',
  '2': const [
    const {'1': 'board', '3': 1, '4': 3, '5': 13, '10': 'board'},
    const {'1': 'river_card', '3': 2, '4': 1, '5': 13, '10': 'riverCard'},
    const {'1': 'cardsStr', '3': 3, '4': 1, '5': 9, '10': 'cardsStr'},
    const {'1': 'pots', '3': 4, '4': 3, '5': 2, '10': 'pots'},
    const {
      '1': 'seats_pots',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.game.SeatsInPots',
      '10': 'seatsPots'
    },
    const {
      '1': 'player_balance',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.game.River.PlayerBalanceEntry',
      '10': 'playerBalance'
    },
    const {
      '1': 'player_card_ranks',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.game.River.PlayerCardRanksEntry',
      '10': 'playerCardRanks'
    },
    const {
      '1': 'boards',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.game.Board',
      '10': 'boards'
    },
  ],
  '3': const [River_PlayerBalanceEntry$json, River_PlayerCardRanksEntry$json],
};

@$core.Deprecated('Use riverDescriptor instead')
const River_PlayerBalanceEntry$json = const {
  '1': 'PlayerBalanceEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 2, '10': 'value'},
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use riverDescriptor instead')
const River_PlayerCardRanksEntry$json = const {
  '1': 'PlayerCardRanksEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `River`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List riverDescriptor = $convert.base64Decode(
    'CgVSaXZlchIUCgVib2FyZBgBIAMoDVIFYm9hcmQSHQoKcml2ZXJfY2FyZBgCIAEoDVIJcml2ZXJDYXJkEhoKCGNhcmRzU3RyGAMgASgJUghjYXJkc1N0chISCgRwb3RzGAQgAygCUgRwb3RzEjAKCnNlYXRzX3BvdHMYBSADKAsyES5nYW1lLlNlYXRzSW5Qb3RzUglzZWF0c1BvdHMSRQoOcGxheWVyX2JhbGFuY2UYBiADKAsyHi5nYW1lLlJpdmVyLlBsYXllckJhbGFuY2VFbnRyeVINcGxheWVyQmFsYW5jZRJMChFwbGF5ZXJfY2FyZF9yYW5rcxgHIAMoCzIgLmdhbWUuUml2ZXIuUGxheWVyQ2FyZFJhbmtzRW50cnlSD3BsYXllckNhcmRSYW5rcxIjCgZib2FyZHMYCSADKAsyCy5nYW1lLkJvYXJkUgZib2FyZHMaQAoSUGxheWVyQmFsYW5jZUVudHJ5EhAKA2tleRgBIAEoDVIDa2V5EhQKBXZhbHVlGAIgASgCUgV2YWx1ZToCOAEaQgoUUGxheWVyQ2FyZFJhbmtzRW50cnkSEAoDa2V5GAEgASgNUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use seatCardsDescriptor instead')
const SeatCards$json = const {
  '1': 'SeatCards',
  '2': const [
    const {'1': 'cards', '3': 2, '4': 3, '5': 13, '10': 'cards'},
    const {'1': 'cardsStr', '3': 3, '4': 1, '5': 9, '10': 'cardsStr'},
  ],
};

/// Descriptor for `SeatCards`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seatCardsDescriptor = $convert.base64Decode(
    'CglTZWF0Q2FyZHMSFAoFY2FyZHMYAiADKA1SBWNhcmRzEhoKCGNhcmRzU3RyGAMgASgJUghjYXJkc1N0cg==');
@$core.Deprecated('Use showdownDescriptor instead')
const Showdown$json = const {
  '1': 'Showdown',
  '2': const [
    const {
      '1': 'seat_cards',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.game.SeatCards',
      '10': 'seatCards'
    },
    const {'1': 'pots', '3': 2, '4': 3, '5': 2, '10': 'pots'},
    const {
      '1': 'seats_pots',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.game.SeatsInPots',
      '10': 'seatsPots'
    },
    const {
      '1': 'player_balance',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.game.Showdown.PlayerBalanceEntry',
      '10': 'playerBalance'
    },
  ],
  '3': const [Showdown_PlayerBalanceEntry$json],
};

@$core.Deprecated('Use showdownDescriptor instead')
const Showdown_PlayerBalanceEntry$json = const {
  '1': 'PlayerBalanceEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 2, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `Showdown`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List showdownDescriptor = $convert.base64Decode(
    'CghTaG93ZG93bhIuCgpzZWF0X2NhcmRzGAEgAygLMg8uZ2FtZS5TZWF0Q2FyZHNSCXNlYXRDYXJkcxISCgRwb3RzGAIgAygCUgRwb3RzEjAKCnNlYXRzX3BvdHMYAyADKAsyES5nYW1lLlNlYXRzSW5Qb3RzUglzZWF0c1BvdHMSSAoOcGxheWVyX2JhbGFuY2UYBCADKAsyIS5nYW1lLlNob3dkb3duLlBsYXllckJhbGFuY2VFbnRyeVINcGxheWVyQmFsYW5jZRpAChJQbGF5ZXJCYWxhbmNlRW50cnkSEAoDa2V5GAEgASgNUgNrZXkSFAoFdmFsdWUYAiABKAJSBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use runItTwiceBoardsDescriptor instead')
const RunItTwiceBoards$json = const {
  '1': 'RunItTwiceBoards',
  '2': const [
    const {'1': 'board_1', '3': 1, '4': 3, '5': 13, '10': 'board1'},
    const {'1': 'board_2', '3': 2, '4': 3, '5': 13, '10': 'board2'},
    const {
      '1': 'stage',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.game.HandStatus',
      '10': 'stage'
    },
    const {
      '1': 'seats_pots',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.game.SeatsInPots',
      '10': 'seatsPots'
    },
    const {'1': 'seat1', '3': 5, '4': 1, '5': 13, '10': 'seat1'},
    const {'1': 'seat2', '3': 6, '4': 1, '5': 13, '10': 'seat2'},
  ],
};

/// Descriptor for `RunItTwiceBoards`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runItTwiceBoardsDescriptor = $convert.base64Decode(
    'ChBSdW5JdFR3aWNlQm9hcmRzEhcKB2JvYXJkXzEYASADKA1SBmJvYXJkMRIXCgdib2FyZF8yGAIgAygNUgZib2FyZDISJgoFc3RhZ2UYAyABKA4yEC5nYW1lLkhhbmRTdGF0dXNSBXN0YWdlEjAKCnNlYXRzX3BvdHMYBCADKAsyES5nYW1lLlNlYXRzSW5Qb3RzUglzZWF0c1BvdHMSFAoFc2VhdDEYBSABKA1SBXNlYXQxEhQKBXNlYXQyGAYgASgNUgVzZWF0Mg==');
@$core.Deprecated('Use noMoreActionsDescriptor instead')
const NoMoreActions$json = const {
  '1': 'NoMoreActions',
  '2': const [
    const {
      '1': 'pots',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.game.SeatsInPots',
      '10': 'pots'
    },
  ],
};

/// Descriptor for `NoMoreActions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List noMoreActionsDescriptor = $convert.base64Decode(
    'Cg1Ob01vcmVBY3Rpb25zEiUKBHBvdHMYASADKAsyES5nYW1lLlNlYXRzSW5Qb3RzUgRwb3Rz');
@$core.Deprecated('Use runItTwiceResultDescriptor instead')
const RunItTwiceResult$json = const {
  '1': 'RunItTwiceResult',
  '2': const [
    const {
      '1': 'run_it_twice_started_at',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.game.HandStatus',
      '10': 'runItTwiceStartedAt'
    },
    const {
      '1': 'board_1_winners',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.game.RunItTwiceResult.Board1WinnersEntry',
      '10': 'board1Winners'
    },
    const {
      '1': 'board_2_winners',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.game.RunItTwiceResult.Board2WinnersEntry',
      '10': 'board2Winners'
    },
  ],
  '3': const [
    RunItTwiceResult_Board1WinnersEntry$json,
    RunItTwiceResult_Board2WinnersEntry$json
  ],
};

@$core.Deprecated('Use runItTwiceResultDescriptor instead')
const RunItTwiceResult_Board1WinnersEntry$json = const {
  '1': 'Board1WinnersEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.game.PotWinners',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use runItTwiceResultDescriptor instead')
const RunItTwiceResult_Board2WinnersEntry$json = const {
  '1': 'Board2WinnersEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.game.PotWinners',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

/// Descriptor for `RunItTwiceResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runItTwiceResultDescriptor = $convert.base64Decode(
    'ChBSdW5JdFR3aWNlUmVzdWx0EkYKF3J1bl9pdF90d2ljZV9zdGFydGVkX2F0GAEgASgOMhAuZ2FtZS5IYW5kU3RhdHVzUhNydW5JdFR3aWNlU3RhcnRlZEF0ElEKD2JvYXJkXzFfd2lubmVycxgCIAMoCzIpLmdhbWUuUnVuSXRUd2ljZVJlc3VsdC5Cb2FyZDFXaW5uZXJzRW50cnlSDWJvYXJkMVdpbm5lcnMSUQoPYm9hcmRfMl93aW5uZXJzGAMgAygLMikuZ2FtZS5SdW5JdFR3aWNlUmVzdWx0LkJvYXJkMldpbm5lcnNFbnRyeVINYm9hcmQyV2lubmVycxpSChJCb2FyZDFXaW5uZXJzRW50cnkSEAoDa2V5GAEgASgNUgNrZXkSJgoFdmFsdWUYAiABKAsyEC5nYW1lLlBvdFdpbm5lcnNSBXZhbHVlOgI4ARpSChJCb2FyZDJXaW5uZXJzRW50cnkSEAoDa2V5GAEgASgNUgNrZXkSJgoFdmFsdWUYAiABKAsyEC5nYW1lLlBvdFdpbm5lcnNSBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use handLogDescriptor instead')
const HandLog$json = const {
  '1': 'HandLog',
  '2': const [
    const {
      '1': 'preflop_actions',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.game.HandActionLog',
      '10': 'preflopActions'
    },
    const {
      '1': 'flop_actions',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.game.HandActionLog',
      '10': 'flopActions'
    },
    const {
      '1': 'turn_actions',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.game.HandActionLog',
      '10': 'turnActions'
    },
    const {
      '1': 'river_actions',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.game.HandActionLog',
      '10': 'riverActions'
    },
    const {
      '1': 'pot_winners',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.game.HandLog.PotWinnersEntry',
      '10': 'potWinners'
    },
    const {
      '1': 'won_at',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.game.HandStatus',
      '10': 'wonAt'
    },
    const {
      '1': 'show_down',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.game.Showdown',
      '10': 'showDown'
    },
    const {
      '1': 'hand_started_at',
      '3': 9,
      '4': 1,
      '5': 4,
      '10': 'handStartedAt'
    },
    const {'1': 'hand_ended_at', '3': 11, '4': 1, '5': 4, '10': 'handEndedAt'},
    const {'1': 'run_it_twice', '3': 12, '4': 1, '5': 8, '10': 'runItTwice'},
    const {
      '1': 'run_it_twice_result',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.game.RunItTwiceResult',
      '10': 'runItTwiceResult'
    },
    const {
      '1': 'seats_pots_showdown',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.game.SeatsInPots',
      '10': 'seatsPotsShowdown'
    },
    const {
      '1': 'boards',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.game.Board',
      '10': 'boards'
    },
    const {
      '1': 'pot_winners_2',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.game.HandLog.PotWinners2Entry',
      '10': 'potWinners2'
    },
  ],
  '3': const [HandLog_PotWinnersEntry$json, HandLog_PotWinners2Entry$json],
};

@$core.Deprecated('Use handLogDescriptor instead')
const HandLog_PotWinnersEntry$json = const {
  '1': 'PotWinnersEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.game.PotWinners',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use handLogDescriptor instead')
const HandLog_PotWinners2Entry$json = const {
  '1': 'PotWinners2Entry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.game.PotWinnersV2',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

/// Descriptor for `HandLog`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handLogDescriptor = $convert.base64Decode(
    'CgdIYW5kTG9nEjwKD3ByZWZsb3BfYWN0aW9ucxgBIAEoCzITLmdhbWUuSGFuZEFjdGlvbkxvZ1IOcHJlZmxvcEFjdGlvbnMSNgoMZmxvcF9hY3Rpb25zGAIgASgLMhMuZ2FtZS5IYW5kQWN0aW9uTG9nUgtmbG9wQWN0aW9ucxI2Cgx0dXJuX2FjdGlvbnMYAyABKAsyEy5nYW1lLkhhbmRBY3Rpb25Mb2dSC3R1cm5BY3Rpb25zEjgKDXJpdmVyX2FjdGlvbnMYBCABKAsyEy5nYW1lLkhhbmRBY3Rpb25Mb2dSDHJpdmVyQWN0aW9ucxI+Cgtwb3Rfd2lubmVycxgFIAMoCzIdLmdhbWUuSGFuZExvZy5Qb3RXaW5uZXJzRW50cnlSCnBvdFdpbm5lcnMSJwoGd29uX2F0GAYgASgOMhAuZ2FtZS5IYW5kU3RhdHVzUgV3b25BdBIrCglzaG93X2Rvd24YCCABKAsyDi5nYW1lLlNob3dkb3duUghzaG93RG93bhImCg9oYW5kX3N0YXJ0ZWRfYXQYCSABKARSDWhhbmRTdGFydGVkQXQSIgoNaGFuZF9lbmRlZF9hdBgLIAEoBFILaGFuZEVuZGVkQXQSIAoMcnVuX2l0X3R3aWNlGAwgASgIUgpydW5JdFR3aWNlEkUKE3J1bl9pdF90d2ljZV9yZXN1bHQYDSABKAsyFi5nYW1lLlJ1bkl0VHdpY2VSZXN1bHRSEHJ1bkl0VHdpY2VSZXN1bHQSQQoTc2VhdHNfcG90c19zaG93ZG93bhgOIAMoCzIRLmdhbWUuU2VhdHNJblBvdHNSEXNlYXRzUG90c1Nob3dkb3duEiMKBmJvYXJkcxgPIAMoCzILLmdhbWUuQm9hcmRSBmJvYXJkcxJCCg1wb3Rfd2lubmVyc18yGBAgAygLMh4uZ2FtZS5IYW5kTG9nLlBvdFdpbm5lcnMyRW50cnlSC3BvdFdpbm5lcnMyGk8KD1BvdFdpbm5lcnNFbnRyeRIQCgNrZXkYASABKA1SA2tleRImCgV2YWx1ZRgCIAEoCzIQLmdhbWUuUG90V2lubmVyc1IFdmFsdWU6AjgBGlIKEFBvdFdpbm5lcnMyRW50cnkSEAoDa2V5GAEgASgNUgNrZXkSKAoFdmFsdWUYAiABKAsyEi5nYW1lLlBvdFdpbm5lcnNWMlIFdmFsdWU6AjgB');
@$core.Deprecated('Use playerInfoDescriptor instead')
const PlayerInfo$json = const {
  '1': 'PlayerInfo',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    const {'1': 'cards', '3': 2, '4': 3, '5': 13, '10': 'cards'},
    const {'1': 'best_cards', '3': 3, '4': 3, '5': 13, '10': 'bestCards'},
    const {'1': 'rank', '3': 4, '4': 1, '5': 13, '10': 'rank'},
    const {
      '1': 'played_until',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.game.HandStatus',
      '10': 'playedUntil'
    },
    const {
      '1': 'balance',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.game.HandPlayerBalance',
      '10': 'balance'
    },
    const {'1': 'hh_cards', '3': 7, '4': 3, '5': 13, '10': 'hhCards'},
    const {'1': 'hh_rank', '3': 8, '4': 1, '5': 13, '10': 'hhRank'},
    const {'1': 'received', '3': 9, '4': 1, '5': 2, '10': 'received'},
    const {'1': 'rake_paid', '3': 10, '4': 1, '5': 2, '10': 'rakePaid'},
  ],
};

/// Descriptor for `PlayerInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerInfoDescriptor = $convert.base64Decode(
    'CgpQbGF5ZXJJbmZvEg4KAmlkGAEgASgEUgJpZBIUCgVjYXJkcxgCIAMoDVIFY2FyZHMSHQoKYmVzdF9jYXJkcxgDIAMoDVIJYmVzdENhcmRzEhIKBHJhbmsYBCABKA1SBHJhbmsSMwoMcGxheWVkX3VudGlsGAUgASgOMhAuZ2FtZS5IYW5kU3RhdHVzUgtwbGF5ZWRVbnRpbBIxCgdiYWxhbmNlGAYgASgLMhcuZ2FtZS5IYW5kUGxheWVyQmFsYW5jZVIHYmFsYW5jZRIZCghoaF9jYXJkcxgHIAMoDVIHaGhDYXJkcxIXCgdoaF9yYW5rGAggASgNUgZoaFJhbmsSGgoIcmVjZWl2ZWQYCSABKAJSCHJlY2VpdmVkEhsKCXJha2VfcGFpZBgKIAEoAlIIcmFrZVBhaWQ=');
@$core.Deprecated('Use handResultDescriptor instead')
const HandResult$json = const {
  '1': 'HandResult',
  '2': const [
    const {'1': 'game_id', '3': 1, '4': 1, '5': 4, '10': 'gameId'},
    const {'1': 'hand_num', '3': 2, '4': 1, '5': 13, '10': 'handNum'},
    const {
      '1': 'game_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.game.GameType',
      '10': 'gameType'
    },
    const {'1': 'no_cards', '3': 4, '4': 1, '5': 13, '10': 'noCards'},
    const {
      '1': 'hand_log',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.game.HandLog',
      '10': 'handLog'
    },
    const {
      '1': 'reward_tracking_ids',
      '3': 6,
      '4': 3,
      '5': 13,
      '10': 'rewardTrackingIds'
    },
    const {'1': 'board_cards', '3': 7, '4': 3, '5': 13, '10': 'boardCards'},
    const {'1': 'board_cards_2', '3': 8, '4': 3, '5': 13, '10': 'boardCards2'},
    const {'1': 'flop', '3': 9, '4': 3, '5': 13, '10': 'flop'},
    const {'1': 'turn', '3': 10, '4': 1, '5': 13, '10': 'turn'},
    const {'1': 'river', '3': 11, '4': 1, '5': 13, '10': 'river'},
    const {
      '1': 'players',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.game.HandResult.PlayersEntry',
      '10': 'players'
    },
    const {
      '1': 'rake_collected',
      '3': 13,
      '4': 1,
      '5': 2,
      '10': 'rakeCollected'
    },
    const {
      '1': 'high_hand',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.game.HighHand',
      '10': 'highHand'
    },
    const {
      '1': 'player_stats',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.game.HandResult.PlayerStatsEntry',
      '10': 'playerStats'
    },
    const {
      '1': 'hand_stats',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.game.HandStats',
      '10': 'handStats'
    },
    const {'1': 'run_it_twice', '3': 17, '4': 1, '5': 8, '10': 'runItTwice'},
    const {'1': 'small_blind', '3': 18, '4': 1, '5': 2, '10': 'smallBlind'},
    const {'1': 'big_blind', '3': 19, '4': 1, '5': 2, '10': 'bigBlind'},
    const {'1': 'ante', '3': 20, '4': 1, '5': 2, '10': 'ante'},
    const {'1': 'max_players', '3': 21, '4': 1, '5': 13, '10': 'maxPlayers'},
  ],
  '3': const [HandResult_PlayersEntry$json, HandResult_PlayerStatsEntry$json],
};

@$core.Deprecated('Use handResultDescriptor instead')
const HandResult_PlayersEntry$json = const {
  '1': 'PlayersEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.game.PlayerInfo',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use handResultDescriptor instead')
const HandResult_PlayerStatsEntry$json = const {
  '1': 'PlayerStatsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 4, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.game.PlayerStats',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

/// Descriptor for `HandResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handResultDescriptor = $convert.base64Decode(
    'CgpIYW5kUmVzdWx0EhcKB2dhbWVfaWQYASABKARSBmdhbWVJZBIZCghoYW5kX251bRgCIAEoDVIHaGFuZE51bRIrCglnYW1lX3R5cGUYAyABKA4yDi5nYW1lLkdhbWVUeXBlUghnYW1lVHlwZRIZCghub19jYXJkcxgEIAEoDVIHbm9DYXJkcxIoCghoYW5kX2xvZxgFIAEoCzINLmdhbWUuSGFuZExvZ1IHaGFuZExvZxIuChNyZXdhcmRfdHJhY2tpbmdfaWRzGAYgAygNUhFyZXdhcmRUcmFja2luZ0lkcxIfCgtib2FyZF9jYXJkcxgHIAMoDVIKYm9hcmRDYXJkcxIiCg1ib2FyZF9jYXJkc18yGAggAygNUgtib2FyZENhcmRzMhISCgRmbG9wGAkgAygNUgRmbG9wEhIKBHR1cm4YCiABKA1SBHR1cm4SFAoFcml2ZXIYCyABKA1SBXJpdmVyEjcKB3BsYXllcnMYDCADKAsyHS5nYW1lLkhhbmRSZXN1bHQuUGxheWVyc0VudHJ5UgdwbGF5ZXJzEiUKDnJha2VfY29sbGVjdGVkGA0gASgCUg1yYWtlQ29sbGVjdGVkEisKCWhpZ2hfaGFuZBgOIAEoCzIOLmdhbWUuSGlnaEhhbmRSCGhpZ2hIYW5kEkQKDHBsYXllcl9zdGF0cxgPIAMoCzIhLmdhbWUuSGFuZFJlc3VsdC5QbGF5ZXJTdGF0c0VudHJ5UgtwbGF5ZXJTdGF0cxIuCgpoYW5kX3N0YXRzGBAgASgLMg8uZ2FtZS5IYW5kU3RhdHNSCWhhbmRTdGF0cxIgCgxydW5faXRfdHdpY2UYESABKAhSCnJ1bkl0VHdpY2USHwoLc21hbGxfYmxpbmQYEiABKAJSCnNtYWxsQmxpbmQSGwoJYmlnX2JsaW5kGBMgASgCUghiaWdCbGluZBISCgRhbnRlGBQgASgCUgRhbnRlEh8KC21heF9wbGF5ZXJzGBUgASgNUgptYXhQbGF5ZXJzGkwKDFBsYXllcnNFbnRyeRIQCgNrZXkYASABKA1SA2tleRImCgV2YWx1ZRgCIAEoCzIQLmdhbWUuUGxheWVySW5mb1IFdmFsdWU6AjgBGlEKEFBsYXllclN0YXRzRW50cnkSEAoDa2V5GAEgASgEUgNrZXkSJwoFdmFsdWUYAiABKAsyES5nYW1lLlBsYXllclN0YXRzUgV2YWx1ZToCOAE=');
@$core.Deprecated('Use handResultClientDescriptor instead')
const HandResultClient$json = const {
  '1': 'HandResultClient',
  '2': const [
    const {'1': 'run_it_twice', '3': 1, '4': 1, '5': 8, '10': 'runItTwice'},
    const {'1': 'active_seats', '3': 2, '4': 3, '5': 13, '10': 'activeSeats'},
    const {
      '1': 'won_at',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.game.HandStatus',
      '10': 'wonAt'
    },
    const {
      '1': 'boards',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.game.Board',
      '10': 'boards'
    },
    const {
      '1': 'pot_winners',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.game.PotWinnersV2',
      '10': 'potWinners'
    },
    const {
      '1': 'pause_time_secs',
      '3': 6,
      '4': 1,
      '5': 13,
      '10': 'pauseTimeSecs'
    },
    const {
      '1': 'player_info',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.game.HandResultClient.PlayerInfoEntry',
      '10': 'playerInfo'
    },
    const {'1': 'scoop', '3': 8, '4': 1, '5': 8, '10': 'scoop'},
    const {
      '1': 'player_stats',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.game.HandResultClient.PlayerStatsEntry',
      '10': 'playerStats'
    },
    const {
      '1': 'timeout_stats',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.game.HandResultClient.TimeoutStatsEntry',
      '10': 'timeoutStats'
    },
    const {'1': 'hand_num', '3': 11, '4': 1, '5': 13, '10': 'handNum'},
    const {
      '1': 'tips_collected',
      '3': 12,
      '4': 1,
      '5': 2,
      '10': 'tipsCollected'
    },
  ],
  '3': const [
    HandResultClient_PlayerInfoEntry$json,
    HandResultClient_PlayerStatsEntry$json,
    HandResultClient_TimeoutStatsEntry$json
  ],
};

@$core.Deprecated('Use handResultClientDescriptor instead')
const HandResultClient_PlayerInfoEntry$json = const {
  '1': 'PlayerInfoEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.game.PlayerHandInfo',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use handResultClientDescriptor instead')
const HandResultClient_PlayerStatsEntry$json = const {
  '1': 'PlayerStatsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 4, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.game.PlayerStats',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use handResultClientDescriptor instead')
const HandResultClient_TimeoutStatsEntry$json = const {
  '1': 'TimeoutStatsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 4, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.game.TimeoutStats',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

/// Descriptor for `HandResultClient`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handResultClientDescriptor = $convert.base64Decode(
    'ChBIYW5kUmVzdWx0Q2xpZW50EiAKDHJ1bl9pdF90d2ljZRgBIAEoCFIKcnVuSXRUd2ljZRIhCgxhY3RpdmVfc2VhdHMYAiADKA1SC2FjdGl2ZVNlYXRzEicKBndvbl9hdBgDIAEoDjIQLmdhbWUuSGFuZFN0YXR1c1IFd29uQXQSIwoGYm9hcmRzGAQgAygLMgsuZ2FtZS5Cb2FyZFIGYm9hcmRzEjMKC3BvdF93aW5uZXJzGAUgAygLMhIuZ2FtZS5Qb3RXaW5uZXJzVjJSCnBvdFdpbm5lcnMSJgoPcGF1c2VfdGltZV9zZWNzGAYgASgNUg1wYXVzZVRpbWVTZWNzEkcKC3BsYXllcl9pbmZvGAcgAygLMiYuZ2FtZS5IYW5kUmVzdWx0Q2xpZW50LlBsYXllckluZm9FbnRyeVIKcGxheWVySW5mbxIUCgVzY29vcBgIIAEoCFIFc2Nvb3ASSgoMcGxheWVyX3N0YXRzGAkgAygLMicuZ2FtZS5IYW5kUmVzdWx0Q2xpZW50LlBsYXllclN0YXRzRW50cnlSC3BsYXllclN0YXRzEk0KDXRpbWVvdXRfc3RhdHMYCiADKAsyKC5nYW1lLkhhbmRSZXN1bHRDbGllbnQuVGltZW91dFN0YXRzRW50cnlSDHRpbWVvdXRTdGF0cxIZCghoYW5kX251bRgLIAEoDVIHaGFuZE51bRIlCg50aXBzX2NvbGxlY3RlZBgMIAEoAlINdGlwc0NvbGxlY3RlZBpTCg9QbGF5ZXJJbmZvRW50cnkSEAoDa2V5GAEgASgNUgNrZXkSKgoFdmFsdWUYAiABKAsyFC5nYW1lLlBsYXllckhhbmRJbmZvUgV2YWx1ZToCOAEaUQoQUGxheWVyU3RhdHNFbnRyeRIQCgNrZXkYASABKARSA2tleRInCgV2YWx1ZRgCIAEoCzIRLmdhbWUuUGxheWVyU3RhdHNSBXZhbHVlOgI4ARpTChFUaW1lb3V0U3RhdHNFbnRyeRIQCgNrZXkYASABKARSA2tleRIoCgV2YWx1ZRgCIAEoCzISLmdhbWUuVGltZW91dFN0YXRzUgV2YWx1ZToCOAE=');
@$core.Deprecated('Use handLogV2Descriptor instead')
const HandLogV2$json = const {
  '1': 'HandLogV2',
  '2': const [
    const {
      '1': 'preflop_actions',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.game.HandActionLog',
      '10': 'preflopActions'
    },
    const {
      '1': 'flop_actions',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.game.HandActionLog',
      '10': 'flopActions'
    },
    const {
      '1': 'turn_actions',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.game.HandActionLog',
      '10': 'turnActions'
    },
    const {
      '1': 'river_actions',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.game.HandActionLog',
      '10': 'riverActions'
    },
    const {
      '1': 'hand_started_at',
      '3': 9,
      '4': 1,
      '5': 4,
      '10': 'handStartedAt'
    },
    const {'1': 'hand_ended_at', '3': 11, '4': 1, '5': 4, '10': 'handEndedAt'},
  ],
};

/// Descriptor for `HandLogV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handLogV2Descriptor = $convert.base64Decode(
    'CglIYW5kTG9nVjISPAoPcHJlZmxvcF9hY3Rpb25zGAEgASgLMhMuZ2FtZS5IYW5kQWN0aW9uTG9nUg5wcmVmbG9wQWN0aW9ucxI2CgxmbG9wX2FjdGlvbnMYAiABKAsyEy5nYW1lLkhhbmRBY3Rpb25Mb2dSC2Zsb3BBY3Rpb25zEjYKDHR1cm5fYWN0aW9ucxgDIAEoCzITLmdhbWUuSGFuZEFjdGlvbkxvZ1ILdHVybkFjdGlvbnMSOAoNcml2ZXJfYWN0aW9ucxgEIAEoCzITLmdhbWUuSGFuZEFjdGlvbkxvZ1IMcml2ZXJBY3Rpb25zEiYKD2hhbmRfc3RhcnRlZF9hdBgJIAEoBFINaGFuZFN0YXJ0ZWRBdBIiCg1oYW5kX2VuZGVkX2F0GAsgASgEUgtoYW5kRW5kZWRBdA==');
@$core.Deprecated('Use handResultServerDescriptor instead')
const HandResultServer$json = const {
  '1': 'HandResultServer',
  '2': const [
    const {'1': 'game_id', '3': 1, '4': 1, '5': 4, '10': 'gameId'},
    const {'1': 'hand_num', '3': 2, '4': 1, '5': 13, '10': 'handNum'},
    const {
      '1': 'game_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.game.GameType',
      '10': 'gameType'
    },
    const {'1': 'no_cards', '3': 4, '4': 1, '5': 13, '10': 'noCards'},
    const {
      '1': 'hand_log',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.game.HandLog',
      '10': 'handLog'
    },
    const {
      '1': 'hand_stats',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.game.HandStats',
      '10': 'handStats'
    },
    const {'1': 'run_it_twice', '3': 8, '4': 1, '5': 8, '10': 'runItTwice'},
    const {'1': 'button_pos', '3': 9, '4': 1, '5': 13, '10': 'buttonPos'},
    const {'1': 'small_blind', '3': 10, '4': 1, '5': 2, '10': 'smallBlind'},
    const {'1': 'big_blind', '3': 11, '4': 1, '5': 2, '10': 'bigBlind'},
    const {'1': 'ante', '3': 12, '4': 1, '5': 2, '10': 'ante'},
    const {'1': 'max_players', '3': 13, '4': 1, '5': 13, '10': 'maxPlayers'},
    const {
      '1': 'result',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.game.HandResultClient',
      '10': 'result'
    },
    const {
      '1': 'log',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.game.HandLogV2',
      '10': 'log'
    },
  ],
};

/// Descriptor for `HandResultServer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handResultServerDescriptor = $convert.base64Decode(
    'ChBIYW5kUmVzdWx0U2VydmVyEhcKB2dhbWVfaWQYASABKARSBmdhbWVJZBIZCghoYW5kX251bRgCIAEoDVIHaGFuZE51bRIrCglnYW1lX3R5cGUYAyABKA4yDi5nYW1lLkdhbWVUeXBlUghnYW1lVHlwZRIZCghub19jYXJkcxgEIAEoDVIHbm9DYXJkcxIoCghoYW5kX2xvZxgFIAEoCzINLmdhbWUuSGFuZExvZ1IHaGFuZExvZxIuCgpoYW5kX3N0YXRzGAYgASgLMg8uZ2FtZS5IYW5kU3RhdHNSCWhhbmRTdGF0cxIgCgxydW5faXRfdHdpY2UYCCABKAhSCnJ1bkl0VHdpY2USHQoKYnV0dG9uX3BvcxgJIAEoDVIJYnV0dG9uUG9zEh8KC3NtYWxsX2JsaW5kGAogASgCUgpzbWFsbEJsaW5kEhsKCWJpZ19ibGluZBgLIAEoAlIIYmlnQmxpbmQSEgoEYW50ZRgMIAEoAlIEYW50ZRIfCgttYXhfcGxheWVycxgNIAEoDVIKbWF4UGxheWVycxIuCgZyZXN1bHQYDiABKAsyFi5nYW1lLkhhbmRSZXN1bHRDbGllbnRSBnJlc3VsdBIhCgNsb2cYDyABKAsyDy5nYW1lLkhhbmRMb2dWMlIDbG9n');
@$core.Deprecated('Use msgAcknowledgementDescriptor instead')
const MsgAcknowledgement$json = const {
  '1': 'MsgAcknowledgement',
  '2': const [
    const {'1': 'message_id', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
    const {'1': 'message_type', '3': 2, '4': 1, '5': 9, '10': 'messageType'},
  ],
};

/// Descriptor for `MsgAcknowledgement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgAcknowledgementDescriptor = $convert.base64Decode(
    'ChJNc2dBY2tub3dsZWRnZW1lbnQSHQoKbWVzc2FnZV9pZBgBIAEoCVIJbWVzc2FnZUlkEiEKDG1lc3NhZ2VfdHlwZRgCIAEoCVILbWVzc2FnZVR5cGU=');
@$core.Deprecated('Use announcementDescriptor instead')
const Announcement$json = const {
  '1': 'Announcement',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'params', '3': 2, '4': 3, '5': 9, '10': 'params'},
  ],
};

/// Descriptor for `Announcement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List announcementDescriptor = $convert.base64Decode(
    'CgxBbm5vdW5jZW1lbnQSEgoEdHlwZRgBIAEoCVIEdHlwZRIWCgZwYXJhbXMYAiADKAlSBnBhcmFtcw==');
@$core.Deprecated('Use handMessageDescriptor instead')
const HandMessage$json = const {
  '1': 'HandMessage',
  '2': const [
    const {'1': 'version', '3': 1, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'game_code', '3': 2, '4': 1, '5': 9, '10': 'gameCode'},
    const {'1': 'hand_num', '3': 3, '4': 1, '5': 13, '10': 'handNum'},
    const {'1': 'seat_no', '3': 4, '4': 1, '5': 13, '10': 'seatNo'},
    const {'1': 'player_id', '3': 5, '4': 1, '5': 4, '10': 'playerId'},
    const {'1': 'message_id', '3': 6, '4': 1, '5': 9, '10': 'messageId'},
    const {'1': 'game_token', '3': 7, '4': 1, '5': 9, '10': 'gameToken'},
    const {
      '1': 'hand_status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.game.HandStatus',
      '10': 'handStatus'
    },
    const {
      '1': 'messages',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.game.HandMessageItem',
      '10': 'messages'
    },
  ],
};

/// Descriptor for `HandMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handMessageDescriptor = $convert.base64Decode(
    'CgtIYW5kTWVzc2FnZRIYCgd2ZXJzaW9uGAEgASgJUgd2ZXJzaW9uEhsKCWdhbWVfY29kZRgCIAEoCVIIZ2FtZUNvZGUSGQoIaGFuZF9udW0YAyABKA1SB2hhbmROdW0SFwoHc2VhdF9ubxgEIAEoDVIGc2VhdE5vEhsKCXBsYXllcl9pZBgFIAEoBFIIcGxheWVySWQSHQoKbWVzc2FnZV9pZBgGIAEoCVIJbWVzc2FnZUlkEh0KCmdhbWVfdG9rZW4YByABKAlSCWdhbWVUb2tlbhIxCgtoYW5kX3N0YXR1cxgIIAEoDjIQLmdhbWUuSGFuZFN0YXR1c1IKaGFuZFN0YXR1cxIxCghtZXNzYWdlcxgJIAMoCzIVLmdhbWUuSGFuZE1lc3NhZ2VJdGVtUghtZXNzYWdlcw==');
@$core.Deprecated('Use dealerChoiceDescriptor instead')
const DealerChoice$json = const {
  '1': 'DealerChoice',
  '2': const [
    const {'1': 'player_id', '3': 1, '4': 1, '5': 4, '10': 'playerId'},
    const {
      '1': 'games',
      '3': 2,
      '4': 3,
      '5': 14,
      '6': '.game.GameType',
      '10': 'games'
    },
    const {'1': 'timeout', '3': 3, '4': 1, '5': 13, '10': 'timeout'},
  ],
};

/// Descriptor for `DealerChoice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dealerChoiceDescriptor = $convert.base64Decode(
    'CgxEZWFsZXJDaG9pY2USGwoJcGxheWVyX2lkGAEgASgEUghwbGF5ZXJJZBIkCgVnYW1lcxgCIAMoDjIOLmdhbWUuR2FtZVR5cGVSBWdhbWVzEhgKB3RpbWVvdXQYAyABKA1SB3RpbWVvdXQ=');
@$core.Deprecated('Use pingPongMessageDescriptor instead')
const PingPongMessage$json = const {
  '1': 'PingPongMessage',
  '2': const [
    const {'1': 'game_id', '3': 1, '4': 1, '5': 4, '10': 'gameId'},
    const {'1': 'game_code', '3': 2, '4': 1, '5': 9, '10': 'gameCode'},
    const {'1': 'player_id', '3': 3, '4': 1, '5': 4, '10': 'playerId'},
    const {'1': 'seq', '3': 4, '4': 1, '5': 13, '10': 'seq'},
  ],
};

/// Descriptor for `PingPongMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingPongMessageDescriptor = $convert.base64Decode(
    'Cg9QaW5nUG9uZ01lc3NhZ2USFwoHZ2FtZV9pZBgBIAEoBFIGZ2FtZUlkEhsKCWdhbWVfY29kZRgCIAEoCVIIZ2FtZUNvZGUSGwoJcGxheWVyX2lkGAMgASgEUghwbGF5ZXJJZBIQCgNzZXEYBCABKA1SA3NlcQ==');
@$core.Deprecated('Use handMessageItemDescriptor instead')
const HandMessageItem$json = const {
  '1': 'HandMessageItem',
  '2': const [
    const {'1': 'message_type', '3': 7, '4': 1, '5': 9, '10': 'messageType'},
    const {
      '1': 'seat_action',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.game.NextSeatAction',
      '9': 0,
      '10': 'seatAction'
    },
    const {
      '1': 'deal_cards',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.game.HandDealCards',
      '9': 0,
      '10': 'dealCards'
    },
    const {
      '1': 'new_hand',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.game.NewHand',
      '9': 0,
      '10': 'newHand'
    },
    const {
      '1': 'player_acted',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.game.HandAction',
      '9': 0,
      '10': 'playerActed'
    },
    const {
      '1': 'action_change',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.game.ActionChange',
      '9': 0,
      '10': 'actionChange'
    },
    const {
      '1': 'hand_result',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.game.HandResult',
      '9': 0,
      '10': 'handResult'
    },
    const {
      '1': 'flop',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.game.Flop',
      '9': 0,
      '10': 'flop'
    },
    const {
      '1': 'turn',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.game.Turn',
      '9': 0,
      '10': 'turn'
    },
    const {
      '1': 'river',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.game.River',
      '9': 0,
      '10': 'river'
    },
    const {
      '1': 'showdown',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.game.Showdown',
      '9': 0,
      '10': 'showdown'
    },
    const {
      '1': 'no_more_actions',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.game.NoMoreActions',
      '9': 0,
      '10': 'noMoreActions'
    },
    const {
      '1': 'current_hand_state',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.game.CurrentHandState',
      '9': 0,
      '10': 'currentHandState'
    },
    const {
      '1': 'msg_ack',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.game.MsgAcknowledgement',
      '9': 0,
      '10': 'msgAck'
    },
    const {
      '1': 'high_hand',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.game.HighHand',
      '9': 0,
      '10': 'highHand'
    },
    const {
      '1': 'run_it_twice',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.game.RunItTwiceBoards',
      '9': 0,
      '10': 'runItTwice'
    },
    const {
      '1': 'announcement',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.game.Announcement',
      '9': 0,
      '10': 'announcement'
    },
    const {
      '1': 'dealer_choice',
      '3': 28,
      '4': 1,
      '5': 11,
      '6': '.game.DealerChoice',
      '9': 0,
      '10': 'dealerChoice'
    },
    const {
      '1': 'hand_result_client',
      '3': 29,
      '4': 1,
      '5': 11,
      '6': '.game.HandResultClient',
      '9': 0,
      '10': 'handResultClient'
    },
    const {
      '1': 'extend_timer',
      '3': 30,
      '4': 1,
      '5': 11,
      '6': '.game.ExtendTimer',
      '9': 0,
      '10': 'extendTimer'
    },
  ],
  '8': const [
    const {'1': 'content'},
  ],
};

/// Descriptor for `HandMessageItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handMessageItemDescriptor = $convert.base64Decode(
    'Cg9IYW5kTWVzc2FnZUl0ZW0SIQoMbWVzc2FnZV90eXBlGAcgASgJUgttZXNzYWdlVHlwZRI3CgtzZWF0X2FjdGlvbhgMIAEoCzIULmdhbWUuTmV4dFNlYXRBY3Rpb25IAFIKc2VhdEFjdGlvbhI0CgpkZWFsX2NhcmRzGA0gASgLMhMuZ2FtZS5IYW5kRGVhbENhcmRzSABSCWRlYWxDYXJkcxIqCghuZXdfaGFuZBgOIAEoCzINLmdhbWUuTmV3SGFuZEgAUgduZXdIYW5kEjUKDHBsYXllcl9hY3RlZBgPIAEoCzIQLmdhbWUuSGFuZEFjdGlvbkgAUgtwbGF5ZXJBY3RlZBI5Cg1hY3Rpb25fY2hhbmdlGBAgASgLMhIuZ2FtZS5BY3Rpb25DaGFuZ2VIAFIMYWN0aW9uQ2hhbmdlEjMKC2hhbmRfcmVzdWx0GBEgASgLMhAuZ2FtZS5IYW5kUmVzdWx0SABSCmhhbmRSZXN1bHQSIAoEZmxvcBgSIAEoCzIKLmdhbWUuRmxvcEgAUgRmbG9wEiAKBHR1cm4YEyABKAsyCi5nYW1lLlR1cm5IAFIEdHVybhIjCgVyaXZlchgUIAEoCzILLmdhbWUuUml2ZXJIAFIFcml2ZXISLAoIc2hvd2Rvd24YFSABKAsyDi5nYW1lLlNob3dkb3duSABSCHNob3dkb3duEj0KD25vX21vcmVfYWN0aW9ucxgWIAEoCzITLmdhbWUuTm9Nb3JlQWN0aW9uc0gAUg1ub01vcmVBY3Rpb25zEkYKEmN1cnJlbnRfaGFuZF9zdGF0ZRgXIAEoCzIWLmdhbWUuQ3VycmVudEhhbmRTdGF0ZUgAUhBjdXJyZW50SGFuZFN0YXRlEjMKB21zZ19hY2sYGCABKAsyGC5nYW1lLk1zZ0Fja25vd2xlZGdlbWVudEgAUgZtc2dBY2sSLQoJaGlnaF9oYW5kGBkgASgLMg4uZ2FtZS5IaWdoSGFuZEgAUghoaWdoSGFuZBI6CgxydW5faXRfdHdpY2UYGiABKAsyFi5nYW1lLlJ1bkl0VHdpY2VCb2FyZHNIAFIKcnVuSXRUd2ljZRI4Cgxhbm5vdW5jZW1lbnQYGyABKAsyEi5nYW1lLkFubm91bmNlbWVudEgAUgxhbm5vdW5jZW1lbnQSOQoNZGVhbGVyX2Nob2ljZRgcIAEoCzISLmdhbWUuRGVhbGVyQ2hvaWNlSABSDGRlYWxlckNob2ljZRJGChJoYW5kX3Jlc3VsdF9jbGllbnQYHSABKAsyFi5nYW1lLkhhbmRSZXN1bHRDbGllbnRIAFIQaGFuZFJlc3VsdENsaWVudBI2CgxleHRlbmRfdGltZXIYHiABKAsyES5nYW1lLkV4dGVuZFRpbWVySABSC2V4dGVuZFRpbWVyQgkKB2NvbnRlbnQ=');
