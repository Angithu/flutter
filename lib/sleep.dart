import 'dart:convert';
import 'package:flutter/material.dart';
import 'color.dart';
import 'imu.dart';

class SleepRoute extends StatelessWidget {
  const SleepRoute({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //     // title: 'Flutter Demo',
    //     theme: ThemeData(
    //     primarySwatch: createMaterialColor(Color.fromARGB(255, 28, 41, 152)),
    // ),
    // );

    TextEditingController Sleeptime = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          title: Row(children: [
            Image.asset('assets/images/UMClogo2.jpg'),
            Container(
              padding: const EdgeInsets.all(35.0),
              child: Text('休眠設定'),
            )
          ],)
        //title: Text('UMC Test IMU'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.cent,
              children: <Widget>[
                // Expanded(
                // flex: 2,
                // child:
                Container(
                  // color: const Color.fromARGB(255, 3, 3, 3),
                  margin: EdgeInsets.all(10.0),
                  child:TextFormField(
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: Sleeptime,
                    decoration:
                    InputDecoration(
                        border:OutlineInputBorder(gapPadding: 1.0, borderRadius: BorderRadius.circular(5.0),),
                        labelText: '輸入休眠時間Max:20',labelStyle:TextStyle
                      (decoration: TextDecoration.underline),
                        prefixIcon:Icon (Icons.timer),
                    ),
                  ),
                ),

                // ),
                new Card(
                  color: createMaterialColor(Color.fromARGB(255, 28, 41, 152)),
                  elevation: 10.0,
                  child: FlatButton(
                      onPressed: () {
                        if(!Sleeptime.text.isEmpty)
                        {
                          var aaa = double.parse(Sleeptime.text.toString()).toInt();

                          if(aaa >= 20)
                          {
                            Sleeptime.text = "20";
                          }
                          else if(0<=aaa && aaa<10)
                            {
                              Sleeptime.text = "0${aaa}";
                            }
                          // print((User(Toolname.text, Location.text).toJson().toString()));
                          // print(utf8.encode(User(Toolname.text, Location.text).toJson().toString()));
                          print(utf8.encode("55,${Sleeptime.text}").toString()+'dfsdfdsfdsfdsfdsfdsfdsfdsffsdfdsfds');
                          mCharacteristic.write(utf8.encode("55,${Sleeptime.text}"));
                          print("Success");
                          //writeData(User(Toolname.text, Location.text).toJson().toString());
                          Scaffold.of(context).showSnackBar(
                            SnackBar(content:
                                  Text("已設定:${(Sleeptime.text)}分鐘後休眠 傳送成功",),
                                    duration: const Duration(seconds: 1),

                            ),
                          );
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //       return SleepRoute();
                          //     }));
                        }
                        else{
                          Scaffold.of(context).showSnackBar(
                            SnackBar(content: Row(
                                children:<Widget>[
                                  Text("填寫不完整"),
                                ]
                            ),
                            ),
                          );
                        }

                        Sleeptime.clear();
                        //Location.clear();
                      },
                      child: new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Text(
                          '設定傳送',
                          style: new TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      )
                  ),

                ),

              ],
            ),
          );
        },
      ),
      // body: Center(
      //     child:RaisedButton(
      //         child: Text("器材一"),
      //         onPressed: (){
      //           Navigator.maybePop(context);
      //           ScaffoldMessenger.of(context).showSnackBar(
      //             const SnackBar(content: Text('登出')),
      //           );
      //         }
      //     )
      // ),
    );
  }
}
