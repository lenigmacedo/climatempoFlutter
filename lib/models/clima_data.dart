class ClimaData {
  String date;
  String dateBr;
  Map<String, dynamic> humidity;
  Map<String, dynamic> rain;
  Map<String, dynamic> wind;
  Map<String, dynamic> uv;
  Map<String, dynamic> thermalSensation;
  Map<String, dynamic> textIcon;
  Map<String, dynamic> temperature;
  Map<String, dynamic> cloudCoverage;
  Map<String, dynamic> sun;

  ClimaData(
      {this.date,
      this.dateBr,
      this.humidity,
      this.rain,
      this.wind,
      this.uv,
      this.thermalSensation,
      this.textIcon,
      this.temperature,
      this.cloudCoverage,
      this.sun});

  ClimaData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    dateBr = json['date_br'];
    humidity = json['humidity'];
    rain = json['rain'];
    wind = json['wind'];
    uv = json['uv'];
    thermalSensation = json['thermal_sensation'];
    textIcon = json['text_icon'];
    temperature = json['temperature'];
    cloudCoverage = json['cloud_coverage'];
    sun = json['sun'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['date_br'] = this.dateBr;

    data['humidity'] = this.humidity;

    data['rain'] = this.rain;

    data['wind'] = this.wind;

    data['uv'] = this.uv;

    data['thermal_sensation'] = this.thermalSensation;

    data['text_icon'] = this.textIcon;

    data['temperature'] = this.temperature;

    data['cloud_coverage'] = this.cloudCoverage;

    data['sun'] = this.sun;

    return data;
  }
}
