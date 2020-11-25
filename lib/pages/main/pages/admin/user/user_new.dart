import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/admin/major/get_major_model.dart';
import 'package:nusbi_flutter/model/models/admin/user/create_admin_model.dart';
import 'package:nusbi_flutter/model/models/admin/user/create_student_model.dart';
import 'package:nusbi_flutter/model/models/admin/user/create_teacher_model.dart';

class NewUserPage extends StatefulWidget {
  final String _userType;
  final Function _callback;

  NewUserPage(this._userType, this._callback);

  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  List<MajorResponseData> majors = [];
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget._userType == "student") {
      getMajorData();
    }
  }

  Future<void> addUser() async {
    if (!_fbKey.currentState.saveAndValidate()) return;
    var _data = _fbKey.currentState.value;
    setState(() {
      _isLoading = true;
    });
    if (widget._userType == "student") {
      var date = (_data['dob'] as DateTime);
      var dob = "${date.year}-${date.month}-${date.day}";
      var result = await ModelService().doAuthRequest(CreateStudentRequest(
          batch: _data['batch'],
          DOB: dob,
          email: _data['email'],
          firstName: _data['firstName'],
          gender: _data['gender'][0],
          lastName: _data['lastName'],
          major: _data['major'],
          username: _data['username'],
          password: _data['password']));
      if (result is String) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (x) => AlertDialog(
                  title: Text("Error"),
                  content: Text(result),
                  actions: [
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ));
        return;
      }
    } else if (widget._userType == "admin") {
      var result = await ModelService().doAuthRequest(
          CreateAdminRequest(_data['username'], _data['password']));
      if (result is String) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (x) => AlertDialog(
                  title: Text("Error"),
                  content: Text(result),
                  actions: [
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ));
        return;
      }
    } else {
      var date = (_data['dob'] as DateTime);
      var dob = "${date.year}-${date.month}-${date.day}";
      var result = await ModelService().doAuthRequest(CreateTeacherRequest(
          DOB: dob,
          email: _data['email'],
          firstName: _data['firstName'],
          gender: _data['gender'][0],
          lastName: _data['lastName'],
          username: _data['username'],
          password: _data['password']));
      if (result is String) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (x) => AlertDialog(
                  title: Text("Error"),
                  content: Text(result),
                  actions: [
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ));
        return;
      }
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("New user added"),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    ));
    widget._callback();
  }

  Future<void> getMajorData() async {
    setState(() {
      _isLoading = true;
    });
    var result = await ModelService().doAuthRequest(GetMajorRequest());
    setState(() {
      _isLoading = false;
    });
    if (result is String) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (x) => AlertDialog(
                title: Text('Error'),
                content: Text(result),
                actions: [
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () => Navigator.of(x).pop(),
                  )
                ],
              ));
      return;
    }
    majors = (result as GetMajorResponse).data;
    var data = FormBuilderDropdown(
      attribute: "major",
      decoration: InputDecoration(labelText: "Major"),
      hint: Text('Select major'),
      validators: [FormBuilderValidators.required()],
      items: majors.isNotEmpty
          ? majors
              .map((d) => DropdownMenuItem(
                  value: d.iD.toString(), child: Text("${d.name}")))
              .toList()
          : [
              DropdownMenuItem(
                value: "-1",
                child: Text(""),
              )
            ],
    );

    setState(() {
      _studentForm.add(data);
    });
  }

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

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
  List<Widget> _studentForm = [
    FormBuilderTextField(
      attribute: "batch",
      decoration: InputDecoration(labelText: "Batch"),
      validators: [FormBuilderValidators.required()],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New user (${widget._userType})'),
        centerTitle: true,
      ),
      body: Stack(children: [
        Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Scrollbar(
                radius: Radius.circular(30),
                child: FormBuilder(
                  key: _fbKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 0),
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
                            height: 32,
                            child: RaisedButton(
                              color: Colors.deepOrange,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              textColor: Colors.white,
                              child: Text('Add'),
                              onPressed: addUser,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        _isLoading
            ? Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black.withOpacity(0.4),
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Please wait',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    ],
                  ),
                ),
              )
            : Container(),
      ]),
    );
  }
}
