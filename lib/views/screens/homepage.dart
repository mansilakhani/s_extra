import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sql_rev/helpers/database_helper.dart';
import 'package:sql_rev/modals/modals.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Students>> getAllStudents;

  final GlobalKey<FormState> insertFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();
  // final TextEditingController updatenameController = TextEditingController();
  // final TextEditingController updateageController = TextEditingController();
  // final TextEditingController updatecityController = TextEditingController();

  // String? name;
  // int? age;
  // String? city;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllStudents = DBHelper.dbHelper.fetchAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQL INJECTION"),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  onChanged: (val) async {
                    setState(() {
                      getAllStudents =
                          DBHelper.dbHelper.fetchSearchedRecords(data: val);
                    });
                  },
                  decoration: InputDecoration(hintText: "Search name here ..."),
                ),
              )),
          Expanded(
            flex: 14,
            child: FutureBuilder(
              future: getAllStudents,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  List<Students> data = snapshot.data;
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, i) {
                        return Card(
                          child: ListTile(
                            isThreeLine: true,
                            //leading: Text("${data[i].id}"),
                            leading: CircleAvatar(
                              backgroundImage: MemoryImage(data[i]!.image),
                            ),
                            title: Text("${data[i].name}"),
                            subtitle:
                                Text("${data[i].city} \n Age: ${data[i].age}"),
                            trailing: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      int resId = await DBHelper.dbHelper
                                          .updateRecord(
                                              name: 'Drishti',
                                              age: 18,
                                              city: 'Mumbai',
                                              id: data[i].id);

                                      if (resId == 1) {
                                        print(
                                            "=====================================");
                                        print("Record updates successfully");
                                        print(
                                            "=====================================");

                                        setState(() {
                                          getAllStudents = DBHelper.dbHelper
                                              .fetchAllRecords();
                                        });
                                      } else {
                                        print(
                                            "=========================================");
                                        print("Record updation failed");
                                        print(
                                            "=======================================");
                                      }
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    )),
                                IconButton(
                                  onPressed: () async {
                                    int resId = await DBHelper.dbHelper
                                        .deleteRecord(id: data[i].id);

                                    if (resId == 1) {
                                      print(
                                          "====================================");
                                      print("Records deleted successfully");
                                      print(
                                          "====================================");

                                      setState(() {
                                        getAllStudents =
                                            DBHelper.dbHelper.fetchAllRecords();
                                      });
                                    } else {
                                      print(
                                          "====================================");
                                      print("Records Deletion failed ");
                                      print(
                                          "====================================");
                                    }
                                    //Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                                // ElevatedButton(
                                //     onPressed: () {
                                //       Navigator.of(context).pop();
                                //     },
                                //     child: Text("Cancel"))
                              ],
                            ),
                          ),
                        );
                      });
                }
                return const CircularProgressIndicator();
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          validateInsert();
        },
      ),
    );
  }

  validateInsert() {
    showDialog(
        context: (context),
        builder: (context) => AlertDialog(
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    if (insertFormKey.currentState!.validate()) {
                      insertFormKey.currentState!.save();

                      int id = await DBHelper.dbHelper.insertRecord(
                        name: name!,
                        age: age!,
                        city: city!,
                        image: image!,
                      );
                      if (id > 0) {
                        print("================================");
                        print("Records insert Sucessfully $id");
                        print("================================");

                        setState(() {
                          getAllStudents = DBHelper.dbHelper.fetchAllRecords();
                        });
                      } else {
                        print("=================================");
                        print("Record insertion failed");
                        print("=================================");
                      }
                    }
                    nameController.clear();
                    ageController.clear();
                    cityController.clear();
                    setState(() {
                      name = "";
                      city = "";
                      age = null;
                      image = null;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Insert"),
                ),
                ElevatedButton(
                    onPressed: () {
                      nameController.clear();
                      ageController.clear();
                      cityController.clear();

                      setState(() {
                        name = "";
                        city = "";
                        age = null;
                        image = null;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"))
              ],
              title: const Center(
                child: Text("Add Records"),
              ),
              content: Form(
                key: insertFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        XFile? xfile =
                            await picker.pickImage(source: ImageSource.camera);

                        image = await xfile?.readAsBytes();

                        var result =
                            await FlutterImageCompress.compressWithList(
                          image!,
                          minHeight: 250,
                          minWidth: 250,
                          quality: 50,
                          rotate: 135,
                        );

                        image = result;
                      },
                      child: Text("Pick Image"),
                    ),
                    TextFormField(
                      controller: nameController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter name first";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: cityController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter city first";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          city = val;
                        });
                      },
                      decoration: const InputDecoration(
                          labelText: "city", border: OutlineInputBorder()),
                    ),
                    TextFormField(
                      controller: ageController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter age first";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          age = int.parse(val!);
                        });
                      },
                      decoration: const InputDecoration(
                          labelText: "age", border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
            ));
  }
}
