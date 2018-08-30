import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:innova_service_flutter_project/data_controller/functions.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text( 'Privacy Policy'), centerTitle: true,),
      body: Container(
          child: SingleChildScrollView(
            child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
              margin: EdgeInsets.only(top: 20.0 , bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '1. Titolare del trattamento e Responsabile della protezione dei dati',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                      """ Il Titolare del Trattamento è Innova Service Facility Management – Società con sede presso Corso Vittorio Emanuele , 65 Cap 87032 - Amantea(CS) - Italia.
Il Responsabile della protezione dei dati può essere contattato tramite 
E-mail: """),
                  Text.rich(
                    TextSpan(
                      text: 'info@innovaservice.eu',
                      style: new TextStyle(
                        color: Colors.blue,
                      ),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          contactUs('info@innovaservice.eu', context);
                        },
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    '2. Finalità e base giuridica del trattamento',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                      """ Innova Service tratta i dati personali di persone fisiche, persone giuridiche, ditte individuali e/o liberi professionisti (“Interessati”) per le seguenti finalità:
necessità di eseguire attività precontrattuali su sua richiesta. Tale necessità rappresenta la base giuridica che legittima i conseguenti trattamenti. Il conferimento dei dati necessari a tali fini rappresenta, a seconda dei casi, un requisito necessario alla conclusione del ad adempiere alla richiesta; in mancanza di essi, la Società sarebbe nell’impossibilità di instaurare il rapporto o di dare esecuzione allo stesso;
""",
                      textAlign: TextAlign.justify),
                  Text(
                    '3. Categorie di dati trattati',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                      """ Innova Service tratta dati personali raccolti direttamente presso l’Interessato, ovvero presso terzi, che includono, a titolo esemplificativo, dati anagrafici (es. nome, cognome, codice fiscale , partita iva), . Innova Service non richiede e non tratta di sua iniziativa dati particolari della propria clientela (es. dati che rivelino l’origine razziale o etnica, le opinioni politiche, e le convinzioni religiose o filosofiche, l’appartenenza sindacale, i dati genetici, i dati biometrici - intesi a identificare in modo univoco una persona fisica, i dati relativi alla salute o alla vita sessuale o all’orientamento sessuale della persona). 
""",
                      textAlign: TextAlign.justify),
                  Text(
                    '4.Destinatari o categorie di destinatari dei dati',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                      """Possono venire a conoscenza dei dati dell’Interessato le persone fisiche e giuridiche nominate Responsabili del trattamento e le persone fisiche autorizzate al trattamento dei dati necessari allo svolgimento delle mansioni assegnategli: lavoratori dipendenti della Società Innova Service o presso di essa distaccati, lavoratori interinali, consulenti finanziari abilitati all’offerta fuori sede, stagisti e consulenti.
 
La Società Innova Service  – senza che sia necessario il consenso dell'Interessato – può comunicare i dati personali in suo possesso:
a quei soggetti cui tale comunicazione debba essere effettuata in adempimento a un obbligo previsto dalla legge, da un regolamento o dalla normativa comunitaria;
negli altri casi previsti dalla normativa vigente sulla protezione dei dati tra i quali, in particolare, società per conto delle quali la Banca svolge attività di intermediazione per la vendita di loro prodotti / servizi.
"""),
                  Text(
                    '5. Diritti degli Interessati',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                      """La normativa vigente sulla protezione dei dati attribuisce specifici diritti all’Interessato, il quale, per l’esercizio degli stessi può rivolgersi direttamente e in qualsiasi momento al Titolare del trattamento.
I diritti esercitabili dall’Interessato, di seguito descritti, sono:
Diritto di accesso;
Diritto di Rettifica;
Diritto di cancellazione;
Diritto di limitazione;
Diritto alla portabilità;
Diritto di opposizione.
Gli Interessati e le persone giuridiche, gli enti e le associazioni possono in qualsiasi momento modificare i consensi facoltativi ogni volta lo desiderano.
Diritto di accesso
Il diritto di accesso prevede la possibilità per l'Interessato di conoscere quali dati personali a sé riferiti sono trattati dalla Società Innova Service .Tra le informazioni fornite sono indicati le finalità del trattamento, le categorie dei dati trattati, il periodo di conservazione previsto o, se non possibile, i criteri utilizzati per definire tale periodo, nonché le garanzie applicate in caso di trasferimento dei dati verso Paesi terzi e i diritti esercitabili dall’Interessato.
Diritto di rettifica
Il diritto di rettifica permette all’Interessato di ottenere l'aggiornamento o la rettifica dei dati inesatti o incompleti che lo riguardano.
 
Diritto di cancellazione (c.d. “oblio”)
Il diritto di cancellazione, o all’oblio, permette all’Interessato di ottenere la cancellazione dei propri dati personali nei seguenti casi particolari:
i dati personali non sono più necessari per le finalità per le quali sono stati raccolti e trattati;
l'Interessato revoca il consenso su cui si basa il trattamento, se non sussiste un’altra base giuridica che possa altrimenti legittimarlo;
l'Interessato si oppone al trattamento e non sussiste alcun ulteriore motivo legittimo per procedere al trattamento effettuato dal titolare per:
il perseguimento di un legittimo interesse proprio o di terzi e non sussiste alcun motivo legittimo prevalente del titolare per procedere al trattamento,
finalità di marketing diretto, compresa la profilazione ad esso connessa;
i dati personali dell’Interessato sono stati trattati illecitamente.
Tale diritto può essere esercitato anche dopo la revoca del consenso.
 
Diritto di limitazione
Il diritto di limitazione è esercitabile dall’Interessato in caso:
di violazione dei presupposti di liceità del trattamento, come alternativa alla cancellazione dei dati;
di richiesta di rettifica dei dati (in attesa della rettifica) o di opposizione al loro trattamento (in attesa della decisione del titolare).
Fatta salva la conservazione, è vietato ogni altro trattamento del dato di cui si chiede la limitazione.
Diritto alla portabilità
Il diritto alla portabilità consente all'Interessato di utilizzare i propri dati in possesso dalla Società
Innova Service per altri scopi. Ciascun Interessato può chiedere di ricevere i dati personali a lui riferibili o chiederne il trasferimento a un altro titolare, in un formato strutturato, di uso comune e leggibile (Diritto alla portabilità).
In particolare, i dati che possono essere oggetto di portabilità sono i dati anagrafici.
Diritto di opposizione
Il diritto di opposizione consente all'Interessato di opporsi in qualsiasi momento, per motivi connessi esclusivamente alla sua situazione, al trattamento dei dati personali che lo riguardano.

"""),
                  Text(
                    '5.1 Deroghe all\'esercizio dei diritti',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                      """La normativa sulla protezione dei dati riconosce specifiche deroghe ai diritti riconosciuti all'Interessato. La Società Innova Service deve tuttavia continuare a trattare i dati personali dell’Interessato al verificarsi di una o più delle seguenti condizioni applicabili:
esecuzione a un obbligo di legge applicabile alla Società Innova Service;
risoluzione di precontenziosi e/o contenziosi (propri o di terzi);
indagini/ispezioni interne e/o esterne;
richieste della pubblica autorità italiana e/o estera;
motivi di interesse pubblico rilevante;
esecuzione di un contratto in essere tra la Società Innova Service ed un terzo;
ulteriori eventuali condizioni/status bloccanti di natura tecnica individuate dalla Società Innova Service
"""),
                  Text(
                    '5.2 Deroghe all\'esercizio dei diritti',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                      """Ciascun Interessato per esercitare i propri diritti potrà contattare la Società Innova Service all'indirizzo di posta elettronica info@innovaservice.eu
La Società Innova Service ha il diritto di chiedere ulteriori informazioni necessarie ai fini identificativi del richiedente.
"""),
                  Text(
                    '6 Periodo di conservazione dei dati',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                      """La Società Innova Service tratta e conserva i dati personali dell’Interessato per tutta la durata del rapporto contrattuale, laddove se ne crei almeno uno, per l’esecuzione degli adempimenti allo stesso inerenti e conseguenti, per il rispetto degli obblighi di legge e regolamentari applicabili, nonché per finalità difensive proprie o di terzi, fino alla scadenza del periodo di conservazione dei dati. 
Al termine del periodo di conservazione applicabile, i dati personali riferibili agli Interessati verranno cancellati o conservati in una forma che non consenta l’identificazione dell’Interessato, a meno che il loro ulteriore trattamento sia necessario per uno o più dei seguenti scopi:
risoluzione di precontenziosi e/o contenziosi avviati prima della scadenza del periodo di conservazione;
per dare seguito ad indagini/ispezioni da parte di funzioni di controllo interno e/o autorità esterne avviati prima della scadenza del periodo di conservazione;
risoluzione di precontenziosi e/o contenziosi avviati prima della scadenza del periodo di conservazione;
"""),
                ],
              ),
            ),
          ),
        ),
      ));
  }
}
