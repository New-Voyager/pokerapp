///
//  Generated code. Do not modify.
//  source: hand.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'hand.pbenum.dart';
import 'enums.pbenum.dart' as $0;

export 'hand.pbenum.dart';

class HandAction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HandAction', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatNo', $pb.PbFieldType.OU3)
    ..e<ACTION>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'action', $pb.PbFieldType.OE, defaultOrMaker: ACTION.ACTION_UNKNOWN, valueOf: ACTION.valueOf, enumValues: ACTION.values)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.OD)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timedOut')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'actionTime', $pb.PbFieldType.OU3)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stack', $pb.PbFieldType.OD)
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'potUpdates', $pb.PbFieldType.OD)
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'actionId')
    ..hasRequiredFields = false
  ;

  HandAction._() : super();
  factory HandAction({
    $core.int? seatNo,
    ACTION? action,
    $core.double? amount,
    $core.bool? timedOut,
    $core.int? actionTime,
    $core.double? stack,
    $core.double? potUpdates,
    $core.String? actionId,
  }) {
    final _result = create();
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (action != null) {
      _result.action = action;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (timedOut != null) {
      _result.timedOut = timedOut;
    }
    if (actionTime != null) {
      _result.actionTime = actionTime;
    }
    if (stack != null) {
      _result.stack = stack;
    }
    if (potUpdates != null) {
      _result.potUpdates = potUpdates;
    }
    if (actionId != null) {
      _result.actionId = actionId;
    }
    return _result;
  }
  factory HandAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HandAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HandAction clone() => HandAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HandAction copyWith(void Function(HandAction) updates) => super.copyWith((message) => updates(message as HandAction)) as HandAction; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandAction create() => HandAction._();
  HandAction createEmptyInstance() => create();
  static $pb.PbList<HandAction> createRepeated() => $pb.PbList<HandAction>();
  @$core.pragma('dart2js:noInline')
  static HandAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HandAction>(create);
  static HandAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seatNo => $_getIZ(0);
  @$pb.TagNumber(1)
  set seatNo($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSeatNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeatNo() => clearField(1);

  @$pb.TagNumber(2)
  ACTION get action => $_getN(1);
  @$pb.TagNumber(2)
  set action(ACTION v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get timedOut => $_getBF(3);
  @$pb.TagNumber(4)
  set timedOut($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimedOut() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimedOut() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get actionTime => $_getIZ(4);
  @$pb.TagNumber(5)
  set actionTime($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasActionTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearActionTime() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get stack => $_getN(5);
  @$pb.TagNumber(6)
  set stack($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasStack() => $_has(5);
  @$pb.TagNumber(6)
  void clearStack() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get potUpdates => $_getN(6);
  @$pb.TagNumber(7)
  set potUpdates($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPotUpdates() => $_has(6);
  @$pb.TagNumber(7)
  void clearPotUpdates() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get actionId => $_getSZ(7);
  @$pb.TagNumber(8)
  set actionId($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasActionId() => $_has(7);
  @$pb.TagNumber(8)
  void clearActionId() => clearField(8);
}

class HandActionLog extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HandActionLog', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'potStart', $pb.PbFieldType.OD)
    ..p<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pots', $pb.PbFieldType.KD)
    ..pc<HandAction>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'actions', $pb.PbFieldType.PM, subBuilder: HandAction.create)
    ..pc<SeatsInPots>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatsPots', $pb.PbFieldType.PM, subBuilder: SeatsInPots.create)
    ..hasRequiredFields = false
  ;

  HandActionLog._() : super();
  factory HandActionLog({
    $core.double? potStart,
    $core.Iterable<$core.double>? pots,
    $core.Iterable<HandAction>? actions,
    $core.Iterable<SeatsInPots>? seatsPots,
  }) {
    final _result = create();
    if (potStart != null) {
      _result.potStart = potStart;
    }
    if (pots != null) {
      _result.pots.addAll(pots);
    }
    if (actions != null) {
      _result.actions.addAll(actions);
    }
    if (seatsPots != null) {
      _result.seatsPots.addAll(seatsPots);
    }
    return _result;
  }
  factory HandActionLog.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HandActionLog.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HandActionLog clone() => HandActionLog()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HandActionLog copyWith(void Function(HandActionLog) updates) => super.copyWith((message) => updates(message as HandActionLog)) as HandActionLog; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandActionLog create() => HandActionLog._();
  HandActionLog createEmptyInstance() => create();
  static $pb.PbList<HandActionLog> createRepeated() => $pb.PbList<HandActionLog>();
  @$core.pragma('dart2js:noInline')
  static HandActionLog getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HandActionLog>(create);
  static HandActionLog? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get potStart => $_getN(0);
  @$pb.TagNumber(1)
  set potStart($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPotStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearPotStart() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.double> get pots => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<HandAction> get actions => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<SeatsInPots> get seatsPots => $_getList(3);
}

class ExtendTimer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ExtendTimer', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatNo', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'extendBySec', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'remainingSec', $pb.PbFieldType.OU3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'actionId')
    ..hasRequiredFields = false
  ;

  ExtendTimer._() : super();
  factory ExtendTimer({
    $core.int? seatNo,
    $core.int? extendBySec,
    $core.int? remainingSec,
    $core.String? actionId,
  }) {
    final _result = create();
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (extendBySec != null) {
      _result.extendBySec = extendBySec;
    }
    if (remainingSec != null) {
      _result.remainingSec = remainingSec;
    }
    if (actionId != null) {
      _result.actionId = actionId;
    }
    return _result;
  }
  factory ExtendTimer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExtendTimer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExtendTimer clone() => ExtendTimer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExtendTimer copyWith(void Function(ExtendTimer) updates) => super.copyWith((message) => updates(message as ExtendTimer)) as ExtendTimer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ExtendTimer create() => ExtendTimer._();
  ExtendTimer createEmptyInstance() => create();
  static $pb.PbList<ExtendTimer> createRepeated() => $pb.PbList<ExtendTimer>();
  @$core.pragma('dart2js:noInline')
  static ExtendTimer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExtendTimer>(create);
  static ExtendTimer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seatNo => $_getIZ(0);
  @$pb.TagNumber(1)
  set seatNo($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSeatNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeatNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get extendBySec => $_getIZ(1);
  @$pb.TagNumber(2)
  set extendBySec($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasExtendBySec() => $_has(1);
  @$pb.TagNumber(2)
  void clearExtendBySec() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get remainingSec => $_getIZ(2);
  @$pb.TagNumber(3)
  set remainingSec($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRemainingSec() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemainingSec() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get actionId => $_getSZ(3);
  @$pb.TagNumber(4)
  set actionId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasActionId() => $_has(3);
  @$pb.TagNumber(4)
  void clearActionId() => clearField(4);
}

class ResetTimer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ResetTimer', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatNo', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'remainingSec', $pb.PbFieldType.OU3)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'actionId')
    ..hasRequiredFields = false
  ;

  ResetTimer._() : super();
  factory ResetTimer({
    $core.int? seatNo,
    $core.int? remainingSec,
    $core.String? actionId,
  }) {
    final _result = create();
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (remainingSec != null) {
      _result.remainingSec = remainingSec;
    }
    if (actionId != null) {
      _result.actionId = actionId;
    }
    return _result;
  }
  factory ResetTimer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResetTimer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResetTimer clone() => ResetTimer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResetTimer copyWith(void Function(ResetTimer) updates) => super.copyWith((message) => updates(message as ResetTimer)) as ResetTimer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ResetTimer create() => ResetTimer._();
  ResetTimer createEmptyInstance() => create();
  static $pb.PbList<ResetTimer> createRepeated() => $pb.PbList<ResetTimer>();
  @$core.pragma('dart2js:noInline')
  static ResetTimer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResetTimer>(create);
  static ResetTimer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seatNo => $_getIZ(0);
  @$pb.TagNumber(1)
  set seatNo($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSeatNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeatNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get remainingSec => $_getIZ(1);
  @$pb.TagNumber(2)
  set remainingSec($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRemainingSec() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemainingSec() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get actionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set actionId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasActionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearActionId() => clearField(3);
}

class BetRaiseOption extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BetRaiseOption', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'text')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  BetRaiseOption._() : super();
  factory BetRaiseOption({
    $core.String? text,
    $core.double? amount,
  }) {
    final _result = create();
    if (text != null) {
      _result.text = text;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    return _result;
  }
  factory BetRaiseOption.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BetRaiseOption.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BetRaiseOption clone() => BetRaiseOption()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BetRaiseOption copyWith(void Function(BetRaiseOption) updates) => super.copyWith((message) => updates(message as BetRaiseOption)) as BetRaiseOption; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BetRaiseOption create() => BetRaiseOption._();
  BetRaiseOption createEmptyInstance() => create();
  static $pb.PbList<BetRaiseOption> createRepeated() => $pb.PbList<BetRaiseOption>();
  @$core.pragma('dart2js:noInline')
  static BetRaiseOption getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BetRaiseOption>(create);
  static BetRaiseOption? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);
}

class NextSeatAction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'NextSeatAction', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatNo', $pb.PbFieldType.OU3)
    ..pc<ACTION>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'availableActions', $pb.PbFieldType.KE, valueOf: ACTION.valueOf, enumValues: ACTION.values, defaultEnumValue: ACTION.ACTION_UNKNOWN)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'straddleAmount', $pb.PbFieldType.OD, protoName: 'straddleAmount')
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callAmount', $pb.PbFieldType.OD, protoName: 'callAmount')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'raiseAmount', $pb.PbFieldType.OD, protoName: 'raiseAmount')
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minBetAmount', $pb.PbFieldType.OD, protoName: 'minBetAmount')
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxBetAmount', $pb.PbFieldType.OD, protoName: 'maxBetAmount')
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minRaiseAmount', $pb.PbFieldType.OD, protoName: 'minRaiseAmount')
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxRaiseAmount', $pb.PbFieldType.OD, protoName: 'maxRaiseAmount')
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'allInAmount', $pb.PbFieldType.OD, protoName: 'allInAmount')
    ..pc<BetRaiseOption>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'betOptions', $pb.PbFieldType.PM, protoName: 'betOptions', subBuilder: BetRaiseOption.create)
    ..aInt64(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'actionTimesoutAt', protoName: 'actionTimesoutAt')
    ..a<$core.int>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'secondsTillTimesout', $pb.PbFieldType.OU3, protoName: 'secondsTillTimesout')
    ..a<$core.double>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatInSoFar', $pb.PbFieldType.OD, protoName: 'seatInSoFar')
    ..aOS(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'actionId', protoName: 'actionId')
    ..a<$core.double>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'potAmount', $pb.PbFieldType.OD, protoName: 'potAmount')
    ..hasRequiredFields = false
  ;

  NextSeatAction._() : super();
  factory NextSeatAction({
    $core.int? seatNo,
    $core.Iterable<ACTION>? availableActions,
    $core.double? straddleAmount,
    $core.double? callAmount,
    $core.double? raiseAmount,
    $core.double? minBetAmount,
    $core.double? maxBetAmount,
    $core.double? minRaiseAmount,
    $core.double? maxRaiseAmount,
    $core.double? allInAmount,
    $core.Iterable<BetRaiseOption>? betOptions,
    $fixnum.Int64? actionTimesoutAt,
    $core.int? secondsTillTimesout,
    $core.double? seatInSoFar,
    $core.String? actionId,
    $core.double? potAmount,
  }) {
    final _result = create();
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (availableActions != null) {
      _result.availableActions.addAll(availableActions);
    }
    if (straddleAmount != null) {
      _result.straddleAmount = straddleAmount;
    }
    if (callAmount != null) {
      _result.callAmount = callAmount;
    }
    if (raiseAmount != null) {
      _result.raiseAmount = raiseAmount;
    }
    if (minBetAmount != null) {
      _result.minBetAmount = minBetAmount;
    }
    if (maxBetAmount != null) {
      _result.maxBetAmount = maxBetAmount;
    }
    if (minRaiseAmount != null) {
      _result.minRaiseAmount = minRaiseAmount;
    }
    if (maxRaiseAmount != null) {
      _result.maxRaiseAmount = maxRaiseAmount;
    }
    if (allInAmount != null) {
      _result.allInAmount = allInAmount;
    }
    if (betOptions != null) {
      _result.betOptions.addAll(betOptions);
    }
    if (actionTimesoutAt != null) {
      _result.actionTimesoutAt = actionTimesoutAt;
    }
    if (secondsTillTimesout != null) {
      _result.secondsTillTimesout = secondsTillTimesout;
    }
    if (seatInSoFar != null) {
      _result.seatInSoFar = seatInSoFar;
    }
    if (actionId != null) {
      _result.actionId = actionId;
    }
    if (potAmount != null) {
      _result.potAmount = potAmount;
    }
    return _result;
  }
  factory NextSeatAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NextSeatAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NextSeatAction clone() => NextSeatAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NextSeatAction copyWith(void Function(NextSeatAction) updates) => super.copyWith((message) => updates(message as NextSeatAction)) as NextSeatAction; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NextSeatAction create() => NextSeatAction._();
  NextSeatAction createEmptyInstance() => create();
  static $pb.PbList<NextSeatAction> createRepeated() => $pb.PbList<NextSeatAction>();
  @$core.pragma('dart2js:noInline')
  static NextSeatAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NextSeatAction>(create);
  static NextSeatAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seatNo => $_getIZ(0);
  @$pb.TagNumber(1)
  set seatNo($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSeatNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeatNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<ACTION> get availableActions => $_getList(1);

  @$pb.TagNumber(3)
  $core.double get straddleAmount => $_getN(2);
  @$pb.TagNumber(3)
  set straddleAmount($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStraddleAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearStraddleAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get callAmount => $_getN(3);
  @$pb.TagNumber(4)
  set callAmount($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCallAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearCallAmount() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get raiseAmount => $_getN(4);
  @$pb.TagNumber(5)
  set raiseAmount($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRaiseAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearRaiseAmount() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get minBetAmount => $_getN(5);
  @$pb.TagNumber(6)
  set minBetAmount($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMinBetAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinBetAmount() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get maxBetAmount => $_getN(6);
  @$pb.TagNumber(7)
  set maxBetAmount($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMaxBetAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxBetAmount() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get minRaiseAmount => $_getN(7);
  @$pb.TagNumber(8)
  set minRaiseAmount($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMinRaiseAmount() => $_has(7);
  @$pb.TagNumber(8)
  void clearMinRaiseAmount() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get maxRaiseAmount => $_getN(8);
  @$pb.TagNumber(9)
  set maxRaiseAmount($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasMaxRaiseAmount() => $_has(8);
  @$pb.TagNumber(9)
  void clearMaxRaiseAmount() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get allInAmount => $_getN(9);
  @$pb.TagNumber(10)
  set allInAmount($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasAllInAmount() => $_has(9);
  @$pb.TagNumber(10)
  void clearAllInAmount() => clearField(10);

  @$pb.TagNumber(11)
  $core.List<BetRaiseOption> get betOptions => $_getList(10);

  @$pb.TagNumber(12)
  $fixnum.Int64 get actionTimesoutAt => $_getI64(11);
  @$pb.TagNumber(12)
  set actionTimesoutAt($fixnum.Int64 v) { $_setInt64(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasActionTimesoutAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearActionTimesoutAt() => clearField(12);

  @$pb.TagNumber(13)
  $core.int get secondsTillTimesout => $_getIZ(12);
  @$pb.TagNumber(13)
  set secondsTillTimesout($core.int v) { $_setUnsignedInt32(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasSecondsTillTimesout() => $_has(12);
  @$pb.TagNumber(13)
  void clearSecondsTillTimesout() => clearField(13);

  @$pb.TagNumber(14)
  $core.double get seatInSoFar => $_getN(13);
  @$pb.TagNumber(14)
  set seatInSoFar($core.double v) { $_setDouble(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasSeatInSoFar() => $_has(13);
  @$pb.TagNumber(14)
  void clearSeatInSoFar() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get actionId => $_getSZ(14);
  @$pb.TagNumber(15)
  set actionId($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasActionId() => $_has(14);
  @$pb.TagNumber(15)
  void clearActionId() => clearField(15);

  @$pb.TagNumber(16)
  $core.double get potAmount => $_getN(15);
  @$pb.TagNumber(16)
  set potAmount($core.double v) { $_setDouble(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasPotAmount() => $_has(15);
  @$pb.TagNumber(16)
  void clearPotAmount() => clearField(16);
}

class PlayerInSeatState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PlayerInSeatState', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..e<$0.PlayerStatus>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: $0.PlayerStatus.PLAYER_UNKNOWN_STATUS, valueOf: $0.PlayerStatus.valueOf, enumValues: $0.PlayerStatus.values)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stack', $pb.PbFieldType.OD)
    ..e<HandStatus>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'round', $pb.PbFieldType.OE, defaultOrMaker: HandStatus.HandStatus_UNKNOWN, valueOf: HandStatus.valueOf, enumValues: HandStatus.values)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerReceived', $pb.PbFieldType.OD, protoName: 'playerReceived')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'buyInExpTime')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'breakExpTime')
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'inhand')
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'openSeat')
    ..aOB(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'postedBlind')
    ..a<$core.int>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatNo', $pb.PbFieldType.OU3)
    ..aOB(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'runItTwice')
    ..aOB(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'missedBlind')
    ..aOB(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'autoStraddle')
    ..aOB(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'buttonStraddle')
    ..aOB(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'muckLosingHand')
    ..a<$core.int>(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'buttonStraddleBet', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  PlayerInSeatState._() : super();
  factory PlayerInSeatState({
    $fixnum.Int64? playerId,
    $core.String? name,
    $0.PlayerStatus? status,
    $core.double? stack,
    HandStatus? round,
    $core.double? playerReceived,
    $core.String? buyInExpTime,
    $core.String? breakExpTime,
    $core.bool? inhand,
    $core.bool? openSeat,
    $core.bool? postedBlind,
    $core.int? seatNo,
    $core.bool? runItTwice,
    $core.bool? missedBlind,
    $core.bool? autoStraddle,
    $core.bool? buttonStraddle,
    $core.bool? muckLosingHand,
    $core.int? buttonStraddleBet,
  }) {
    final _result = create();
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (name != null) {
      _result.name = name;
    }
    if (status != null) {
      _result.status = status;
    }
    if (stack != null) {
      _result.stack = stack;
    }
    if (round != null) {
      _result.round = round;
    }
    if (playerReceived != null) {
      _result.playerReceived = playerReceived;
    }
    if (buyInExpTime != null) {
      _result.buyInExpTime = buyInExpTime;
    }
    if (breakExpTime != null) {
      _result.breakExpTime = breakExpTime;
    }
    if (inhand != null) {
      _result.inhand = inhand;
    }
    if (openSeat != null) {
      _result.openSeat = openSeat;
    }
    if (postedBlind != null) {
      _result.postedBlind = postedBlind;
    }
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (runItTwice != null) {
      _result.runItTwice = runItTwice;
    }
    if (missedBlind != null) {
      _result.missedBlind = missedBlind;
    }
    if (autoStraddle != null) {
      _result.autoStraddle = autoStraddle;
    }
    if (buttonStraddle != null) {
      _result.buttonStraddle = buttonStraddle;
    }
    if (muckLosingHand != null) {
      _result.muckLosingHand = muckLosingHand;
    }
    if (buttonStraddleBet != null) {
      _result.buttonStraddleBet = buttonStraddleBet;
    }
    return _result;
  }
  factory PlayerInSeatState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerInSeatState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayerInSeatState clone() => PlayerInSeatState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayerInSeatState copyWith(void Function(PlayerInSeatState) updates) => super.copyWith((message) => updates(message as PlayerInSeatState)) as PlayerInSeatState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerInSeatState create() => PlayerInSeatState._();
  PlayerInSeatState createEmptyInstance() => create();
  static $pb.PbList<PlayerInSeatState> createRepeated() => $pb.PbList<PlayerInSeatState>();
  @$core.pragma('dart2js:noInline')
  static PlayerInSeatState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerInSeatState>(create);
  static PlayerInSeatState? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get playerId => $_getI64(0);
  @$pb.TagNumber(1)
  set playerId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $0.PlayerStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status($0.PlayerStatus v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get stack => $_getN(3);
  @$pb.TagNumber(4)
  set stack($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStack() => $_has(3);
  @$pb.TagNumber(4)
  void clearStack() => clearField(4);

  @$pb.TagNumber(5)
  HandStatus get round => $_getN(4);
  @$pb.TagNumber(5)
  set round(HandStatus v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasRound() => $_has(4);
  @$pb.TagNumber(5)
  void clearRound() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get playerReceived => $_getN(5);
  @$pb.TagNumber(6)
  set playerReceived($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPlayerReceived() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlayerReceived() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get buyInExpTime => $_getSZ(6);
  @$pb.TagNumber(7)
  set buyInExpTime($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasBuyInExpTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearBuyInExpTime() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get breakExpTime => $_getSZ(7);
  @$pb.TagNumber(8)
  set breakExpTime($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasBreakExpTime() => $_has(7);
  @$pb.TagNumber(8)
  void clearBreakExpTime() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get inhand => $_getBF(8);
  @$pb.TagNumber(9)
  set inhand($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasInhand() => $_has(8);
  @$pb.TagNumber(9)
  void clearInhand() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get openSeat => $_getBF(9);
  @$pb.TagNumber(10)
  set openSeat($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasOpenSeat() => $_has(9);
  @$pb.TagNumber(10)
  void clearOpenSeat() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get postedBlind => $_getBF(10);
  @$pb.TagNumber(11)
  set postedBlind($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasPostedBlind() => $_has(10);
  @$pb.TagNumber(11)
  void clearPostedBlind() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get seatNo => $_getIZ(11);
  @$pb.TagNumber(12)
  set seatNo($core.int v) { $_setUnsignedInt32(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasSeatNo() => $_has(11);
  @$pb.TagNumber(12)
  void clearSeatNo() => clearField(12);

  @$pb.TagNumber(13)
  $core.bool get runItTwice => $_getBF(12);
  @$pb.TagNumber(13)
  set runItTwice($core.bool v) { $_setBool(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasRunItTwice() => $_has(12);
  @$pb.TagNumber(13)
  void clearRunItTwice() => clearField(13);

  @$pb.TagNumber(14)
  $core.bool get missedBlind => $_getBF(13);
  @$pb.TagNumber(14)
  set missedBlind($core.bool v) { $_setBool(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasMissedBlind() => $_has(13);
  @$pb.TagNumber(14)
  void clearMissedBlind() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get autoStraddle => $_getBF(14);
  @$pb.TagNumber(15)
  set autoStraddle($core.bool v) { $_setBool(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasAutoStraddle() => $_has(14);
  @$pb.TagNumber(15)
  void clearAutoStraddle() => clearField(15);

  @$pb.TagNumber(16)
  $core.bool get buttonStraddle => $_getBF(15);
  @$pb.TagNumber(16)
  set buttonStraddle($core.bool v) { $_setBool(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasButtonStraddle() => $_has(15);
  @$pb.TagNumber(16)
  void clearButtonStraddle() => clearField(16);

  @$pb.TagNumber(17)
  $core.bool get muckLosingHand => $_getBF(16);
  @$pb.TagNumber(17)
  set muckLosingHand($core.bool v) { $_setBool(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasMuckLosingHand() => $_has(16);
  @$pb.TagNumber(17)
  void clearMuckLosingHand() => clearField(17);

  @$pb.TagNumber(18)
  $core.int get buttonStraddleBet => $_getIZ(17);
  @$pb.TagNumber(18)
  set buttonStraddleBet($core.int v) { $_setUnsignedInt32(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasButtonStraddleBet() => $_has(17);
  @$pb.TagNumber(18)
  void clearButtonStraddleBet() => clearField(18);
}

class PlayerBalance extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PlayerBalance', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatNo', $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'balance', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  PlayerBalance._() : super();
  factory PlayerBalance({
    $core.int? seatNo,
    $fixnum.Int64? playerId,
    $core.double? balance,
  }) {
    final _result = create();
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (balance != null) {
      _result.balance = balance;
    }
    return _result;
  }
  factory PlayerBalance.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerBalance.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayerBalance clone() => PlayerBalance()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayerBalance copyWith(void Function(PlayerBalance) updates) => super.copyWith((message) => updates(message as PlayerBalance)) as PlayerBalance; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerBalance create() => PlayerBalance._();
  PlayerBalance createEmptyInstance() => create();
  static $pb.PbList<PlayerBalance> createRepeated() => $pb.PbList<PlayerBalance>();
  @$core.pragma('dart2js:noInline')
  static PlayerBalance getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerBalance>(create);
  static PlayerBalance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seatNo => $_getIZ(0);
  @$pb.TagNumber(1)
  set seatNo($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSeatNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeatNo() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get playerId => $_getI64(1);
  @$pb.TagNumber(2)
  set playerId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlayerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerId() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get balance => $_getN(2);
  @$pb.TagNumber(3)
  set balance($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBalance() => $_has(2);
  @$pb.TagNumber(3)
  void clearBalance() => clearField(3);
}

class HighHandWinner extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HighHandWinner', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerName')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hhRank', $pb.PbFieldType.OU3)
    ..p<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hhCards', $pb.PbFieldType.KU3)
    ..p<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerCards', $pb.PbFieldType.KU3)
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatNo', $pb.PbFieldType.OU3)
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boardNo', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  HighHandWinner._() : super();
  factory HighHandWinner({
    $fixnum.Int64? playerId,
    $core.String? playerName,
    $core.int? hhRank,
    $core.Iterable<$core.int>? hhCards,
    $core.Iterable<$core.int>? playerCards,
    $core.int? seatNo,
    $core.int? boardNo,
  }) {
    final _result = create();
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (playerName != null) {
      _result.playerName = playerName;
    }
    if (hhRank != null) {
      _result.hhRank = hhRank;
    }
    if (hhCards != null) {
      _result.hhCards.addAll(hhCards);
    }
    if (playerCards != null) {
      _result.playerCards.addAll(playerCards);
    }
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (boardNo != null) {
      _result.boardNo = boardNo;
    }
    return _result;
  }
  factory HighHandWinner.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HighHandWinner.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HighHandWinner clone() => HighHandWinner()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HighHandWinner copyWith(void Function(HighHandWinner) updates) => super.copyWith((message) => updates(message as HighHandWinner)) as HighHandWinner; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HighHandWinner create() => HighHandWinner._();
  HighHandWinner createEmptyInstance() => create();
  static $pb.PbList<HighHandWinner> createRepeated() => $pb.PbList<HighHandWinner>();
  @$core.pragma('dart2js:noInline')
  static HighHandWinner getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HighHandWinner>(create);
  static HighHandWinner? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get playerId => $_getI64(0);
  @$pb.TagNumber(1)
  set playerId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get playerName => $_getSZ(1);
  @$pb.TagNumber(2)
  set playerName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlayerName() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerName() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get hhRank => $_getIZ(2);
  @$pb.TagNumber(3)
  set hhRank($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHhRank() => $_has(2);
  @$pb.TagNumber(3)
  void clearHhRank() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get hhCards => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$core.int> get playerCards => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get seatNo => $_getIZ(5);
  @$pb.TagNumber(6)
  set seatNo($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSeatNo() => $_has(5);
  @$pb.TagNumber(6)
  void clearSeatNo() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get boardNo => $_getIZ(6);
  @$pb.TagNumber(7)
  set boardNo($core.int v) { $_setUnsignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasBoardNo() => $_has(6);
  @$pb.TagNumber(7)
  void clearBoardNo() => clearField(7);
}

class HighHand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HighHand', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameCode', protoName: 'gameCode')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'handNum', $pb.PbFieldType.OU3)
    ..pc<HighHandWinner>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'winners', $pb.PbFieldType.PM, subBuilder: HighHandWinner.create)
    ..hasRequiredFields = false
  ;

  HighHand._() : super();
  factory HighHand({
    $core.String? gameCode,
    $core.int? handNum,
    $core.Iterable<HighHandWinner>? winners,
  }) {
    final _result = create();
    if (gameCode != null) {
      _result.gameCode = gameCode;
    }
    if (handNum != null) {
      _result.handNum = handNum;
    }
    if (winners != null) {
      _result.winners.addAll(winners);
    }
    return _result;
  }
  factory HighHand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HighHand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HighHand clone() => HighHand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HighHand copyWith(void Function(HighHand) updates) => super.copyWith((message) => updates(message as HighHand)) as HighHand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HighHand create() => HighHand._();
  HighHand createEmptyInstance() => create();
  static $pb.PbList<HighHand> createRepeated() => $pb.PbList<HighHand>();
  @$core.pragma('dart2js:noInline')
  static HighHand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HighHand>(create);
  static HighHand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGameCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get handNum => $_getIZ(1);
  @$pb.TagNumber(2)
  set handNum($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHandNum() => $_has(1);
  @$pb.TagNumber(2)
  void clearHandNum() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<HighHandWinner> get winners => $_getList(2);
}

class PlayerActRound extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PlayerActRound', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..e<ACTION>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'action', $pb.PbFieldType.OE, defaultOrMaker: ACTION.ACTION_UNKNOWN, valueOf: ACTION.valueOf, enumValues: ACTION.values)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.OD)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'raiseAmount', $pb.PbFieldType.OD, protoName: 'raiseAmount')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'actedBetIndex', $pb.PbFieldType.OU3)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'betAmount', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  PlayerActRound._() : super();
  factory PlayerActRound({
    ACTION? action,
    $core.double? amount,
    $core.double? raiseAmount,
    $core.int? actedBetIndex,
    $core.double? betAmount,
  }) {
    final _result = create();
    if (action != null) {
      _result.action = action;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (raiseAmount != null) {
      _result.raiseAmount = raiseAmount;
    }
    if (actedBetIndex != null) {
      _result.actedBetIndex = actedBetIndex;
    }
    if (betAmount != null) {
      _result.betAmount = betAmount;
    }
    return _result;
  }
  factory PlayerActRound.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerActRound.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayerActRound clone() => PlayerActRound()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayerActRound copyWith(void Function(PlayerActRound) updates) => super.copyWith((message) => updates(message as PlayerActRound)) as PlayerActRound; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerActRound create() => PlayerActRound._();
  PlayerActRound createEmptyInstance() => create();
  static $pb.PbList<PlayerActRound> createRepeated() => $pb.PbList<PlayerActRound>();
  @$core.pragma('dart2js:noInline')
  static PlayerActRound getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerActRound>(create);
  static PlayerActRound? _defaultInstance;

  @$pb.TagNumber(1)
  ACTION get action => $_getN(0);
  @$pb.TagNumber(1)
  set action(ACTION v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAction() => $_has(0);
  @$pb.TagNumber(1)
  void clearAction() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get raiseAmount => $_getN(2);
  @$pb.TagNumber(3)
  set raiseAmount($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRaiseAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearRaiseAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get actedBetIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set actedBetIndex($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasActedBetIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearActedBetIndex() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get betAmount => $_getN(4);
  @$pb.TagNumber(5)
  set betAmount($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasBetAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearBetAmount() => clearField(5);
}

class SeatsInPots extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SeatsInPots', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..p<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seats', $pb.PbFieldType.KU3)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pot', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  SeatsInPots._() : super();
  factory SeatsInPots({
    $core.Iterable<$core.int>? seats,
    $core.double? pot,
  }) {
    final _result = create();
    if (seats != null) {
      _result.seats.addAll(seats);
    }
    if (pot != null) {
      _result.pot = pot;
    }
    return _result;
  }
  factory SeatsInPots.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SeatsInPots.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SeatsInPots clone() => SeatsInPots()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SeatsInPots copyWith(void Function(SeatsInPots) updates) => super.copyWith((message) => updates(message as SeatsInPots)) as SeatsInPots; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SeatsInPots create() => SeatsInPots._();
  SeatsInPots createEmptyInstance() => create();
  static $pb.PbList<SeatsInPots> createRepeated() => $pb.PbList<SeatsInPots>();
  @$core.pragma('dart2js:noInline')
  static SeatsInPots getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SeatsInPots>(create);
  static SeatsInPots? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get seats => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get pot => $_getN(1);
  @$pb.TagNumber(2)
  set pot($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPot() => $_has(1);
  @$pb.TagNumber(2)
  void clearPot() => clearField(2);
}

class SeatBetting extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SeatBetting', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..p<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatBet', $pb.PbFieldType.KD)
    ..hasRequiredFields = false
  ;

  SeatBetting._() : super();
  factory SeatBetting({
    $core.Iterable<$core.double>? seatBet,
  }) {
    final _result = create();
    if (seatBet != null) {
      _result.seatBet.addAll(seatBet);
    }
    return _result;
  }
  factory SeatBetting.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SeatBetting.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SeatBetting clone() => SeatBetting()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SeatBetting copyWith(void Function(SeatBetting) updates) => super.copyWith((message) => updates(message as SeatBetting)) as SeatBetting; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SeatBetting create() => SeatBetting._();
  SeatBetting createEmptyInstance() => create();
  static $pb.PbList<SeatBetting> createRepeated() => $pb.PbList<SeatBetting>();
  @$core.pragma('dart2js:noInline')
  static SeatBetting getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SeatBetting>(create);
  static SeatBetting? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.double> get seatBet => $_getList(0);
}

class RoundState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RoundState', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..aOM<SeatBetting>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'betting', subBuilder: SeatBetting.create)
    ..m<$core.int, $core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerBalance', entryClassName: 'RoundState.PlayerBalanceEntry', keyFieldType: $pb.PbFieldType.OU3, valueFieldType: $pb.PbFieldType.OD, packageName: const $pb.PackageName('game'))
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'betIndex', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  RoundState._() : super();
  factory RoundState({
    SeatBetting? betting,
    $core.Map<$core.int, $core.double>? playerBalance,
    $core.int? betIndex,
  }) {
    final _result = create();
    if (betting != null) {
      _result.betting = betting;
    }
    if (playerBalance != null) {
      _result.playerBalance.addAll(playerBalance);
    }
    if (betIndex != null) {
      _result.betIndex = betIndex;
    }
    return _result;
  }
  factory RoundState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoundState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoundState clone() => RoundState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoundState copyWith(void Function(RoundState) updates) => super.copyWith((message) => updates(message as RoundState)) as RoundState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RoundState create() => RoundState._();
  RoundState createEmptyInstance() => create();
  static $pb.PbList<RoundState> createRepeated() => $pb.PbList<RoundState>();
  @$core.pragma('dart2js:noInline')
  static RoundState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoundState>(create);
  static RoundState? _defaultInstance;

  @$pb.TagNumber(1)
  SeatBetting get betting => $_getN(0);
  @$pb.TagNumber(1)
  set betting(SeatBetting v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBetting() => $_has(0);
  @$pb.TagNumber(1)
  void clearBetting() => clearField(1);
  @$pb.TagNumber(1)
  SeatBetting ensureBetting() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.Map<$core.int, $core.double> get playerBalance => $_getMap(1);

  @$pb.TagNumber(3)
  $core.int get betIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set betIndex($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBetIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearBetIndex() => clearField(3);
}

class PlayerMovedTable extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PlayerMovedTable', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tournamentId', $pb.PbFieldType.OU3)
    ..a<$core.int>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'oldTableNo', $pb.PbFieldType.OU3)
    ..a<$core.int>(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'newTableNo', $pb.PbFieldType.OU3)
    ..a<$core.int>(31, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'newTableSeatNo', $pb.PbFieldType.OU3)
    ..aOS(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameCode')
    ..a<$fixnum.Int64>(60, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(70, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameInfo')
    ..hasRequiredFields = false
  ;

  PlayerMovedTable._() : super();
  factory PlayerMovedTable({
    $core.int? tournamentId,
    $core.int? oldTableNo,
    $core.int? newTableNo,
    $core.int? newTableSeatNo,
    $core.String? gameCode,
    $fixnum.Int64? playerId,
    $core.String? gameInfo,
  }) {
    final _result = create();
    if (tournamentId != null) {
      _result.tournamentId = tournamentId;
    }
    if (oldTableNo != null) {
      _result.oldTableNo = oldTableNo;
    }
    if (newTableNo != null) {
      _result.newTableNo = newTableNo;
    }
    if (newTableSeatNo != null) {
      _result.newTableSeatNo = newTableSeatNo;
    }
    if (gameCode != null) {
      _result.gameCode = gameCode;
    }
    if (playerId != null) {
      _result.playerId = playerId;
    }
    if (gameInfo != null) {
      _result.gameInfo = gameInfo;
    }
    return _result;
  }
  factory PlayerMovedTable.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerMovedTable.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayerMovedTable clone() => PlayerMovedTable()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayerMovedTable copyWith(void Function(PlayerMovedTable) updates) => super.copyWith((message) => updates(message as PlayerMovedTable)) as PlayerMovedTable; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerMovedTable create() => PlayerMovedTable._();
  PlayerMovedTable createEmptyInstance() => create();
  static $pb.PbList<PlayerMovedTable> createRepeated() => $pb.PbList<PlayerMovedTable>();
  @$core.pragma('dart2js:noInline')
  static PlayerMovedTable getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerMovedTable>(create);
  static PlayerMovedTable? _defaultInstance;

  @$pb.TagNumber(10)
  $core.int get tournamentId => $_getIZ(0);
  @$pb.TagNumber(10)
  set tournamentId($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(10)
  $core.bool hasTournamentId() => $_has(0);
  @$pb.TagNumber(10)
  void clearTournamentId() => clearField(10);

  @$pb.TagNumber(20)
  $core.int get oldTableNo => $_getIZ(1);
  @$pb.TagNumber(20)
  set oldTableNo($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(20)
  $core.bool hasOldTableNo() => $_has(1);
  @$pb.TagNumber(20)
  void clearOldTableNo() => clearField(20);

  @$pb.TagNumber(30)
  $core.int get newTableNo => $_getIZ(2);
  @$pb.TagNumber(30)
  set newTableNo($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(30)
  $core.bool hasNewTableNo() => $_has(2);
  @$pb.TagNumber(30)
  void clearNewTableNo() => clearField(30);

  @$pb.TagNumber(31)
  $core.int get newTableSeatNo => $_getIZ(3);
  @$pb.TagNumber(31)
  set newTableSeatNo($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(31)
  $core.bool hasNewTableSeatNo() => $_has(3);
  @$pb.TagNumber(31)
  void clearNewTableSeatNo() => clearField(31);

  @$pb.TagNumber(40)
  $core.String get gameCode => $_getSZ(4);
  @$pb.TagNumber(40)
  set gameCode($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(40)
  $core.bool hasGameCode() => $_has(4);
  @$pb.TagNumber(40)
  void clearGameCode() => clearField(40);

  @$pb.TagNumber(60)
  $fixnum.Int64 get playerId => $_getI64(5);
  @$pb.TagNumber(60)
  set playerId($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(60)
  $core.bool hasPlayerId() => $_has(5);
  @$pb.TagNumber(60)
  void clearPlayerId() => clearField(60);

  @$pb.TagNumber(70)
  $core.String get gameInfo => $_getSZ(6);
  @$pb.TagNumber(70)
  set gameInfo($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(70)
  $core.bool hasGameInfo() => $_has(6);
  @$pb.TagNumber(70)
  void clearGameInfo() => clearField(70);
}

class CurrentHandState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CurrentHandState', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'handNum', $pb.PbFieldType.OU3)
    ..e<$0.GameType>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gameType', $pb.PbFieldType.OE, defaultOrMaker: $0.GameType.UNKNOWN, valueOf: $0.GameType.valueOf, enumValues: $0.GameType.values)
    ..e<HandStatus>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentRound', $pb.PbFieldType.OE, defaultOrMaker: HandStatus.HandStatus_UNKNOWN, valueOf: HandStatus.valueOf, enumValues: HandStatus.values)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'buttonPos', $pb.PbFieldType.OU3)
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'smallBlindPos', $pb.PbFieldType.OU3)
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bigBlindPos', $pb.PbFieldType.OU3)
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bigBlind', $pb.PbFieldType.OD)
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'smallBlind', $pb.PbFieldType.OD)
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'straddle', $pb.PbFieldType.OD)
    ..m<$core.int, PlayerActRound>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playersActed', entryClassName: 'CurrentHandState.PlayersActedEntry', keyFieldType: $pb.PbFieldType.OU3, valueFieldType: $pb.PbFieldType.OM, valueCreator: PlayerActRound.create, packageName: const $pb.PackageName('game'))
    ..p<$core.int>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boardCards', $pb.PbFieldType.KU3)
    ..p<$core.int>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boardCards2', $pb.PbFieldType.KU3, protoName: 'board_cards_2')
    ..aOS(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cardsStr', protoName: 'cardsStr')
    ..aOS(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cards2Str', protoName: 'cards2Str')
    ..aOS(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerCards')
    ..a<$core.int>(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerSeatNo', $pb.PbFieldType.OU3)
    ..m<$fixnum.Int64, $core.double>(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playersStack', entryClassName: 'CurrentHandState.PlayersStackEntry', keyFieldType: $pb.PbFieldType.OU6, valueFieldType: $pb.PbFieldType.OD, packageName: const $pb.PackageName('game'))
    ..a<$core.int>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nextSeatToAct', $pb.PbFieldType.OU3)
    ..a<$core.int>(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'remainingActionTime', $pb.PbFieldType.OU3)
    ..aOM<NextSeatAction>(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nextSeatAction', subBuilder: NextSeatAction.create)
    ..p<$core.double>(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pots', $pb.PbFieldType.KD)
    ..a<$core.double>(24, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'potUpdates', $pb.PbFieldType.OD)
    ..a<$core.int>(25, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'noCards', $pb.PbFieldType.OU3)
    ..aOB(36, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bombPot')
    ..aOB(37, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'doubleBoard')
    ..a<$core.double>(38, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bombPotBet', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  CurrentHandState._() : super();
  factory CurrentHandState({
    $fixnum.Int64? gameId,
    $core.int? handNum,
    $0.GameType? gameType,
    HandStatus? currentRound,
    $core.int? buttonPos,
    $core.int? smallBlindPos,
    $core.int? bigBlindPos,
    $core.double? bigBlind,
    $core.double? smallBlind,
    $core.double? straddle,
    $core.Map<$core.int, PlayerActRound>? playersActed,
    $core.Iterable<$core.int>? boardCards,
    $core.Iterable<$core.int>? boardCards2,
    $core.String? cardsStr,
    $core.String? cards2Str,
    $core.String? playerCards,
    $core.int? playerSeatNo,
    $core.Map<$fixnum.Int64, $core.double>? playersStack,
    $core.int? nextSeatToAct,
    $core.int? remainingActionTime,
    NextSeatAction? nextSeatAction,
    $core.Iterable<$core.double>? pots,
    $core.double? potUpdates,
    $core.int? noCards,
    $core.bool? bombPot,
    $core.bool? doubleBoard,
    $core.double? bombPotBet,
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
    if (currentRound != null) {
      _result.currentRound = currentRound;
    }
    if (buttonPos != null) {
      _result.buttonPos = buttonPos;
    }
    if (smallBlindPos != null) {
      _result.smallBlindPos = smallBlindPos;
    }
    if (bigBlindPos != null) {
      _result.bigBlindPos = bigBlindPos;
    }
    if (bigBlind != null) {
      _result.bigBlind = bigBlind;
    }
    if (smallBlind != null) {
      _result.smallBlind = smallBlind;
    }
    if (straddle != null) {
      _result.straddle = straddle;
    }
    if (playersActed != null) {
      _result.playersActed.addAll(playersActed);
    }
    if (boardCards != null) {
      _result.boardCards.addAll(boardCards);
    }
    if (boardCards2 != null) {
      _result.boardCards2.addAll(boardCards2);
    }
    if (cardsStr != null) {
      _result.cardsStr = cardsStr;
    }
    if (cards2Str != null) {
      _result.cards2Str = cards2Str;
    }
    if (playerCards != null) {
      _result.playerCards = playerCards;
    }
    if (playerSeatNo != null) {
      _result.playerSeatNo = playerSeatNo;
    }
    if (playersStack != null) {
      _result.playersStack.addAll(playersStack);
    }
    if (nextSeatToAct != null) {
      _result.nextSeatToAct = nextSeatToAct;
    }
    if (remainingActionTime != null) {
      _result.remainingActionTime = remainingActionTime;
    }
    if (nextSeatAction != null) {
      _result.nextSeatAction = nextSeatAction;
    }
    if (pots != null) {
      _result.pots.addAll(pots);
    }
    if (potUpdates != null) {
      _result.potUpdates = potUpdates;
    }
    if (noCards != null) {
      _result.noCards = noCards;
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
    return _result;
  }
  factory CurrentHandState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CurrentHandState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CurrentHandState clone() => CurrentHandState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CurrentHandState copyWith(void Function(CurrentHandState) updates) => super.copyWith((message) => updates(message as CurrentHandState)) as CurrentHandState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CurrentHandState create() => CurrentHandState._();
  CurrentHandState createEmptyInstance() => create();
  static $pb.PbList<CurrentHandState> createRepeated() => $pb.PbList<CurrentHandState>();
  @$core.pragma('dart2js:noInline')
  static CurrentHandState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CurrentHandState>(create);
  static CurrentHandState? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get gameId => $_getI64(0);
  @$pb.TagNumber(1)
  set gameId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get handNum => $_getIZ(1);
  @$pb.TagNumber(2)
  set handNum($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHandNum() => $_has(1);
  @$pb.TagNumber(2)
  void clearHandNum() => clearField(2);

  @$pb.TagNumber(3)
  $0.GameType get gameType => $_getN(2);
  @$pb.TagNumber(3)
  set gameType($0.GameType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasGameType() => $_has(2);
  @$pb.TagNumber(3)
  void clearGameType() => clearField(3);

  @$pb.TagNumber(4)
  HandStatus get currentRound => $_getN(3);
  @$pb.TagNumber(4)
  set currentRound(HandStatus v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurrentRound() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrentRound() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get buttonPos => $_getIZ(4);
  @$pb.TagNumber(5)
  set buttonPos($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasButtonPos() => $_has(4);
  @$pb.TagNumber(5)
  void clearButtonPos() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get smallBlindPos => $_getIZ(5);
  @$pb.TagNumber(6)
  set smallBlindPos($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSmallBlindPos() => $_has(5);
  @$pb.TagNumber(6)
  void clearSmallBlindPos() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get bigBlindPos => $_getIZ(6);
  @$pb.TagNumber(7)
  set bigBlindPos($core.int v) { $_setUnsignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasBigBlindPos() => $_has(6);
  @$pb.TagNumber(7)
  void clearBigBlindPos() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get bigBlind => $_getN(7);
  @$pb.TagNumber(8)
  set bigBlind($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasBigBlind() => $_has(7);
  @$pb.TagNumber(8)
  void clearBigBlind() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get smallBlind => $_getN(8);
  @$pb.TagNumber(9)
  set smallBlind($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasSmallBlind() => $_has(8);
  @$pb.TagNumber(9)
  void clearSmallBlind() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get straddle => $_getN(9);
  @$pb.TagNumber(10)
  set straddle($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasStraddle() => $_has(9);
  @$pb.TagNumber(10)
  void clearStraddle() => clearField(10);

  @$pb.TagNumber(12)
  $core.Map<$core.int, PlayerActRound> get playersActed => $_getMap(10);

  @$pb.TagNumber(13)
  $core.List<$core.int> get boardCards => $_getList(11);

  @$pb.TagNumber(14)
  $core.List<$core.int> get boardCards2 => $_getList(12);

  @$pb.TagNumber(15)
  $core.String get cardsStr => $_getSZ(13);
  @$pb.TagNumber(15)
  set cardsStr($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(15)
  $core.bool hasCardsStr() => $_has(13);
  @$pb.TagNumber(15)
  void clearCardsStr() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get cards2Str => $_getSZ(14);
  @$pb.TagNumber(16)
  set cards2Str($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(16)
  $core.bool hasCards2Str() => $_has(14);
  @$pb.TagNumber(16)
  void clearCards2Str() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get playerCards => $_getSZ(15);
  @$pb.TagNumber(17)
  set playerCards($core.String v) { $_setString(15, v); }
  @$pb.TagNumber(17)
  $core.bool hasPlayerCards() => $_has(15);
  @$pb.TagNumber(17)
  void clearPlayerCards() => clearField(17);

  @$pb.TagNumber(18)
  $core.int get playerSeatNo => $_getIZ(16);
  @$pb.TagNumber(18)
  set playerSeatNo($core.int v) { $_setUnsignedInt32(16, v); }
  @$pb.TagNumber(18)
  $core.bool hasPlayerSeatNo() => $_has(16);
  @$pb.TagNumber(18)
  void clearPlayerSeatNo() => clearField(18);

  @$pb.TagNumber(19)
  $core.Map<$fixnum.Int64, $core.double> get playersStack => $_getMap(17);

  @$pb.TagNumber(20)
  $core.int get nextSeatToAct => $_getIZ(18);
  @$pb.TagNumber(20)
  set nextSeatToAct($core.int v) { $_setUnsignedInt32(18, v); }
  @$pb.TagNumber(20)
  $core.bool hasNextSeatToAct() => $_has(18);
  @$pb.TagNumber(20)
  void clearNextSeatToAct() => clearField(20);

  @$pb.TagNumber(21)
  $core.int get remainingActionTime => $_getIZ(19);
  @$pb.TagNumber(21)
  set remainingActionTime($core.int v) { $_setUnsignedInt32(19, v); }
  @$pb.TagNumber(21)
  $core.bool hasRemainingActionTime() => $_has(19);
  @$pb.TagNumber(21)
  void clearRemainingActionTime() => clearField(21);

  @$pb.TagNumber(22)
  NextSeatAction get nextSeatAction => $_getN(20);
  @$pb.TagNumber(22)
  set nextSeatAction(NextSeatAction v) { setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasNextSeatAction() => $_has(20);
  @$pb.TagNumber(22)
  void clearNextSeatAction() => clearField(22);
  @$pb.TagNumber(22)
  NextSeatAction ensureNextSeatAction() => $_ensure(20);

  @$pb.TagNumber(23)
  $core.List<$core.double> get pots => $_getList(21);

  @$pb.TagNumber(24)
  $core.double get potUpdates => $_getN(22);
  @$pb.TagNumber(24)
  set potUpdates($core.double v) { $_setDouble(22, v); }
  @$pb.TagNumber(24)
  $core.bool hasPotUpdates() => $_has(22);
  @$pb.TagNumber(24)
  void clearPotUpdates() => clearField(24);

  @$pb.TagNumber(25)
  $core.int get noCards => $_getIZ(23);
  @$pb.TagNumber(25)
  set noCards($core.int v) { $_setUnsignedInt32(23, v); }
  @$pb.TagNumber(25)
  $core.bool hasNoCards() => $_has(23);
  @$pb.TagNumber(25)
  void clearNoCards() => clearField(25);

  @$pb.TagNumber(36)
  $core.bool get bombPot => $_getBF(24);
  @$pb.TagNumber(36)
  set bombPot($core.bool v) { $_setBool(24, v); }
  @$pb.TagNumber(36)
  $core.bool hasBombPot() => $_has(24);
  @$pb.TagNumber(36)
  void clearBombPot() => clearField(36);

  @$pb.TagNumber(37)
  $core.bool get doubleBoard => $_getBF(25);
  @$pb.TagNumber(37)
  set doubleBoard($core.bool v) { $_setBool(25, v); }
  @$pb.TagNumber(37)
  $core.bool hasDoubleBoard() => $_has(25);
  @$pb.TagNumber(37)
  void clearDoubleBoard() => clearField(37);

  @$pb.TagNumber(38)
  $core.double get bombPotBet => $_getN(26);
  @$pb.TagNumber(38)
  set bombPotBet($core.double v) { $_setDouble(26, v); }
  @$pb.TagNumber(38)
  $core.bool hasBombPotBet() => $_has(26);
  @$pb.TagNumber(38)
  void clearBombPotBet() => clearField(38);
}

class HandWinner extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HandWinner', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatNo', $pb.PbFieldType.OU3)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'loCard')
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.OD)
    ..p<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'winningCards', $pb.PbFieldType.KU3)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'winningCardsStr')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rankStr')
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rank', $pb.PbFieldType.OU3)
    ..p<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerCards', $pb.PbFieldType.KU3)
    ..p<$core.int>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boardCards', $pb.PbFieldType.KU3)
    ..hasRequiredFields = false
  ;

  HandWinner._() : super();
  factory HandWinner({
    $core.int? seatNo,
    $core.bool? loCard,
    $core.double? amount,
    $core.Iterable<$core.int>? winningCards,
    $core.String? winningCardsStr,
    $core.String? rankStr,
    $core.int? rank,
    $core.Iterable<$core.int>? playerCards,
    $core.Iterable<$core.int>? boardCards,
  }) {
    final _result = create();
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (loCard != null) {
      _result.loCard = loCard;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (winningCards != null) {
      _result.winningCards.addAll(winningCards);
    }
    if (winningCardsStr != null) {
      _result.winningCardsStr = winningCardsStr;
    }
    if (rankStr != null) {
      _result.rankStr = rankStr;
    }
    if (rank != null) {
      _result.rank = rank;
    }
    if (playerCards != null) {
      _result.playerCards.addAll(playerCards);
    }
    if (boardCards != null) {
      _result.boardCards.addAll(boardCards);
    }
    return _result;
  }
  factory HandWinner.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HandWinner.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HandWinner clone() => HandWinner()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HandWinner copyWith(void Function(HandWinner) updates) => super.copyWith((message) => updates(message as HandWinner)) as HandWinner; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandWinner create() => HandWinner._();
  HandWinner createEmptyInstance() => create();
  static $pb.PbList<HandWinner> createRepeated() => $pb.PbList<HandWinner>();
  @$core.pragma('dart2js:noInline')
  static HandWinner getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HandWinner>(create);
  static HandWinner? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seatNo => $_getIZ(0);
  @$pb.TagNumber(1)
  set seatNo($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSeatNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeatNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get loCard => $_getBF(1);
  @$pb.TagNumber(2)
  set loCard($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLoCard() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoCard() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get winningCards => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get winningCardsStr => $_getSZ(4);
  @$pb.TagNumber(5)
  set winningCardsStr($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasWinningCardsStr() => $_has(4);
  @$pb.TagNumber(5)
  void clearWinningCardsStr() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get rankStr => $_getSZ(5);
  @$pb.TagNumber(6)
  set rankStr($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRankStr() => $_has(5);
  @$pb.TagNumber(6)
  void clearRankStr() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get rank => $_getIZ(6);
  @$pb.TagNumber(7)
  set rank($core.int v) { $_setUnsignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasRank() => $_has(6);
  @$pb.TagNumber(7)
  void clearRank() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get playerCards => $_getList(7);

  @$pb.TagNumber(9)
  $core.List<$core.int> get boardCards => $_getList(8);
}

class PotWinners extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PotWinners', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'potNo', $pb.PbFieldType.OU3)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.OD)
    ..pc<HandWinner>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hiWinners', $pb.PbFieldType.PM, subBuilder: HandWinner.create)
    ..pc<HandWinner>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lowWinners', $pb.PbFieldType.PM, subBuilder: HandWinner.create)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pauseTime', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  PotWinners._() : super();
  factory PotWinners({
    $core.int? potNo,
    $core.double? amount,
    $core.Iterable<HandWinner>? hiWinners,
    $core.Iterable<HandWinner>? lowWinners,
    $core.int? pauseTime,
  }) {
    final _result = create();
    if (potNo != null) {
      _result.potNo = potNo;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (hiWinners != null) {
      _result.hiWinners.addAll(hiWinners);
    }
    if (lowWinners != null) {
      _result.lowWinners.addAll(lowWinners);
    }
    if (pauseTime != null) {
      _result.pauseTime = pauseTime;
    }
    return _result;
  }
  factory PotWinners.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PotWinners.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PotWinners clone() => PotWinners()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PotWinners copyWith(void Function(PotWinners) updates) => super.copyWith((message) => updates(message as PotWinners)) as PotWinners; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PotWinners create() => PotWinners._();
  PotWinners createEmptyInstance() => create();
  static $pb.PbList<PotWinners> createRepeated() => $pb.PbList<PotWinners>();
  @$core.pragma('dart2js:noInline')
  static PotWinners getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PotWinners>(create);
  static PotWinners? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get potNo => $_getIZ(0);
  @$pb.TagNumber(1)
  set potNo($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPotNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearPotNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<HandWinner> get hiWinners => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<HandWinner> get lowWinners => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get pauseTime => $_getIZ(4);
  @$pb.TagNumber(5)
  set pauseTime($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPauseTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearPauseTime() => clearField(5);
}

class BoardCardRank extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BoardCardRank', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boardNo', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatNo', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hiRank', $pb.PbFieldType.OU3)
    ..p<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hiCards', $pb.PbFieldType.KU3)
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lowFound')
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'loRank', $pb.PbFieldType.OU3)
    ..p<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'loCards', $pb.PbFieldType.KU3)
    ..a<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hhRank', $pb.PbFieldType.OU3)
    ..p<$core.int>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hhCards', $pb.PbFieldType.KU3)
    ..hasRequiredFields = false
  ;

  BoardCardRank._() : super();
  factory BoardCardRank({
    $core.int? boardNo,
    $core.int? seatNo,
    $core.int? hiRank,
    $core.Iterable<$core.int>? hiCards,
    $core.bool? lowFound,
    $core.int? loRank,
    $core.Iterable<$core.int>? loCards,
    $core.int? hhRank,
    $core.Iterable<$core.int>? hhCards,
  }) {
    final _result = create();
    if (boardNo != null) {
      _result.boardNo = boardNo;
    }
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (hiRank != null) {
      _result.hiRank = hiRank;
    }
    if (hiCards != null) {
      _result.hiCards.addAll(hiCards);
    }
    if (lowFound != null) {
      _result.lowFound = lowFound;
    }
    if (loRank != null) {
      _result.loRank = loRank;
    }
    if (loCards != null) {
      _result.loCards.addAll(loCards);
    }
    if (hhRank != null) {
      _result.hhRank = hhRank;
    }
    if (hhCards != null) {
      _result.hhCards.addAll(hhCards);
    }
    return _result;
  }
  factory BoardCardRank.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BoardCardRank.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BoardCardRank clone() => BoardCardRank()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BoardCardRank copyWith(void Function(BoardCardRank) updates) => super.copyWith((message) => updates(message as BoardCardRank)) as BoardCardRank; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BoardCardRank create() => BoardCardRank._();
  BoardCardRank createEmptyInstance() => create();
  static $pb.PbList<BoardCardRank> createRepeated() => $pb.PbList<BoardCardRank>();
  @$core.pragma('dart2js:noInline')
  static BoardCardRank getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BoardCardRank>(create);
  static BoardCardRank? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get boardNo => $_getIZ(0);
  @$pb.TagNumber(1)
  set boardNo($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBoardNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearBoardNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get seatNo => $_getIZ(1);
  @$pb.TagNumber(2)
  set seatNo($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSeatNo() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeatNo() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get hiRank => $_getIZ(2);
  @$pb.TagNumber(3)
  set hiRank($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHiRank() => $_has(2);
  @$pb.TagNumber(3)
  void clearHiRank() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get hiCards => $_getList(3);

  @$pb.TagNumber(5)
  $core.bool get lowFound => $_getBF(4);
  @$pb.TagNumber(5)
  set lowFound($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLowFound() => $_has(4);
  @$pb.TagNumber(5)
  void clearLowFound() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get loRank => $_getIZ(5);
  @$pb.TagNumber(6)
  set loRank($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLoRank() => $_has(5);
  @$pb.TagNumber(6)
  void clearLoRank() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.int> get loCards => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get hhRank => $_getIZ(7);
  @$pb.TagNumber(8)
  set hhRank($core.int v) { $_setUnsignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasHhRank() => $_has(7);
  @$pb.TagNumber(8)
  void clearHhRank() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<$core.int> get hhCards => $_getList(8);
}

class Board extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Board', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boardNo', $pb.PbFieldType.OU3)
    ..p<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cards', $pb.PbFieldType.KU3)
    ..m<$core.int, BoardCardRank>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playerRank', entryClassName: 'Board.PlayerRankEntry', keyFieldType: $pb.PbFieldType.OU3, valueFieldType: $pb.PbFieldType.OM, valueCreator: BoardCardRank.create, packageName: const $pb.PackageName('game'))
    ..hasRequiredFields = false
  ;

  Board._() : super();
  factory Board({
    $core.int? boardNo,
    $core.Iterable<$core.int>? cards,
    $core.Map<$core.int, BoardCardRank>? playerRank,
  }) {
    final _result = create();
    if (boardNo != null) {
      _result.boardNo = boardNo;
    }
    if (cards != null) {
      _result.cards.addAll(cards);
    }
    if (playerRank != null) {
      _result.playerRank.addAll(playerRank);
    }
    return _result;
  }
  factory Board.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Board.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Board clone() => Board()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Board copyWith(void Function(Board) updates) => super.copyWith((message) => updates(message as Board)) as Board; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Board create() => Board._();
  Board createEmptyInstance() => create();
  static $pb.PbList<Board> createRepeated() => $pb.PbList<Board>();
  @$core.pragma('dart2js:noInline')
  static Board getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Board>(create);
  static Board? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get boardNo => $_getIZ(0);
  @$pb.TagNumber(1)
  set boardNo($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBoardNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearBoardNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get cards => $_getList(1);

  @$pb.TagNumber(3)
  $core.Map<$core.int, BoardCardRank> get playerRank => $_getMap(2);
}

class Winner extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Winner', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatNo', $pb.PbFieldType.OU3)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  Winner._() : super();
  factory Winner({
    $core.int? seatNo,
    $core.double? amount,
  }) {
    final _result = create();
    if (seatNo != null) {
      _result.seatNo = seatNo;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    return _result;
  }
  factory Winner.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Winner.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Winner clone() => Winner()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Winner copyWith(void Function(Winner) updates) => super.copyWith((message) => updates(message as Winner)) as Winner; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Winner create() => Winner._();
  Winner createEmptyInstance() => create();
  static $pb.PbList<Winner> createRepeated() => $pb.PbList<Winner>();
  @$core.pragma('dart2js:noInline')
  static Winner getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Winner>(create);
  static Winner? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seatNo => $_getIZ(0);
  @$pb.TagNumber(1)
  set seatNo($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSeatNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeatNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);
}

class BoardWinner extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BoardWinner', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boardNo', $pb.PbFieldType.OU3)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.OD)
    ..m<$core.int, Winner>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hiWinners', entryClassName: 'BoardWinner.HiWinnersEntry', keyFieldType: $pb.PbFieldType.OU3, valueFieldType: $pb.PbFieldType.OM, valueCreator: Winner.create, packageName: const $pb.PackageName('game'))
    ..m<$core.int, Winner>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lowWinners', entryClassName: 'BoardWinner.LowWinnersEntry', keyFieldType: $pb.PbFieldType.OU3, valueFieldType: $pb.PbFieldType.OM, valueCreator: Winner.create, packageName: const $pb.PackageName('game'))
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hiRankText')
    ..hasRequiredFields = false
  ;

  BoardWinner._() : super();
  factory BoardWinner({
    $core.int? boardNo,
    $core.double? amount,
    $core.Map<$core.int, Winner>? hiWinners,
    $core.Map<$core.int, Winner>? lowWinners,
    $core.String? hiRankText,
  }) {
    final _result = create();
    if (boardNo != null) {
      _result.boardNo = boardNo;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (hiWinners != null) {
      _result.hiWinners.addAll(hiWinners);
    }
    if (lowWinners != null) {
      _result.lowWinners.addAll(lowWinners);
    }
    if (hiRankText != null) {
      _result.hiRankText = hiRankText;
    }
    return _result;
  }
  factory BoardWinner.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BoardWinner.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BoardWinner clone() => BoardWinner()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BoardWinner copyWith(void Function(BoardWinner) updates) => super.copyWith((message) => updates(message as BoardWinner)) as BoardWinner; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BoardWinner create() => BoardWinner._();
  BoardWinner createEmptyInstance() => create();
  static $pb.PbList<BoardWinner> createRepeated() => $pb.PbList<BoardWinner>();
  @$core.pragma('dart2js:noInline')
  static BoardWinner getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BoardWinner>(create);
  static BoardWinner? _defaultInstance;

  @$pb.TagNumber(2)
  $core.int get boardNo => $_getIZ(0);
  @$pb.TagNumber(2)
  set boardNo($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasBoardNo() => $_has(0);
  @$pb.TagNumber(2)
  void clearBoardNo() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(3)
  set amount($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.Map<$core.int, Winner> get hiWinners => $_getMap(2);

  @$pb.TagNumber(5)
  $core.Map<$core.int, Winner> get lowWinners => $_getMap(3);

  @$pb.TagNumber(6)
  $core.String get hiRankText => $_getSZ(4);
  @$pb.TagNumber(6)
  set hiRankText($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasHiRankText() => $_has(4);
  @$pb.TagNumber(6)
  void clearHiRankText() => clearField(6);
}

class PotWinnersV2 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PotWinnersV2', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'potNo', $pb.PbFieldType.OU3)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.OD)
    ..pc<BoardWinner>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boardWinners', $pb.PbFieldType.PM, subBuilder: BoardWinner.create)
    ..p<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seatsInPots', $pb.PbFieldType.KU3)
    ..hasRequiredFields = false
  ;

  PotWinnersV2._() : super();
  factory PotWinnersV2({
    $core.int? potNo,
    $core.double? amount,
    $core.Iterable<BoardWinner>? boardWinners,
    $core.Iterable<$core.int>? seatsInPots,
  }) {
    final _result = create();
    if (potNo != null) {
      _result.potNo = potNo;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (boardWinners != null) {
      _result.boardWinners.addAll(boardWinners);
    }
    if (seatsInPots != null) {
      _result.seatsInPots.addAll(seatsInPots);
    }
    return _result;
  }
  factory PotWinnersV2.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PotWinnersV2.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PotWinnersV2 clone() => PotWinnersV2()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PotWinnersV2 copyWith(void Function(PotWinnersV2) updates) => super.copyWith((message) => updates(message as PotWinnersV2)) as PotWinnersV2; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PotWinnersV2 create() => PotWinnersV2._();
  PotWinnersV2 createEmptyInstance() => create();
  static $pb.PbList<PotWinnersV2> createRepeated() => $pb.PbList<PotWinnersV2>();
  @$core.pragma('dart2js:noInline')
  static PotWinnersV2 getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PotWinnersV2>(create);
  static PotWinnersV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get potNo => $_getIZ(0);
  @$pb.TagNumber(1)
  set potNo($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPotNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearPotNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<BoardWinner> get boardWinners => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$core.int> get seatsInPots => $_getList(3);
}

class HandResultV2 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HandResultV2', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..pc<Board>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boards', $pb.PbFieldType.PM, subBuilder: Board.create)
    ..pc<PotWinnersV2>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'potWinners', $pb.PbFieldType.PM, subBuilder: PotWinnersV2.create)
    ..hasRequiredFields = false
  ;

  HandResultV2._() : super();
  factory HandResultV2({
    $core.Iterable<Board>? boards,
    $core.Iterable<PotWinnersV2>? potWinners,
  }) {
    final _result = create();
    if (boards != null) {
      _result.boards.addAll(boards);
    }
    if (potWinners != null) {
      _result.potWinners.addAll(potWinners);
    }
    return _result;
  }
  factory HandResultV2.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HandResultV2.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HandResultV2 clone() => HandResultV2()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HandResultV2 copyWith(void Function(HandResultV2) updates) => super.copyWith((message) => updates(message as HandResultV2)) as HandResultV2; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandResultV2 create() => HandResultV2._();
  HandResultV2 createEmptyInstance() => create();
  static $pb.PbList<HandResultV2> createRepeated() => $pb.PbList<HandResultV2>();
  @$core.pragma('dart2js:noInline')
  static HandResultV2 getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HandResultV2>(create);
  static HandResultV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Board> get boards => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<PotWinnersV2> get potWinners => $_getList(1);
}

class HandPlayerBalance extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HandPlayerBalance', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'before', $pb.PbFieldType.OD)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'after', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  HandPlayerBalance._() : super();
  factory HandPlayerBalance({
    $core.double? before,
    $core.double? after,
  }) {
    final _result = create();
    if (before != null) {
      _result.before = before;
    }
    if (after != null) {
      _result.after = after;
    }
    return _result;
  }
  factory HandPlayerBalance.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HandPlayerBalance.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HandPlayerBalance clone() => HandPlayerBalance()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HandPlayerBalance copyWith(void Function(HandPlayerBalance) updates) => super.copyWith((message) => updates(message as HandPlayerBalance)) as HandPlayerBalance; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HandPlayerBalance create() => HandPlayerBalance._();
  HandPlayerBalance createEmptyInstance() => create();
  static $pb.PbList<HandPlayerBalance> createRepeated() => $pb.PbList<HandPlayerBalance>();
  @$core.pragma('dart2js:noInline')
  static HandPlayerBalance getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HandPlayerBalance>(create);
  static HandPlayerBalance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get before => $_getN(0);
  @$pb.TagNumber(1)
  set before($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBefore() => $_has(0);
  @$pb.TagNumber(1)
  void clearBefore() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get after => $_getN(1);
  @$pb.TagNumber(2)
  set after($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfter() => clearField(2);
}

class PlayerHandInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PlayerHandInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'game'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..p<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cards', $pb.PbFieldType.KU3)
    ..e<HandStatus>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playedUntil', $pb.PbFieldType.OE, defaultOrMaker: HandStatus.HandStatus_UNKNOWN, valueOf: HandStatus.valueOf, enumValues: HandStatus.values)
    ..aOM<HandPlayerBalance>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'balance', subBuilder: HandPlayerBalance.create)
    ..p<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hhCards', $pb.PbFieldType.KU3)
    ..a<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hhRank', $pb.PbFieldType.OU3)
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'received', $pb.PbFieldType.OD)
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rakePaid', $pb.PbFieldType.OD)
    ..a<$core.double>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'potContribution', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  PlayerHandInfo._() : super();
  factory PlayerHandInfo({
    $fixnum.Int64? id,
    $core.Iterable<$core.int>? cards,
    HandStatus? playedUntil,
    HandPlayerBalance? balance,
    $core.Iterable<$core.int>? hhCards,
    $core.int? hhRank,
    $core.double? received,
    $core.double? rakePaid,
    $core.double? potContribution,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (cards != null) {
      _result.cards.addAll(cards);
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
    if (potContribution != null) {
      _result.potContribution = potContribution;
    }
    return _result;
  }
  factory PlayerHandInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerHandInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayerHandInfo clone() => PlayerHandInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayerHandInfo copyWith(void Function(PlayerHandInfo) updates) => super.copyWith((message) => updates(message as PlayerHandInfo)) as PlayerHandInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerHandInfo create() => PlayerHandInfo._();
  PlayerHandInfo createEmptyInstance() => create();
  static $pb.PbList<PlayerHandInfo> createRepeated() => $pb.PbList<PlayerHandInfo>();
  @$core.pragma('dart2js:noInline')
  static PlayerHandInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerHandInfo>(create);
  static PlayerHandInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get cards => $_getList(1);

  @$pb.TagNumber(5)
  HandStatus get playedUntil => $_getN(2);
  @$pb.TagNumber(5)
  set playedUntil(HandStatus v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasPlayedUntil() => $_has(2);
  @$pb.TagNumber(5)
  void clearPlayedUntil() => clearField(5);

  @$pb.TagNumber(6)
  HandPlayerBalance get balance => $_getN(3);
  @$pb.TagNumber(6)
  set balance(HandPlayerBalance v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasBalance() => $_has(3);
  @$pb.TagNumber(6)
  void clearBalance() => clearField(6);
  @$pb.TagNumber(6)
  HandPlayerBalance ensureBalance() => $_ensure(3);

  @$pb.TagNumber(7)
  $core.List<$core.int> get hhCards => $_getList(4);

  @$pb.TagNumber(8)
  $core.int get hhRank => $_getIZ(5);
  @$pb.TagNumber(8)
  set hhRank($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(8)
  $core.bool hasHhRank() => $_has(5);
  @$pb.TagNumber(8)
  void clearHhRank() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get received => $_getN(6);
  @$pb.TagNumber(9)
  set received($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(9)
  $core.bool hasReceived() => $_has(6);
  @$pb.TagNumber(9)
  void clearReceived() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get rakePaid => $_getN(7);
  @$pb.TagNumber(10)
  set rakePaid($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(10)
  $core.bool hasRakePaid() => $_has(7);
  @$pb.TagNumber(10)
  void clearRakePaid() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get potContribution => $_getN(8);
  @$pb.TagNumber(11)
  set potContribution($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(11)
  $core.bool hasPotContribution() => $_has(8);
  @$pb.TagNumber(11)
  void clearPotContribution() => clearField(11);
}

