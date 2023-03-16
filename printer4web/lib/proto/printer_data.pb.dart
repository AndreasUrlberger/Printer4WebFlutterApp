///
//  Generated code. Do not modify.
//  source: lib/proto/printer_data.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class StatusRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StatusRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Printer'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'includePrintConfigs')
    ..hasRequiredFields = false
  ;

  StatusRequest._() : super();
  factory StatusRequest({
    $core.bool? includePrintConfigs,
  }) {
    final _result = create();
    if (includePrintConfigs != null) {
      _result.includePrintConfigs = includePrintConfigs;
    }
    return _result;
  }
  factory StatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StatusRequest clone() => StatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StatusRequest copyWith(void Function(StatusRequest) updates) => super.copyWith((message) => updates(message as StatusRequest)) as StatusRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StatusRequest create() => StatusRequest._();
  StatusRequest createEmptyInstance() => create();
  static $pb.PbList<StatusRequest> createRepeated() => $pb.PbList<StatusRequest>();
  @$core.pragma('dart2js:noInline')
  static StatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StatusRequest>(create);
  static StatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get includePrintConfigs => $_getBF(0);
  @$pb.TagNumber(1)
  set includePrintConfigs($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIncludePrintConfigs() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncludePrintConfigs() => clearField(1);
}

class AddPrintConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddPrintConfig', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Printer'), createEmptyInstance: create)
    ..aOM<PrintConfig>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'printConfig', subBuilder: PrintConfig.create)
    ..hasRequiredFields = false
  ;

  AddPrintConfig._() : super();
  factory AddPrintConfig({
    PrintConfig? printConfig,
  }) {
    final _result = create();
    if (printConfig != null) {
      _result.printConfig = printConfig;
    }
    return _result;
  }
  factory AddPrintConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddPrintConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddPrintConfig clone() => AddPrintConfig()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddPrintConfig copyWith(void Function(AddPrintConfig) updates) => super.copyWith((message) => updates(message as AddPrintConfig)) as AddPrintConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddPrintConfig create() => AddPrintConfig._();
  AddPrintConfig createEmptyInstance() => create();
  static $pb.PbList<AddPrintConfig> createRepeated() => $pb.PbList<AddPrintConfig>();
  @$core.pragma('dart2js:noInline')
  static AddPrintConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddPrintConfig>(create);
  static AddPrintConfig? _defaultInstance;

  @$pb.TagNumber(1)
  PrintConfig get printConfig => $_getN(0);
  @$pb.TagNumber(1)
  set printConfig(PrintConfig v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPrintConfig() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrintConfig() => clearField(1);
  @$pb.TagNumber(1)
  PrintConfig ensurePrintConfig() => $_ensure(0);
}

class ChangeTempControl extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChangeTempControl', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Printer'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isActive', protoName: 'isActive')
    ..hasRequiredFields = false
  ;

  ChangeTempControl._() : super();
  factory ChangeTempControl({
    $core.bool? isActive,
  }) {
    final _result = create();
    if (isActive != null) {
      _result.isActive = isActive;
    }
    return _result;
  }
  factory ChangeTempControl.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChangeTempControl.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChangeTempControl clone() => ChangeTempControl()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChangeTempControl copyWith(void Function(ChangeTempControl) updates) => super.copyWith((message) => updates(message as ChangeTempControl)) as ChangeTempControl; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ChangeTempControl create() => ChangeTempControl._();
  ChangeTempControl createEmptyInstance() => create();
  static $pb.PbList<ChangeTempControl> createRepeated() => $pb.PbList<ChangeTempControl>();
  @$core.pragma('dart2js:noInline')
  static ChangeTempControl getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChangeTempControl>(create);
  static ChangeTempControl? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isActive => $_getBF(0);
  @$pb.TagNumber(1)
  set isActive($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIsActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsActive() => clearField(1);
}

class RemovePrintConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemovePrintConfig', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Printer'), createEmptyInstance: create)
    ..aOM<PrintConfig>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'printConfig', subBuilder: PrintConfig.create)
    ..hasRequiredFields = false
  ;

  RemovePrintConfig._() : super();
  factory RemovePrintConfig({
    PrintConfig? printConfig,
  }) {
    final _result = create();
    if (printConfig != null) {
      _result.printConfig = printConfig;
    }
    return _result;
  }
  factory RemovePrintConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemovePrintConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemovePrintConfig clone() => RemovePrintConfig()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemovePrintConfig copyWith(void Function(RemovePrintConfig) updates) => super.copyWith((message) => updates(message as RemovePrintConfig)) as RemovePrintConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RemovePrintConfig create() => RemovePrintConfig._();
  RemovePrintConfig createEmptyInstance() => create();
  static $pb.PbList<RemovePrintConfig> createRepeated() => $pb.PbList<RemovePrintConfig>();
  @$core.pragma('dart2js:noInline')
  static RemovePrintConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemovePrintConfig>(create);
  static RemovePrintConfig? _defaultInstance;

  @$pb.TagNumber(1)
  PrintConfig get printConfig => $_getN(0);
  @$pb.TagNumber(1)
  set printConfig(PrintConfig v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPrintConfig() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrintConfig() => clearField(1);
  @$pb.TagNumber(1)
  PrintConfig ensurePrintConfig() => $_ensure(0);
}

class PrintConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PrintConfig', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Printer'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperature', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..hasRequiredFields = false
  ;

  PrintConfig._() : super();
  factory PrintConfig({
    $core.int? temperature,
    $core.String? name,
  }) {
    final _result = create();
    if (temperature != null) {
      _result.temperature = temperature;
    }
    if (name != null) {
      _result.name = name;
    }
    return _result;
  }
  factory PrintConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PrintConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PrintConfig clone() => PrintConfig()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PrintConfig copyWith(void Function(PrintConfig) updates) => super.copyWith((message) => updates(message as PrintConfig)) as PrintConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PrintConfig create() => PrintConfig._();
  PrintConfig createEmptyInstance() => create();
  static $pb.PbList<PrintConfig> createRepeated() => $pb.PbList<PrintConfig>();
  @$core.pragma('dart2js:noInline')
  static PrintConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrintConfig>(create);
  static PrintConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get temperature => $_getIZ(0);
  @$pb.TagNumber(1)
  set temperature($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTemperature() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemperature() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class PrinterStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PrinterStatus', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Printer'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isTempControlActive')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperatureOutside', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperatureInsideTop', $pb.PbFieldType.OF)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperatureInsideBottom', $pb.PbFieldType.OF)
    ..aOM<PrintConfig>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentPrintConfig', subBuilder: PrintConfig.create)
    ..pc<PrintConfig>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'printConfigs', $pb.PbFieldType.PM, subBuilder: PrintConfig.create)
    ..hasRequiredFields = false
  ;

  PrinterStatus._() : super();
  factory PrinterStatus({
    $core.bool? isTempControlActive,
    $core.double? temperatureOutside,
    $core.double? temperatureInsideTop,
    $core.double? temperatureInsideBottom,
    PrintConfig? currentPrintConfig,
    $core.Iterable<PrintConfig>? printConfigs,
  }) {
    final _result = create();
    if (isTempControlActive != null) {
      _result.isTempControlActive = isTempControlActive;
    }
    if (temperatureOutside != null) {
      _result.temperatureOutside = temperatureOutside;
    }
    if (temperatureInsideTop != null) {
      _result.temperatureInsideTop = temperatureInsideTop;
    }
    if (temperatureInsideBottom != null) {
      _result.temperatureInsideBottom = temperatureInsideBottom;
    }
    if (currentPrintConfig != null) {
      _result.currentPrintConfig = currentPrintConfig;
    }
    if (printConfigs != null) {
      _result.printConfigs.addAll(printConfigs);
    }
    return _result;
  }
  factory PrinterStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PrinterStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PrinterStatus clone() => PrinterStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PrinterStatus copyWith(void Function(PrinterStatus) updates) => super.copyWith((message) => updates(message as PrinterStatus)) as PrinterStatus; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PrinterStatus create() => PrinterStatus._();
  PrinterStatus createEmptyInstance() => create();
  static $pb.PbList<PrinterStatus> createRepeated() => $pb.PbList<PrinterStatus>();
  @$core.pragma('dart2js:noInline')
  static PrinterStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrinterStatus>(create);
  static PrinterStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isTempControlActive => $_getBF(0);
  @$pb.TagNumber(1)
  set isTempControlActive($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIsTempControlActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsTempControlActive() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get temperatureOutside => $_getN(1);
  @$pb.TagNumber(2)
  set temperatureOutside($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTemperatureOutside() => $_has(1);
  @$pb.TagNumber(2)
  void clearTemperatureOutside() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get temperatureInsideTop => $_getN(2);
  @$pb.TagNumber(3)
  set temperatureInsideTop($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTemperatureInsideTop() => $_has(2);
  @$pb.TagNumber(3)
  void clearTemperatureInsideTop() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get temperatureInsideBottom => $_getN(3);
  @$pb.TagNumber(4)
  set temperatureInsideBottom($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTemperatureInsideBottom() => $_has(3);
  @$pb.TagNumber(4)
  void clearTemperatureInsideBottom() => clearField(4);

  @$pb.TagNumber(5)
  PrintConfig get currentPrintConfig => $_getN(4);
  @$pb.TagNumber(5)
  set currentPrintConfig(PrintConfig v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCurrentPrintConfig() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrentPrintConfig() => clearField(5);
  @$pb.TagNumber(5)
  PrintConfig ensureCurrentPrintConfig() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.List<PrintConfig> get printConfigs => $_getList(5);
}

