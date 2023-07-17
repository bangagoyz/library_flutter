import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus/Components/Admin/searchBuku.dart';
import 'package:perpus/Screens/User/Peminjaman/PeminjamanScreens.dart';
import 'package:perpus/Utils/constants.dart';
import 'package:perpus/size_config.dart';

import '../../../api/apiConfig.dart';

class AdminBukuComponents extends StatefulWidget {
  @override
  State<AdminBukuComponents> createState() => _AdminBukuComponents();
}

class _AdminBukuComponents extends State<AdminBukuComponents> {
  Response? response;
  var dio = Dio();
  var dataBuku;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataBuku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(hexColor('#67B26F')),
              Color(hexColor('#4ca2cd'))
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          ),
          title: Text(
            "List Buku",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                showSearch(
                    context: context, delegate: SearchBook(dataBuku: dataBuku));
              },
            )
          ],
        ),
        body: SafeArea(
            child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(20)),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: dataBuku == null
                        ? 0
                        : dataBuku.length, //penghitung item
                    itemBuilder: (BuildContext context, int index) {
                      // return cardBuku(dataBuku[index]);

                      return cardBuku(dataBuku[index]);
                    },
                  ),
                )
              ],
            )),
          ),
        )));
  }

  Widget cardBuku(data) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, PeminjamanScreens.routeName,
        //     arguments: data);
      },
      child: Card(
        elevation: 10.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
          child: Container(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1.0, color: Colors.white))),
                child: Image.asset('assets/images/buku1.jpg'),
              ),
              title: Text(
                '${data['judulBuku']}',
                style:
                    TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Penulis',
                    style: TextStyle(
                        color: mTitleColor, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${data['penulisBuku']}',
                    style: TextStyle(
                        color: mSubtitleColor, fontWeight: FontWeight.bold),
                  ),
                  data['sedia'] == true
                      ? Text(
                          'Tersedia',
                          style: TextStyle(
                              color: kColorGreen, fontWeight: FontWeight.bold),
                        )
                      : Text(
                          'Dalam Peminjaman',
                          style: TextStyle(
                              color: kColorRedSlow,
                              fontWeight: FontWeight.bold),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int hexColor(String color) {
    String newColor = '0xff' + color;
    newColor = newColor.replaceAll('#', '');
    int finalColor = int.parse(newColor);
    return finalColor;
  }

  void getDataBuku() async {
    utilsApps.showDialog(context);
    bool status;
    var msg;
    try {
      response = await dio.get(getAllBuku);

      status = response!.data['sukses'];
      msg = response!.data['msg']; //response untuk ambil data dari respon api
      if (status) {
        setState(() {
          dataBuku = response!.data['data']; //show datas
          utilsApps.hideDialog(context);
        });
      } else {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.SCALE,
            title: 'Gagal',
            desc: '$msg',
            btnOkOnPress: () {
              utilsApps.hideDialog(context);
            }).show();
      }
    } catch (e) {
      print(e);
      AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.SCALE,
          title: 'Gagal',
          desc: 'Terjadi Kesalahan Internal',
          btnOkOnPress: () {
            utilsApps.hideDialog(context);
          }).show();
    }
  }
}
