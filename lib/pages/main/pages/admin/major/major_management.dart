import 'package:flutter/material.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/admin/major/create_major_model.dart';
import 'package:nusbi_flutter/model/models/admin/major/get_major_model.dart';

class MajorManagement extends StatefulWidget {
  @override
  _MajorManagementState createState() => _MajorManagementState();
}

class _MajorManagementState extends State<MajorManagement> {
  var addMajorTextEditingController = TextEditingController();
  List<MajorResponseData> _majors = [];
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> deleteMajor() async {}

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    var result = await ModelService().doAuthRequest(GetMajorRequest());

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
    _majors = (result as GetMajorResponse).data;
    setState(() {
      _isLoading = false;
    });
  }

  void addMajor() async {
    var result = await ModelService()
        .doAuthRequest(CreateMajorRequest(addMajorTextEditingController.text));
    addMajorTextEditingController.text = "";
    Navigator.of(context).pop();
    if (result is String) {
      showDialog(
          context: context,
          builder: (x) => AlertDialog(
                title: Text('Error'),
                content: Text(result),
                actions: [
                  FlatButton(
                      child: Text("Ok"),
                      onPressed: () => Navigator.of(context).pop(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))
                ],
              ));
      return;
    }
    await getData();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      action: SnackBarAction(
        label: "Ok",
        onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
      ),
      content: Text("Major Added"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Majors'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showDialog(
                context: context,
                builder: (x) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: Text("New Major"),
                      content: TextField(
                        decoration: InputDecoration(
                            labelText: "Major Name",
                            hintText: "Computer Science"),
                        controller: addMajorTextEditingController,
                        onSubmitted: (_) => addMajor,
                      ),
                      actions: [
                        FlatButton(
                          child: Text("Add"),
                          onPressed: addMajor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        FlatButton(
                            child: Text("Cancel"),
                            onPressed: () => Navigator.of(context).pop(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)))
                      ],
                    )),
          )
        ],
      ),
      body: Stack(children: [
        Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            child: Scrollbar(
              radius: Radius.circular(30),
              child: ListView.separated(
                  itemBuilder: (x, i) => ListTile(
                        title: Text(_majors[i].name),
                      ),
                  separatorBuilder: (x, i) => Divider(
                        height: 0,
                      ),
                  itemCount: _majors.length),
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
