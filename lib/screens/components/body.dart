import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_facchi/screens/routes.dart';

import '../home.dart';


class Body extends StatefulWidget {
  static String routeName = "/body";
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Time to build goods habits!",
      "image": "assets/images/splash_1.jpg",
    },
    {
      "text": "scritta seconda",
      "image": "assets/images/splash_1.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity, //per accentrare
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                //permette di creare un visualizzatore di immagini o schede, scorrendole una alla volta.
                itemCount: splashData.length,
                //contatore, in base alla lunghezza del vettore contenente immagini e testi
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  //index è l'indice che ha il valore del Count e l'altro parametro è la chiave
                  text: splashData[index]["text"],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(splashData.length,
                              (index) => buildDots(index: index)),
                    ),
                    Spacer(flex: 2),
                    DefaultButton(
                      text: "Avanti",
                      press: (){
                        Navigator.pushNamed(context, HomePage.routeName );
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDots({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.purple : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);
  final String text;
  final  VoidCallback  press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.purple,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    required this.text,
    required this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          "ToDo Facchi",
          style: TextStyle(
              fontSize: 36, color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        Text(
          text!,
          //il ! è un null check perchè il tipo String non può essere nullo
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 2), //aggiunge spazio
        Image.asset(
          image!,
          height: 265,
          width: 235,
        ),
      ],
    );
  }
}