import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegetablenote/pages/addplant.dart';
import 'package:vegetablenote/pages/harvest.dart';
import 'package:vegetablenote/pages/history.dart';
import 'package:vegetablenote/pages/historysm.dart';
import 'package:vegetablenote/pages/login.dart';
import 'package:vegetablenote/pages/updatePlant.dart';
import 'package:vegetablenote/service/auth_service.dart';

class PlantPages extends StatefulWidget {
  const PlantPages({ Key? key , this.email }) : super(key: key);
  final String? email;

  @override
  State<PlantPages> createState() => _PlantPagesState();
}

class _PlantPagesState extends State<PlantPages> {

  CollectionReference plants = FirebaseFirestore.instance.collection('Plants');

  Future<void> delPlant({required String id}) {
    return plants
      .doc(id)
      .delete()
      .then((value) => print("Deleted data Successfully"))
      .catchError((error) => print("Failed to delete user: $error"));
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: ListView(
          children: [
            text(),
            showlist(),
            textt( AddplantPages(email: widget.email) , 'เพิ่มการปลูก'),
            textt( HistoryPages(email: widget.email,) , 'ดูประวัติการเก็บผลผลิต'),
            textout( const LoginPage() , 'ออกจากระบบ'),
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

  SizedBox textout(next , text) {
    return SizedBox(
      width: 130,
      height: 45,
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
        ),
        onPressed: () {
          
          var alertDialog = AlertDialog(
            content: const Text(
                'คุณต้องการออกจากระบบใช่หรือไม่',),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ยกเลิก')),
              TextButton(
                  onPressed: () {
                    var route = MaterialPageRoute(builder: (context) => next,);
                    signoutWithEmail();
                    Navigator.push(context, route);
                  },
                  child: const Text(
                    'ยืนยัน',
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          );
          showDialog(
            context: context,
            builder: (context) => alertDialog,
          );
          
        },
        child: Text(text),
      ),
    );
  }

  Widget showlist() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Plants').where('email',isEqualTo: widget.email).snapshots(),
      builder: (context, snapshot) {
        List<Widget> listMe = [];
        if (snapshot.hasData) {
          var products = snapshot.data;
          listMe = [
            Column(
              children: products!.docs.map((DocumentSnapshot doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    onTap: () {
                      var alertDialog = AlertDialog(
                        content: const Text(
                            'คุณต้องการเก็บผลผลิต  ใช่หรือไม่'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              var route = MaterialPageRoute(builder: (context) => HistorySmallPages(email: widget.email,nameplant: data['plant_name'],),);
                              Navigator.push(context, route);
                            },
                            child: Text('ดูประวัติการเก็บผลผลิตของ ${data['plant_name']}'),
                          ),
                          TextButton(
                              onPressed: () {
                                var route = MaterialPageRoute(builder: (context) => UpdatePlant(id: doc.id,email: widget.email));
                                Navigator.push(context, route);
                              },
                              child: const Text(
                                'แก้ไขข้อมูล',
                                style: TextStyle(color: Colors.green),
                              )),
                          TextButton(
                              onPressed: () {
                                var route = MaterialPageRoute(builder: (context) => HarvestPages(nameplant: data['plant_name'] , email: widget.email,),);
                                Navigator.push(context, route);
                              },
                              child: const Text(
                                'ยืนยัน',
                                style: TextStyle(color: Colors.red),
                              )),
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('ยกเลิก')),
                          
                        ],
                      );
                      showDialog(
                        context: context,
                        builder: (context) => alertDialog,
                      );
                    },
                    title: Text(
                      '${data['plant_name']}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.green),
                    ),
                    subtitle: Text('ปลูกเมื่อวันที่ ' + '${data['date_plant']}'),
                    trailing: IconButton(
                      onPressed: () {
                        var alertDialog = AlertDialog(
                          content: Text(
                              'คุณต้องการลบผัก ${data['plant_name']} ใช่หรือไม่',),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('ยกเลิก')),
                            TextButton(
                                onPressed: () {
                                  delPlant(id: doc.id)
                                  .then((value) => Navigator.pop(context));
                                },
                                child: const Text(
                                  'ยืนยัน',
                                  style: TextStyle(color: Colors.red),
                                )),
                          ],
                        );
                        showDialog(
                          context: context,
                          builder: (context) => alertDialog,
                        );
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ];
        }
        return Center(
          child: Column(
            children: listMe,
          ),
        );
      },
    );
  }

  Container text() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: const Text(
        'รายการการปลูก',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}