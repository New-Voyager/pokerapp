///
//  Generated code. Do not modify.
//  source: handmessage.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'hand.pb.dart' as $0;

import 'enums.pbenum.dart' as $1;
import 'hand.pbenum.dart' as $0;

class PlayerStats extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerStats',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'preflopRaise')
    ..aOB(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'postflopRaise')
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cbet')
    ..aOB(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'vpip')
    ..aOB(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'threeBet')
    ..aOB(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'allin')
    ..aOB(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'wentToShowdown')
    ..aOB(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'wonChipsAtShowdown')
    ..aOB(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'headsup')
    ..a<$fixnum.Int64>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'headsupPlayer',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'wonHeadsup')
    ..aOB(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'badbeat')
    ..aOB(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'inPreflop')
    ..aOB(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'inFlop')
    ..aOB(
        15,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'inTurn')
    ..aOB(
        16,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'inRiver')
    ..hasRequiredFields = false;

  PlayerStats._() : super();
  factory PlayerStats({
    $core.bool? preflopRaise,
    $core.bool? postflopRaise,
    $core.bool? cbet,
    $core.bool? vpip,
    $core.bool? threeBet,
    $core.bool? allin,
    $core.bool? wentToShowdown,
    $core.bool? wonChipsAtShowdown,
    $core.bool? headsup,
    $fixnum.Int64? headsupPlayer,
    $core.bool? wonHeadsup,
    $core.bool? badbeat,
    $core.bool? inPreflop,
    $core.bool? inFlop,
    $core.bool? inTurn,
    $core.bool? inRiver,
  }) {
    final _result = create();
    if (preflopRaise != null) {
      _result.preflopRaise = preflopRaise;
    }
    if (postflopRaise != null) {
      _result.postflopRaise = postflopRaise;
    }
    if (cbet != null) {
      _result.cbet = cbet;
    }
    if (vpip != null) {
      _result.vpip = vpip;
    }
    if (threeBet != null) {
      _result.threeBet = threeBet;
    }
    if (allin != null) {
      _result.allin = allin;
    }
    if (wentToShowdown != null) {
      _result.wentToShowdown = wentToShowdown;
    }
    if (wonChipsAtShowdown != null) {
      _result.wonChipsAtShowdown = wonChipsAtShowdown;
    }
    if (headsup != null) {
      _result.headsup = headsup;
    }
    if (headsupPlayer != null) {
      _result.headsupPlayer = headsupPlayer;
    }
    if (wonHeadsup != null) {
      _result.wonHeadsup = wonHeadsup;
    }
    if (badbeat != null) {
      _result.badbeat = badbeat;
    }
    if (inPreflop != null) {
      _result.inPreflop = inPreflop;
    }
    if (inFlop != null) {
      _result.inFlop = inFlop;
    }
    if (inTurn != null) {
      _result.inTurn = inTurn;
    }
    if (inRiver != null) {
      _result.inRiver = inRiver;
    }
    return _result;
  }
  factory PlayerStats.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerStats.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerStats clone() => PlayerStats()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerStats copyWith(void Function(PlayerStats) updates) =>
      super.copyWith((message) => updates(message as PlayerStats))
          as PlayerStats; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerStats create() => PlayerStats._();
  PlayerStats createEmptyInstance() => create();
  static $pb.PbList<PlayerStats> createRepeated() => $pb.PbList<PlayerStats>();
  @$core.pragma('dart2js:noInline')
  static PlayerStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerStats>(create);
  static PlayerStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get preflopRaise => $_getBF(0);
  @$pb.TagNumber(1)
  set preflopRaise($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPreflopRaise() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreflopRaise() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get postflopRaise => $_getBF(1);
  @$pb.TagNumber(2)
  set postflopRaise($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPostflopRaise() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostflopRaise() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get cbet => $_getBF(2);
  @$pb.TagNumber(3)
  set cbet($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCbet() => $_has(2);
  @$pb.TagNumber(3)
  void clearCbet() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get vpip => $_getBF(3);
  @$pb.TagNumber(4)
  set vpip($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasVpip() => $_has(3);
  @$pb.TagNumber(4)
  void clearVpip() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get threeBet => $_getBF(4);
  @$pb.TagNumber(5)
  set threeBet($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasThreeBet() => $_has(4);
  @$pb.TagNumber(5)
  void clearThreeBet() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get allin => $_getBF(5);
  @$pb.TagNumber(6)
  set allin($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasAllin() => $_has(5);
  @$pb.TagNumber(6)
  void clearAllin() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get wentToShowdown => $_getBF(6);
  @$pb.TagNumber(7)
  set wentToShowdown($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasWentToShowdown() => $_has(6);
  @$pb.TagNumber(7)
  void clearWentToShowdown() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get wonChipsAtShowdown => $_getBF(7);
  @$pb.TagNumber(8)
  set wonChipsAtShowdown($core.bool v) {
    $_setBool(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasWonChipsAtShowdown() => $_has(7);
  @$pb.TagNumber(8)
  void clearWonChipsAtShowdown() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get headsup => $_getBF(8);
  @$pb.TagNumber(9)
  set headsup($core.bool v) {
    $_setBool(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasHeadsup() => $_has(8);
  @$pb.TagNumber(9)
  void clearHeadsup() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get headsupPlayer => $_getI64(9);
  @$pb.TagNumber(10)
  set headsupPlayer($fixnum.Int64 v) {
    $_setInt64(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasHeadsupPlayer() => $_has(9);
  @$pb.TagNumber(10)
  void clearHeadsupPlayer() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get wonHeadsup => $_getBF(10);
  @$pb.TagNumber(11)
  set wonHeadsup($core.bool v) {
    $_setBool(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasWonHeadsup() => $_has(10);
  @$pb.TagNumber(11)
  void clearWonHeadsup() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get badbeat => $_getBF(11);
  @$pb.TagNumber(12)
  set badbeat($core.bool v) {
    $_setBool(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasBadbeat() => $_has(11);
  @$pb.TagNumber(12)
  void clearBadbeat() => clearField(12);

  @$pb.TagNumber(13)
  $core.bool get inPreflop => $_getBF(12);
  @$pb.TagNumber(13)
  set inPreflop($core.bool v) {
    $_setBool(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasInPreflop() => $_has(12);
  @$pb.TagNumber(13)
  void clearInPreflop() => clearField(13);

  @$pb.TagNumber(14)
  $core.bool get inFlop => $_getBF(13);
  @$pb.TagNumber(14)
  set inFlop($core.bool v) {
    $_setBool(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasInFlop() => $_has(13);
  @$pb.TagNumber(14)
  void clearInFlop() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get inTurn => $_getBF(14);
  @$pb.TagNumber(15)
  set inTurn($core.bool v) {
    $_setBool(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasInTurn() => $_has(14);
  @$pb.TagNumber(15)
  void clearInTurn() => clearField(15);

  @$pb.TagNumber(16)
  $core.bool get inRiver => $_getBF(15);
  @$pb.TagNumber(16)
  set inRiver($core.bool v) {
    $_setBool(15, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasInRiver() => $_has(15);
  @$pb.TagNumber(16)
  void clearInRiver() => clearField(16);
}

class TimeoutStats extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'TimeoutStats',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'consecutiveActionTimeouts',
        $pb.PbFieldType.OU3)
    ..aOB(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'actedAtLeastOnce')
    ..hasRequiredFields = false;

  TimeoutStats._() : super();
  factory TimeoutStats({
    $core.int? consecutiveActionTimeouts,
    $core.bool? actedAtLeastOnce,
  }) {
    final _result = create();
    if (consecutiveActionTimeouts != null) {
      _result.consecutiveActionTimeouts = consecutiveActionTimeouts;
    }
    if (actedAtLeastOnce != null) {
      _result.actedAtLeastOnce = actedAtLeastOnce;
    }
    return _result;
  }
  factory TimeoutStats.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TimeoutStats.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TimeoutStats clone() => TimeoutStats()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TimeoutStats copyWith(void Function(TimeoutStats) updates) =>
      super.copyWith((message) => updates(message as TimeoutStats))
          as TimeoutStats; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TimeoutStats create() => TimeoutStats._();
  TimeoutStats createEmptyInstance() => create();
  static $pb.PbList<TimeoutStats> createRepeated() =>
      $pb.PbList<TimeoutStats>();
  @$core.pragma('dart2js:noInline')
  static TimeoutStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TimeoutStats>(create);
  static TimeoutStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get consecutiveActionTimeouts => $_getIZ(0);
  @$pb.TagNumber(1)
  set consecutiveActionTimeouts($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasConsecutiveActionTimeouts() => $_has(0);
  @$pb.TagNumber(1)
  void clearConsecutiveActionTimeouts() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get actedAtLeastOnce => $_getBF(1);
  @$pb.TagNumber(2)
  set actedAtLeastOnce($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasActedAtLeastOnce() => $_has(1);
  @$pb.TagNumber(2)
  void clearActedAtLeastOnce() => clearField(2);
}

class HandStats extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'HandStats',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'endedAtPreflop')
    ..aOB(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'endedAtFlop')
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'endedAtTurn')
    ..aOB(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'endedAtRiver')
    ..aOB(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'endedAtShowdown')
    ..hasRequiredFields = false;

  HandStats._() : super();
  factory HandStats({
    $core.bool? endedAtPreflop,
    $core.bool? endedAtFlop,
    $core.bool? endedAtTurn,
    $core.bool? endedAtRiver,
    $core.bool? endedAtShowdown,
  }) {
    final _result = create();
    if (endedAtPreflop != null) {
      _result.endedAtPreflop = endedAtPreflop;
    }
    if (endedAtFlop != null) {
      _result.endedAtFlop = endedAtFlop;
    }
    if (endedAtTurn != null) {
      _result.endedAtTurn = endedAtTurn;
    }
    if (endedAtRiver != null) {
      _result.endedAtRiver = endedAtRiver;
    }
    if (endedAtShowdown != null) {
      _result.endedAtShowdown = endedAtShowdown;
    }
    return _result;
  }
  factory HandStats.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HandStats.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  HandStats clone() => HandStats()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  HandStats copyWith(void Function(HandStats) updates) =>
      super.copyWith((message) => updates(message as HandStats))
          as HandStats; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandStats create() => HandStats._();
  HandStats createEmptyInstance() => create();
  static $pb.PbList<HandStats> createRepeated() => $pb.PbList<HandStats>();
  @$core.pragma('dart2js:noInline')
  static HandStats getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HandStats>(create);
  static HandStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get endedAtPreflop => $_getBF(0);
  @$pb.TagNumber(1)
  set endedAtPreflop($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasEndedAtPreflop() => $_has(0);
  @$pb.TagNumber(1)
  void clearEndedAtPreflop() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get endedAtFlop => $_getBF(1);
  @$pb.TagNumber(2)
  set endedAtFlop($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasEndedAtFlop() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndedAtFlop() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get endedAtTurn => $_getBF(2);
  @$pb.TagNumber(3)
  set endedAtTurn($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasEndedAtTurn() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndedAtTurn() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get endedAtRiver => $_getBF(3);
  @$pb.TagNumber(4)
  set endedAtRiver($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasEndedAtRiver() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndedAtRiver() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get endedAtShowdown => $_getBF(4);
  @$pb.TagNumber(5)
  set endedAtShowdown($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasEndedAtShowdown() => $_has(4);
  @$pb.TagNumber(5)
  void clearEndedAtShowdown() => clearField(5);
}

class NewHand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NewHand',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handNum',
        $pb.PbFieldType.OU3)
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'buttonPos',
        $pb.PbFieldType.OU3)
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sbPos',
        $pb.PbFieldType.OU3)
    ..a<$core.int>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bbPos',
        $pb.PbFieldType.OU3)
    ..a<$core.int>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nextActionSeat',
        $pb.PbFieldType.OU3)
    ..m<$core.int, $core.String>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerCards',
        entryClassName: 'NewHand.PlayerCardsEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('game'))
    ..e<$1.GameType>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'gameType',
        $pb.PbFieldType.OE,
        defaultOrMaker: $1.GameType.UNKNOWN,
        valueOf: $1.GameType.valueOf,
        enumValues: $1.GameType.values)
    ..a<$core.int>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'noCards',
        $pb.PbFieldType.OU3)
    ..a<$core.double>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'smallBlind',
        $pb.PbFieldType.OD)
    ..a<$core.double>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bigBlind',
        $pb.PbFieldType.OD)
    ..a<$core.double>(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bringIn',
        $pb.PbFieldType.OD)
    ..a<$core.double>(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'straddle',
        $pb.PbFieldType.OD)
    ..m<$core.int, $0.PlayerInSeatState>(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playersInSeats',
        entryClassName: 'NewHand.PlayersInSeatsEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $0.PlayerInSeatState.create,
        packageName: const $pb.PackageName('game'))
    ..m<$core.int, $0.PlayerActRound>(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playersActed',
        entryClassName: 'NewHand.PlayersActedEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $0.PlayerActRound.create,
        packageName: const $pb.PackageName('game'))
    ..aOB(
        15,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bombPot')
    ..aOB(
        16,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'doubleBoard')
    ..a<$core.double>(
        17,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bombPotBet',
        $pb.PbFieldType.OD)
    ..a<$core.double>(
        18,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'ante',
        $pb.PbFieldType.OD)
    ..p<$core.double>(
        19,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pots',
        $pb.PbFieldType.PD)
    ..a<$core.double>(
        20,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'potUpdates',
        $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  NewHand._() : super();
  factory NewHand({
    $core.int? handNum,
    $core.int? buttonPos,
    $core.int? sbPos,
    $core.int? bbPos,
    $core.int? nextActionSeat,
    $core.Map<$core.int, $core.String>? playerCards,
    $1.GameType? gameType,
    $core.int? noCards,
    $core.double? smallBlind,
    $core.double? bigBlind,
    $core.double? bringIn,
    $core.double? straddle,
    $core.Map<$core.int, $0.PlayerInSeatState>? playersInSeats,
    $core.Map<$core.int, $0.PlayerActRound>? playersActed,
    $core.bool? bombPot,
    $core.bool? doubleBoard,
    $core.double? bombPotBet,
    $core.double? ante,
    $core.Iterable<$core.double>? pots,
    $core.double? potUpdates,
  }) {
    final _result = create();
    if (handNum != null) {
      _result.handNum = handNum;
    }
    if (buttonPos != null) {
      _result.buttonPos = buttonPos;
    }
    if (sbPos != null) {
      _result.sbPos = sbPos;
    }
    if (bbPos != null) {
      _result.bbPos = bbPos;
    }
    if (nextActionSeat != null) {
      _result.nextActionSeat = nextActionSeat;
    }
    if (playerCards != null) {
      _result.playerCards.addAll(playerCards);
    }
    if (gameType != null) {
      _result.gameType = gameType;
    }
    if (noCards != null) {
      _result.noCards = noCards;
    }
    if (smallBlind != null) {
      _result.smallBlind = smallBlind;
    }
    if (bigBlind != null) {
      _result.bigBlind = bigBlind;
    }
    if (bringIn != null) {
      _result.bringIn = bringIn;
    }
    if (straddle != null) {
      _result.straddle = straddle;
    }
    if (playersInSeats != null) {
      _result.playersInSeats.addAll(playersInSeats);
    }
    if (playersActed != null) {
      _result.playersActed.addAll(playersActed);
    }
    if (bombPot != null) {
      _result.bombPot = bombPot;
    }
    if (doubleBoard != null) {
      _result.doubleBoard = doubleBoard;
    }
    if (bombPotBet != null) {
      _result.bombPotBet = bombPotBet;
    }
    if (ante != null) {
      _result.ante = ante;
    }
    if (pots != null) {
      _result.pots.addAll(pots);
    }
    if (potUpdates != null) {
      _result.potUpdates = potUpdates;
    }
    return _result;
  }
  factory NewHand.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NewHand.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NewHand clone() => NewHand()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NewHand copyWith(void Function(NewHand) updates) =>
      super.copyWith((message) => updates(message as NewHand))
          as NewHand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NewHand create() => NewHand._();
  NewHand createEmptyInstance() => create();
  static $pb.PbList<NewHand> createRepeated() => $pb.PbList<NewHand>();
  @$core.pragma('dart2js:noInline')
  static NewHand getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NewHand>(create);
  static NewHand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get handNum => $_getIZ(0);
  @$pb.TagNumber(1)
  set handNum($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasHandNum() => $_has(0);
  @$pb.TagNumber(1)
  void clearHandNum() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get buttonPos => $_getIZ(1);
  @$pb.TagNumber(2)
  set buttonPos($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasButtonPos() => $_has(1);
  @$pb.TagNumber(2)
  void clearButtonPos() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get sbPos => $_getIZ(2);
  @$pb.TagNumber(3)
  set sbPos($core.int v) {
    $_setUnsignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSbPos() => $_has(2);
  @$pb.TagNumber(3)
  void clearSbPos() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get bbPos => $_getIZ(3);
  @$pb.TagNumber(4)
  set bbPos($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasBbPos() => $_has(3);
  @$pb.TagNumber(4)
  void clearBbPos() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get nextActionSeat => $_getIZ(4);
  @$pb.TagNumber(5)
  set nextActionSeat($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasNextActionSeat() => $_has(4);
  @$pb.TagNumber(5)
  void clearNextActionSeat() => clearField(5);

  @$pb.TagNumber(6)
  $core.Map<$core.int, $core.String> get playerCards => $_getMap(5);

  @$pb.TagNumber(7)
  $1.GameType get gameType => $_getN(6);
  @$pb.TagNumber(7)
  set gameType($1.GameType v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasGameType() => $_has(6);
  @$pb.TagNumber(7)
  void clearGameType() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get noCards => $_getIZ(7);
  @$pb.TagNumber(8)
  set noCards($core.int v) {
    $_setUnsignedInt32(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasNoCards() => $_has(7);
  @$pb.TagNumber(8)
  void clearNoCards() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get smallBlind => $_getN(8);
  @$pb.TagNumber(9)
  set smallBlind($core.double v) {
    $_setDouble(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasSmallBlind() => $_has(8);
  @$pb.TagNumber(9)
  void clearSmallBlind() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get bigBlind => $_getN(9);
  @$pb.TagNumber(10)
  set bigBlind($core.double v) {
    $_setDouble(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasBigBlind() => $_has(9);
  @$pb.TagNumber(10)
  void clearBigBlind() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get bringIn => $_getN(10);
  @$pb.TagNumber(11)
  set bringIn($core.double v) {
    $_setDouble(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasBringIn() => $_has(10);
  @$pb.TagNumber(11)
  void clearBringIn() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get straddle => $_getN(11);
  @$pb.TagNumber(12)
  set straddle($core.double v) {
    $_setDouble(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasStraddle() => $_has(11);
  @$pb.TagNumber(12)
  void clearStraddle() => clearField(12);

  @$pb.TagNumber(13)
  $core.Map<$core.int, $0.PlayerInSeatState> get playersInSeats => $_getMap(12);

  @$pb.TagNumber(14)
  $core.Map<$core.int, $0.PlayerActRound> get playersActed => $_getMap(13);

  @$pb.TagNumber(15)
  $core.bool get bombPot => $_getBF(14);
  @$pb.TagNumber(15)
  set bombPot($core.bool v) {
    $_setBool(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasBombPot() => $_has(14);
  @$pb.TagNumber(15)
  void clearBombPot() => clearField(15);

  @$pb.TagNumber(16)
  $core.bool get doubleBoard => $_getBF(15);
  @$pb.TagNumber(16)
  set doubleBoard($core.bool v) {
    $_setBool(15, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasDoubleBoard() => $_has(15);
  @$pb.TagNumber(16)
  void clearDoubleBoard() => clearField(16);

  @$pb.TagNumber(17)
  $core.double get bombPotBet => $_getN(16);
  @$pb.TagNumber(17)
  set bombPotBet($core.double v) {
    $_setDouble(16, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasBombPotBet() => $_has(16);
  @$pb.TagNumber(17)
  void clearBombPotBet() => clearField(17);

  @$pb.TagNumber(18)
  $core.double get ante => $_getN(17);
  @$pb.TagNumber(18)
  set ante($core.double v) {
    $_setDouble(17, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasAnte() => $_has(17);
  @$pb.TagNumber(18)
  void clearAnte() => clearField(18);

  @$pb.TagNumber(19)
  $core.List<$core.double> get pots => $_getList(18);

  @$pb.TagNumber(20)
  $core.double get potUpdates => $_getN(19);
  @$pb.TagNumber(20)
  set potUpdates($core.double v) {
    $_setDouble(19, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasPotUpdates() => $_has(19);
  @$pb.TagNumber(20)
  void clearPotUpdates() => clearField(20);
}

class HandDealCards extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'HandDealCards',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seatNo',
        $pb.PbFieldType.OU3)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cards')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cardsStr',
        protoName: 'cardsStr')
    ..hasRequiredFields = false;

  HandDealCards._() : super();
  factory HandDealCards({
    $core.int? seatNo,
    $core.String? cards,
    $core.String? cardsStr,
  }) {
    final _result = create();
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (cards != null) {
      _result.cards = cards;
    }
    if (cardsStr != null) {
      _result.cardsStr = cardsStr;
    }
    return _result;
  }
  factory HandDealCards.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HandDealCards.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  HandDealCards clone() => HandDealCards()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  HandDealCards copyWith(void Function(HandDealCards) updates) =>
      super.copyWith((message) => updates(message as HandDealCards))
          as HandDealCards; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandDealCards create() => HandDealCards._();
  HandDealCards createEmptyInstance() => create();
  static $pb.PbList<HandDealCards> createRepeated() =>
      $pb.PbList<HandDealCards>();
  @$core.pragma('dart2js:noInline')
  static HandDealCards getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HandDealCards>(create);
  static HandDealCards? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seatNo => $_getIZ(0);
  @$pb.TagNumber(1)
  set seatNo($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSeatNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeatNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get cards => $_getSZ(1);
  @$pb.TagNumber(2)
  set cards($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCards() => $_has(1);
  @$pb.TagNumber(2)
  void clearCards() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get cardsStr => $_getSZ(2);
  @$pb.TagNumber(3)
  set cardsStr($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCardsStr() => $_has(2);
  @$pb.TagNumber(3)
  void clearCardsStr() => clearField(3);
}

class ActionChange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ActionChange',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seatNo',
        $pb.PbFieldType.OU3)
    ..p<$core.double>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pots',
        $pb.PbFieldType.PD)
    ..a<$core.double>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'potUpdates',
        $pb.PbFieldType.OD)
    ..pc<$0.SeatsInPots>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seatsPots',
        $pb.PbFieldType.PM,
        subBuilder: $0.SeatsInPots.create)
    ..a<$core.double>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'betAmount',
        $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  ActionChange._() : super();
  factory ActionChange({
    $core.int? seatNo,
    $core.Iterable<$core.double>? pots,
    $core.double? potUpdates,
    $core.Iterable<$0.SeatsInPots>? seatsPots,
    $core.double? betAmount,
  }) {
    final _result = create();
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (pots != null) {
      _result.pots.addAll(pots);
    }
    if (potUpdates != null) {
      _result.potUpdates = potUpdates;
    }
    if (seatsPots != null) {
      _result.seatsPots.addAll(seatsPots);
    }
    if (betAmount != null) {
      _result.betAmount = betAmount;
    }
    return _result;
  }
  factory ActionChange.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ActionChange.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ActionChange clone() => ActionChange()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ActionChange copyWith(void Function(ActionChange) updates) =>
      super.copyWith((message) => updates(message as ActionChange))
          as ActionChange; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ActionChange create() => ActionChange._();
  ActionChange createEmptyInstance() => create();
  static $pb.PbList<ActionChange> createRepeated() =>
      $pb.PbList<ActionChange>();
  @$core.pragma('dart2js:noInline')
  static ActionChange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActionChange>(create);
  static ActionChange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seatNo => $_getIZ(0);
  @$pb.TagNumber(1)
  set seatNo($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSeatNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeatNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.double> get pots => $_getList(1);

  @$pb.TagNumber(3)
  $core.double get potUpdates => $_getN(2);
  @$pb.TagNumber(3)
  set potUpdates($core.double v) {
    $_setDouble(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPotUpdates() => $_has(2);
  @$pb.TagNumber(3)
  void clearPotUpdates() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$0.SeatsInPots> get seatsPots => $_getList(3);

  @$pb.TagNumber(5)
  $core.double get betAmount => $_getN(4);
  @$pb.TagNumber(5)
  set betAmount($core.double v) {
    $_setDouble(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasBetAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearBetAmount() => clearField(5);
}

class Flop extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Flop',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..p<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'board',
        $pb.PbFieldType.PU3)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cardsStr',
        protoName: 'cardsStr')
    ..p<$core.double>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pots',
        $pb.PbFieldType.PD)
    ..pc<$0.SeatsInPots>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seatsPots',
        $pb.PbFieldType.PM,
        subBuilder: $0.SeatsInPots.create)
    ..m<$core.int, $core.double>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerBalance',
        entryClassName: 'Flop.PlayerBalanceEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('game'))
    ..m<$core.int, $core.String>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerCardRanks',
        entryClassName: 'Flop.PlayerCardRanksEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('game'))
    ..pc<$0.Board>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'boards',
        $pb.PbFieldType.PM,
        subBuilder: $0.Board.create)
    ..a<$core.double>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'potUpdates',
        $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  Flop._() : super();
  factory Flop({
    $core.Iterable<$core.int>? board,
    $core.String? cardsStr,
    $core.Iterable<$core.double>? pots,
    $core.Iterable<$0.SeatsInPots>? seatsPots,
    $core.Map<$core.int, $core.double>? playerBalance,
    $core.Map<$core.int, $core.String>? playerCardRanks,
    $core.Iterable<$0.Board>? boards,
    $core.double? potUpdates,
  }) {
    final _result = create();
    if (board != null) {
      _result.board.addAll(board);
    }
    if (cardsStr != null) {
      _result.cardsStr = cardsStr;
    }
    if (pots != null) {
      _result.pots.addAll(pots);
    }
    if (seatsPots != null) {
      _result.seatsPots.addAll(seatsPots);
    }
    if (playerBalance != null) {
      _result.playerBalance.addAll(playerBalance);
    }
    if (playerCardRanks != null) {
      _result.playerCardRanks.addAll(playerCardRanks);
    }
    if (boards != null) {
      _result.boards.addAll(boards);
    }
    if (potUpdates != null) {
      _result.potUpdates = potUpdates;
    }
    return _result;
  }
  factory Flop.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Flop.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Flop clone() => Flop()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Flop copyWith(void Function(Flop) updates) =>
      super.copyWith((message) => updates(message as Flop))
          as Flop; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Flop create() => Flop._();
  Flop createEmptyInstance() => create();
  static $pb.PbList<Flop> createRepeated() => $pb.PbList<Flop>();
  @$core.pragma('dart2js:noInline')
  static Flop getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Flop>(create);
  static Flop? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get board => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get cardsStr => $_getSZ(1);
  @$pb.TagNumber(2)
  set cardsStr($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCardsStr() => $_has(1);
  @$pb.TagNumber(2)
  void clearCardsStr() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.double> get pots => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$0.SeatsInPots> get seatsPots => $_getList(3);

  @$pb.TagNumber(5)
  $core.Map<$core.int, $core.double> get playerBalance => $_getMap(4);

  @$pb.TagNumber(6)
  $core.Map<$core.int, $core.String> get playerCardRanks => $_getMap(5);

  @$pb.TagNumber(7)
  $core.List<$0.Board> get boards => $_getList(6);

  @$pb.TagNumber(8)
  $core.double get potUpdates => $_getN(7);
  @$pb.TagNumber(8)
  set potUpdates($core.double v) {
    $_setDouble(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasPotUpdates() => $_has(7);
  @$pb.TagNumber(8)
  void clearPotUpdates() => clearField(8);
}

class Turn extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Turn',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..p<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'board',
        $pb.PbFieldType.PU3)
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'turnCard',
        $pb.PbFieldType.OU3)
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cardsStr',
        protoName: 'cardsStr')
    ..p<$core.double>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pots',
        $pb.PbFieldType.PD)
    ..pc<$0.SeatsInPots>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seatsPots',
        $pb.PbFieldType.PM,
        subBuilder: $0.SeatsInPots.create)
    ..m<$core.int, $core.double>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerBalance',
        entryClassName: 'Turn.PlayerBalanceEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('game'))
    ..m<$core.int, $core.String>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerCardRanks',
        entryClassName: 'Turn.PlayerCardRanksEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('game'))
    ..pc<$0.Board>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'boards',
        $pb.PbFieldType.PM,
        subBuilder: $0.Board.create)
    ..a<$core.double>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'potUpdates',
        $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  Turn._() : super();
  factory Turn({
    $core.Iterable<$core.int>? board,
    $core.int? turnCard,
    $core.String? cardsStr,
    $core.Iterable<$core.double>? pots,
    $core.Iterable<$0.SeatsInPots>? seatsPots,
    $core.Map<$core.int, $core.double>? playerBalance,
    $core.Map<$core.int, $core.String>? playerCardRanks,
    $core.Iterable<$0.Board>? boards,
    $core.double? potUpdates,
  }) {
    final _result = create();
    if (board != null) {
      _result.board.addAll(board);
    }
    if (turnCard != null) {
      _result.turnCard = turnCard;
    }
    if (cardsStr != null) {
      _result.cardsStr = cardsStr;
    }
    if (pots != null) {
      _result.pots.addAll(pots);
    }
    if (seatsPots != null) {
      _result.seatsPots.addAll(seatsPots);
    }
    if (playerBalance != null) {
      _result.playerBalance.addAll(playerBalance);
    }
    if (playerCardRanks != null) {
      _result.playerCardRanks.addAll(playerCardRanks);
    }
    if (boards != null) {
      _result.boards.addAll(boards);
    }
    if (potUpdates != null) {
      _result.potUpdates = potUpdates;
    }
    return _result;
  }
  factory Turn.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Turn.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Turn clone() => Turn()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Turn copyWith(void Function(Turn) updates) =>
      super.copyWith((message) => updates(message as Turn))
          as Turn; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Turn create() => Turn._();
  Turn createEmptyInstance() => create();
  static $pb.PbList<Turn> createRepeated() => $pb.PbList<Turn>();
  @$core.pragma('dart2js:noInline')
  static Turn getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Turn>(create);
  static Turn? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get board => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get turnCard => $_getIZ(1);
  @$pb.TagNumber(2)
  set turnCard($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTurnCard() => $_has(1);
  @$pb.TagNumber(2)
  void clearTurnCard() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get cardsStr => $_getSZ(2);
  @$pb.TagNumber(3)
  set cardsStr($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCardsStr() => $_has(2);
  @$pb.TagNumber(3)
  void clearCardsStr() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.double> get pots => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$0.SeatsInPots> get seatsPots => $_getList(4);

  @$pb.TagNumber(6)
  $core.Map<$core.int, $core.double> get playerBalance => $_getMap(5);

  @$pb.TagNumber(7)
  $core.Map<$core.int, $core.String> get playerCardRanks => $_getMap(6);

  @$pb.TagNumber(8)
  $core.List<$0.Board> get boards => $_getList(7);

  @$pb.TagNumber(9)
  $core.double get potUpdates => $_getN(8);
  @$pb.TagNumber(9)
  set potUpdates($core.double v) {
    $_setDouble(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPotUpdates() => $_has(8);
  @$pb.TagNumber(9)
  void clearPotUpdates() => clearField(9);
}

class River extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'River',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..p<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'board',
        $pb.PbFieldType.PU3)
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'riverCard',
        $pb.PbFieldType.OU3)
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cardsStr',
        protoName: 'cardsStr')
    ..p<$core.double>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pots',
        $pb.PbFieldType.PD)
    ..pc<$0.SeatsInPots>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seatsPots',
        $pb.PbFieldType.PM,
        subBuilder: $0.SeatsInPots.create)
    ..m<$core.int, $core.double>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerBalance',
        entryClassName: 'River.PlayerBalanceEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('game'))
    ..m<$core.int, $core.String>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerCardRanks',
        entryClassName: 'River.PlayerCardRanksEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('game'))
    ..pc<$0.Board>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'boards',
        $pb.PbFieldType.PM,
        subBuilder: $0.Board.create)
    ..a<$core.double>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'potUpdates',
        $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  River._() : super();
  factory River({
    $core.Iterable<$core.int>? board,
    $core.int? riverCard,
    $core.String? cardsStr,
    $core.Iterable<$core.double>? pots,
    $core.Iterable<$0.SeatsInPots>? seatsPots,
    $core.Map<$core.int, $core.double>? playerBalance,
    $core.Map<$core.int, $core.String>? playerCardRanks,
    $core.Iterable<$0.Board>? boards,
    $core.double? potUpdates,
  }) {
    final _result = create();
    if (board != null) {
      _result.board.addAll(board);
    }
    if (riverCard != null) {
      _result.riverCard = riverCard;
    }
    if (cardsStr != null) {
      _result.cardsStr = cardsStr;
    }
    if (pots != null) {
      _result.pots.addAll(pots);
    }
    if (seatsPots != null) {
      _result.seatsPots.addAll(seatsPots);
    }
    if (playerBalance != null) {
      _result.playerBalance.addAll(playerBalance);
    }
    if (playerCardRanks != null) {
      _result.playerCardRanks.addAll(playerCardRanks);
    }
    if (boards != null) {
      _result.boards.addAll(boards);
    }
    if (potUpdates != null) {
      _result.potUpdates = potUpdates;
    }
    return _result;
  }
  factory River.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory River.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  River clone() => River()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  River copyWith(void Function(River) updates) =>
      super.copyWith((message) => updates(message as River))
          as River; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static River create() => River._();
  River createEmptyInstance() => create();
  static $pb.PbList<River> createRepeated() => $pb.PbList<River>();
  @$core.pragma('dart2js:noInline')
  static River getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<River>(create);
  static River? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get board => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get riverCard => $_getIZ(1);
  @$pb.TagNumber(2)
  set riverCard($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRiverCard() => $_has(1);
  @$pb.TagNumber(2)
  void clearRiverCard() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get cardsStr => $_getSZ(2);
  @$pb.TagNumber(3)
  set cardsStr($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCardsStr() => $_has(2);
  @$pb.TagNumber(3)
  void clearCardsStr() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.double> get pots => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$0.SeatsInPots> get seatsPots => $_getList(4);

  @$pb.TagNumber(6)
  $core.Map<$core.int, $core.double> get playerBalance => $_getMap(5);

  @$pb.TagNumber(7)
  $core.Map<$core.int, $core.String> get playerCardRanks => $_getMap(6);

  @$pb.TagNumber(9)
  $core.List<$0.Board> get boards => $_getList(7);

  @$pb.TagNumber(10)
  $core.double get potUpdates => $_getN(8);
  @$pb.TagNumber(10)
  set potUpdates($core.double v) {
    $_setDouble(8, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasPotUpdates() => $_has(8);
  @$pb.TagNumber(10)
  void clearPotUpdates() => clearField(10);
}

class SeatCards extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SeatCards',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..p<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cards',
        $pb.PbFieldType.PU3)
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cardsStr',
        protoName: 'cardsStr')
    ..hasRequiredFields = false;

  SeatCards._() : super();
  factory SeatCards({
    $core.Iterable<$core.int>? cards,
    $core.String? cardsStr,
  }) {
    final _result = create();
    if (cards != null) {
      _result.cards.addAll(cards);
    }
    if (cardsStr != null) {
      _result.cardsStr = cardsStr;
    }
    return _result;
  }
  factory SeatCards.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SeatCards.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SeatCards clone() => SeatCards()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SeatCards copyWith(void Function(SeatCards) updates) =>
      super.copyWith((message) => updates(message as SeatCards))
          as SeatCards; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SeatCards create() => SeatCards._();
  SeatCards createEmptyInstance() => create();
  static $pb.PbList<SeatCards> createRepeated() => $pb.PbList<SeatCards>();
  @$core.pragma('dart2js:noInline')
  static SeatCards getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SeatCards>(create);
  static SeatCards? _defaultInstance;

  @$pb.TagNumber(2)
  $core.List<$core.int> get cards => $_getList(0);

  @$pb.TagNumber(3)
  $core.String get cardsStr => $_getSZ(1);
  @$pb.TagNumber(3)
  set cardsStr($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCardsStr() => $_has(1);
  @$pb.TagNumber(3)
  void clearCardsStr() => clearField(3);
}

class Showdown extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Showdown',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..pc<SeatCards>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seatCards',
        $pb.PbFieldType.PM,
        subBuilder: SeatCards.create)
    ..p<$core.double>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pots',
        $pb.PbFieldType.PD)
    ..pc<$0.SeatsInPots>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seatsPots',
        $pb.PbFieldType.PM,
        subBuilder: $0.SeatsInPots.create)
    ..m<$core.int, $core.double>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerBalance',
        entryClassName: 'Showdown.PlayerBalanceEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('game'))
    ..hasRequiredFields = false;

  Showdown._() : super();
  factory Showdown({
    $core.Iterable<SeatCards>? seatCards,
    $core.Iterable<$core.double>? pots,
    $core.Iterable<$0.SeatsInPots>? seatsPots,
    $core.Map<$core.int, $core.double>? playerBalance,
  }) {
    final _result = create();
    if (seatCards != null) {
      _result.seatCards.addAll(seatCards);
    }
    if (pots != null) {
      _result.pots.addAll(pots);
    }
    if (seatsPots != null) {
      _result.seatsPots.addAll(seatsPots);
    }
    if (playerBalance != null) {
      _result.playerBalance.addAll(playerBalance);
    }
    return _result;
  }
  factory Showdown.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Showdown.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Showdown clone() => Showdown()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Showdown copyWith(void Function(Showdown) updates) =>
      super.copyWith((message) => updates(message as Showdown))
          as Showdown; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Showdown create() => Showdown._();
  Showdown createEmptyInstance() => create();
  static $pb.PbList<Showdown> createRepeated() => $pb.PbList<Showdown>();
  @$core.pragma('dart2js:noInline')
  static Showdown getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Showdown>(create);
  static Showdown? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SeatCards> get seatCards => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.double> get pots => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$0.SeatsInPots> get seatsPots => $_getList(2);

  @$pb.TagNumber(4)
  $core.Map<$core.int, $core.double> get playerBalance => $_getMap(3);
}

class RunItTwiceBoards extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'RunItTwiceBoards',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..p<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'board1',
        $pb.PbFieldType.PU3,
        protoName: 'board_1')
    ..p<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'board2',
        $pb.PbFieldType.PU3,
        protoName: 'board_2')
    ..e<$0.HandStatus>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'stage',
        $pb.PbFieldType.OE,
        defaultOrMaker: $0.HandStatus.HandStatus_UNKNOWN,
        valueOf: $0.HandStatus.valueOf,
        enumValues: $0.HandStatus.values)
    ..pc<$0.SeatsInPots>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seatsPots',
        $pb.PbFieldType.PM,
        subBuilder: $0.SeatsInPots.create)
    ..a<$core.int>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seat1',
        $pb.PbFieldType.OU3)
    ..a<$core.int>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seat2',
        $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  RunItTwiceBoards._() : super();
  factory RunItTwiceBoards({
    $core.Iterable<$core.int>? board1,
    $core.Iterable<$core.int>? board2,
    $0.HandStatus? stage,
    $core.Iterable<$0.SeatsInPots>? seatsPots,
    $core.int? seat1,
    $core.int? seat2,
  }) {
    final _result = create();
    if (board1 != null) {
      _result.board1.addAll(board1);
    }
    if (board2 != null) {
      _result.board2.addAll(board2);
    }
    if (stage != null) {
      _result.stage = stage;
    }
    if (seatsPots != null) {
      _result.seatsPots.addAll(seatsPots);
    }
    if (seat1 != null) {
      _result.seat1 = seat1;
    }
    if (seat2 != null) {
      _result.seat2 = seat2;
    }
    return _result;
  }
  factory RunItTwiceBoards.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RunItTwiceBoards.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  RunItTwiceBoards clone() => RunItTwiceBoards()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  RunItTwiceBoards copyWith(void Function(RunItTwiceBoards) updates) =>
      super.copyWith((message) => updates(message as RunItTwiceBoards))
          as RunItTwiceBoards; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RunItTwiceBoards create() => RunItTwiceBoards._();
  RunItTwiceBoards createEmptyInstance() => create();
  static $pb.PbList<RunItTwiceBoards> createRepeated() =>
      $pb.PbList<RunItTwiceBoards>();
  @$core.pragma('dart2js:noInline')
  static RunItTwiceBoards getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RunItTwiceBoards>(create);
  static RunItTwiceBoards? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get board1 => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get board2 => $_getList(1);

  @$pb.TagNumber(3)
  $0.HandStatus get stage => $_getN(2);
  @$pb.TagNumber(3)
  set stage($0.HandStatus v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasStage() => $_has(2);
  @$pb.TagNumber(3)
  void clearStage() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$0.SeatsInPots> get seatsPots => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get seat1 => $_getIZ(4);
  @$pb.TagNumber(5)
  set seat1($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasSeat1() => $_has(4);
  @$pb.TagNumber(5)
  void clearSeat1() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get seat2 => $_getIZ(5);
  @$pb.TagNumber(6)
  set seat2($core.int v) {
    $_setUnsignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasSeat2() => $_has(5);
  @$pb.TagNumber(6)
  void clearSeat2() => clearField(6);
}

class NoMoreActions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NoMoreActions',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..pc<$0.SeatsInPots>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pots',
        $pb.PbFieldType.PM,
        subBuilder: $0.SeatsInPots.create)
    ..hasRequiredFields = false;

  NoMoreActions._() : super();
  factory NoMoreActions({
    $core.Iterable<$0.SeatsInPots>? pots,
  }) {
    final _result = create();
    if (pots != null) {
      _result.pots.addAll(pots);
    }
    return _result;
  }
  factory NoMoreActions.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NoMoreActions.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NoMoreActions clone() => NoMoreActions()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NoMoreActions copyWith(void Function(NoMoreActions) updates) =>
      super.copyWith((message) => updates(message as NoMoreActions))
          as NoMoreActions; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NoMoreActions create() => NoMoreActions._();
  NoMoreActions createEmptyInstance() => create();
  static $pb.PbList<NoMoreActions> createRepeated() =>
      $pb.PbList<NoMoreActions>();
  @$core.pragma('dart2js:noInline')
  static NoMoreActions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NoMoreActions>(create);
  static NoMoreActions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.SeatsInPots> get pots => $_getList(0);
}

class RunItTwiceResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'RunItTwiceResult',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..e<$0.HandStatus>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'runItTwiceStartedAt',
        $pb.PbFieldType.OE,
        defaultOrMaker: $0.HandStatus.HandStatus_UNKNOWN,
        valueOf: $0.HandStatus.valueOf,
        enumValues: $0.HandStatus.values)
    ..m<$core.int, $0.PotWinners>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'board1Winners',
        protoName: 'board_1_winners',
        entryClassName: 'RunItTwiceResult.Board1WinnersEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $0.PotWinners.create,
        packageName: const $pb.PackageName('game'))
    ..m<$core.int, $0.PotWinners>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'board2Winners',
        protoName: 'board_2_winners',
        entryClassName: 'RunItTwiceResult.Board2WinnersEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $0.PotWinners.create,
        packageName: const $pb.PackageName('game'))
    ..hasRequiredFields = false;

  RunItTwiceResult._() : super();
  factory RunItTwiceResult({
    $0.HandStatus? runItTwiceStartedAt,
    $core.Map<$core.int, $0.PotWinners>? board1Winners,
    $core.Map<$core.int, $0.PotWinners>? board2Winners,
  }) {
    final _result = create();
    if (runItTwiceStartedAt != null) {
      _result.runItTwiceStartedAt = runItTwiceStartedAt;
    }
    if (board1Winners != null) {
      _result.board1Winners.addAll(board1Winners);
    }
    if (board2Winners != null) {
      _result.board2Winners.addAll(board2Winners);
    }
    return _result;
  }
  factory RunItTwiceResult.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RunItTwiceResult.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  RunItTwiceResult clone() => RunItTwiceResult()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  RunItTwiceResult copyWith(void Function(RunItTwiceResult) updates) =>
      super.copyWith((message) => updates(message as RunItTwiceResult))
          as RunItTwiceResult; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RunItTwiceResult create() => RunItTwiceResult._();
  RunItTwiceResult createEmptyInstance() => create();
  static $pb.PbList<RunItTwiceResult> createRepeated() =>
      $pb.PbList<RunItTwiceResult>();
  @$core.pragma('dart2js:noInline')
  static RunItTwiceResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RunItTwiceResult>(create);
  static RunItTwiceResult? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HandStatus get runItTwiceStartedAt => $_getN(0);
  @$pb.TagNumber(1)
  set runItTwiceStartedAt($0.HandStatus v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRunItTwiceStartedAt() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunItTwiceStartedAt() => clearField(1);

  @$pb.TagNumber(2)
  $core.Map<$core.int, $0.PotWinners> get board1Winners => $_getMap(1);

  @$pb.TagNumber(3)
  $core.Map<$core.int, $0.PotWinners> get board2Winners => $_getMap(2);
}

class HandLog extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'HandLog',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..aOM<$0.HandActionLog>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'preflopActions',
        subBuilder: $0.HandActionLog.create)
    ..aOM<$0.HandActionLog>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'flopActions',
        subBuilder: $0.HandActionLog.create)
    ..aOM<$0.HandActionLog>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'turnActions',
        subBuilder: $0.HandActionLog.create)
    ..aOM<$0.HandActionLog>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'riverActions',
        subBuilder: $0.HandActionLog.create)
    ..m<$core.int, $0.PotWinners>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'potWinners',
        entryClassName: 'HandLog.PotWinnersEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $0.PotWinners.create,
        packageName: const $pb.PackageName('game'))
    ..e<$0.HandStatus>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'wonAt',
        $pb.PbFieldType.OE,
        defaultOrMaker: $0.HandStatus.HandStatus_UNKNOWN,
        valueOf: $0.HandStatus.valueOf,
        enumValues: $0.HandStatus.values)
    ..aOM<Showdown>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'showDown',
        subBuilder: Showdown.create)
    ..a<$fixnum.Int64>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handStartedAt',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handEndedAt',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'runItTwice')
    ..aOM<RunItTwiceResult>(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'runItTwiceResult',
        subBuilder: RunItTwiceResult.create)
    ..pc<$0.SeatsInPots>(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seatsPotsShowdown',
        $pb.PbFieldType.PM,
        subBuilder: $0.SeatsInPots.create)
    ..pc<$0.Board>(
        15,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'boards',
        $pb.PbFieldType.PM,
        subBuilder: $0.Board.create)
    ..m<$core.int, $0.PotWinnersV2>(
        16,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'potWinners2',
        protoName: 'pot_winners_2',
        entryClassName: 'HandLog.PotWinners2Entry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $0.PotWinnersV2.create,
        packageName: const $pb.PackageName('game'))
    ..p<$fixnum.Int64>(
        17,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'headsupPlayers',
        $pb.PbFieldType.PU6)
    ..hasRequiredFields = false;

  HandLog._() : super();
  factory HandLog({
    $0.HandActionLog? preflopActions,
    $0.HandActionLog? flopActions,
    $0.HandActionLog? turnActions,
    $0.HandActionLog? riverActions,
    $core.Map<$core.int, $0.PotWinners>? potWinners,
    $0.HandStatus? wonAt,
    Showdown? showDown,
    $fixnum.Int64? handStartedAt,
    $fixnum.Int64? handEndedAt,
    $core.bool? runItTwice,
    RunItTwiceResult? runItTwiceResult,
    $core.Iterable<$0.SeatsInPots>? seatsPotsShowdown,
    $core.Iterable<$0.Board>? boards,
    $core.Map<$core.int, $0.PotWinnersV2>? potWinners2,
    $core.Iterable<$fixnum.Int64>? headsupPlayers,
  }) {
    final _result = create();
    if (preflopActions != null) {
      _result.preflopActions = preflopActions;
    }
    if (flopActions != null) {
      _result.flopActions = flopActions;
    }
    if (turnActions != null) {
      _result.turnActions = turnActions;
    }
    if (riverActions != null) {
      _result.riverActions = riverActions;
    }
    if (potWinners != null) {
      _result.potWinners.addAll(potWinners);
    }
    if (wonAt != null) {
      _result.wonAt = wonAt;
    }
    if (showDown != null) {
      _result.showDown = showDown;
    }
    if (handStartedAt != null) {
      _result.handStartedAt = handStartedAt;
    }
    if (handEndedAt != null) {
      _result.handEndedAt = handEndedAt;
    }
    if (runItTwice != null) {
      _result.runItTwice = runItTwice;
    }
    if (runItTwiceResult != null) {
      _result.runItTwiceResult = runItTwiceResult;
    }
    if (seatsPotsShowdown != null) {
      _result.seatsPotsShowdown.addAll(seatsPotsShowdown);
    }
    if (boards != null) {
      _result.boards.addAll(boards);
    }
    if (potWinners2 != null) {
      _result.potWinners2.addAll(potWinners2);
    }
    if (headsupPlayers != null) {
      _result.headsupPlayers.addAll(headsupPlayers);
    }
    return _result;
  }
  factory HandLog.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HandLog.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  HandLog clone() => HandLog()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  HandLog copyWith(void Function(HandLog) updates) =>
      super.copyWith((message) => updates(message as HandLog))
          as HandLog; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandLog create() => HandLog._();
  HandLog createEmptyInstance() => create();
  static $pb.PbList<HandLog> createRepeated() => $pb.PbList<HandLog>();
  @$core.pragma('dart2js:noInline')
  static HandLog getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HandLog>(create);
  static HandLog? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HandActionLog get preflopActions => $_getN(0);
  @$pb.TagNumber(1)
  set preflopActions($0.HandActionLog v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPreflopActions() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreflopActions() => clearField(1);
  @$pb.TagNumber(1)
  $0.HandActionLog ensurePreflopActions() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.HandActionLog get flopActions => $_getN(1);
  @$pb.TagNumber(2)
  set flopActions($0.HandActionLog v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasFlopActions() => $_has(1);
  @$pb.TagNumber(2)
  void clearFlopActions() => clearField(2);
  @$pb.TagNumber(2)
  $0.HandActionLog ensureFlopActions() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.HandActionLog get turnActions => $_getN(2);
  @$pb.TagNumber(3)
  set turnActions($0.HandActionLog v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTurnActions() => $_has(2);
  @$pb.TagNumber(3)
  void clearTurnActions() => clearField(3);
  @$pb.TagNumber(3)
  $0.HandActionLog ensureTurnActions() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.HandActionLog get riverActions => $_getN(3);
  @$pb.TagNumber(4)
  set riverActions($0.HandActionLog v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasRiverActions() => $_has(3);
  @$pb.TagNumber(4)
  void clearRiverActions() => clearField(4);
  @$pb.TagNumber(4)
  $0.HandActionLog ensureRiverActions() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.Map<$core.int, $0.PotWinners> get potWinners => $_getMap(4);

  @$pb.TagNumber(6)
  $0.HandStatus get wonAt => $_getN(5);
  @$pb.TagNumber(6)
  set wonAt($0.HandStatus v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasWonAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearWonAt() => clearField(6);

  @$pb.TagNumber(8)
  Showdown get showDown => $_getN(6);
  @$pb.TagNumber(8)
  set showDown(Showdown v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasShowDown() => $_has(6);
  @$pb.TagNumber(8)
  void clearShowDown() => clearField(8);
  @$pb.TagNumber(8)
  Showdown ensureShowDown() => $_ensure(6);

  @$pb.TagNumber(9)
  $fixnum.Int64 get handStartedAt => $_getI64(7);
  @$pb.TagNumber(9)
  set handStartedAt($fixnum.Int64 v) {
    $_setInt64(7, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasHandStartedAt() => $_has(7);
  @$pb.TagNumber(9)
  void clearHandStartedAt() => clearField(9);

  @$pb.TagNumber(11)
  $fixnum.Int64 get handEndedAt => $_getI64(8);
  @$pb.TagNumber(11)
  set handEndedAt($fixnum.Int64 v) {
    $_setInt64(8, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasHandEndedAt() => $_has(8);
  @$pb.TagNumber(11)
  void clearHandEndedAt() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get runItTwice => $_getBF(9);
  @$pb.TagNumber(12)
  set runItTwice($core.bool v) {
    $_setBool(9, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasRunItTwice() => $_has(9);
  @$pb.TagNumber(12)
  void clearRunItTwice() => clearField(12);

  @$pb.TagNumber(13)
  RunItTwiceResult get runItTwiceResult => $_getN(10);
  @$pb.TagNumber(13)
  set runItTwiceResult(RunItTwiceResult v) {
    setField(13, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasRunItTwiceResult() => $_has(10);
  @$pb.TagNumber(13)
  void clearRunItTwiceResult() => clearField(13);
  @$pb.TagNumber(13)
  RunItTwiceResult ensureRunItTwiceResult() => $_ensure(10);

  @$pb.TagNumber(14)
  $core.List<$0.SeatsInPots> get seatsPotsShowdown => $_getList(11);

  @$pb.TagNumber(15)
  $core.List<$0.Board> get boards => $_getList(12);

  @$pb.TagNumber(16)
  $core.Map<$core.int, $0.PotWinnersV2> get potWinners2 => $_getMap(13);

  @$pb.TagNumber(17)
  $core.List<$fixnum.Int64> get headsupPlayers => $_getList(14);
}

class PlayerInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerInfo',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..p<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cards',
        $pb.PbFieldType.PU3)
    ..p<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bestCards',
        $pb.PbFieldType.PU3)
    ..a<$core.int>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'rank',
        $pb.PbFieldType.OU3)
    ..e<$0.HandStatus>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playedUntil',
        $pb.PbFieldType.OE,
        defaultOrMaker: $0.HandStatus.HandStatus_UNKNOWN,
        valueOf: $0.HandStatus.valueOf,
        enumValues: $0.HandStatus.values)
    ..aOM<$0.HandPlayerBalance>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'balance',
        subBuilder: $0.HandPlayerBalance.create)
    ..p<$core.int>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'hhCards',
        $pb.PbFieldType.PU3)
    ..a<$core.int>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'hhRank',
        $pb.PbFieldType.OU3)
    ..a<$core.double>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'received',
        $pb.PbFieldType.OD)
    ..a<$core.double>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'rakePaid',
        $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  PlayerInfo._() : super();
  factory PlayerInfo({
    $fixnum.Int64? id,
    $core.Iterable<$core.int>? cards,
    $core.Iterable<$core.int>? bestCards,
    $core.int? rank,
    $0.HandStatus? playedUntil,
    $0.HandPlayerBalance? balance,
    $core.Iterable<$core.int>? hhCards,
    $core.int? hhRank,
    $core.double? received,
    $core.double? rakePaid,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (cards != null) {
      _result.cards.addAll(cards);
    }
    if (bestCards != null) {
      _result.bestCards.addAll(bestCards);
    }
    if (rank != null) {
      _result.rank = rank;
    }
    if (playedUntil != null) {
      _result.playedUntil = playedUntil;
    }
    if (balance != null) {
      _result.balance = balance;
    }
    if (hhCards != null) {
      _result.hhCards.addAll(hhCards);
    }
    if (hhRank != null) {
      _result.hhRank = hhRank;
    }
    if (received != null) {
      _result.received = received;
    }
    if (rakePaid != null) {
      _result.rakePaid = rakePaid;
    }
    return _result;
  }
  factory PlayerInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerInfo clone() => PlayerInfo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerInfo copyWith(void Function(PlayerInfo) updates) =>
      super.copyWith((message) => updates(message as PlayerInfo))
          as PlayerInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerInfo create() => PlayerInfo._();
  PlayerInfo createEmptyInstance() => create();
  static $pb.PbList<PlayerInfo> createRepeated() => $pb.PbList<PlayerInfo>();
  @$core.pragma('dart2js:noInline')
  static PlayerInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerInfo>(create);
  static PlayerInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get cards => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get bestCards => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get rank => $_getIZ(3);
  @$pb.TagNumber(4)
  set rank($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasRank() => $_has(3);
  @$pb.TagNumber(4)
  void clearRank() => clearField(4);

  @$pb.TagNumber(5)
  $0.HandStatus get playedUntil => $_getN(4);
  @$pb.TagNumber(5)
  set playedUntil($0.HandStatus v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPlayedUntil() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlayedUntil() => clearField(5);

  @$pb.TagNumber(6)
  $0.HandPlayerBalance get balance => $_getN(5);
  @$pb.TagNumber(6)
  set balance($0.HandPlayerBalance v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasBalance() => $_has(5);
  @$pb.TagNumber(6)
  void clearBalance() => clearField(6);
  @$pb.TagNumber(6)
  $0.HandPlayerBalance ensureBalance() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.List<$core.int> get hhCards => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get hhRank => $_getIZ(7);
  @$pb.TagNumber(8)
  set hhRank($core.int v) {
    $_setUnsignedInt32(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasHhRank() => $_has(7);
  @$pb.TagNumber(8)
  void clearHhRank() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get received => $_getN(8);
  @$pb.TagNumber(9)
  set received($core.double v) {
    $_setDouble(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasReceived() => $_has(8);
  @$pb.TagNumber(9)
  void clearReceived() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get rakePaid => $_getN(9);
  @$pb.TagNumber(10)
  set rakePaid($core.double v) {
    $_setDouble(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasRakePaid() => $_has(9);
  @$pb.TagNumber(10)
  void clearRakePaid() => clearField(10);
}

class HandResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'HandResult',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'gameId',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handNum',
        $pb.PbFieldType.OU3)
    ..e<$1.GameType>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'gameType',
        $pb.PbFieldType.OE,
        defaultOrMaker: $1.GameType.UNKNOWN,
        valueOf: $1.GameType.valueOf,
        enumValues: $1.GameType.values)
    ..a<$core.int>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'noCards',
        $pb.PbFieldType.OU3)
    ..aOM<HandLog>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handLog',
        subBuilder: HandLog.create)
    ..p<$core.int>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'rewardTrackingIds',
        $pb.PbFieldType.PU3)
    ..p<$core.int>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'boardCards',
        $pb.PbFieldType.PU3)
    ..p<$core.int>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'boardCards2',
        $pb.PbFieldType.PU3,
        protoName: 'board_cards_2')
    ..p<$core.int>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'flop',
        $pb.PbFieldType.PU3)
    ..a<$core.int>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'turn',
        $pb.PbFieldType.OU3)
    ..a<$core.int>(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'river',
        $pb.PbFieldType.OU3)
    ..m<$core.int, PlayerInfo>(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'players',
        entryClassName: 'HandResult.PlayersEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: PlayerInfo.create,
        packageName: const $pb.PackageName('game'))
    ..a<$core.double>(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'rakeCollected',
        $pb.PbFieldType.OD)
    ..aOM<$0.HighHand>(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'highHand',
        subBuilder: $0.HighHand.create)
    ..m<$fixnum.Int64, PlayerStats>(
        15,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerStats',
        entryClassName: 'HandResult.PlayerStatsEntry',
        keyFieldType: $pb.PbFieldType.OU6,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: PlayerStats.create,
        packageName: const $pb.PackageName('game'))
    ..aOM<HandStats>(
        16,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handStats',
        subBuilder: HandStats.create)
    ..aOB(
        17,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'runItTwice')
    ..a<$core.double>(
        18,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'smallBlind',
        $pb.PbFieldType.OD)
    ..a<$core.double>(
        19,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bigBlind',
        $pb.PbFieldType.OD)
    ..a<$core.double>(
        20,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'ante',
        $pb.PbFieldType.OD)
    ..a<$core.int>(
        21,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'maxPlayers',
        $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  HandResult._() : super();
  factory HandResult({
    $fixnum.Int64? gameId,
    $core.int? handNum,
    $1.GameType? gameType,
    $core.int? noCards,
    HandLog? handLog,
    $core.Iterable<$core.int>? rewardTrackingIds,
    $core.Iterable<$core.int>? boardCards,
    $core.Iterable<$core.int>? boardCards2,
    $core.Iterable<$core.int>? flop,
    $core.int? turn,
    $core.int? river,
    $core.Map<$core.int, PlayerInfo>? players,
    $core.double? rakeCollected,
    $0.HighHand? highHand,
    $core.Map<$fixnum.Int64, PlayerStats>? playerStats,
    HandStats? handStats,
    $core.bool? runItTwice,
    $core.double? smallBlind,
    $core.double? bigBlind,
    $core.double? ante,
    $core.int? maxPlayers,
  }) {
    final _result = create();
    if (gameId != null) {
      _result.gameId = gameId;
    }
    if (handNum != null) {
      _result.handNum = handNum;
    }
    if (gameType != null) {
      _result.gameType = gameType;
    }
    if (noCards != null) {
      _result.noCards = noCards;
    }
    if (handLog != null) {
      _result.handLog = handLog;
    }
    if (rewardTrackingIds != null) {
      _result.rewardTrackingIds.addAll(rewardTrackingIds);
    }
    if (boardCards != null) {
      _result.boardCards.addAll(boardCards);
    }
    if (boardCards2 != null) {
      _result.boardCards2.addAll(boardCards2);
    }
    if (flop != null) {
      _result.flop.addAll(flop);
    }
    if (turn != null) {
      _result.turn = turn;
    }
    if (river != null) {
      _result.river = river;
    }
    if (players != null) {
      _result.players.addAll(players);
    }
    if (rakeCollected != null) {
      _result.rakeCollected = rakeCollected;
    }
    if (highHand != null) {
      _result.highHand = highHand;
    }
    if (playerStats != null) {
      _result.playerStats.addAll(playerStats);
    }
    if (handStats != null) {
      _result.handStats = handStats;
    }
    if (runItTwice != null) {
      _result.runItTwice = runItTwice;
    }
    if (smallBlind != null) {
      _result.smallBlind = smallBlind;
    }
    if (bigBlind != null) {
      _result.bigBlind = bigBlind;
    }
    if (ante != null) {
      _result.ante = ante;
    }
    if (maxPlayers != null) {
      _result.maxPlayers = maxPlayers;
    }
    return _result;
  }
  factory HandResult.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HandResult.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  HandResult clone() => HandResult()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  HandResult copyWith(void Function(HandResult) updates) =>
      super.copyWith((message) => updates(message as HandResult))
          as HandResult; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandResult create() => HandResult._();
  HandResult createEmptyInstance() => create();
  static $pb.PbList<HandResult> createRepeated() => $pb.PbList<HandResult>();
  @$core.pragma('dart2js:noInline')
  static HandResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HandResult>(create);
  static HandResult? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get gameId => $_getI64(0);
  @$pb.TagNumber(1)
  set gameId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get handNum => $_getIZ(1);
  @$pb.TagNumber(2)
  set handNum($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasHandNum() => $_has(1);
  @$pb.TagNumber(2)
  void clearHandNum() => clearField(2);

  @$pb.TagNumber(3)
  $1.GameType get gameType => $_getN(2);
  @$pb.TagNumber(3)
  set gameType($1.GameType v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasGameType() => $_has(2);
  @$pb.TagNumber(3)
  void clearGameType() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get noCards => $_getIZ(3);
  @$pb.TagNumber(4)
  set noCards($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasNoCards() => $_has(3);
  @$pb.TagNumber(4)
  void clearNoCards() => clearField(4);

  @$pb.TagNumber(5)
  HandLog get handLog => $_getN(4);
  @$pb.TagNumber(5)
  set handLog(HandLog v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasHandLog() => $_has(4);
  @$pb.TagNumber(5)
  void clearHandLog() => clearField(5);
  @$pb.TagNumber(5)
  HandLog ensureHandLog() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.List<$core.int> get rewardTrackingIds => $_getList(5);

  @$pb.TagNumber(7)
  $core.List<$core.int> get boardCards => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<$core.int> get boardCards2 => $_getList(7);

  @$pb.TagNumber(9)
  $core.List<$core.int> get flop => $_getList(8);

  @$pb.TagNumber(10)
  $core.int get turn => $_getIZ(9);
  @$pb.TagNumber(10)
  set turn($core.int v) {
    $_setUnsignedInt32(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasTurn() => $_has(9);
  @$pb.TagNumber(10)
  void clearTurn() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get river => $_getIZ(10);
  @$pb.TagNumber(11)
  set river($core.int v) {
    $_setUnsignedInt32(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasRiver() => $_has(10);
  @$pb.TagNumber(11)
  void clearRiver() => clearField(11);

  @$pb.TagNumber(12)
  $core.Map<$core.int, PlayerInfo> get players => $_getMap(11);

  @$pb.TagNumber(13)
  $core.double get rakeCollected => $_getN(12);
  @$pb.TagNumber(13)
  set rakeCollected($core.double v) {
    $_setDouble(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasRakeCollected() => $_has(12);
  @$pb.TagNumber(13)
  void clearRakeCollected() => clearField(13);

  @$pb.TagNumber(14)
  $0.HighHand get highHand => $_getN(13);
  @$pb.TagNumber(14)
  set highHand($0.HighHand v) {
    setField(14, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasHighHand() => $_has(13);
  @$pb.TagNumber(14)
  void clearHighHand() => clearField(14);
  @$pb.TagNumber(14)
  $0.HighHand ensureHighHand() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.Map<$fixnum.Int64, PlayerStats> get playerStats => $_getMap(14);

  @$pb.TagNumber(16)
  HandStats get handStats => $_getN(15);
  @$pb.TagNumber(16)
  set handStats(HandStats v) {
    setField(16, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasHandStats() => $_has(15);
  @$pb.TagNumber(16)
  void clearHandStats() => clearField(16);
  @$pb.TagNumber(16)
  HandStats ensureHandStats() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.bool get runItTwice => $_getBF(16);
  @$pb.TagNumber(17)
  set runItTwice($core.bool v) {
    $_setBool(16, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasRunItTwice() => $_has(16);
  @$pb.TagNumber(17)
  void clearRunItTwice() => clearField(17);

  @$pb.TagNumber(18)
  $core.double get smallBlind => $_getN(17);
  @$pb.TagNumber(18)
  set smallBlind($core.double v) {
    $_setDouble(17, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasSmallBlind() => $_has(17);
  @$pb.TagNumber(18)
  void clearSmallBlind() => clearField(18);

  @$pb.TagNumber(19)
  $core.double get bigBlind => $_getN(18);
  @$pb.TagNumber(19)
  set bigBlind($core.double v) {
    $_setDouble(18, v);
  }

  @$pb.TagNumber(19)
  $core.bool hasBigBlind() => $_has(18);
  @$pb.TagNumber(19)
  void clearBigBlind() => clearField(19);

  @$pb.TagNumber(20)
  $core.double get ante => $_getN(19);
  @$pb.TagNumber(20)
  set ante($core.double v) {
    $_setDouble(19, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasAnte() => $_has(19);
  @$pb.TagNumber(20)
  void clearAnte() => clearField(20);

  @$pb.TagNumber(21)
  $core.int get maxPlayers => $_getIZ(20);
  @$pb.TagNumber(21)
  set maxPlayers($core.int v) {
    $_setUnsignedInt32(20, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasMaxPlayers() => $_has(20);
  @$pb.TagNumber(21)
  void clearMaxPlayers() => clearField(21);
}

class HandResultClient extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'HandResultClient',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'runItTwice')
    ..p<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'activeSeats',
        $pb.PbFieldType.PU3)
    ..e<$0.HandStatus>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'wonAt',
        $pb.PbFieldType.OE,
        defaultOrMaker: $0.HandStatus.HandStatus_UNKNOWN,
        valueOf: $0.HandStatus.valueOf,
        enumValues: $0.HandStatus.values)
    ..pc<$0.Board>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'boards',
        $pb.PbFieldType.PM,
        subBuilder: $0.Board.create)
    ..pc<$0.PotWinnersV2>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'potWinners',
        $pb.PbFieldType.PM,
        subBuilder: $0.PotWinnersV2.create)
    ..a<$core.int>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pauseTimeSecs',
        $pb.PbFieldType.OU3)
    ..m<$core.int, $0.PlayerHandInfo>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerInfo',
        entryClassName: 'HandResultClient.PlayerInfoEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $0.PlayerHandInfo.create,
        packageName: const $pb.PackageName('game'))
    ..aOB(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'scoop')
    ..m<$fixnum.Int64, PlayerStats>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerStats',
        entryClassName: 'HandResultClient.PlayerStatsEntry',
        keyFieldType: $pb.PbFieldType.OU6,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: PlayerStats.create,
        packageName: const $pb.PackageName('game'))
    ..m<$fixnum.Int64, TimeoutStats>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'timeoutStats',
        entryClassName: 'HandResultClient.TimeoutStatsEntry',
        keyFieldType: $pb.PbFieldType.OU6,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: TimeoutStats.create,
        packageName: const $pb.PackageName('game'))
    ..a<$core.int>(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handNum',
        $pb.PbFieldType.OU3)
    ..a<$core.double>(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'tipsCollected',
        $pb.PbFieldType.OD)
    ..pc<$0.HighHandWinner>(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'highHandWinners',
        $pb.PbFieldType.PM,
        subBuilder: $0.HighHandWinner.create)
    ..hasRequiredFields = false;

  HandResultClient._() : super();
  factory HandResultClient({
    $core.bool? runItTwice,
    $core.Iterable<$core.int>? activeSeats,
    $0.HandStatus? wonAt,
    $core.Iterable<$0.Board>? boards,
    $core.Iterable<$0.PotWinnersV2>? potWinners,
    $core.int? pauseTimeSecs,
    $core.Map<$core.int, $0.PlayerHandInfo>? playerInfo,
    $core.bool? scoop,
    $core.Map<$fixnum.Int64, PlayerStats>? playerStats,
    $core.Map<$fixnum.Int64, TimeoutStats>? timeoutStats,
    $core.int? handNum,
    $core.double? tipsCollected,
    $core.Iterable<$0.HighHandWinner>? highHandWinners,
  }) {
    final _result = create();
    if (runItTwice != null) {
      _result.runItTwice = runItTwice;
    }
    if (activeSeats != null) {
      _result.activeSeats.addAll(activeSeats);
    }
    if (wonAt != null) {
      _result.wonAt = wonAt;
    }
    if (boards != null) {
      _result.boards.addAll(boards);
    }
    if (potWinners != null) {
      _result.potWinners.addAll(potWinners);
    }
    if (pauseTimeSecs != null) {
      _result.pauseTimeSecs = pauseTimeSecs;
    }
    if (playerInfo != null) {
      _result.playerInfo.addAll(playerInfo);
    }
    if (scoop != null) {
      _result.scoop = scoop;
    }
    if (playerStats != null) {
      _result.playerStats.addAll(playerStats);
    }
    if (timeoutStats != null) {
      _result.timeoutStats.addAll(timeoutStats);
    }
    if (handNum != null) {
      _result.handNum = handNum;
    }
    if (tipsCollected != null) {
      _result.tipsCollected = tipsCollected;
    }
    if (highHandWinners != null) {
      _result.highHandWinners.addAll(highHandWinners);
    }
    return _result;
  }
  factory HandResultClient.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HandResultClient.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  HandResultClient clone() => HandResultClient()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  HandResultClient copyWith(void Function(HandResultClient) updates) =>
      super.copyWith((message) => updates(message as HandResultClient))
          as HandResultClient; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandResultClient create() => HandResultClient._();
  HandResultClient createEmptyInstance() => create();
  static $pb.PbList<HandResultClient> createRepeated() =>
      $pb.PbList<HandResultClient>();
  @$core.pragma('dart2js:noInline')
  static HandResultClient getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HandResultClient>(create);
  static HandResultClient? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get runItTwice => $_getBF(0);
  @$pb.TagNumber(1)
  set runItTwice($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRunItTwice() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunItTwice() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get activeSeats => $_getList(1);

  @$pb.TagNumber(3)
  $0.HandStatus get wonAt => $_getN(2);
  @$pb.TagNumber(3)
  set wonAt($0.HandStatus v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasWonAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearWonAt() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$0.Board> get boards => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$0.PotWinnersV2> get potWinners => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get pauseTimeSecs => $_getIZ(5);
  @$pb.TagNumber(6)
  set pauseTimeSecs($core.int v) {
    $_setUnsignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPauseTimeSecs() => $_has(5);
  @$pb.TagNumber(6)
  void clearPauseTimeSecs() => clearField(6);

  @$pb.TagNumber(7)
  $core.Map<$core.int, $0.PlayerHandInfo> get playerInfo => $_getMap(6);

  @$pb.TagNumber(8)
  $core.bool get scoop => $_getBF(7);
  @$pb.TagNumber(8)
  set scoop($core.bool v) {
    $_setBool(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasScoop() => $_has(7);
  @$pb.TagNumber(8)
  void clearScoop() => clearField(8);

  @$pb.TagNumber(9)
  $core.Map<$fixnum.Int64, PlayerStats> get playerStats => $_getMap(8);

  @$pb.TagNumber(10)
  $core.Map<$fixnum.Int64, TimeoutStats> get timeoutStats => $_getMap(9);

  @$pb.TagNumber(11)
  $core.int get handNum => $_getIZ(10);
  @$pb.TagNumber(11)
  set handNum($core.int v) {
    $_setUnsignedInt32(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasHandNum() => $_has(10);
  @$pb.TagNumber(11)
  void clearHandNum() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get tipsCollected => $_getN(11);
  @$pb.TagNumber(12)
  set tipsCollected($core.double v) {
    $_setDouble(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasTipsCollected() => $_has(11);
  @$pb.TagNumber(12)
  void clearTipsCollected() => clearField(12);

  @$pb.TagNumber(13)
  $core.List<$0.HighHandWinner> get highHandWinners => $_getList(12);
}

class HandLogV2 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'HandLogV2',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..aOM<$0.HandActionLog>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'preflopActions',
        subBuilder: $0.HandActionLog.create)
    ..aOM<$0.HandActionLog>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'flopActions',
        subBuilder: $0.HandActionLog.create)
    ..aOM<$0.HandActionLog>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'turnActions',
        subBuilder: $0.HandActionLog.create)
    ..aOM<$0.HandActionLog>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'riverActions',
        subBuilder: $0.HandActionLog.create)
    ..a<$fixnum.Int64>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handStartedAt',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handEndedAt',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  HandLogV2._() : super();
  factory HandLogV2({
    $0.HandActionLog? preflopActions,
    $0.HandActionLog? flopActions,
    $0.HandActionLog? turnActions,
    $0.HandActionLog? riverActions,
    $fixnum.Int64? handStartedAt,
    $fixnum.Int64? handEndedAt,
  }) {
    final _result = create();
    if (preflopActions != null) {
      _result.preflopActions = preflopActions;
    }
    if (flopActions != null) {
      _result.flopActions = flopActions;
    }
    if (turnActions != null) {
      _result.turnActions = turnActions;
    }
    if (riverActions != null) {
      _result.riverActions = riverActions;
    }
    if (handStartedAt != null) {
      _result.handStartedAt = handStartedAt;
    }
    if (handEndedAt != null) {
      _result.handEndedAt = handEndedAt;
    }
    return _result;
  }
  factory HandLogV2.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HandLogV2.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  HandLogV2 clone() => HandLogV2()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  HandLogV2 copyWith(void Function(HandLogV2) updates) =>
      super.copyWith((message) => updates(message as HandLogV2))
          as HandLogV2; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandLogV2 create() => HandLogV2._();
  HandLogV2 createEmptyInstance() => create();
  static $pb.PbList<HandLogV2> createRepeated() => $pb.PbList<HandLogV2>();
  @$core.pragma('dart2js:noInline')
  static HandLogV2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HandLogV2>(create);
  static HandLogV2? _defaultInstance;

  @$pb.TagNumber(1)
  $0.HandActionLog get preflopActions => $_getN(0);
  @$pb.TagNumber(1)
  set preflopActions($0.HandActionLog v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPreflopActions() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreflopActions() => clearField(1);
  @$pb.TagNumber(1)
  $0.HandActionLog ensurePreflopActions() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.HandActionLog get flopActions => $_getN(1);
  @$pb.TagNumber(2)
  set flopActions($0.HandActionLog v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasFlopActions() => $_has(1);
  @$pb.TagNumber(2)
  void clearFlopActions() => clearField(2);
  @$pb.TagNumber(2)
  $0.HandActionLog ensureFlopActions() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.HandActionLog get turnActions => $_getN(2);
  @$pb.TagNumber(3)
  set turnActions($0.HandActionLog v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTurnActions() => $_has(2);
  @$pb.TagNumber(3)
  void clearTurnActions() => clearField(3);
  @$pb.TagNumber(3)
  $0.HandActionLog ensureTurnActions() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.HandActionLog get riverActions => $_getN(3);
  @$pb.TagNumber(4)
  set riverActions($0.HandActionLog v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasRiverActions() => $_has(3);
  @$pb.TagNumber(4)
  void clearRiverActions() => clearField(4);
  @$pb.TagNumber(4)
  $0.HandActionLog ensureRiverActions() => $_ensure(3);

  @$pb.TagNumber(9)
  $fixnum.Int64 get handStartedAt => $_getI64(4);
  @$pb.TagNumber(9)
  set handStartedAt($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasHandStartedAt() => $_has(4);
  @$pb.TagNumber(9)
  void clearHandStartedAt() => clearField(9);

  @$pb.TagNumber(11)
  $fixnum.Int64 get handEndedAt => $_getI64(5);
  @$pb.TagNumber(11)
  set handEndedAt($fixnum.Int64 v) {
    $_setInt64(5, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasHandEndedAt() => $_has(5);
  @$pb.TagNumber(11)
  void clearHandEndedAt() => clearField(11);
}

class HandResultServer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'HandResultServer',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'gameId',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handNum',
        $pb.PbFieldType.OU3)
    ..e<$1.GameType>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'gameType',
        $pb.PbFieldType.OE,
        defaultOrMaker: $1.GameType.UNKNOWN,
        valueOf: $1.GameType.valueOf,
        enumValues: $1.GameType.values)
    ..a<$core.int>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'noCards',
        $pb.PbFieldType.OU3)
    ..aOM<HandLog>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handLog',
        subBuilder: HandLog.create)
    ..aOM<HandStats>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handStats',
        subBuilder: HandStats.create)
    ..aOB(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'runItTwice')
    ..a<$core.int>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'buttonPos',
        $pb.PbFieldType.OU3)
    ..a<$core.double>(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'smallBlind',
        $pb.PbFieldType.OD)
    ..a<$core.double>(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'bigBlind',
        $pb.PbFieldType.OD)
    ..a<$core.double>(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'ante',
        $pb.PbFieldType.OD)
    ..a<$core.int>(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'maxPlayers',
        $pb.PbFieldType.OU3)
    ..aOM<HandResultClient>(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'result',
        subBuilder: HandResultClient.create)
    ..aOM<HandLogV2>(
        15,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'log',
        subBuilder: HandLogV2.create)
    ..a<$core.double>(
        16,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'collectedAnte',
        $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  HandResultServer._() : super();
  factory HandResultServer({
    $fixnum.Int64? gameId,
    $core.int? handNum,
    $1.GameType? gameType,
    $core.int? noCards,
    HandLog? handLog,
    HandStats? handStats,
    $core.bool? runItTwice,
    $core.int? buttonPos,
    $core.double? smallBlind,
    $core.double? bigBlind,
    $core.double? ante,
    $core.int? maxPlayers,
    HandResultClient? result,
    HandLogV2? log,
    $core.double? collectedAnte,
  }) {
    final _result = create();
    if (gameId != null) {
      _result.gameId = gameId;
    }
    if (handNum != null) {
      _result.handNum = handNum;
    }
    if (gameType != null) {
      _result.gameType = gameType;
    }
    if (noCards != null) {
      _result.noCards = noCards;
    }
    if (handLog != null) {
      _result.handLog = handLog;
    }
    if (handStats != null) {
      _result.handStats = handStats;
    }
    if (runItTwice != null) {
      _result.runItTwice = runItTwice;
    }
    if (buttonPos != null) {
      _result.buttonPos = buttonPos;
    }
    if (smallBlind != null) {
      _result.smallBlind = smallBlind;
    }
    if (bigBlind != null) {
      _result.bigBlind = bigBlind;
    }
    if (ante != null) {
      _result.ante = ante;
    }
    if (maxPlayers != null) {
      _result.maxPlayers = maxPlayers;
    }
    if (result != null) {
      _result.result = result;
    }
    if (log != null) {
      _result.log = log;
    }
    if (collectedAnte != null) {
      _result.collectedAnte = collectedAnte;
    }
    return _result;
  }
  factory HandResultServer.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HandResultServer.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  HandResultServer clone() => HandResultServer()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  HandResultServer copyWith(void Function(HandResultServer) updates) =>
      super.copyWith((message) => updates(message as HandResultServer))
          as HandResultServer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandResultServer create() => HandResultServer._();
  HandResultServer createEmptyInstance() => create();
  static $pb.PbList<HandResultServer> createRepeated() =>
      $pb.PbList<HandResultServer>();
  @$core.pragma('dart2js:noInline')
  static HandResultServer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HandResultServer>(create);
  static HandResultServer? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get gameId => $_getI64(0);
  @$pb.TagNumber(1)
  set gameId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get handNum => $_getIZ(1);
  @$pb.TagNumber(2)
  set handNum($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasHandNum() => $_has(1);
  @$pb.TagNumber(2)
  void clearHandNum() => clearField(2);

  @$pb.TagNumber(3)
  $1.GameType get gameType => $_getN(2);
  @$pb.TagNumber(3)
  set gameType($1.GameType v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasGameType() => $_has(2);
  @$pb.TagNumber(3)
  void clearGameType() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get noCards => $_getIZ(3);
  @$pb.TagNumber(4)
  set noCards($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasNoCards() => $_has(3);
  @$pb.TagNumber(4)
  void clearNoCards() => clearField(4);

  @$pb.TagNumber(5)
  HandLog get handLog => $_getN(4);
  @$pb.TagNumber(5)
  set handLog(HandLog v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasHandLog() => $_has(4);
  @$pb.TagNumber(5)
  void clearHandLog() => clearField(5);
  @$pb.TagNumber(5)
  HandLog ensureHandLog() => $_ensure(4);

  @$pb.TagNumber(6)
  HandStats get handStats => $_getN(5);
  @$pb.TagNumber(6)
  set handStats(HandStats v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasHandStats() => $_has(5);
  @$pb.TagNumber(6)
  void clearHandStats() => clearField(6);
  @$pb.TagNumber(6)
  HandStats ensureHandStats() => $_ensure(5);

  @$pb.TagNumber(8)
  $core.bool get runItTwice => $_getBF(6);
  @$pb.TagNumber(8)
  set runItTwice($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasRunItTwice() => $_has(6);
  @$pb.TagNumber(8)
  void clearRunItTwice() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get buttonPos => $_getIZ(7);
  @$pb.TagNumber(9)
  set buttonPos($core.int v) {
    $_setUnsignedInt32(7, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasButtonPos() => $_has(7);
  @$pb.TagNumber(9)
  void clearButtonPos() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get smallBlind => $_getN(8);
  @$pb.TagNumber(10)
  set smallBlind($core.double v) {
    $_setDouble(8, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasSmallBlind() => $_has(8);
  @$pb.TagNumber(10)
  void clearSmallBlind() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get bigBlind => $_getN(9);
  @$pb.TagNumber(11)
  set bigBlind($core.double v) {
    $_setDouble(9, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasBigBlind() => $_has(9);
  @$pb.TagNumber(11)
  void clearBigBlind() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get ante => $_getN(10);
  @$pb.TagNumber(12)
  set ante($core.double v) {
    $_setDouble(10, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasAnte() => $_has(10);
  @$pb.TagNumber(12)
  void clearAnte() => clearField(12);

  @$pb.TagNumber(13)
  $core.int get maxPlayers => $_getIZ(11);
  @$pb.TagNumber(13)
  set maxPlayers($core.int v) {
    $_setUnsignedInt32(11, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasMaxPlayers() => $_has(11);
  @$pb.TagNumber(13)
  void clearMaxPlayers() => clearField(13);

  @$pb.TagNumber(14)
  HandResultClient get result => $_getN(12);
  @$pb.TagNumber(14)
  set result(HandResultClient v) {
    setField(14, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasResult() => $_has(12);
  @$pb.TagNumber(14)
  void clearResult() => clearField(14);
  @$pb.TagNumber(14)
  HandResultClient ensureResult() => $_ensure(12);

  @$pb.TagNumber(15)
  HandLogV2 get log => $_getN(13);
  @$pb.TagNumber(15)
  set log(HandLogV2 v) {
    setField(15, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasLog() => $_has(13);
  @$pb.TagNumber(15)
  void clearLog() => clearField(15);
  @$pb.TagNumber(15)
  HandLogV2 ensureLog() => $_ensure(13);

  @$pb.TagNumber(16)
  $core.double get collectedAnte => $_getN(14);
  @$pb.TagNumber(16)
  set collectedAnte($core.double v) {
    $_setDouble(14, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasCollectedAnte() => $_has(14);
  @$pb.TagNumber(16)
  void clearCollectedAnte() => clearField(16);
}

class MsgAcknowledgement extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'MsgAcknowledgement',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'messageId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'messageType')
    ..hasRequiredFields = false;

  MsgAcknowledgement._() : super();
  factory MsgAcknowledgement({
    $core.String? messageId,
    $core.String? messageType,
  }) {
    final _result = create();
    if (messageId != null) {
      _result.messageId = messageId;
    }
    if (messageType != null) {
      _result.messageType = messageType;
    }
    return _result;
  }
  factory MsgAcknowledgement.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory MsgAcknowledgement.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MsgAcknowledgement clone() => MsgAcknowledgement()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MsgAcknowledgement copyWith(void Function(MsgAcknowledgement) updates) =>
      super.copyWith((message) => updates(message as MsgAcknowledgement))
          as MsgAcknowledgement; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MsgAcknowledgement create() => MsgAcknowledgement._();
  MsgAcknowledgement createEmptyInstance() => create();
  static $pb.PbList<MsgAcknowledgement> createRepeated() =>
      $pb.PbList<MsgAcknowledgement>();
  @$core.pragma('dart2js:noInline')
  static MsgAcknowledgement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MsgAcknowledgement>(create);
  static MsgAcknowledgement? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get messageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set messageId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get messageType => $_getSZ(1);
  @$pb.TagNumber(2)
  set messageType($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMessageType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageType() => clearField(2);
}

class Announcement extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Announcement',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'type')
    ..pPS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'params')
    ..hasRequiredFields = false;

  Announcement._() : super();
  factory Announcement({
    $core.String? type,
    $core.Iterable<$core.String>? params,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (params != null) {
      _result.params.addAll(params);
    }
    return _result;
  }
  factory Announcement.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Announcement.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Announcement clone() => Announcement()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Announcement copyWith(void Function(Announcement) updates) =>
      super.copyWith((message) => updates(message as Announcement))
          as Announcement; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Announcement create() => Announcement._();
  Announcement createEmptyInstance() => create();
  static $pb.PbList<Announcement> createRepeated() =>
      $pb.PbList<Announcement>();
  @$core.pragma('dart2js:noInline')
  static Announcement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Announcement>(create);
  static Announcement? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get params => $_getList(1);
}

class HandMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'HandMessage',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'version')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'gameCode')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handNum',
        $pb.PbFieldType.OU3)
    ..a<$core.int>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seatNo',
        $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerId',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'messageId')
    ..aOS(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'gameToken')
    ..e<$0.HandStatus>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handStatus',
        $pb.PbFieldType.OE,
        defaultOrMaker: $0.HandStatus.HandStatus_UNKNOWN,
        valueOf: $0.HandStatus.valueOf,
        enumValues: $0.HandStatus.values)
    ..pc<HandMessageItem>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'messages',
        $pb.PbFieldType.PM,
        subBuilder: HandMessageItem.create)
    ..hasRequiredFields = false;

  HandMessage._() : super();
  factory HandMessage({
    $core.String? version,
    $core.String? gameCode,
    $core.int? handNum,
    $core.int? seatNo,
    $fixnum.Int64? playerId,
    $core.String? messageId,
    $core.String? gameToken,
    $0.HandStatus? handStatus,
    $core.Iterable<HandMessageItem>? messages,
  }) {
    final _result = create();
    if (version != null) {
      _result.version = version;
    }
    if (gameCode != null) {
      _result.gameCode = gameCode;
    }
    if (handNum != null) {
      _result.handNum = handNum;
    }
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (messageId != null) {
      _result.messageId = messageId;
    }
    if (gameToken != null) {
      _result.gameToken = gameToken;
    }
    if (handStatus != null) {
      _result.handStatus = handStatus;
    }
    if (messages != null) {
      _result.messages.addAll(messages);
    }
    return _result;
  }
  factory HandMessage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HandMessage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  HandMessage clone() => HandMessage()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  HandMessage copyWith(void Function(HandMessage) updates) =>
      super.copyWith((message) => updates(message as HandMessage))
          as HandMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandMessage create() => HandMessage._();
  HandMessage createEmptyInstance() => create();
  static $pb.PbList<HandMessage> createRepeated() => $pb.PbList<HandMessage>();
  @$core.pragma('dart2js:noInline')
  static HandMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HandMessage>(create);
  static HandMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get gameCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set gameCode($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasGameCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearGameCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get handNum => $_getIZ(2);
  @$pb.TagNumber(3)
  set handNum($core.int v) {
    $_setUnsignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasHandNum() => $_has(2);
  @$pb.TagNumber(3)
  void clearHandNum() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get seatNo => $_getIZ(3);
  @$pb.TagNumber(4)
  set seatNo($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSeatNo() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeatNo() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get playerId => $_getI64(4);
  @$pb.TagNumber(5)
  set playerId($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPlayerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlayerId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get messageId => $_getSZ(5);
  @$pb.TagNumber(6)
  set messageId($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasMessageId() => $_has(5);
  @$pb.TagNumber(6)
  void clearMessageId() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get gameToken => $_getSZ(6);
  @$pb.TagNumber(7)
  set gameToken($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasGameToken() => $_has(6);
  @$pb.TagNumber(7)
  void clearGameToken() => clearField(7);

  @$pb.TagNumber(8)
  $0.HandStatus get handStatus => $_getN(7);
  @$pb.TagNumber(8)
  set handStatus($0.HandStatus v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasHandStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearHandStatus() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<HandMessageItem> get messages => $_getList(8);
}

class DealerChoice extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DealerChoice',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerId',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<$1.GameType>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'games',
        $pb.PbFieldType.PE,
        valueOf: $1.GameType.valueOf,
        enumValues: $1.GameType.values)
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'timeout',
        $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  DealerChoice._() : super();
  factory DealerChoice({
    $fixnum.Int64? playerId,
    $core.Iterable<$1.GameType>? games,
    $core.int? timeout,
  }) {
    final _result = create();
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (games != null) {
      _result.games.addAll(games);
    }
    if (timeout != null) {
      _result.timeout = timeout;
    }
    return _result;
  }
  factory DealerChoice.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DealerChoice.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DealerChoice clone() => DealerChoice()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DealerChoice copyWith(void Function(DealerChoice) updates) =>
      super.copyWith((message) => updates(message as DealerChoice))
          as DealerChoice; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DealerChoice create() => DealerChoice._();
  DealerChoice createEmptyInstance() => create();
  static $pb.PbList<DealerChoice> createRepeated() =>
      $pb.PbList<DealerChoice>();
  @$core.pragma('dart2js:noInline')
  static DealerChoice getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DealerChoice>(create);
  static DealerChoice? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get playerId => $_getI64(0);
  @$pb.TagNumber(1)
  set playerId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPlayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$1.GameType> get games => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get timeout => $_getIZ(2);
  @$pb.TagNumber(3)
  set timeout($core.int v) {
    $_setUnsignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTimeout() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeout() => clearField(3);
}

class ClientAliveMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ClientAliveMessage',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'gameId',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'gameCode')
    ..a<$fixnum.Int64>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerId',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  ClientAliveMessage._() : super();
  factory ClientAliveMessage({
    $fixnum.Int64? gameId,
    $core.String? gameCode,
    $fixnum.Int64? playerId,
  }) {
    final _result = create();
    if (gameId != null) {
      _result.gameId = gameId;
    }
    if (gameCode != null) {
      _result.gameCode = gameCode;
    }
    if (playerId != null) {
      _result.playerId = playerId;
    }
    return _result;
  }
  factory ClientAliveMessage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ClientAliveMessage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ClientAliveMessage clone() => ClientAliveMessage()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ClientAliveMessage copyWith(void Function(ClientAliveMessage) updates) =>
      super.copyWith((message) => updates(message as ClientAliveMessage))
          as ClientAliveMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ClientAliveMessage create() => ClientAliveMessage._();
  ClientAliveMessage createEmptyInstance() => create();
  static $pb.PbList<ClientAliveMessage> createRepeated() =>
      $pb.PbList<ClientAliveMessage>();
  @$core.pragma('dart2js:noInline')
  static ClientAliveMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClientAliveMessage>(create);
  static ClientAliveMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get gameId => $_getI64(0);
  @$pb.TagNumber(1)
  set gameId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get gameCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set gameCode($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasGameCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearGameCode() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get playerId => $_getI64(2);
  @$pb.TagNumber(3)
  set playerId($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPlayerId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlayerId() => clearField(3);
}

enum HandMessageItem_Content {
  seatAction,
  dealCards,
  newHand,
  playerActed,
  actionChange,
  handResult,
  flop,
  turn,
  river,
  showdown,
  noMoreActions,
  currentHandState,
  msgAck,
  highHand,
  runItTwice,
  announcement,
  dealerChoice,
  handResultClient,
  extendTimer,
  resetTimer,
  notSet
}

class HandMessageItem extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, HandMessageItem_Content>
      _HandMessageItem_ContentByTag = {
    12: HandMessageItem_Content.seatAction,
    13: HandMessageItem_Content.dealCards,
    14: HandMessageItem_Content.newHand,
    15: HandMessageItem_Content.playerActed,
    16: HandMessageItem_Content.actionChange,
    17: HandMessageItem_Content.handResult,
    18: HandMessageItem_Content.flop,
    19: HandMessageItem_Content.turn,
    20: HandMessageItem_Content.river,
    21: HandMessageItem_Content.showdown,
    22: HandMessageItem_Content.noMoreActions,
    23: HandMessageItem_Content.currentHandState,
    24: HandMessageItem_Content.msgAck,
    25: HandMessageItem_Content.highHand,
    26: HandMessageItem_Content.runItTwice,
    27: HandMessageItem_Content.announcement,
    28: HandMessageItem_Content.dealerChoice,
    29: HandMessageItem_Content.handResultClient,
    30: HandMessageItem_Content.extendTimer,
    31: HandMessageItem_Content.resetTimer,
    0: HandMessageItem_Content.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'HandMessageItem',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'game'),
      createEmptyInstance: create)
    ..oo(0, [
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      31
    ])
    ..aOS(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'messageType')
    ..aOM<$0.NextSeatAction>(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'seatAction',
        subBuilder: $0.NextSeatAction.create)
    ..aOM<HandDealCards>(
        13,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'dealCards',
        subBuilder: HandDealCards.create)
    ..aOM<NewHand>(
        14,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'newHand',
        subBuilder: NewHand.create)
    ..aOM<$0.HandAction>(
        15,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerActed',
        subBuilder: $0.HandAction.create)
    ..aOM<ActionChange>(
        16,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'actionChange',
        subBuilder: ActionChange.create)
    ..aOM<HandResult>(
        17,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handResult',
        subBuilder: HandResult.create)
    ..aOM<Flop>(
        18,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'flop',
        subBuilder: Flop.create)
    ..aOM<Turn>(
        19,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'turn',
        subBuilder: Turn.create)
    ..aOM<River>(
        20,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'river',
        subBuilder: River.create)
    ..aOM<Showdown>(
        21,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'showdown',
        subBuilder: Showdown.create)
    ..aOM<NoMoreActions>(
        22,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'noMoreActions',
        subBuilder: NoMoreActions.create)
    ..aOM<$0.CurrentHandState>(
        23,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'currentHandState',
        subBuilder: $0.CurrentHandState.create)
    ..aOM<MsgAcknowledgement>(
        24,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'msgAck',
        subBuilder: MsgAcknowledgement.create)
    ..aOM<$0.HighHand>(
        25,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'highHand',
        subBuilder: $0.HighHand.create)
    ..aOM<RunItTwiceBoards>(
        26,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'runItTwice',
        subBuilder: RunItTwiceBoards.create)
    ..aOM<Announcement>(
        27,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'announcement',
        subBuilder: Announcement.create)
    ..aOM<DealerChoice>(
        28,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'dealerChoice',
        subBuilder: DealerChoice.create)
    ..aOM<HandResultClient>(
        29,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'handResultClient',
        subBuilder: HandResultClient.create)
    ..aOM<$0.ExtendTimer>(
        30,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'extendTimer',
        subBuilder: $0.ExtendTimer.create)
    ..aOM<$0.ResetTimer>(
        31,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'resetTimer',
        subBuilder: $0.ResetTimer.create)
    ..hasRequiredFields = false;

  HandMessageItem._() : super();
  factory HandMessageItem({
    $core.String? messageType,
    $0.NextSeatAction? seatAction,
    HandDealCards? dealCards,
    NewHand? newHand,
    $0.HandAction? playerActed,
    ActionChange? actionChange,
    HandResult? handResult,
    Flop? flop,
    Turn? turn,
    River? river,
    Showdown? showdown,
    NoMoreActions? noMoreActions,
    $0.CurrentHandState? currentHandState,
    MsgAcknowledgement? msgAck,
    $0.HighHand? highHand,
    RunItTwiceBoards? runItTwice,
    Announcement? announcement,
    DealerChoice? dealerChoice,
    HandResultClient? handResultClient,
    $0.ExtendTimer? extendTimer,
    $0.ResetTimer? resetTimer,
  }) {
    final _result = create();
    if (messageType != null) {
      _result.messageType = messageType;
    }
    if (seatAction != null) {
      _result.seatAction = seatAction;
    }
    if (dealCards != null) {
      _result.dealCards = dealCards;
    }
    if (newHand != null) {
      _result.newHand = newHand;
    }
    if (playerActed != null) {
      _result.playerActed = playerActed;
    }
    if (actionChange != null) {
      _result.actionChange = actionChange;
    }
    if (handResult != null) {
      _result.handResult = handResult;
    }
    if (flop != null) {
      _result.flop = flop;
    }
    if (turn != null) {
      _result.turn = turn;
    }
    if (river != null) {
      _result.river = river;
    }
    if (showdown != null) {
      _result.showdown = showdown;
    }
    if (noMoreActions != null) {
      _result.noMoreActions = noMoreActions;
    }
    if (currentHandState != null) {
      _result.currentHandState = currentHandState;
    }
    if (msgAck != null) {
      _result.msgAck = msgAck;
    }
    if (highHand != null) {
      _result.highHand = highHand;
    }
    if (runItTwice != null) {
      _result.runItTwice = runItTwice;
    }
    if (announcement != null) {
      _result.announcement = announcement;
    }
    if (dealerChoice != null) {
      _result.dealerChoice = dealerChoice;
    }
    if (handResultClient != null) {
      _result.handResultClient = handResultClient;
    }
    if (extendTimer != null) {
      _result.extendTimer = extendTimer;
    }
    if (resetTimer != null) {
      _result.resetTimer = resetTimer;
    }
    return _result;
  }
  factory HandMessageItem.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HandMessageItem.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  HandMessageItem clone() => HandMessageItem()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  HandMessageItem copyWith(void Function(HandMessageItem) updates) =>
      super.copyWith((message) => updates(message as HandMessageItem))
          as HandMessageItem; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandMessageItem create() => HandMessageItem._();
  HandMessageItem createEmptyInstance() => create();
  static $pb.PbList<HandMessageItem> createRepeated() =>
      $pb.PbList<HandMessageItem>();
  @$core.pragma('dart2js:noInline')
  static HandMessageItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HandMessageItem>(create);
  static HandMessageItem? _defaultInstance;

  HandMessageItem_Content whichContent() =>
      _HandMessageItem_ContentByTag[$_whichOneof(0)]!;
  void clearContent() => clearField($_whichOneof(0));

  @$pb.TagNumber(7)
  $core.String get messageType => $_getSZ(0);
  @$pb.TagNumber(7)
  set messageType($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasMessageType() => $_has(0);
  @$pb.TagNumber(7)
  void clearMessageType() => clearField(7);

  @$pb.TagNumber(12)
  $0.NextSeatAction get seatAction => $_getN(1);
  @$pb.TagNumber(12)
  set seatAction($0.NextSeatAction v) {
    setField(12, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasSeatAction() => $_has(1);
  @$pb.TagNumber(12)
  void clearSeatAction() => clearField(12);
  @$pb.TagNumber(12)
  $0.NextSeatAction ensureSeatAction() => $_ensure(1);

  @$pb.TagNumber(13)
  HandDealCards get dealCards => $_getN(2);
  @$pb.TagNumber(13)
  set dealCards(HandDealCards v) {
    setField(13, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasDealCards() => $_has(2);
  @$pb.TagNumber(13)
  void clearDealCards() => clearField(13);
  @$pb.TagNumber(13)
  HandDealCards ensureDealCards() => $_ensure(2);

  @$pb.TagNumber(14)
  NewHand get newHand => $_getN(3);
  @$pb.TagNumber(14)
  set newHand(NewHand v) {
    setField(14, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasNewHand() => $_has(3);
  @$pb.TagNumber(14)
  void clearNewHand() => clearField(14);
  @$pb.TagNumber(14)
  NewHand ensureNewHand() => $_ensure(3);

  @$pb.TagNumber(15)
  $0.HandAction get playerActed => $_getN(4);
  @$pb.TagNumber(15)
  set playerActed($0.HandAction v) {
    setField(15, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasPlayerActed() => $_has(4);
  @$pb.TagNumber(15)
  void clearPlayerActed() => clearField(15);
  @$pb.TagNumber(15)
  $0.HandAction ensurePlayerActed() => $_ensure(4);

  @$pb.TagNumber(16)
  ActionChange get actionChange => $_getN(5);
  @$pb.TagNumber(16)
  set actionChange(ActionChange v) {
    setField(16, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasActionChange() => $_has(5);
  @$pb.TagNumber(16)
  void clearActionChange() => clearField(16);
  @$pb.TagNumber(16)
  ActionChange ensureActionChange() => $_ensure(5);

  @$pb.TagNumber(17)
  HandResult get handResult => $_getN(6);
  @$pb.TagNumber(17)
  set handResult(HandResult v) {
    setField(17, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasHandResult() => $_has(6);
  @$pb.TagNumber(17)
  void clearHandResult() => clearField(17);
  @$pb.TagNumber(17)
  HandResult ensureHandResult() => $_ensure(6);

  @$pb.TagNumber(18)
  Flop get flop => $_getN(7);
  @$pb.TagNumber(18)
  set flop(Flop v) {
    setField(18, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasFlop() => $_has(7);
  @$pb.TagNumber(18)
  void clearFlop() => clearField(18);
  @$pb.TagNumber(18)
  Flop ensureFlop() => $_ensure(7);

  @$pb.TagNumber(19)
  Turn get turn => $_getN(8);
  @$pb.TagNumber(19)
  set turn(Turn v) {
    setField(19, v);
  }

  @$pb.TagNumber(19)
  $core.bool hasTurn() => $_has(8);
  @$pb.TagNumber(19)
  void clearTurn() => clearField(19);
  @$pb.TagNumber(19)
  Turn ensureTurn() => $_ensure(8);

  @$pb.TagNumber(20)
  River get river => $_getN(9);
  @$pb.TagNumber(20)
  set river(River v) {
    setField(20, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasRiver() => $_has(9);
  @$pb.TagNumber(20)
  void clearRiver() => clearField(20);
  @$pb.TagNumber(20)
  River ensureRiver() => $_ensure(9);

  @$pb.TagNumber(21)
  Showdown get showdown => $_getN(10);
  @$pb.TagNumber(21)
  set showdown(Showdown v) {
    setField(21, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasShowdown() => $_has(10);
  @$pb.TagNumber(21)
  void clearShowdown() => clearField(21);
  @$pb.TagNumber(21)
  Showdown ensureShowdown() => $_ensure(10);

  @$pb.TagNumber(22)
  NoMoreActions get noMoreActions => $_getN(11);
  @$pb.TagNumber(22)
  set noMoreActions(NoMoreActions v) {
    setField(22, v);
  }

  @$pb.TagNumber(22)
  $core.bool hasNoMoreActions() => $_has(11);
  @$pb.TagNumber(22)
  void clearNoMoreActions() => clearField(22);
  @$pb.TagNumber(22)
  NoMoreActions ensureNoMoreActions() => $_ensure(11);

  @$pb.TagNumber(23)
  $0.CurrentHandState get currentHandState => $_getN(12);
  @$pb.TagNumber(23)
  set currentHandState($0.CurrentHandState v) {
    setField(23, v);
  }

  @$pb.TagNumber(23)
  $core.bool hasCurrentHandState() => $_has(12);
  @$pb.TagNumber(23)
  void clearCurrentHandState() => clearField(23);
  @$pb.TagNumber(23)
  $0.CurrentHandState ensureCurrentHandState() => $_ensure(12);

  @$pb.TagNumber(24)
  MsgAcknowledgement get msgAck => $_getN(13);
  @$pb.TagNumber(24)
  set msgAck(MsgAcknowledgement v) {
    setField(24, v);
  }

  @$pb.TagNumber(24)
  $core.bool hasMsgAck() => $_has(13);
  @$pb.TagNumber(24)
  void clearMsgAck() => clearField(24);
  @$pb.TagNumber(24)
  MsgAcknowledgement ensureMsgAck() => $_ensure(13);

  @$pb.TagNumber(25)
  $0.HighHand get highHand => $_getN(14);
  @$pb.TagNumber(25)
  set highHand($0.HighHand v) {
    setField(25, v);
  }

  @$pb.TagNumber(25)
  $core.bool hasHighHand() => $_has(14);
  @$pb.TagNumber(25)
  void clearHighHand() => clearField(25);
  @$pb.TagNumber(25)
  $0.HighHand ensureHighHand() => $_ensure(14);

  @$pb.TagNumber(26)
  RunItTwiceBoards get runItTwice => $_getN(15);
  @$pb.TagNumber(26)
  set runItTwice(RunItTwiceBoards v) {
    setField(26, v);
  }

  @$pb.TagNumber(26)
  $core.bool hasRunItTwice() => $_has(15);
  @$pb.TagNumber(26)
  void clearRunItTwice() => clearField(26);
  @$pb.TagNumber(26)
  RunItTwiceBoards ensureRunItTwice() => $_ensure(15);

  @$pb.TagNumber(27)
  Announcement get announcement => $_getN(16);
  @$pb.TagNumber(27)
  set announcement(Announcement v) {
    setField(27, v);
  }

  @$pb.TagNumber(27)
  $core.bool hasAnnouncement() => $_has(16);
  @$pb.TagNumber(27)
  void clearAnnouncement() => clearField(27);
  @$pb.TagNumber(27)
  Announcement ensureAnnouncement() => $_ensure(16);

  @$pb.TagNumber(28)
  DealerChoice get dealerChoice => $_getN(17);
  @$pb.TagNumber(28)
  set dealerChoice(DealerChoice v) {
    setField(28, v);
  }

  @$pb.TagNumber(28)
  $core.bool hasDealerChoice() => $_has(17);
  @$pb.TagNumber(28)
  void clearDealerChoice() => clearField(28);
  @$pb.TagNumber(28)
  DealerChoice ensureDealerChoice() => $_ensure(17);

  @$pb.TagNumber(29)
  HandResultClient get handResultClient => $_getN(18);
  @$pb.TagNumber(29)
  set handResultClient(HandResultClient v) {
    setField(29, v);
  }

  @$pb.TagNumber(29)
  $core.bool hasHandResultClient() => $_has(18);
  @$pb.TagNumber(29)
  void clearHandResultClient() => clearField(29);
  @$pb.TagNumber(29)
  HandResultClient ensureHandResultClient() => $_ensure(18);

  @$pb.TagNumber(30)
  $0.ExtendTimer get extendTimer => $_getN(19);
  @$pb.TagNumber(30)
  set extendTimer($0.ExtendTimer v) {
    setField(30, v);
  }

  @$pb.TagNumber(30)
  $core.bool hasExtendTimer() => $_has(19);
  @$pb.TagNumber(30)
  void clearExtendTimer() => clearField(30);
  @$pb.TagNumber(30)
  $0.ExtendTimer ensureExtendTimer() => $_ensure(19);

  @$pb.TagNumber(31)
  $0.ResetTimer get resetTimer => $_getN(20);
  @$pb.TagNumber(31)
  set resetTimer($0.ResetTimer v) {
    setField(31, v);
  }

  @$pb.TagNumber(31)
  $core.bool hasResetTimer() => $_has(20);
  @$pb.TagNumber(31)
  void clearResetTimer() => clearField(31);
  @$pb.TagNumber(31)
  $0.ResetTimer ensureResetTimer() => $_ensure(20);
}
