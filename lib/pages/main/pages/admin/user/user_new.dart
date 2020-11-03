import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class NewUserPage extends StatefulWidget {
  final String _userType;

  NewUserPage(this._userType);

  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<Widget> _studentForm = [
    FormBuilderTextField(
      attribute: "batch",
      decoration: InputDecoration(labelText: "Batch"),
      validators: [
        FormBuilderValidators.numeric(),
        FormBuilderValidators.max(2040),
        FormBuilderValidators.required()
      ],
    ),
  ];
  List<Widget> _teacherForm = [
    FormBuilderTextField(
      attribute: "firstName",
      decoration: InputDecoration(labelText: "First Name"),
      validators: [
        FormBuilderValidators.minLength(2),
        FormBuilderValidators.maxLength(30),
      ],
    ),
    FormBuilderTextField(
      attribute: "lastName",
      decoration: InputDecoration(labelText: "Last Name"),
      validators: [
        FormBuilderValidators.minLength(2),
        FormBuilderValidators.maxLength(30),
      ],
    ),
    FormBuilderDropdown(
      attribute: "gender",
      decoration: InputDecoration(labelText: "Gender"),
      initialValue: 'Male',
      hint: Text('Select Gender'),
      validators: [FormBuilderValidators.required()],
      items: ['Male', 'Female']
          .map((gender) =>
              DropdownMenuItem(value: gender, child: Text("$gender")))
          .toList(),
    ),
    FormBuilderDateTimePicker(
      attribute: "dob",
      inputType: InputType.date,
      format: DateFormat("yyyy-MM-dd"),
      decoration: InputDecoration(labelText: "DOB"),
      validator: FormBuilderValidators.required(),
    ),
    FormBuilderTextField(
      attribute: "email",
      decoration: InputDecoration(labelText: "Email"),
      validators: [
        FormBuilderValidators.email(),
        FormBuilderValidators.required()
      ],
    ),

    FormBuilderCheckbox(
      attribute: 'accept_terms',
      label: Text("Are you sure?"),
      validators: [
        FormBuilderValidators.requiredTrue(
          errorText: "You must be sure to add new user",
        ),
      ],
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New user (${widget._userType})'),
        centerTitle: true,
      ),
      body: FormBuilder(
        key: _fbKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            child: Column(
              children: [
                FormBuilderTextField(
                  attribute: "username",
                  decoration: InputDecoration(labelText: "Username"),
                  validators: [
                    FormBuilderValidators.minLength(5),
                    FormBuilderValidators.maxLength(30),
                  ],
                ),
                FormBuilderTextField(
                  attribute: "password",
                  decoration: InputDecoration(labelText: "Password"),
                  validators: [
                    FormBuilderValidators.minLength(8),
                    FormBuilderValidators.maxLength(30),
                  ],
                ),
                ...(widget._userType == 'student'
                    ? _studentForm + _teacherForm
                    : widget._userType == 'teacher'
                        ? _teacherForm
                        : []),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.deepOrange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    textColor: Colors.white,
                    child: Text('Add'),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
