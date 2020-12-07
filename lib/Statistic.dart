class Statistic {
   int temperature;
   int environmentMoisture;
   int soilMoisture;

  Statistic({this.temperature, this.environmentMoisture, this.soilMoisture});

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
        temperature: json['temperature'],
        environmentMoisture: json['environmentMoisture'],
        soilMoisture: json['soilMoisture']);
  }

  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'environmentMoisture': environmentMoisture,
        'soilMoisture': soilMoisture
      };
}
