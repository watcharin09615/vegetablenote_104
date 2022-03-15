import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegetablenote/pages/plant.dart';

class HistorySmallPages extends StatefulWidget {
  const HistorySmallPages({ Key? key , this.email , this.nameplant}) : super(key: key);
  final String? nameplant;
  final String? email;

  @override
  State<HistorySmallPages> createState() => _HistorySmallPagesState();
}

class _HistorySmallPagesState extends State<HistorySmallPages> {


  
  CollectionReference harvest = FirebaseFirestore.instance.collection('Harvest');
  Future<void> delHarvest({required String id}) {
    return harvest
      .doc(id)
      .delete()
      .then((value) => print("Deleted data Successfully"))
      .catchError((error) => print("Failed to delete harvest: $error"));
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: ListView(
          children: [
            text(),
            showlist(),
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

  Widget showlist() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Harvest').where('email',isEqualTo: widget.email).where('harvest_name',isEqualTo: widget.nameplant).snapshots(),
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
                    onTap: () {},
                    title: Text(
                      '${data['harvest_name']}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.green),
                    ),
                    subtitle: Text('เก็บเมื่อวันที่ ' + '${data['date_harvest']}' + ' จำนวน ' + '${data['qty']}' + ' kg'),
                    trailing: IconButton(
                      onPressed: () {
                        var alertDialog = AlertDialog(
                          content: Text(
                              'คุณต้องการลบประวัติการเก็บ ${data['harvest_name']} ใช่หรือไม่'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('ยกเลิก')),
                            TextButton(
                                onPressed: () {
                                  delHarvest(id: doc.id)
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
        'ประวัติการเก็บผลผลิต',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

}