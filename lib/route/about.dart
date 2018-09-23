import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/data_controller/functions.dart';
import 'package:innova_service_flutter_project/data_controller/quote.dart';
import 'package:innova_service_flutter_project/login_controller/login.dart';
import 'package:innova_service_flutter_project/main.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Chi Siamo"),centerTitle: true,),
    body:Stack(fit: StackFit.expand, children: <Widget>[
      Image.asset('asset/images/home_bg.png',
          fit: BoxFit.fitWidth, alignment: Alignment.topCenter),
      ListView(children: <Widget>[
        Stack(children: <Widget>[


          Container(
              color: Theme.of(context).primaryColor,
              margin: EdgeInsets.only(top: 180.0),
              //alignment: Alignment.bottomCenter,
    ),


              Card(
                  margin: EdgeInsets.only(
                      bottom: 10.0, left: 10.0, right: 10.0, top: 200.0),
                  elevation: 6.0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 30.0,
                                top: 40.0,
                                right: 30.0,
                                bottom: 40.0),
                            child: Column(children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(bottom: 30.0),
                                child: Image.asset('asset/images/logo.png',
                                    width: 150.0),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  """Innova Service è una Società Cooperativa che nasce dall’idea di un gruppo di professionisti, di lunga e provata esperienza ognuno in un settore specifico per le attività di igiene ambientale e cura della persona, con l’obiettivo di portare sul mercato una azienda che, con l’entusiasmo e la forza dell’aggregazione porti maggiore linfa e determinazione all’organizzazione e gestione aziendale con la conseguenza di offrire ai clienti servizi altamente professionale e di qualità.""",
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                  // style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "COSA FACCIAMO",
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 1.4,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,

                                      ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Innova Service si occupa di: ",
                                      ),
                                      TextSpan(
                                          text:
                                              "pulizie civili ed industriali, manutenzione del verde, disinfestazione e derattizzazione, manutenzione idraulica ed elettrica, tinteggiatura, lavori di cartongesso e piccoli lavori edili.",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54)),
                                      TextSpan(
                                        text:
                                            "\nOggi quello dei servizi è un mercato in continua evoluzione, segnato da una forte competizione. Pertanto la consapevolezza di questi fattori e la volontà di distinguere la società, offrendo dei servizi di qualità che siano il frutto di una corretta e coerente organizzazione dei diversi elementi che li compongono, hanno fatto si ché Innova Service abbia una organizzazione interna, la cui capacità innovativa è in grado di creare quelle differenze positive e congruenti che gli consentono di interpretare l’inarrestabile cambiamento del mercato e di avere la giusta percezione, al fine di anticipare le aspettative dei clienti per meglio soddisfarne le esigenze del global service.",
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    "LA NOSTRA MISSION",
                                    textAlign: TextAlign.left,
                                    textScaleFactor: 1.4,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        ),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: RichText(
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            "Investiamo moltissimo nella specializzazione e nella ricerca costante di tecniche e prodotti di nuova concezione e a basso impatto ambientale; in ciò, determinanti sono il contributo di ",
                                      ),
                                      TextSpan(
                                          text: "personale qualificato ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54)),
                                      TextSpan(
                                        text:
                                            "e il supporto tecnico di aziende leader nella produzione di materiali e macchinari appositamente progettati per il nostro settore. Garantendo un efficente e professionale proposta di ",
                                      ),
                                      TextSpan(
                                          text: "Facility Management.",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54))
                                    ],
                                  ),
                                ),
                              ),
                            ])),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, left: 30.0, right: 30.0, bottom: 40.0),
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              (currentUser != null)
                                  ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuoteRequest()),
                              )
                                  : _showDialog(context);
                            },
                            child: Text("FAI UN PREVENTIVO"),
                            textColor: Colors.white,
                          ),
                        ),
                      ]))




        ]),

        Container(
            alignment: Alignment.center,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: GestureDetector(
                            onTap: () {
                              contactUs('$facebook', context);
                            },
                            child: ImageIcon(
                              AssetImage(
                                  'asset/images/facebook_logo_button.png'),
                              color: Colors.white,
                              size: 30.0,
                            ))),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: GestureDetector(
                            onTap: () {
                              contactUs('$www', context);
                            },
                            child: ImageIcon(
                              AssetImage('asset/images/internet.png'),
                              color: Colors.white,
                              size: 30.0,
                            )))
                  ]),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          "©2018 INNOVA SERVICE FACILITY MANAGEMENT",
                                      style: TextStyle(fontSize: 9.0)),
                                  TextSpan(
                                      text: "\nP.Iva - 03544210788",
                                      style: TextStyle(fontSize: 8.0))
                                ]))
                          ])),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            RichText(
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "Corso Vittorio Emanuele, n° 65",
                                  style: TextStyle(fontSize: 9.0)),
                              TextSpan(
                                  text: "\n87032 - Amantea (Cs) - Italia",
                                  style: TextStyle(fontSize: 8.0))
                            ]))
                          ])),
                ]))


      ]),
    ]));
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (context) {
        // return object of type Dialog
        return AlertDialog(
          content : new Text("Devi accedere per proseguire"),
          actions : <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("ACCEDI",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        );
      },
    );
  }
}
