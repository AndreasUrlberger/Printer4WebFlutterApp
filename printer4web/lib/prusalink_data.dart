class PrusalinkPrinterData {
  Temperature temperature;

  PrusalinkPrinterData({
    required this.temperature,
  });

  factory PrusalinkPrinterData.fromJson(Map<String, dynamic> json) {
    return PrusalinkPrinterData(
      temperature: Temperature.fromJson(
        (json["temperature"] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }
}

class Temperature {
  Nozzle nozzle;
  Heatbed heatbed;

  Temperature({required this.nozzle, required this.heatbed});

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(
      nozzle: Nozzle.fromJson(
        (json["tool0"] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      heatbed: Heatbed.fromJson(
        (json["bed"] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }
}

class Nozzle {
  double actualTemp;
  double targetTemp;

  Nozzle({required this.actualTemp, required this.targetTemp});

  factory Nozzle.fromJson(Map<String, dynamic> json) {
    return Nozzle(
      actualTemp: (json["actual"] as num?)?.toDouble() ?? 0,
      targetTemp: (json["target"] as num?)?.toDouble() ?? 0,
    );
  }
}

class Heatbed {
  double actualTemp;
  double targetTemp;

  Heatbed({required this.actualTemp, required this.targetTemp});

  factory Heatbed.fromJson(Map<String, dynamic> json) {
    return Heatbed(
      actualTemp: (json["actual"] as num?)?.toDouble() ?? 0,
      targetTemp: (json["target"] as num?)?.toDouble() ?? 0,
    );
  }
}

// Job json example: {
//
//    "job":{
//       "estimatedPrintTime":759,
//       "averagePrintTime":null,
//       "lastPrintTime":null,
//       "filament":null,
//       "file":{
//          "name":"Positionssensor A Halter_0.1mm_PETG_MK3S_13m.gcode",
//          "path":"/PrusaLink gcodes/Schreibtisch/Positionssensor A Halter_0.1mm_PETG_MK3S_13m.gcode",
//          "size":580285,
//          "origin":"local",
//          "date":1678733675,
//          "display":"Positionssensor A Halter_0.1mm_PETG_MK3S_13m.gcode"
//       },
//       "user":"_api"
//    },
//    "progress":{
//       "completion":null,
//       "filepos":0,
//       "printTime":null,
//       "printTimeLeft":null,
//       "printTimeLeftOrigin":"estimate",
//       "pos_z_mm":35.5,
//       "printSpeed":100,
//       "flow_factor":100
//    },
//    "state":"Operational"
// }

class PrusalinkJobData {
  Job? job;
  Progress? progress;
  String state;

  PrusalinkJobData({
    required this.job,
    required this.progress,
    required this.state,
  });

  factory PrusalinkJobData.fromJson(Map<String, dynamic> json) {
    final jobJson = (json["job"] as Map?)?.cast<String, dynamic>();
    final progressJson = (json["progress"] as Map?)?.cast<String, dynamic>();

    return PrusalinkJobData(
      job: jobJson == null ? null : Job.fromJson(jobJson),
      progress: progressJson == null ? null : Progress.fromJson(progressJson),
      state: json["state"] as String? ?? "Unknown",
    );
  }

  @override
  String toString() {
    return 'Job: $job, Progress: $progress, State: $state';
  }
}

class Job {
  int? estimatedPrintTime;
  int? averagePrintTime;
  int? lastPrintTime;
  File file;

  Job({
    required this.estimatedPrintTime,
    required this.averagePrintTime,
    required this.lastPrintTime,
    required this.file,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      estimatedPrintTime: json["estimatedPrintTime"] as int?,
      averagePrintTime: json["averagePrintTime"] as int?,
      lastPrintTime: json["lastPrintTime"] as int?,
      file: File.fromJson(json["file"]),
    );
  }

  @override
  String toString() {
    return 'Estimated print time: $estimatedPrintTime, Average print time: $averagePrintTime, Last print time: $lastPrintTime, File: ${file.toString()}';
  }
}

class File {
  String? name;
  String? path;
  int? size;
  String? origin;
  int? date;
  String? display;

  File({
    required this.name,
    required this.path,
    required this.size,
    required this.origin,
    required this.date,
    required this.display,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      name: json["name"] as String?,
      path: json["path"] as String?,
      size: json["size"] as int?,
      origin: json["origin"] as String?,
      date: json["date"] as int?,
      display: json["display"] as String?,
    );
  }

  @override
  String toString() {
    return 'Name: $name, Path: $path, Size: $size, Origin: $origin, Date: $date, Display: $display';
  }
}

class Progress {
  double? completion;
  int? printTime;
  int? printTimeLeft;

  Progress({
    required this.completion,
    required this.printTime,
    required this.printTimeLeft,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    // Print printTimeLeft
    return Progress(
      completion: json["completion"] as double?,
      printTime: json["printTime"] as int?,
      printTimeLeft: json["printTimeLeft"] as int?,
    );
  }

  @override
  String toString() {
    return 'Completion: $completion, Print time: $printTime, Print time left: $printTimeLeft';
  }
}

// Files json example: {
//   "origin": "local",
//   "name": "Positionssensor A Halter_0.1mm_PETG_MK3S_13m.gcode",
//   "path": "/PrusaLink gcodes/Schreibtisch/Positionssensor A Halter_0.1mm_PETG_MK3S_13m.gcode",
//   "type": "machinecode",
//   "typePath": [
//     "machinecode",
//     "gcode"
//   ],
//   "refs": {
//     "resource": "/api/files/local/PrusaLink gcodes/Schreibtisch/Positionssensor A Halter_0.1mm_PETG_MK3S_13m.gcode",
//     "download": "/api/files/local/PrusaLink gcodes/Schreibtisch/Positionssensor A Halter_0.1mm_PETG_MK3S_13m.gcode/raw",
//     "thumbnailSmall": null,
//     "thumbnailBig": "/api/thumbnails/PrusaLink gcodes/Schreibtisch/Positionssensor A Halter_0.1mm_PETG_MK3S_13m.gcode.orig.png"
//   },
//   "size": 580285,
//   "date": 1678733675,
//   "gcodeAnalysis": {
//     "estimatedPrintTime": 759,
//     "material": "PETG",
//     "layerHeight": 0.1
//   }
// }

class PrusalinkFilesData {
  String origin;
  String name;
  String path;
  String type;
  List<String> typePath;
  Refs refs;
  int size;
  int date;
  GcodeAnalysis gcodeAnalysis;

  PrusalinkFilesData({
    required this.origin,
    required this.name,
    required this.path,
    required this.type,
    required this.typePath,
    required this.refs,
    required this.size,
    required this.date,
    required this.gcodeAnalysis,
  });

  factory PrusalinkFilesData.fromJson(Map<String, dynamic> json) {
    return PrusalinkFilesData(
      origin: json["origin"] as String,
      name: json["name"] as String,
      path: json["path"] as String,
      type: json["type"] as String,
      typePath: List<String>.from(json["typePath"].map((x) => x)),
      refs: Refs.fromJson(json["refs"]),
      size: json["size"] as int,
      date: json["date"] as int,
      gcodeAnalysis: GcodeAnalysis.fromJson(json["gcodeAnalysis"]),
    );
  }
}

class GcodeAnalysis {
  int estimatedPrintTime;
  String material;
  double layerHeight;

  GcodeAnalysis({
    required this.estimatedPrintTime,
    required this.material,
    required this.layerHeight,
  });

  factory GcodeAnalysis.fromJson(Map<String, dynamic> json) {
    return GcodeAnalysis(
      estimatedPrintTime: json["estimatedPrintTime"] as int,
      material: json["material"] as String,
      layerHeight: json["layerHeight"] as double,
    );
  }
}

class Refs {
  String resource;
  String download;
  dynamic thumbnailSmall;
  String thumbnailBig;

  Refs({
    required this.resource,
    required this.download,
    required this.thumbnailSmall,
    required this.thumbnailBig,
  });

  factory Refs.fromJson(Map<String, dynamic> json) {
    return Refs(
      resource: json["resource"] as String,
      download: json["download"] as String,
      thumbnailSmall: json["thumbnailSmall"],
      thumbnailBig: json["thumbnailBig"] as String,
    );
  }
}