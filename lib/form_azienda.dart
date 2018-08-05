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

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  maxLength: 24,
                  decoration: InputDecoration(labelText: 'nome',  prefixIcon: Icon(Icons.group)),
                  validator: (value) {
                    if (value.isEmpty ) {
                      return 'Please enter some text';
                    }
                  },
                ), // We'll build this out in the next steps!
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, we want to show a Snackbar
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                      }
                    },
                    child: Text('Submit'),
                  ),
                )
              ]),
        ));
  }
}
