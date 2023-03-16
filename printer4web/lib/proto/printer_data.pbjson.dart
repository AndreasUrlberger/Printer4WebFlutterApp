///
//  Generated code. Do not modify.
//  source: lib/proto/printer_data.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use statusRequestDescriptor instead')
const StatusRequest$json = const {
  '1': 'StatusRequest',
  '2': const [
    const {'1': 'include_print_configs', '3': 1, '4': 1, '5': 8, '10': 'includePrintConfigs'},
  ],
};

/// Descriptor for `StatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statusRequestDescriptor = $convert.base64Decode('Cg1TdGF0dXNSZXF1ZXN0EjIKFWluY2x1ZGVfcHJpbnRfY29uZmlncxgBIAEoCFITaW5jbHVkZVByaW50Q29uZmlncw==');
@$core.Deprecated('Use addPrintConfigDescriptor instead')
const AddPrintConfig$json = const {
  '1': 'AddPrintConfig',
  '2': const [
    const {'1': 'print_config', '3': 1, '4': 1, '5': 11, '6': '.Printer.PrintConfig', '10': 'printConfig'},
  ],
};

/// Descriptor for `AddPrintConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addPrintConfigDescriptor = $convert.base64Decode('Cg5BZGRQcmludENvbmZpZxI3CgxwcmludF9jb25maWcYASABKAsyFC5QcmludGVyLlByaW50Q29uZmlnUgtwcmludENvbmZpZw==');
@$core.Deprecated('Use changeTempControlDescriptor instead')
const ChangeTempControl$json = const {
  '1': 'ChangeTempControl',
  '2': const [
    const {'1': 'isActive', '3': 1, '4': 1, '5': 8, '10': 'isActive'},
  ],
};

/// Descriptor for `ChangeTempControl`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeTempControlDescriptor = $convert.base64Decode('ChFDaGFuZ2VUZW1wQ29udHJvbBIaCghpc0FjdGl2ZRgBIAEoCFIIaXNBY3RpdmU=');
@$core.Deprecated('Use removePrintConfigDescriptor instead')
const RemovePrintConfig$json = const {
  '1': 'RemovePrintConfig',
  '2': const [
    const {'1': 'print_config', '3': 1, '4': 1, '5': 11, '6': '.Printer.PrintConfig', '10': 'printConfig'},
  ],
};

/// Descriptor for `RemovePrintConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePrintConfigDescriptor = $convert.base64Decode('ChFSZW1vdmVQcmludENvbmZpZxI3CgxwcmludF9jb25maWcYASABKAsyFC5QcmludGVyLlByaW50Q29uZmlnUgtwcmludENvbmZpZw==');
@$core.Deprecated('Use printConfigDescriptor instead')
const PrintConfig$json = const {
  '1': 'PrintConfig',
  '2': const [
    const {'1': 'temperature', '3': 1, '4': 1, '5': 5, '10': 'temperature'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `PrintConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List printConfigDescriptor = $convert.base64Decode('CgtQcmludENvbmZpZxIgCgt0ZW1wZXJhdHVyZRgBIAEoBVILdGVtcGVyYXR1cmUSEgoEbmFtZRgCIAEoCVIEbmFtZQ==');
@$core.Deprecated('Use printerStatusDescriptor instead')
const PrinterStatus$json = const {
  '1': 'PrinterStatus',
  '2': const [
    const {'1': 'is_temp_control_active', '3': 1, '4': 1, '5': 8, '10': 'isTempControlActive'},
    const {'1': 'temperature_outside', '3': 2, '4': 1, '5': 2, '10': 'temperatureOutside'},
    const {'1': 'temperature_inside_top', '3': 3, '4': 1, '5': 2, '10': 'temperatureInsideTop'},
    const {'1': 'temperature_inside_bottom', '3': 4, '4': 1, '5': 2, '10': 'temperatureInsideBottom'},
    const {'1': 'current_print_config', '3': 5, '4': 1, '5': 11, '6': '.Printer.PrintConfig', '10': 'currentPrintConfig'},
    const {'1': 'print_configs', '3': 6, '4': 3, '5': 11, '6': '.Printer.PrintConfig', '10': 'printConfigs'},
  ],
};

/// Descriptor for `PrinterStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List printerStatusDescriptor = $convert.base64Decode('Cg1QcmludGVyU3RhdHVzEjMKFmlzX3RlbXBfY29udHJvbF9hY3RpdmUYASABKAhSE2lzVGVtcENvbnRyb2xBY3RpdmUSLwoTdGVtcGVyYXR1cmVfb3V0c2lkZRgCIAEoAlISdGVtcGVyYXR1cmVPdXRzaWRlEjQKFnRlbXBlcmF0dXJlX2luc2lkZV90b3AYAyABKAJSFHRlbXBlcmF0dXJlSW5zaWRlVG9wEjoKGXRlbXBlcmF0dXJlX2luc2lkZV9ib3R0b20YBCABKAJSF3RlbXBlcmF0dXJlSW5zaWRlQm90dG9tEkYKFGN1cnJlbnRfcHJpbnRfY29uZmlnGAUgASgLMhQuUHJpbnRlci5QcmludENvbmZpZ1ISY3VycmVudFByaW50Q29uZmlnEjkKDXByaW50X2NvbmZpZ3MYBiADKAsyFC5QcmludGVyLlByaW50Q29uZmlnUgxwcmludENvbmZpZ3M=');
