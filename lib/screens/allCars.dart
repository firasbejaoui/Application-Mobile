import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services.dart';
import '../utils.dart';

class AllCars extends StatefulWidget {
  const AllCars({Key? key}) : super(key: key);

  @override
  _AllCarsState createState() => _AllCarsState();
}

class _AllCarsState extends State<AllCars> {
  List cars = getAllCars();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void refresh() {
    setState(() {
      this.cars = getAllCars();
      reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        iconSize: 40,
        color: Colors.blue,
        icon: Icon(Icons.add_circle),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => BuildPopupDialog(refresh: this.refresh),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: DataTable2(
                    columnSpacing: 1,
                    minWidth: 600,
                    dataTextStyle: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    headingTextStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    columns: [
                      DataColumn(
                        label: Text("Ref"),
                      ),
                      DataColumn(
                        label: Text("Description"),
                      ),
                      DataColumn(
                        label: Text("Date"),
                      ),
                      DataColumn(
                        label: Text("Action"),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      cars.length,
                      (int index) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text('${cars[index]['ref']}')),
                          DataCell(Text('${cars[index]['description']}')),
                          DataCell(Text(cars[index]['date'].toString().split(' ')[0])),
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) => BuildPopupDialogModif(refresh: this.refresh, data: cars[index]),
                                      );
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: TextButton(
                                    onPressed: () {
                                      removeCar(cars[index]['ref']);
                                      this.refresh();
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildPopupDialog extends StatefulWidget {
  final refresh;
  const BuildPopupDialog({Key? key, this.refresh}) : super(key: key);

  @override
  _BuildPopupDialogState createState() => _BuildPopupDialogState();
}

class _BuildPopupDialogState extends State<BuildPopupDialog> {
  _BuildPopupDialogState({
    Key? key,
  });
  TextEditingController _refController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 350,
              width: 400,
              child: Column(
                children: [
                  Text("Ajouter une voiture"),
                  SizedBox(
                    height: 15,
                  ),
                  Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: this._refController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Ref',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: this._descriptionController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Description',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: this._dateController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Date de maintenance',
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 17),
                          ),
                          onPressed: () {
                            addCar({"ref": this._refController.value.text, "description": this._descriptionController.value.text, "date": DateTime.parse(this._dateController.value.text)});
                            widget.refresh();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Ajouter",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildPopupDialogModif extends StatefulWidget {
  final data;
  final refresh;
  const BuildPopupDialogModif({Key? key, this.refresh, this.data}) : super(key: key);

  @override
  _BuildPopupDialogModifState createState() => _BuildPopupDialogModifState();
}

class _BuildPopupDialogModifState extends State<BuildPopupDialogModif> {
  _BuildPopupDialogModifState({
    Key? key,
  });
  TextEditingController _refController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.data);
    _descriptionController.text = widget.data['description'];
    _refController.text = widget.data['ref'];
    _dateController.text = widget.data['date'].toString().split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 350,
              width: 400,
              child: Column(
                children: [
                  Text("Modifier une voiture"),
                  SizedBox(
                    height: 15,
                  ),
                  Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: this._refController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Ref',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: this._descriptionController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Description',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: this._dateController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Date de maintenance',
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 17),
                          ),
                          onPressed: () {
                            updateCar(widget.data['ref'],
                                {"ref": this._refController.value.text, "description": this._descriptionController.value.text, "date": DateTime.parse(this._dateController.value.text)});
                            widget.refresh();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Modifier",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
