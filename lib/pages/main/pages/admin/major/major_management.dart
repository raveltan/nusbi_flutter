import 'package:flutter/material.dart';
import 'package:nusbi_flutter/model/model_service.dart';
import 'package:nusbi_flutter/model/models/admin/major/create_major_model.dart';

class MajorManagement extends StatefulWidget {
  @override
  _MajorManagementState createState() => _MajorManagementState();
}

class _MajorManagementState extends State<MajorManagement> {
  var addMajorTextEditingController = TextEditingController();

  void addMajor() async {
    var result = await ModelService()
        .doAuthRequest(CreateMajorRequest(addMajorTextEditingController.text));
    addMajorTextEditingController.text = "";
    Navigator.of(context).pop();
    print(result);
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Major Added"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
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
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 700),
          child: Scrollbar(
            radius: Radius.circular(30),
            child: ListView.separated(
                itemBuilder: (x, i) => ListTile(
                      title: Text('Computer Science'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_forever),
                        onPressed: () {},
                      ),
                    ),
                separatorBuilder: (x, i) => Divider(
                      height: 0,
                    ),
                itemCount: 10),
          ),
        ),
      ),
    );
  }
}
