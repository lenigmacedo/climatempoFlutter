import 'package:climatempo_teste/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff7B42A3).withOpacity(0.5),
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        ),
      ),
    );
  }

  checkPermissions() {
    geolocator.checkGeolocationPermissionStatus().then((value) async {
      double latitude;
      double longitude;

      await geolocator.getCurrentPosition().then((position) async {
        latitude = position.latitude;
        longitude = position.longitude;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(
            latitude: latitude,
            longitude: longitude,
          ),
        ),
      );
    });
  }
}
