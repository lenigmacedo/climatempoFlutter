import 'dart:async';
import 'dart:math';

import 'package:climatempo_teste/models/clima_atual.dart';
import 'package:climatempo_teste/models/clima_data.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  final double latitude;
  final double longitude;
  HomePage({this.latitude, this.longitude}) : super();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getClimate();
    clima = fetchData();
    setBackground();
    getFutureClimate();
  }

  String city;
  Future<ClimaAtual> clima;
  List<ClimaData> proximosClimas = List<ClimaData>();
  Image background = Image.asset(
    "assets/images/fundochuva.jpg",
    fit: BoxFit.fitWidth,
    key: ValueKey(2),
    width: 800,
  );
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Image backgroundRain;
  Image backgroundCloudy;
  Image backgroundSun;

  @override
  Widget build(BuildContext context) {
    backgroundRain = Image.asset(
      "assets/images/fundochuva.jpg",
      fit: BoxFit.fitWidth,
      key: ValueKey(2),
      width: MediaQuery.of(context).size.width,
    );

    backgroundCloudy = Image.asset("assets/images/fundonublado.jpg",
        fit: BoxFit.cover,
        key: ValueKey(3),
        width: MediaQuery.of(context).size.width);

    backgroundSun = Image.asset("assets/images/fundosol.jpg",
        fit: BoxFit.cover,
        key: ValueKey(4),
        width: MediaQuery.of(context).size.width);

    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: AnimatedSwitcher(
            child: background,
            duration: Duration(seconds: 1),
            key: ValueKey(1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, top: 25),
          child: SafeArea(
            child: FutureBuilder<ClimaAtual>(
              future: clima,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(city,
                                    style: GoogleFonts.manrope(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Icon(
                                setIcon(snapshot.data.condition),
                                color: Colors.white,
                                size: 120,
                              ),
                              Text(
                                "${snapshot.data.temperature.toString()}°",
                                style: GoogleFonts.manrope(
                                    color: Colors.white, fontSize: 66),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20,bottom: 20),
                              child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    snapshot.data.condition,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.manrope(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  Text(
                                    "Umidade em ${snapshot.data.humidity}%",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.manrope(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  Text(
                                    "Sensação térmica em ${snapshot.data.sensation}°",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.manrope(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 80, 10, 0),
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Card(
                                  color: Colors.white.withOpacity(0.85),
                                  child: Container(
                                    width: 150,
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            getWeekDay(
                                                proximosClimas[index].dateBr),
                                            style: GoogleFonts.manrope(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Icon(
                                            setIcon(proximosClimas[index]
                                                .textIcon['text']['pt']),
                                            size: 24,
                                          ),
                                        ),
                                        Text(
                                          "${proximosClimas[index].temperature['min']}° / ${proximosClimas[index].temperature['max']}°",
                                          style: GoogleFonts.manrope(
                                              fontSize: 26,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            proximosClimas[index]
                                                .textIcon['text']['pt'],
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.manrope(
                                                fontSize: 17),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          },
                          itemCount: proximosClimas.length,
                        ),
                      )
                    ],
                  );
                }

                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                );
              },
            ),
          ),
        )
      ],
    ));
  }

  void getFutureClimate() async {
    final response = await Dio().get(
        "http://apiadvisor.climatempo.com.br/api/v1/forecast/locale/3477/days/15?token=5e0f9f6825b9b6fa3774b73da2808f6d");

    for (Map<String, dynamic> json in response.data['data']) {
      ClimaData clima = ClimaData.fromJson(json);

      String getDate = DateFormat("dd/MM/yyyy").format(DateTime.now());

      if (clima.dateBr.compareTo(getDate) == 1) {
        proximosClimas.add(clima);
      }
    }
  }

  Future<void> getClimate() async {
    List<Placemark> p = await geolocator.placemarkFromCoordinates(
        widget.latitude, widget.longitude);

    Placemark place = p[0];

    setState(() {
      //Devido á bug no pacote, o nome da cidade está vindo errado
      city = place.subAdministrativeArea;
    });
  }

  String getWeekDay(String data) {
    DateTime stringToDate = new DateFormat("dd/MM/yyyy").parse(data);

    switch (stringToDate.weekday) {
      case 1:
        return "Seg";
        break;
      case 2:
        return "Ter";
        break;
      case 3:
        return "Qua";
        break;
      case 4:
        return "Qui";
        break;
      case 5:
        return "Sex";
        break;
      case 6:
        return "Sáb";
        break;
      case 7:
        return "Dom";
        break;
    }
    return '';
  }

  IconData setIcon(String condition) {
    condition = condition.toLowerCase();

    if (condition.contains('sol') &&
        condition.contains('nuvens') &&
        condition.contains('chuva')) {
      return FontAwesomeIcons.cloudSunRain;
    } else if (condition.contains('sol') && condition.contains('nuvens')) {
      return FontAwesomeIcons.cloudSun;
    } else if (condition.contains('sol')) {
      return Icons.wb_sunny;
    } else if (condition.contains('sol') && condition.contains('chuva')) {
      return FontAwesomeIcons.cloudRain;
    } else {
      return Icons.cloud;
    }
  }

  void setBackground() {
    Random rng = Random();
    Image x;

    Timer.periodic(Duration(seconds: 20), (Timer t) {
      switch (rng.nextInt(3)) {
        case 0:
          x = backgroundCloudy;
          break;
        case 1:
          x = backgroundRain;
          break;
        case 2:
          x = backgroundSun;
          break;
      }

      setState(() {
        background = x;
      });
    });
  }

  Future<ClimaAtual> fetchData() async {
    final response = await Dio().get(
        "http://apiadvisor.climatempo.com.br/api/v1/weather/locale/3477/current?&token=5e0f9f6825b9b6fa3774b73da2808f6d");
    return ClimaAtual.fromJson(response.data['data']);
  }
}
