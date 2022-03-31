import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vegetablenote/pages/plant.dart';

class UpdatePlant extends StatefulWidget {
  const UpdatePlant({ Key? key , this.id , this.email}) : super(key: key);
  final String? id;
  final String? email;

  @override
  State<UpdatePlant> createState() => _UpdatePlantState();
}

class _UpdatePlantState extends State<UpdatePlant> {

  final TextEditingController _name = TextEditingController();
  final format = DateFormat("dd-MM-yyyy");
  final TextEditingController _date = TextEditingController();

  DateTime selectedDate = DateTime.now();

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2020),
  //       lastDate: DateTime(2030));
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //   }
  // }


  CollectionReference plant = FirebaseFirestore.instance.collection('Plants');

  Future<void> updatePlant() {
  return plant.doc(widget.id).update
  ({
      'plant_name': _name.text,
      'date_plant': _date.text,
    })
    .then((value) => print("Plant Updated"))
    .catchError((error) => print("Failed to update plant: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    child: Scaffold(
        body: Form(
          child: ListView(
            children: [
              updatetext(_name , 'Plant name' , 'plant_name' ),
              inputdate(),
              submit(),
              textt(PlantPages(email: widget.email,) , 'ย้อนกลับ'),
            ],
          ),
        ),
      ), 
    );
  }

  SizedBox textt(next , text) {
    return SizedBox(
      width: 130,
      height: 45,
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
        ),
        onPressed: () {
          var route = MaterialPageRoute(builder: (context) => next,);
          Navigator.push(context, route);
        },
        child: Text(text),
      ),
    );
  }

  Widget updatetext(a,b,c){
    return FutureBuilder<DocumentSnapshot>(
      future: plant.doc(widget.id).get(),
      builder: (context, snapshot){
        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        a.text = data[c].toString();
        return Container(
          width: 250,
          margin: const EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
          child: TextFormField(

            controller: a,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: Color.fromARGB(255, 99, 206, 0), width: 2),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: Color.fromARGB(255, 99, 206, 0), width: 2),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: Color.fromARGB(255, 99, 206, 0), width: 2),
                ),
              prefixIcon: const Icon(
                Icons.sell,
                color: Color.fromARGB(255, 99, 206, 0),
              ),
              label: Text(
                b,
                style: const TextStyle(color: Color.fromARGB(255, 99, 206, 0)),
              ),
            ),
          ),
        );
      }
    );
  }

  Container inputdate() {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
      child: Column(
          
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DateTimeField(
            format: format, 
            controller: _date,
            onShowPicker: (context, currentValue) {
            return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
            },
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: Color.fromARGB(255, 99, 206, 0), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: Color.fromARGB(255, 99, 206, 0), width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                prefixIcon: Icon(
                  Icons.date_range_outlined,
                  color: Color.fromARGB(255, 99, 206, 0),
                ),
                label: Text(
                  'Date Plant',
                  style: TextStyle(color: Color.fromARGB(255, 99, 206, 0)),
                ),
              //   label: Text(
              //   selectedDate.toString().split(' ')[0],
              //   style: TextStyle(color: Colors.purple),
              // ),
              ),
            ),
          ],
        ),
    );
  }

  SizedBox submit() {
    return SizedBox(
      width: 130,
      height: 45,
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
        ),
        onPressed: () {
          updatePlant();
          var route = MaterialPageRoute(builder: (context) => PlantPages(email: widget.email,),);
          Navigator.push(context, route);
        },
        child: const Text('Update'),
      ),
    );
  }
}