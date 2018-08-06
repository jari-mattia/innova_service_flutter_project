import 'package:flutter/material.dart';

class FormAzienda extends StatefulWidget {
  @override
  FormAziendaState createState() {
    return FormAziendaState();
  }
}

class FormAziendaState extends State<FormAzienda> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  TextEditingController _controllerName;
  TextEditingController _controllerPI;
  TextEditingController _controllerEmail;
  TextEditingController _controllerRichiesta;

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePartitaIva(String value) {
    Pattern pattern = r'^[0-9]{11}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Partita Iva';
    else
      return null;
  }

  void _resetForm() {
    _formKey.currentState.reset();
    setState(() {
      _autoValidate = false;
    });
  }

  void _clearField(TextEditingController _controller) {
    setState(() {
      _controller = TextEditingController(text: '');
      print(_controller);

    });
  }

  Widget clear(TextEditingController controller){
    return IconButton(
        icon: Icon(Icons.cancel),
        onPressed: (){_clearField(controller);}
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            TextFormField(
              controller: _controllerName,
              maxLength: 24,
              decoration: InputDecoration(
                  suffixIcon: clear(_controllerName),
                  labelText: 'Nome', prefixIcon: Icon(Icons.group)),
              validator: (String arg) {
                if (arg.length < 3)
                  return 'Name must be more than 2 character';
                else
                  return null;
              },
            ), // We'll build this out in the next steps!

            TextFormField(
                controller: _controllerPI,
                maxLength: 11,
                decoration: InputDecoration(
                    suffixIcon: clear(_controllerPI),
                    labelText: 'Partita Iva',
                    prefixIcon: Icon(Icons.payment)),
                keyboardType: TextInputType.number,
                validator: validatePartitaIva), // We'l

            TextFormField(
                controller: _controllerEmail,
                maxLength: 256,
                decoration: InputDecoration(
                    suffixIcon: clear(_controllerEmail),
                    labelText: 'Email', prefixIcon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail), // We'

            TextFormField(
              controller: _controllerRichiesta,
              maxLength: 1000,
              decoration: InputDecoration(
                  suffixIcon: clear(_controllerRichiesta),
                  labelText: 'Richiesta', prefixIcon: Icon(Icons.edit)),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: _validateInputs,
                    child: Text('Invia', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    color: Colors.redAccent,
                    onPressed: _resetForm,
                    child: Text('reset', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ]),
        ));
  }
}
