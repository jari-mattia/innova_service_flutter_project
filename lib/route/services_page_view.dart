import 'package:flutter/material.dart';

import 'package:innova_service_flutter_project/route/service_page.dart';

class MyServicesPageView extends StatefulWidget {
  @override
  _MyServicesPageViewState createState() => new _MyServicesPageViewState();
}

class _MyServicesPageViewState extends State<MyServicesPageView> {
  final _page1Av = "page_1_av.png";
  final _page1Bg = "page_1_bg.png";
  final _page1Title = "Pulizie Civili ed Industriali";
  final _page1Desc =
      "La consolidata esperienza nel settore ci permette di offrire un servizio che va oltre le irrinunciabili esigenze igieniche. L’igiene dell’ambiente di lavoro è indispensabile per garantire un confort adeguato, salvaguardare la salute del lavoratore, nonché tutelare l’immagine aziendale. \nNoi assicuriamo un servizio di grande qualità grazie alle competenze dei nostri addetti ed all’efficacia dei prodotti utilizzati. \n\nInterveniamo in ogni tipo di ambiente, civile ed industriale, garantendo pulizia e disinfezione di ambienti ad alto rischio sanitario quali (alberghi e strutture ricettive, ospedali, case di riposo per anziani, uffici, ristoranti, reparti produzione alimentare ecc…). \nInoltre alle strutture alberghiere offriamo servizi di pulizia, facchinaggio, riassetto camere, portierato, reception, solo a camera venduta per salvaguardare oltre che l’igiene anche l’economicità dell’imprenditore alberghiero.";
  final _page1Color = Colors.blue;

  final _page2Av = "page_2_av.png";
  final _page2Bg = "page_2_bg.jpeg";
  final _page2Title = "Gestione Aree Verdi";
  final _page2Desc =
      """La nostra esperienza al servizio della Vs area verde. Le aree verdi rappresentano una riserva fondamentale per la sostenibilità e la qualità della vita. Noi interveniamo a qualsiasi livello ed in qualsiasi area con tecnici ed operatori altamente qualificati e con attrezzature all’avanguardia in grado di curare al meglio parchi e giardini.
  
  \n- Progettazione e realizzazione parchi e giardini;
  \n- Potatura siepi , cespugli , arbusti e rampicanti;
  \n- Servizio giardinaggio e cura dei tappeti erbosi;
  \n- Interventi parassitari;
  \n- Raccolta foglie / materiale di scarto.""";
  final _page2Color = Colors.green;

  final _page3Av = "page_3_av.png";
  final _page3Bg = "page_3_bg.jpg";
  final _page3Title =
      "Installazione e Manutenzione Impianti Termoidraulici ed Elettrici";
  final _page3Desc =
      """Professionalità , esperienza , innovazione tecnologica volta alla sostenibilità ambientale sono i principi che ci guidano nella realizzazione, gestione e manutenzione degli impianti tecnologici. \nLa società Innova Service coop è in grado di realizzare opere di natura idraulica che richiedono un elevato grado di precisione. Vantando un ottima competenza nell’ installazione, gestione e manutenzione di impianti tecnologici, quali:

\n- Climatizzazione
\n- Idrico sanitari
\n- Elettrico
\n- Distribuzione gas e metano
\n- Caldaie e scaldini
\n- Condizionamento""";
  final _page3Color = Colors.red;

  final _page4Av = "page_4_av.png";
  final _page4Bg = "page_4_bg.jpg";
  final _page4Title = "Disinfestazione Derattizzazione Sanificazione";
  final _page4Desc =
      "Interventi deratizzazione professionali per eliminare ogni tipo di insetto in qualsiasi genere di ambiente. Le nostre soluzioni per eliminare topi e ratti sono pesate per ambienti privati ed imprese, tenendo conto delle diverse esigenze dei nostri clienti e dei contesti ambientali nei quali intervenire. \nLa nostra società Innova Service coop. esegue interventi mirati di Disinfestazione da insetti striscianti e volanti garantendo l’insieme delle operazioni tendenti all’eliminazione, o alla limitazione, dei parassiti infestanti e dei loro danni. \nI servizi per la disinfestazione da insetti e parassiti sono diretti contro zanzare, vespe, mosche, cimici dei letti, parassiti delle derrate alimentari, formiche, blatte. \n\nIn più Innova Service coop. è installatore del sistema di nebulizzazione automatizzato Anti-Zanzare leader nel mondo. Scopri contattandoci tutti i vantaggi del sistema innovativo automatico a nebulizzazione continua con programmi prestabiliti, per famiglie ed imprese, per gli ambienti quali: giardini, parchi, residence, lidi balneari, ristoranti ed alberghi, ecc… \nLa Sanificazione secondo Innova Service coop. viene effettuata utilizzando prodotti specifici a Presidio Medico Chirurgico e Biotici principalmente presso: mense, scuole, cliniche, edifici pubblici ed anche in ambienti che sono stati esposti a forti rischi di infezione. Utilizzando il nuovo sistema OzoSi.";
  final _page4Color = Colors.amber;

  final _page5Av = "page_5_av.png";
  final _page5Bg = "page_5_bg.png";
  final _page5Title = "Ristrutturazioni Edili \n Tinteggiatura e Cartongesso";
  final _page5Desc =
      "Tutte le difficoltà di una ristrutturazione vengono superate con successo da Innova Service coop che saprà consigliarvi sempre la soluzione migliore. \nDa piccole stanze a intere abitazioni (o locali ), un team di esperti affiancati da professionisti del settore si occuperà di ogni tipo di sistemazione, dalla demolizione dell’esistente, al rifacimento o realizzazione ex novo di pareti e di rivestimento, sia in piastrelle che in legno. Ma anche sostituzioni serramenti, porte interne ed esterne, ricostruzioni di bagni sanitari e dipinture varie.";
  final _page5Color = Colors.cyan;

  final _rightArrow = Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Align(
          alignment: Alignment.center,
          child: Icon(Icons.arrow_forward_ios,
              color: Colors.grey[350], size: 30.0)),
    ],
  );

  final _leftArrow = Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Align(
          alignment: Alignment.center,
          child:
              Icon(Icons.arrow_back_ios, color: Colors.grey[350], size: 30.0)),
    ],
  );

  final _bothArrow = Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: Icon(Icons.arrow_back_ios,
                  color: Colors.grey[350], size: 30.0)),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: Icon(Icons.arrow_forward_ios,
                  color: Colors.grey[350], size: 30.0)),
        ],
      ),
    ],
  );

  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        MyServicesPage(Key("page_1"), _page1Av, _page1Bg, _page1Title, _page1Desc,
            _page1Color, _rightArrow),
        MyServicesPage(Key("page_2"), _page2Av, _page2Bg, _page2Title, _page2Desc,
            _page2Color, _bothArrow),
        MyServicesPage(Key("page_3"), _page3Av, _page3Bg, _page3Title, _page3Desc,
            _page3Color, _bothArrow),
        MyServicesPage(Key("page_4"), _page4Av, _page4Bg, _page4Title, _page4Desc,
            _page4Color, _bothArrow),
        MyServicesPage(Key("page_5"), _page5Av, _page5Bg, _page5Title, _page5Desc,
            _page5Color, _leftArrow),
      ],
    );
  }
}
