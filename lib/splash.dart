import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:glam0/home/home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();

}
class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    /// Logo with animated Colorize text
     return SplashScreenView(
      navigateRoute: Home(),
      duration: 8000,
      imageSize: 80,
      imageSrc: 'Capture.PNG',
      text: "G L A M",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40,
      ),
      colors: [
        Colors.red,
        Colors.pink,
      ],
      backgroundColor: Colors.white,
    );
  }


}