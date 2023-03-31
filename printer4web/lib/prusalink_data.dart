class PrusalinkPrinterData {
  Temperature temperature;

  PrusalinkPrinterData({
    required this.temperature,
  });

  factory PrusalinkPrinterData.fromJson(Map<String, dynamic> json) {
    return PrusalinkPrinterData(temperature: Temperature.fromJson(json["temperature"]));
  }
}

class Temperature {
  Nozzle nozzle;
  Heatbed heatbed;

  Temperature({required this.nozzle, required this.heatbed});

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(
      nozzle: Nozzle.fromJson(json["tool0"]),
      heatbed: Heatbed.fromJson(json["bed"]),
    );
  }
}

class Nozzle {
  double actualTemp;
  double targetTemp;

  Nozzle({required this.actualTemp, required this.targetTemp});

  factory Nozzle.fromJson(Map<String, dynamic> json) {
    return Nozzle(
      actualTemp: json["actual"] as double,
      targetTemp: json["target"] as double,
    );
  }
}

class Heatbed {
  double actualTemp;
  double targetTemp;

  Heatbed({required this.actualTemp, required this.targetTemp});

  factory Heatbed.fromJson(Map<String, dynamic> json) {
    return Heatbed(
      actualTemp: json["actual"] as double,
      targetTemp: json["target"] as double,
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
  Job job;
  Progress progress;
  String state;

  PrusalinkJobData({
    required this.job,
    required this.progress,
    required this.state,
  });

  factory PrusalinkJobData.fromJson(Map<String, dynamic> json) {
    return PrusalinkJobData(
      job: Job.fromJson(json["job"]),
      progress: Progress.fromJson(json["progress"]),
      state: json["state"] as String,
    );
  }
}

class Job {
  int? estimatedPrintTime;
  int? averagePrintTime;
  int? lastPrintTime;
  File file;
  String user;

  Job({
    required this.estimatedPrintTime,
    required this.averagePrintTime,
    required this.lastPrintTime,
    required this.file,
    required this.user,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      estimatedPrintTime: json["estimatedPrintTime"] as int?,
      averagePrintTime: json["averagePrintTime"] as int?,
      lastPrintTime: json["lastPrintTime"] as int?,
      file: File.fromJson(json["file"]),
      user: json["user"] as String,
    );
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
}

class Progress {
  int? completion;
  int filepos;
  int? printTime;
  int? printTimeLeft;
  String printTimeLeftOrigin;
  double posZMm;
  int printSpeed;
  int flowFactor;

  Progress({
    required this.completion,
    required this.filepos,
    required this.printTime,
    required this.printTimeLeft,
    required this.printTimeLeftOrigin,
    required this.posZMm,
    required this.printSpeed,
    required this.flowFactor,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      completion: json["completion"] as int?,
      filepos: json["filepos"] as int,
      printTime: json["printTime"] as int?,
      printTimeLeft: json["printTimeLeft"] as int?,
      printTimeLeftOrigin: json["printTimeLeftOrigin"] as String,
      posZMm: json["pos_z_mm"] as double,
      printSpeed: json["printSpeed"] as int,
      flowFactor: json["flow_factor"] as int,
    );
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