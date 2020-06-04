class ClimaAtual {
  int temperature;
  String windDirection;
  int windVelocity;
  int humidity;
  String condition;
  int pressure;
  String icon;
  int sensation;
  String date;

  ClimaAtual(
      {this.temperature,
      this.windDirection,
      this.windVelocity,
      this.humidity,
      this.condition,
      this.pressure,
      this.icon,
      this.sensation,
      this.date});

  ClimaAtual.fromJson(Map<String, dynamic> json) {
    temperature = json['temperature'];
    windDirection = json['wind_direction'];
    windVelocity = json['wind_velocity'];
    humidity = json['humidity'];
    condition = json['condition'];
    pressure = json['pressure'];
    icon = json['icon'];
    sensation = json['sensation'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temperature'] = this.temperature;
    data['wind_direction'] = this.windDirection;
    data['wind_velocity'] = this.windVelocity;
    data['humidity'] = this.humidity;
    data['condition'] = this.condition;
    data['pressure'] = this.pressure;
    data['icon'] = this.icon;
    data['sensation'] = this.sensation;
    data['date'] = this.date;
    return data;
  }
}
