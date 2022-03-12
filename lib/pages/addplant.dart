import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vegetablenote/pages/plant.dart';

class AddplantPages extends StatefulWidget {
  const AddplantPages({ Key? key , this.email}) : super(key: key);
  final String? email;

  @override
  State<AddplantPages> createState() => _AddplantPagesState();
}

class _AddplantPagesState extends State<AddplantPages> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final format = DateFormat("dd-MM-yyyy");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Form(
        child: ListView(
          children: [
            text(),
            input( _name , 'Name Plant'),
            inputdate( _date , 'Date Plant'),
            submit(),
            textt( PlantPages(email: widget.email,) , 'กลับหน้าหลัก'),

          ],
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

  CollectionReference plants = FirebaseFirestore.instance.collection('Plants');
  Future<void> addProduct() {
    return plants
        .add({
          'email': widget.email,
          'plant_name': _name.text,
          'date_plant': _date.toString(),
        })
        .then((value) => print("Plants data has been successfully"))
        .catchError((error) => print("Failed to add data: $error"));
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
          addProduct();
          var route = MaterialPageRoute(builder: (context) => PlantPages(email: widget.email,),);
          Navigator.push(context, route);
        },
        child: const Text('เพิ่ม'),
      ),
    );
  }


  Container input(a,b) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
      child: TextFormField(
        controller: a,
        // keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Enter ' + b;
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.purple, width: 2),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.purple, width: 2),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          prefixIcon: const Icon(
            Icons.sell,
            color: Colors.purple,
          ),
          label: Text(
            b,
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ),
    );
  }



  Container inputdate(a,b) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
      child: DateTimeField(
        controller: a,
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context,
            firstDate: DateTime(2000),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100)
          );
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.purple, width: 2),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.purple, width: 2),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          prefixIcon: const Icon(
            Icons.sell,
            color: Colors.purple,
          ),
          label: Text(
            b,
            style: TextStyle(color: Colors.purple),
          ),
        ),
      ),
    );
  }

  Container text() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: const Text(
        'เพิ่มการปลูก',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}