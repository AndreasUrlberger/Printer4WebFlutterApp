class PrusalinkData {
  Temperature temperature;

  PrusalinkData({
    required this.temperature,
  });

  factory PrusalinkData.fromJson(Map<String, dynamic> json) {
    return PrusalinkData(
        temperature: Temperature.fromJson(json["temperature"]));
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
