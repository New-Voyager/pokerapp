///
//  Generated code. Do not modify.
//  source: game.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'game.pbenum.dart';

export 'game.pbenum.dart';

class PlayerState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerState',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'game'),
      createEmptyInstance: create)
    ..a<$core.double>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'buyIn',
        $pb.PbFieldType.OF)
    ..a<$core.double>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'currentBalance',
        $pb.PbFieldType.OF)
    ..e<PlayerStatus>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status',
        $pb.PbFieldType.OE,
        defaultOrMaker: PlayerStatus.PLAYER_UNKNOWN_STATUS,
        valueOf: PlayerStatus.valueOf,
        enumValues: PlayerStatus.values)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameToken')
    ..a<$fixnum.Int64>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameTokenInt', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  PlayerState._() : super();
  factory PlayerState({
    $core.double? buyIn,
    $core.double? currentBalance,
    PlayerStatus? status,
    $core.String? gameToken,
    $fixnum.Int64? gameTokenInt,
  }) {
    final _result = create();
    if (buyIn != null) {
      _result.buyIn = buyIn;
    }
    if (currentBalance != null) {
      _result.currentBalance = currentBalance;
    }
    if (status != null) {
      _result.status = status;
    }
    if (gameToken != null) {
      _result.gameToken = gameToken;
    }
    if (gameTokenInt != null) {
      _result.gameTokenInt = gameTokenInt;
    }
    return _result;
  }
  factory PlayerState.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerState.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerState clone() => PlayerState()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerState copyWith(void Function(PlayerState) updates) =>
      super.copyWith((message) => updates(message as PlayerState))
          as PlayerState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerState create() => PlayerState._();
  PlayerState createEmptyInstance() => create();
  static $pb.PbList<PlayerState> createRepeated() => $pb.PbList<PlayerState>();
  @$core.pragma('dart2js:noInline')
  static PlayerState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerState>(create);
  static PlayerState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get buyIn => $_getN(0);
  @$pb.TagNumber(1)
  set buyIn($core.double v) {
    $_setFloat(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasBuyIn() => $_has(0);
  @$pb.TagNumber(1)
  void clearBuyIn() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get currentBalance => $_getN(1);
  @$pb.TagNumber(2)
  set currentBalance($core.double v) {
    $_setFloat(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCurrentBalance() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentBalance() => clearField(2);

  @$pb.TagNumber(3)
  PlayerStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(PlayerStatus v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get gameToken => $_getSZ(3);
  @$pb.TagNumber(4)
  set gameToken($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasGameToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearGameToken() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get gameTokenInt => $_getI64(4);
  @$pb.TagNumber(5)
  set gameTokenInt($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasGameTokenInt() => $_has(4);
  @$pb.TagNumber(5)
  void clearGameTokenInt() => clearField(5);
}

class GamePlayerUpdate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GamePlayerUpdate',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names')
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
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatNo',
        $pb.PbFieldType.OU3)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stack', $pb.PbFieldType.OF)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'buyIn', $pb.PbFieldType.OF)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameToken')
    ..e<PlayerStatus>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: PlayerStatus.PLAYER_UNKNOWN_STATUS, valueOf: PlayerStatus.valueOf, enumValues: PlayerStatus.values)
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'reloadChips', $pb.PbFieldType.OF)
    ..e<NewUpdate>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'newUpdate', $pb.PbFieldType.OE, defaultOrMaker: NewUpdate.UNKNOWN_PLAYER_UPDATE, valueOf: NewUpdate.valueOf, enumValues: NewUpdate.values)
    ..a<$core.int>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'oldSeat', $pb.PbFieldType.OU3)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'breakExpAt')
    ..hasRequiredFields = false;

  GamePlayerUpdate._() : super();
  factory GamePlayerUpdate({
    $fixnum.Int64? playerId,
    $core.int? seatNo,
    $core.double? stack,
    $core.double? buyIn,
    $core.String? gameToken,
    PlayerStatus? status,
    $core.double? reloadChips,
    NewUpdate? newUpdate,
    $core.int? oldSeat,
    $core.String? breakExpAt,
  }) {
    final _result = create();
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (stack != null) {
      _result.stack = stack;
    }
    if (buyIn != null) {
      _result.buyIn = buyIn;
    }
    if (gameToken != null) {
      _result.gameToken = gameToken;
    }
    if (status != null) {
      _result.status = status;
    }
    if (reloadChips != null) {
      _result.reloadChips = reloadChips;
    }
    if (newUpdate != null) {
      _result.newUpdate = newUpdate;
    }
    if (oldSeat != null) {
      _result.oldSeat = oldSeat;
    }
    if (breakExpAt != null) {
      _result.breakExpAt = breakExpAt;
    }
    return _result;
  }
  factory GamePlayerUpdate.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GamePlayerUpdate.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GamePlayerUpdate clone() => GamePlayerUpdate()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GamePlayerUpdate copyWith(void Function(GamePlayerUpdate) updates) =>
      super.copyWith((message) => updates(message as GamePlayerUpdate))
          as GamePlayerUpdate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GamePlayerUpdate create() => GamePlayerUpdate._();
  GamePlayerUpdate createEmptyInstance() => create();
  static $pb.PbList<GamePlayerUpdate> createRepeated() =>
      $pb.PbList<GamePlayerUpdate>();
  @$core.pragma('dart2js:noInline')
  static GamePlayerUpdate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GamePlayerUpdate>(create);
  static GamePlayerUpdate? _defaultInstance;

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
  $core.int get seatNo => $_getIZ(1);
  @$pb.TagNumber(2)
  set seatNo($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSeatNo() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeatNo() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get stack => $_getN(2);
  @$pb.TagNumber(3)
  set stack($core.double v) {
    $_setFloat(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasStack() => $_has(2);
  @$pb.TagNumber(3)
  void clearStack() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get buyIn => $_getN(3);
  @$pb.TagNumber(4)
  set buyIn($core.double v) {
    $_setFloat(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasBuyIn() => $_has(3);
  @$pb.TagNumber(4)
  void clearBuyIn() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get gameToken => $_getSZ(4);
  @$pb.TagNumber(5)
  set gameToken($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasGameToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearGameToken() => clearField(5);

  @$pb.TagNumber(6)
  PlayerStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(PlayerStatus v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get reloadChips => $_getN(6);
  @$pb.TagNumber(7)
  set reloadChips($core.double v) {
    $_setFloat(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasReloadChips() => $_has(6);
  @$pb.TagNumber(7)
  void clearReloadChips() => clearField(7);

  @$pb.TagNumber(8)
  NewUpdate get newUpdate => $_getN(7);
  @$pb.TagNumber(8)
  set newUpdate(NewUpdate v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasNewUpdate() => $_has(7);
  @$pb.TagNumber(8)
  void clearNewUpdate() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get oldSeat => $_getIZ(8);
  @$pb.TagNumber(9)
  set oldSeat($core.int v) {
    $_setUnsignedInt32(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasOldSeat() => $_has(8);
  @$pb.TagNumber(9)
  void clearOldSeat() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get breakExpAt => $_getSZ(9);
  @$pb.TagNumber(10)
  set breakExpAt($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasBreakExpAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearBreakExpAt() => clearField(10);
}

class SeatMove extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SeatMove',
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
        protoName: 'playerId',
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerUuid',
        protoName: 'playerUuid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stack', $pb.PbFieldType.OF)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'oldSeatNo', $pb.PbFieldType.OU3, protoName: 'oldSeatNo')
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'newSeatNo', $pb.PbFieldType.OU3, protoName: 'newSeatNo')
    ..hasRequiredFields = false;

  SeatMove._() : super();
  factory SeatMove({
    $fixnum.Int64? playerId,
    $core.String? playerUuid,
    $core.String? name,
    $core.double? stack,
    $core.int? oldSeatNo,
    $core.int? newSeatNo,
  }) {
    final _result = create();
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (playerUuid != null) {
      _result.playerUuid = playerUuid;
    }
    if (name != null) {
      _result.name = name;
    }
    if (stack != null) {
      _result.stack = stack;
    }
    if (oldSeatNo != null) {
      _result.oldSeatNo = oldSeatNo;
    }
    if (newSeatNo != null) {
      _result.newSeatNo = newSeatNo;
    }
    return _result;
  }
  factory SeatMove.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SeatMove.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SeatMove clone() => SeatMove()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SeatMove copyWith(void Function(SeatMove) updates) =>
      super.copyWith((message) => updates(message as SeatMove))
          as SeatMove; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SeatMove create() => SeatMove._();
  SeatMove createEmptyInstance() => create();
  static $pb.PbList<SeatMove> createRepeated() => $pb.PbList<SeatMove>();
  @$core.pragma('dart2js:noInline')
  static SeatMove getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SeatMove>(create);
  static SeatMove? _defaultInstance;

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
  $core.String get playerUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set playerUuid($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPlayerUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerUuid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get stack => $_getN(3);
  @$pb.TagNumber(4)
  set stack($core.double v) {
    $_setFloat(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasStack() => $_has(3);
  @$pb.TagNumber(4)
  void clearStack() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get oldSeatNo => $_getIZ(4);
  @$pb.TagNumber(5)
  set oldSeatNo($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasOldSeatNo() => $_has(4);
  @$pb.TagNumber(5)
  void clearOldSeatNo() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get newSeatNo => $_getIZ(5);
  @$pb.TagNumber(6)
  set newSeatNo($core.int v) {
    $_setUnsignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasNewSeatNo() => $_has(5);
  @$pb.TagNumber(6)
  void clearNewSeatNo() => clearField(6);
}

class SeatUpdate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SeatUpdate',
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
    ..a<$fixnum.Int64>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'playerId',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerUuid')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stack', $pb.PbFieldType.OF)
    ..e<PlayerStatus>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerStatus', $pb.PbFieldType.OE, defaultOrMaker: PlayerStatus.PLAYER_UNKNOWN_STATUS, valueOf: PlayerStatus.valueOf, enumValues: PlayerStatus.values)
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'openSeat')
    ..hasRequiredFields = false;

  SeatUpdate._() : super();
  factory SeatUpdate({
    $core.int? seatNo,
    $fixnum.Int64? playerId,
    $core.String? playerUuid,
    $core.String? name,
    $core.double? stack,
    PlayerStatus? playerStatus,
    $core.bool? openSeat,
  }) {
    final _result = create();
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (playerUuid != null) {
      _result.playerUuid = playerUuid;
    }
    if (name != null) {
      _result.name = name;
    }
    if (stack != null) {
      _result.stack = stack;
    }
    if (playerStatus != null) {
      _result.playerStatus = playerStatus;
    }
    if (openSeat != null) {
      _result.openSeat = openSeat;
    }
    return _result;
  }
  factory SeatUpdate.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SeatUpdate.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  SeatUpdate clone() => SeatUpdate()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  SeatUpdate copyWith(void Function(SeatUpdate) updates) =>
      super.copyWith((message) => updates(message as SeatUpdate))
          as SeatUpdate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SeatUpdate create() => SeatUpdate._();
  SeatUpdate createEmptyInstance() => create();
  static $pb.PbList<SeatUpdate> createRepeated() => $pb.PbList<SeatUpdate>();
  @$core.pragma('dart2js:noInline')
  static SeatUpdate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeatUpdate>(create);
  static SeatUpdate? _defaultInstance;

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
  $fixnum.Int64 get playerId => $_getI64(1);
  @$pb.TagNumber(2)
  set playerId($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPlayerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get playerUuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set playerUuid($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPlayerUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlayerUuid() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get stack => $_getN(4);
  @$pb.TagNumber(5)
  set stack($core.double v) {
    $_setFloat(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasStack() => $_has(4);
  @$pb.TagNumber(5)
  void clearStack() => clearField(5);

  @$pb.TagNumber(6)
  PlayerStatus get playerStatus => $_getN(5);
  @$pb.TagNumber(6)
  set playerStatus(PlayerStatus v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPlayerStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlayerStatus() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get openSeat => $_getBF(6);
  @$pb.TagNumber(7)
  set openSeat($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasOpenSeat() => $_has(6);
  @$pb.TagNumber(7)
  void clearOpenSeat() => clearField(7);
}

class TableUpdate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'TableUpdate',
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
            : 'type')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatChangeTime',
        $pb.PbFieldType.OU3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'waitlistPlayerName')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'waitlistRemainingTime', $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'waitlistPlayerId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'waitlistPlayerUuid')
    ..p<$fixnum.Int64>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatChangePlayers', $pb.PbFieldType.PU6)
    ..p<$fixnum.Int64>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatChangeSeatNo', $pb.PbFieldType.PU6)
    ..a<$fixnum.Int64>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatChangeHost', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..pc<SeatMove>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatMoves', $pb.PbFieldType.PM, subBuilder: SeatMove.create)
    ..pc<SeatUpdate>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatUpdates', $pb.PbFieldType.PM, subBuilder: SeatUpdate.create)
    ..hasRequiredFields = false;

  TableUpdate._() : super();
  factory TableUpdate({
    $core.int? seatNo,
    $core.String? type,
    $core.int? seatChangeTime,
    $core.String? waitlistPlayerName,
    $core.int? waitlistRemainingTime,
    $fixnum.Int64? waitlistPlayerId,
    $core.String? waitlistPlayerUuid,
    $core.Iterable<$fixnum.Int64>? seatChangePlayers,
    $core.Iterable<$fixnum.Int64>? seatChangeSeatNo,
    $fixnum.Int64? seatChangeHost,
    $core.Iterable<SeatMove>? seatMoves,
    $core.Iterable<SeatUpdate>? seatUpdates,
  }) {
    final _result = create();
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (type != null) {
      _result.type = type;
    }
    if (seatChangeTime != null) {
      _result.seatChangeTime = seatChangeTime;
    }
    if (waitlistPlayerName != null) {
      _result.waitlistPlayerName = waitlistPlayerName;
    }
    if (waitlistRemainingTime != null) {
      _result.waitlistRemainingTime = waitlistRemainingTime;
    }
    if (waitlistPlayerId != null) {
      _result.waitlistPlayerId = waitlistPlayerId;
    }
    if (waitlistPlayerUuid != null) {
      _result.waitlistPlayerUuid = waitlistPlayerUuid;
    }
    if (seatChangePlayers != null) {
      _result.seatChangePlayers.addAll(seatChangePlayers);
    }
    if (seatChangeSeatNo != null) {
      _result.seatChangeSeatNo.addAll(seatChangeSeatNo);
    }
    if (seatChangeHost != null) {
      _result.seatChangeHost = seatChangeHost;
    }
    if (seatMoves != null) {
      _result.seatMoves.addAll(seatMoves);
    }
    if (seatUpdates != null) {
      _result.seatUpdates.addAll(seatUpdates);
    }
    return _result;
  }
  factory TableUpdate.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TableUpdate.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  TableUpdate clone() => TableUpdate()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  TableUpdate copyWith(void Function(TableUpdate) updates) =>
      super.copyWith((message) => updates(message as TableUpdate))
          as TableUpdate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TableUpdate create() => TableUpdate._();
  TableUpdate createEmptyInstance() => create();
  static $pb.PbList<TableUpdate> createRepeated() => $pb.PbList<TableUpdate>();
  @$core.pragma('dart2js:noInline')
  static TableUpdate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TableUpdate>(create);
  static TableUpdate? _defaultInstance;

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
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get seatChangeTime => $_getIZ(2);
  @$pb.TagNumber(3)
  set seatChangeTime($core.int v) {
    $_setUnsignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSeatChangeTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeatChangeTime() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get waitlistPlayerName => $_getSZ(3);
  @$pb.TagNumber(4)
  set waitlistPlayerName($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasWaitlistPlayerName() => $_has(3);
  @$pb.TagNumber(4)
  void clearWaitlistPlayerName() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get waitlistRemainingTime => $_getIZ(4);
  @$pb.TagNumber(5)
  set waitlistRemainingTime($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasWaitlistRemainingTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearWaitlistRemainingTime() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get waitlistPlayerId => $_getI64(5);
  @$pb.TagNumber(6)
  set waitlistPlayerId($fixnum.Int64 v) {
    $_setInt64(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasWaitlistPlayerId() => $_has(5);
  @$pb.TagNumber(6)
  void clearWaitlistPlayerId() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get waitlistPlayerUuid => $_getSZ(6);
  @$pb.TagNumber(7)
  set waitlistPlayerUuid($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasWaitlistPlayerUuid() => $_has(6);
  @$pb.TagNumber(7)
  void clearWaitlistPlayerUuid() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<$fixnum.Int64> get seatChangePlayers => $_getList(7);

  @$pb.TagNumber(9)
  $core.List<$fixnum.Int64> get seatChangeSeatNo => $_getList(8);

  @$pb.TagNumber(10)
  $fixnum.Int64 get seatChangeHost => $_getI64(9);
  @$pb.TagNumber(10)
  set seatChangeHost($fixnum.Int64 v) {
    $_setInt64(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasSeatChangeHost() => $_has(9);
  @$pb.TagNumber(10)
  void clearSeatChangeHost() => clearField(10);

  @$pb.TagNumber(11)
  $core.List<SeatMove> get seatMoves => $_getList(10);

  @$pb.TagNumber(12)
  $core.List<SeatUpdate> get seatUpdates => $_getList(11);
}

class PlayerConfigUpdate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PlayerConfigUpdate',
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
    ..aOB(2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'muckLosingHand')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'runItTwicePrompt')
    ..hasRequiredFields = false;

  PlayerConfigUpdate._() : super();
  factory PlayerConfigUpdate({
    $fixnum.Int64? playerId,
    $core.bool? muckLosingHand,
    $core.bool? runItTwicePrompt,
  }) {
    final _result = create();
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (muckLosingHand != null) {
      _result.muckLosingHand = muckLosingHand;
    }
    if (runItTwicePrompt != null) {
      _result.runItTwicePrompt = runItTwicePrompt;
    }
    return _result;
  }
  factory PlayerConfigUpdate.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PlayerConfigUpdate.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PlayerConfigUpdate clone() => PlayerConfigUpdate()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PlayerConfigUpdate copyWith(void Function(PlayerConfigUpdate) updates) =>
      super.copyWith((message) => updates(message as PlayerConfigUpdate))
          as PlayerConfigUpdate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerConfigUpdate create() => PlayerConfigUpdate._();
  PlayerConfigUpdate createEmptyInstance() => create();
  static $pb.PbList<PlayerConfigUpdate> createRepeated() =>
      $pb.PbList<PlayerConfigUpdate>();
  @$core.pragma('dart2js:noInline')
  static PlayerConfigUpdate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerConfigUpdate>(create);
  static PlayerConfigUpdate? _defaultInstance;

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
  $core.bool get muckLosingHand => $_getBF(1);
  @$pb.TagNumber(2)
  set muckLosingHand($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMuckLosingHand() => $_has(1);
  @$pb.TagNumber(2)
  void clearMuckLosingHand() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get runItTwicePrompt => $_getBF(2);
  @$pb.TagNumber(3)
  set runItTwicePrompt($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRunItTwicePrompt() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunItTwicePrompt() => clearField(3);
}
