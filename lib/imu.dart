import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'main.dart';
import 'color.dart';
import 'sleep.dart';
import 'dart:io';

// late double currentValue=0;
// late double currentvalue1=0;
List<String> traceDust = [];
late double acc_x=0;
late double acc_y=0;
late double acc_z=0;
late double UI_yaw=0;
late double UI_v=0;
late double UI_x=0;
late double UI_y=0;
late double picx=0;
late double picy=0;
late double reset_x=0;
late double reset_y=0;
late BluetoothCharacteristic mCharacteristic;
late int timx =0;
late int timy =0;
late int timz =0;
ChartSeriesController? _chartSeriesController1;
ChartSeriesController? _chartSeriesController2;
ChartSeriesController? _chartSeriesController3;
// List<dynamic>? chartSeriesController = [];
List<Acc_xData>? XchartData=[];
List<Acc_yData>? YchartData=[];
List<Acc_zData>? ZchartData=[];
List<double> Accxvalue=[];
List<double> Accyvalue=[];
List<double> Acczvalue=[];
bool notice =false;

class Acc_xData {
  final int time;
  final double value;
  Acc_xData(this.time, this.value);
}

class Acc_yData {
  final int time;
  final double value;
  Acc_yData(this.time, this.value);
}

class Acc_zData {
  final int time;
  final double value;
  Acc_zData(this.time, this.value);
}


class SensorPage extends StatefulWidget {
  const SensorPage({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  final String SERVICE_UUID = "7fafc202-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a9";
  late bool isReady;
  late BluetoothCharacteristic characteristic123;
  //Stream<List<int>> stream;
  late Stream <List<int>> stream;


  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
  }

  connectToDevice() async {
    if (widget.device == null) {
      _Pop();
      return;
    }

    //一次性timer
    new Timer(const Duration(seconds: 10), () {
      if (!isReady) {
        disconnectFromDevice();
        _Pop();
      }
    });

    await widget.device.connect(autoConnect: true,timeout: Duration(seconds: 5));
    discoverServices();
    Timer.periodic(const Duration(seconds: 10),(timer)
    {
      widget.device.state.listen((state) {
        print(state);
        if(state == BluetoothDeviceState.disconnected)
        {

          // const snackBar = SnackBar(content:
          // Text("已斷線",),);
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          try{
            print("已斷線");
            // SensorPage(device: widget.device);
          }
          on Exception catch (e) {
            print('EXAMPLE::client exception - $e');
          }
        }
        else if(state == BluetoothDeviceState.connected)
        {
          if(notice== true)
            {
              print(mCharacteristic.value.toString());
              mCharacteristic.write(utf8.encode("55,87"));
              print(DateTime.now().toString() +  " trigger ESP32");
            }

        }
      }
      );
    }
    );
    // Timer.periodic(const Duration(seconds: 2), (timer)
    // {
    //   mCharacteristic.write(utf8.encode("87"));
    //   print("on_success");
    // }
    // );
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      _Pop();
      return;
    }

    widget.device.disconnect();
  }

  sleeping()
  {
    mCharacteristic.write(utf8.encode("55,00"));
    print("直接休眠");
    const snackBar = SnackBar(content:
        Text("已休眠",),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // Scaffold.of(context).showSnackBar(
    //   SnackBar(content:
    //   Text("已休眠",),
    //     duration: const Duration(seconds: 0),
    //   ),
    // );

  }

  discoverServices() async {

    if (widget.device == null) {
      _Pop();
      return;
    }
    await widget.device.requestMtu(256);
    await Future.delayed(Duration(seconds: 1));
    await widget.device.mtu.first;
    // print(mtu);
    // late BluetoothCharacteristic ss;
    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) async {
      // print(service.uuid.toString());
      // var characteristics = service.characteristics;
      // for(BluetoothCharacteristic c in characteristics) {
      //   List<int> value = await c.read();
      //   print(value.toString()+"123");
      //   //await c.write([0x12, 0x34]);
      // }
      // Writes to a characteristic

      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) async {
          // print(characteristic.uuid.toString());
          // print(characteristic.value.toString()+"123154");
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {

            // var descriptors = characteristic.descriptors;
            // for(BluetoothDescriptor d in  descriptors)
            //   {
            //     List<int> value = await d.read();
            //     debugPrint("123:${000Hvalue}");
            //   }
            // debugPrint(characteristic.descriptors.toString());
            // debugPrint("Here is characteristic.value: ${characteristic.value}");
            // print((characteristic.isNotifying).toString()+"231351516");
            characteristic.setNotifyValue(true);
            characteristic.value.listen((event) {
              stream = characteristic.value;
            });
            // characteristic.value.listen((value) {
            //   print("wait");
            // });
            mCharacteristic = characteristic;
            // ss = characteristic;
            // print(ss.toString()+":log");
            //characteristic.write(value);
            // stream = characteristic.value;
            // print(stream.toString()+ "log1");
            setState(() {
              isReady = true;
              timx=0;
              timy=0;
              timz=0;
            });
          }
        });
      }
    });
    // await ss.setNotifyValue(true);
    // stream = ss.value;
    //debugPrint(stream.toString()+"123");
    if (!isReady) {
      _Pop();
    }
  }

  Future<bool> _onWillPop() async{
    showDialog(
        context: context,
        builder: (context) =>
        new AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to disconnect device and go back?'),
          actions: <Widget>[
            new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No')),
            new FlatButton(
                onPressed: () {
                  widget.device.disconnect();
                  reset_y=0;
                  reset_x=0;
                  // disconnectFromDevice();
                  Navigator.of(context).pop(true);
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return FindDevicesScreen();
                  }));
                },
                child: new Text('Yes')),
          ],
        )
    );
    return false;
  }

  _Pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }
  _getSeriesDatax() {
    if(traceDust.length==0)
    {
      List<Acc_xData> xdata = [
        Acc_xData(0, 0),
      ];
      List<charts.Series<Acc_xData, int>> series1 = [
        charts.Series(
            id: "value",
            data: xdata,
            domainFn: (Acc_xData series1, _) => series1.time,
            measureFn: (Acc_xData series1, _) => series1.value,
            colorFn: (Acc_xData series1, _) => charts.MaterialPalette.blue.shadeDefault
        )
      ];
      return series1;
    }
    else{

      XchartData!.add(Acc_xData(timx, Accxvalue[timx]));
      timx++;
      if(XchartData!.length==10)
      {
        XchartData!.removeAt(0);
        // print("xchart" + XchartData.toString());
        if(XchartData![XchartData!.length-1].value!=null)
        {
          // print('Length1 '+XchartData![XchartData!.length-1].value.toString());

          _chartSeriesController1?.updateDataSource(addedDataIndex: (XchartData!.length-1), removedDataIndex: 0);
        }
      }

    }

  }


  _getSeriesDatay() {
    if(traceDust.length==0)
    {
      List<Acc_yData> ydata = [
        Acc_yData(0, 0),
      ];
      List<charts.Series<Acc_yData, int>> series2 = [
        charts.Series(
            id: "value",
            data: ydata,
            domainFn: (Acc_yData series2, _) => series2.time,
            measureFn: (Acc_yData series2, _) => series2.value,
            colorFn: (Acc_yData series2, _) => charts.MaterialPalette.blue.shadeDefault
        )
      ];
      return series2;
    }
    else{
      YchartData!.add(Acc_yData(timy, Accyvalue[timy]));
      timy++;
      if(YchartData!.length==10)
      {
        YchartData!.removeAt(0);
        _chartSeriesController2?.updateDataSource(addedDataIndex: YchartData!.length-1, removedDataIndex: 0);
      }
    }
  }

  _getSeriesDataz() {
    if(traceDust.length==0)
    {
      List<Acc_zData> zdata = [
        Acc_zData(0, 0),
      ];
      List<charts.Series<Acc_zData, int>> series3 = [
        charts.Series(
            id: "value",
            data: zdata,
            domainFn: (Acc_zData series3, _) => series3.time,
            measureFn: (Acc_zData series3, _) => series3.value,
            colorFn: (Acc_zData series3, _) => charts.MaterialPalette.blue.shadeDefault
        )
      ];
      return series3;
    }
    else{

      ZchartData!.add(Acc_zData(timz, Acczvalue[timz]));
      timz++;
      if(ZchartData!.length==10)
      {
        ZchartData!.removeAt(0);
        _chartSeriesController3?.updateDataSource(addedDataIndex: ZchartData!.length-1, removedDataIndex: 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    // Oscilloscope oscilloscope = Oscilloscope(
    //   showYAxis: true,
    //   padding: 0.0,
    //   backgroundColor: Colors.black,
    //   traceColor: Colors.white,
    //   yAxisMax: 3000.0,
    //   yAxisMin: 0.0,
    //   dataSet: traceDust,
    // );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
            title: Row(children: [
              Image.asset('assets/images/UMClogo2.jpg'),
              Container(
                padding: const EdgeInsets.all(30.0),
                child: Text('UMC IMU'),
              )
            ],)
          //title: Text('UMC Test IMU'),
        ),
        body: Container(
            child: !isReady
                ? Center(
              child: Text(
                "連接中...",
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
            )
                : Container(
              child: StreamBuilder<List<int>>(
                stream: mCharacteristic.value,
                builder: (BuildContext context,
                     snapshot) {
                  //print(snapshot.connectionState);
                  // print(stream);
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  // print(snapshot.connectionState);
                  if (snapshot.connectionState ==
                      ConnectionState.active)
                  {
                    notice =false;
                    var currentValue = _dataParser(snapshot.data!);

                    traceDust = (currentValue.split(";"));
                    debugPrint(DateTime.now().toString() +
                        "string:" + traceDust.toString());
                    if (traceDust.length == 5) {
                      traceDust[6] = 0.toString();
                    }
                    else if(traceDust.length == 8)
                    {
                      notice = true;
                      acc_x = (double.tryParse(traceDust[0])!);
                      Accxvalue.add(acc_x);
                      acc_y = (double.tryParse(traceDust[1])!);
                      Accyvalue.add(acc_y);
                      acc_z = (double.tryParse(traceDust[2])!);
                      Acczvalue.add(acc_z);
                      UI_yaw = (double.tryParse(traceDust[3])!);
                      UI_v = (double.tryParse(traceDust[6])!);
                      // mCharacteristic.write(utf8.encode("55,87"));
                      if (traceDust[4].isNotEmpty)
                      {
                        if(traceDust[4] != 'nan')
                        {
                          UI_x = (double.tryParse(traceDust[4])!) - reset_x;
                          picx = UI_x ;
                        }

                      }
                      if (traceDust[5] != 'nan'&& traceDust[5].isNotEmpty)
                      {
                        UI_y = ((double.tryParse(traceDust[5])!)*-1) - reset_y;
                        picy = UI_y*-1;
                        // c33 = picy * -1;
                        // traceDust[2] = c33.toString();
                      }
                      _getSeriesDatax();
                      _getSeriesDatay();
                      _getSeriesDataz();
                      // mCharacteristic.write(utf8.encode("55,87"));
                    }
                    else{
                      notice = false;
                    }


                          // c33 = double.tryParse(traceDust[2])!;
                          // c33 = c33*-1;
                          //traceDust.add(double.tryParse(currentValue.split(";").toString()) ?? 0);
                          //traceDust.add(double.tryParse(currentValue.toString()) ?? 0);
                          //print(traceDust);

                    return Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      const Text('Current value from IMU',
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text('Acc_x:${(acc_x)}g',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Color.fromRGBO(
                                                        5, 112, 32, 1.0)),),
                                            Text('yaw:${(UI_yaw.toStringAsFixed(2))}°',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Color.fromRGBO(
                                                        175, 11, 190, 1.0))),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text('Acc_y:${(acc_y)}g',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Color.fromRGBO(
                                                        7, 62, 116, 1.0))),
                                            Text('Pitch:${(UI_x.toStringAsFixed(2))}°',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Color.fromRGBO(
                                                        190, 86, 11, 1.0))),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text('Acc_z:${(acc_z)}g',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Color.fromRGBO(
                                                        68, 11, 190, 1.0))),
                                            Text('Roll:${(UI_y.toStringAsFixed(2))}°',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Color.fromRGBO(
                                                        192, 108, 132, 1))),
                                          ],
                                        ),
                                      ),
                                      // Text('Acc_x:${(acc_x)}g ' 'Acc_y:${(acc_y)}g',
                                      //     style: const TextStyle(
                                      //         fontWeight: FontWeight.bold,
                                      //         fontSize: 18,
                                      //         color: Color.fromRGBO(
                                      //             5, 112, 32, 1.0)),),
                                      // Text('Acc_y:${(acc_y)}g',
                                      //     style: const TextStyle(
                                      //         fontWeight: FontWeight.bold,
                                      //         fontSize: 24,
                                      //         color: Color.fromRGBO(
                                      //             7, 62, 116, 1.0))),
                                      // Text('Acc_z:${(acc_z)}g',
                                      //     style: const TextStyle(
                                      //         fontWeight: FontWeight.bold,
                                      //         fontSize: 24,
                                      //         color: Color.fromRGBO(
                                      //             68, 11, 190, 1.0))),
                                      // Text('Acc_x:${(acc_x)}g  ''yaw:${(UI_yaw)}°',
                                      //     style: const TextStyle(
                                      //         fontWeight: FontWeight.bold,
                                      //         fontSize: 20,
                                      //         color: Color.fromRGBO(
                                      //             175, 11, 190, 1.0))),
                                      // Text('Acc_y:${(acc_y)}g  ''Pitch:${(UI_x.toStringAsFixed(3))}°',
                                      //     style: const TextStyle(
                                      //         fontWeight: FontWeight.bold,
                                      //         fontSize: 20,
                                      //         color: Color.fromRGBO(
                                      //             190, 86, 11, 1.0))),
                                      // Text('Acc_z:${(acc_z)}g  ''Roll:${(UI_y.toStringAsFixed(3))}°',
                                      //     style: const TextStyle(
                                      //         fontWeight: FontWeight.bold,
                                      //         fontSize: 20,
                                      //         color: Color.fromRGBO(
                                      //             192, 108, 132, 1))),
                                      Text('Battery:${(UI_v)}v',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                              color: Color.fromRGBO(
                                                  6, 78, 20, 1.0))),
                                      // Text('Current value from IMU',
                                      //     style: TextStyle(fontSize: 14)),
                                      // Text('${currentValue}',
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.bold,
                                      //         fontSize: 24))
                                    ]),
                              ),
                              Expanded(
                                  flex: 5,
                                  child: Column(children: <Widget>[
                                    Container(
                                      color: const Color.fromARGB(255, 3, 3, 3),
                                      child: Center(
                                        child: CustomPaint(
                                          // 使用CustomPaint
                                          size: Size(width, width),
                                          painter: DialPainter(),
                                        ),
                                      ),
                                    ),
                                  ])),
                              Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        //width: 150.0,
                                          child:Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                child:new Card(
                                                  color: createMaterialColor(Color.fromARGB(255, 28, 41, 152)),
                                                  elevation: 5.0,
                                                  child: FlatButton(
                                                      onPressed: () async {

                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (context) {
                                                              return ChartRoute();
                                                            }));
                                                      },
                                                      child: new Padding(
                                                        padding: new EdgeInsets.all(10.0),
                                                        child: new Text(
                                                          'Chart',
                                                          style: new TextStyle(color: Colors.white, fontSize: 10.0),
                                                        ),
                                                      )
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child:new Card(
                                                  color: createMaterialColor(Color.fromARGB(255, 28, 41, 152)),
                                                  elevation: 5.0,
                                                  child: FlatButton(
                                                      onPressed: () {
                                                        reset_x = (double.tryParse(traceDust[4])!);
                                                        reset_y = (double.tryParse(traceDust[5])!)*-1;
                                                        // resetcurrentValue = (double.tryParse(traceDust[1])!);
                                                        // print("reset"+resetcurrentValue.toString());
                                                        //  print("C"+currentValue.toString());
                                                      },
                                                      child: new Padding(
                                                        padding: new EdgeInsets.all(10.0),
                                                        child: new Text(
                                                          '歸   零',
                                                          style: new TextStyle(color: Colors.white, fontSize: 10.0),
                                                        ),
                                                      )
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child:new Card(
                                                  color: createMaterialColor(Color.fromARGB(255, 28, 41, 152)),
                                                  elevation: 5.0,
                                                  child: FlatButton(
                                                      onPressed: () {
                                                        // if(!Toolname.text.isEmpty)
                                                        // {
                                                        // print((User(Toolname.text, Location.text).toJson().toString()));
                                                        // print(utf8.encode(User(Toolname.text, Location.text).toJson().toString()));
                                                        //mCharacteristic.write(utf8.encode(User(Toolname.text, Location.text).toJson().toString()));
                                                        //writeData(User(Toolname.text, Location.text).toJson().toString());
                                                        // Scaffold.of(context).showSnackBar(
                                                        //   SnackBar(content: Row(
                                                        //       children:<Widget>[
                                                        //         Text("已設定:${(10)}分鐘後休眠 傳送成功"),
                                                        //
                                                        //       ]
                                                        //   ),
                                                        //
                                                        //   ),
                                                        // );
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (context) {
                                                              return SleepRoute();
                                                            }));
                                                        // }
                                                        // else{
                                                        //   Scaffold.of(context).showSnackBar(
                                                        //     SnackBar(content: Row(
                                                        //         children:<Widget>[
                                                        //           Text("填寫不完整"),
                                                        //         ]
                                                        //     ),
                                                        //     ),
                                                        //   );
                                                        // }
                                                      },
                                                      child: new Padding(
                                                        padding: new EdgeInsets.all(1.0),
                                                        child: new Text(
                                                          '休眠設定',
                                                          style: new TextStyle(color: Colors.white, fontSize: 10.0),
                                                        ),
                                                      )
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 50,
                                                height: 50,
                                                child:new Card(
                                                  color: createMaterialColor(Color.fromARGB(255, 255, 0, 0)),
                                                  elevation: 5.0,
                                                  child: FlatButton(
                                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                                      onPressed: (){
                                                        sleeping();
                                                      },
                                                    // child: new Padding(
                                                    // padding: new EdgeInsets.all(1.0),
                                                    child: new Text(
                                                    '休眠',
                                                    style: new TextStyle(color: Colors.white, fontSize: 12.0),
                                                    ),
                                                      materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                                                    // ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                      )
                                    ],
                                  )
                              )
                              // Expanded(
                              //   flex: 1,
                              //   child: oscilloscope,
                              // )
                            ],
                          ));
                        } else {
                          return Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                const Text('Check the connection',
                                    style: TextStyle(fontSize: 18)),
                              ]));
                        }
                      },
                    ),
                  )),
      ),
    );

  }
}

class DialPainter extends CustomPainter{

  late double width;
  late double height;
  late double radius;
  late final Paint _paint = _initPaint();
  late double unit ;


  Paint _initPaint() {
    return Paint()
      ..isAntiAlias = true
      ..color = Colors.white;
  }

  @override
  void paint(Canvas canvas, Size size) {
    initSize(size);

    drawDial(canvas);

    //drawCalibration(canvas);

    drawText(canvas);


    drawCenter(canvas);

    var date = DateTime.now();
    //
    // drawHour(canvas, date);
    //
    // drawMinutes(canvas, date);
    //
    drawSeconds(canvas, date);

  }

  void initSize(Size size) {
    //
    width = size.width;
    height = size.height;
    radius = min(width, height)/2 ;
    unit = radius / 15;
  }

  void drawSeconds(Canvas canvas, DateTime date) {
    // double hourHalfHeight = 0.4 * unit;
    // double secondsLeft = -4.5 * unit;
    // double secondsTop = -hourHalfHeight;
    // double secondsRight = 12.5 * unit;
    // double secondsBottom = hourHalfHeight;

    Path secondsPath = Path();
    // secondsPath.moveTo(secondsLeft, secondsTop);
    //
    // /// 尾部弧形
    // var rect = Rect.fromLTWH(secondsLeft, secondsTop, 2.5 * unit, hourHalfHeight * 2);
    // secondsPath.addArc(rect, pi/2, pi);
    //
    // /// 尾部圆角矩形
    // var rRect = RRect.fromLTRBR(secondsLeft + 1 * unit, secondsTop, - 2 * unit, secondsBottom, Radius.circular(0.25 * unit));
    // secondsPath.addRRect(rRect);
    //
    // /// 指针
    // secondsPath.moveTo(- 2 * unit, - 0.125 * unit);
    // secondsPath.lineTo(secondsRight, 0);
    // secondsPath.lineTo(-2 * unit, 0.125 * unit);

    /// 中心圆
    var ovalRect = Rect.fromLTWH(- 0.67 * unit, - 0.67 * unit, 1.33 * unit, 1.33 * unit);
    secondsPath.addOval(ovalRect);

    canvas.save();
    canvas.translate(width/2, height/2);

    var z = sqrt((picx*picx)+(picy*picy));
    // print(z);
    if(z>90)
    {
      z=90;
      picx = (90)*(cos((atan2(picy, picx))))*(width-40)/180;
      picy = (90)*(sin((atan2(picy, picx))))*(width-40)/180;
    }
    else
    {
      picx = (z)*(cos((atan2(picy, picx))))*(width-40)/180;
      picy = (z)*(sin((atan2(picy, picx))))*(width-40)/180;
    }
    //c11 = c11*(width-40)/180;
    //c22 = c22*(width-40)/180;
    //print(c11.toString()+"cc");
    //print(c22.toString()+"mm");
    canvas.translate(picx,picy);

    /// 绘制阴影
    // canvas.drawShadow(secondsPath, const Color(0xFFcc0000), 0.17 * unit, true);

    /// 绘制秒针
    _paint.color = const Color(0xFFcc0000);
    canvas.drawPath(secondsPath, _paint);

    canvas.restore();
  }

  // void drawMinutes(Canvas canvas, DateTime date) {
  //   double hourHalfHeight = 0.4 * unit;
  //   double minutesLeft = -1.33 * unit;
  //   double minutesTop = -hourHalfHeight;
  //   double minutesRight = 11* unit;
  //   double minutesBottom = hourHalfHeight;
  //
  //   canvas.save();
  //   canvas.translate(width/2, height/2);
  //   canvas.rotate(2*pi/60 * (date.minute - 15 + date.second / 60));
  //
  //   /// 绘制分针
  //   var rRect = RRect.fromLTRBR(minutesLeft, minutesTop, minutesRight, minutesBottom, Radius.circular(0.42 * unit));
  //   _paint.color = const Color(0xFF343536);
  //   canvas.drawRRect(rRect, _paint);
  //
  //   canvas.restore();
  // }

  // void drawHour(Canvas canvas, DateTime date) {
  //
  //   double hourHalfHeight = 0.4 * unit;
  //   double hourRectRight =   7 * unit;
  //
  //   Path hourPath = Path();
  //   /// 添加矩形 时针主体
  //   hourPath.moveTo(0 - hourHalfHeight, 0 - hourHalfHeight);
  //   hourPath.lineTo(hourRectRight, 0 - hourHalfHeight);
  //   hourPath.lineTo(hourRectRight, 0 + hourHalfHeight);
  //   hourPath.lineTo(0 - hourHalfHeight, 0 + hourHalfHeight);
  //
  //   /// 时针箭头尾部弧形
  //   double offsetTop = 0.5 * unit;
  //   double arcWidth = 1.5 * unit;
  //   double arrowWidth = 2.17 * unit;
  //   double offset = 0.42 * unit;
  //   var rect = Rect.fromLTWH(hourRectRight - offset, 0 - hourHalfHeight - offsetTop, arcWidth, hourHalfHeight * 2 + offsetTop * 2);
  //   hourPath.addArc(rect, pi/2, pi);
  //   /// 时针箭头
  //   hourPath.moveTo(hourRectRight - offset + arcWidth/2, 0 - hourHalfHeight - offsetTop);
  //   hourPath.lineTo(hourRectRight - offset + arcWidth/2 + arrowWidth, 0);
  //   hourPath.lineTo(hourRectRight - offset + arcWidth/2, 0 + hourHalfHeight + offsetTop);
  //   hourPath.close();
  //
  //   canvas.save();
  //   canvas.translate(width/2, height/2);
  //   canvas.rotate(2*pi/60*((date.hour - 3 + date.minute / 60 + date.second/60/60) * 5 ));
  //   ///绘制
  //   _paint.color = const Color(0xFF232425);
  //   canvas.drawPath(hourPath, _paint);
  //   canvas.restore();
  // }

  void drawCenter(Canvas canvas) {
    var radialGradient =
    ui.Gradient.radial(Offset(width / 2, height / 2), radius, [
      const Color.fromARGB(255, 176, 116, 116),
      const Color.fromARGB(255, 234, 235, 241),
      const Color.fromARGB(255, 233, 236, 241),
    ], [0, 0.9, 1.0]);

    /// 底部背景
    _paint
      ..shader = radialGradient
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF000000);
    canvas.drawCircle(
        Offset(width/2, height/2), 2 * unit, _paint);


    /// 顶部圆点
    _paint
      ..shader = null
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFE5082E);
    //canvas.drawCircle(Offset(width/2, height/2), 0.8 * unit, _paint);
  }

  void drawDial(ui.Canvas canvas) {
    /// 绘制一个线性渐变的圆
    var gradient = ui.Gradient.linear(
        Offset(width/2, height/2 - radius),
        Offset(width/2, height/2 + radius),
        [const Color(0xFFF9F9F9), const Color(0xFF666666)]);

    _paint.shader = gradient;
    _paint.color = Colors.white;
    canvas.drawCircle(Offset(width/2, height/2), radius, _paint);

    /// 绘制一层径向渐变的圆
    var radialGradient = ui.Gradient.radial(Offset(width/2, height/2), radius, [
      const Color.fromARGB(216, 246, 248, 249),
      const Color.fromARGB(216, 229, 235, 238),
      const Color.fromARGB(216,205, 212, 217),
      const Color.fromARGB(216,245, 247, 249),
    ], [0, 0.92, 0.93, 1.0]);

    _paint.shader = radialGradient;
    canvas.drawCircle(Offset(width/2, height/2), radius -  0.3 * unit, _paint);

    /// 绘制一层border
    var shadowRadius = radius -  0.8 * unit;
    _paint
      ..color = const Color.fromARGB(33, 0, 0, 0)
      ..shader = null
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.1 * unit;
    canvas.drawCircle(Offset(width/2, height/2), shadowRadius - 0.2 * unit, _paint);

    ///绘制阴影
    Path path = Path();
    path.moveTo(width/2, height/2);
    var rect = Rect.fromLTRB(width/2 - shadowRadius, height/2 - shadowRadius, width/2+shadowRadius, height /2 +shadowRadius);
    path.addOval(rect);
    canvas.drawShadow(path, const Color.fromARGB(51, 0, 0, 0), 1 * unit, true);
  }

  /// 绘制刻度
  // void drawCalibration(ui.Canvas canvas) {
  //   double dialCanvasRadius = radius -  0.8 * unit;
  //   canvas.save();
  //   canvas.translate(width/2, height/2);
  //
  //   // var y = 0.0;
  //   // var x1 = 0.0;
  //   // var x2 = 0.0;
  //
  //    _paint.shader = null;
  //    _paint.color = const Color(0xFFC80E0E);
  //   // for( int i = 0; i < 60; i++){
  //   //   x1 =  dialCanvasRadius - (i % 5 == 0 ? 0.85 * unit : 1 * unit);
  //   //   x2 = dialCanvasRadius - (i % 5 == 0 ? 2 * unit : 1.67 * unit);
  //   //   _paint.strokeWidth = i % 5 == 0 ? 0.38 * unit : 0.2 * unit;
  //   //   canvas.drawLine(Offset(x1, y), Offset(x2, y), _paint);
  //   //   canvas.rotate(2*pi/60);
  //   // }
  //   canvas.restore();
  // }

  /// 绘制刻度上的值 +-
  void drawText(ui.Canvas canvas) {
    String m="";
    double dialCanvasRadius = radius +  1 * unit;
    var textPainter = TextPainter(
      text: const TextSpan(
          text:
          "+",
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, height: 1.0)),
      textDirection: TextDirection.rtl,
      textWidthBasis: TextWidthBasis.longestLine,
      maxLines: 1,
    )..layout();

    var offset = 2.25 * unit;
    var points = [
      Offset(width / 2 + dialCanvasRadius - offset - textPainter.width-6 , height / 2 - textPainter.height / 2 -3),
      Offset(width / 2 - textPainter.width /2, height / 2 + dialCanvasRadius - offset - textPainter.height),
      Offset(width / 2 - dialCanvasRadius + offset , height / 2  - textPainter.height / 2 -4),
      Offset(width / 2 - textPainter.width +2, height / 2 - dialCanvasRadius + offset-9),
    ];
    for(int i = 0; i< 4; i++){
      if(i==0 || i==3)
      {
        m="+";
      }
      else{
        m="-";
      }
      textPainter = TextPainter(
        text: TextSpan(
            text:
            m.toString(),
            style: const TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold, height: 1.0)),
        textDirection: TextDirection.rtl,
        textWidthBasis: TextWidthBasis.longestLine,
        maxLines: 1,
      )..layout();

      textPainter.paint(canvas, points[i]);
    }
  }
  //是指父控件重新渲染時是否重新繪製，這裡設置為true 表示每次都重新繪製
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

// class ChartRoute extends StatefulWidget {
//   @override
//   _ChartPageState createState() => _ChartPageState();
// }
class ChartRoute extends StatelessWidget {
  // const ChartRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // sleep(Duration(seconds: 1));
    // print("OK");
    // return MaterialApp(
    //     // title: 'Flutter Demo',
    //     theme: ThemeData(
    //     primarySwatch: createMaterialColor(Color.fromARGB(255, 28, 41, 152)),
    // ),
    // );
    return Scaffold(
      appBar: AppBar(
          title: Row(children: [
            Image.asset('assets/images/UMClogo2.jpg'),
            Container(
              padding: const EdgeInsets.all(35.0),
              child: Text('加速度'),
            )
          ],)
        //title: Text('UMC Test IMU'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Scaffold(
                      backgroundColor: Colors.black,
                      body: SfCartesianChart(
                          series: <LineSeries<Acc_xData,int>>[
                            LineSeries<Acc_xData, int>(
                              onRendererCreated: (ChartSeriesController controller1){
                                Future.delayed(Duration(milliseconds: 100));
                                _chartSeriesController1 = controller1;
                                print("chart123"+controller1.toString());
                              },
                              dataSource: XchartData!,
                              color: const Color.fromRGBO(
                                  190, 86, 11, 1.0),
                              xValueMapper: (Acc_xData value, _) =>value.time,
                              yValueMapper: (Acc_xData value, _) =>value.value,
                            )
                          ],
                          primaryXAxis: NumericAxis(
                              majorGridLines: const MajorGridLines(width: 0),
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              interval: 1,
                              title: AxisTitle(
                                  text: 'Time (s)',
                                  textStyle: const TextStyle(
                                      color: Color.fromRGBO(
                                          247, 246, 246, 1.0)))),
                          primaryYAxis: NumericAxis(
                              axisLine: const AxisLine(width: 0),
                              majorTickLines: const MajorTickLines(size: 0),
                              title: AxisTitle(
                                  text: 'X AXIS(g)',
                                  textStyle: const TextStyle(
                                      color: Color.fromRGBO(
                                          247, 246, 246, 1.0))))
                      ),
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Scaffold(
                      backgroundColor: Colors.black,
                      body: SfCartesianChart(
                          series: <LineSeries<Acc_yData,int>>[
                            LineSeries<Acc_yData, int>(
                              onRendererCreated: (ChartSeriesController controller2){
                                _chartSeriesController2=controller2;
                              },
                              dataSource: YchartData!,
                              color: const Color.fromRGBO(
                                  190, 86, 11, 1.0),
                              xValueMapper: (Acc_yData value, _) =>value.time,
                              yValueMapper: (Acc_yData value, _) =>value.value,
                            )
                          ],
                          primaryXAxis: NumericAxis(
                              majorGridLines: const MajorGridLines(width: 0),
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              interval: 1,
                              title: AxisTitle(
                                  text: 'Time (s)',
                                  textStyle: const TextStyle(
                                      color: Color.fromRGBO(
                                          247, 246, 246, 1.0)))),
                          primaryYAxis: NumericAxis(
                              axisLine: const AxisLine(width: 0),
                              majorTickLines: const MajorTickLines(size: 0),
                              title: AxisTitle(
                                  text: 'Y AXIS(g)',
                                  textStyle: const TextStyle(
                                      color: Color.fromRGBO(
                                          247, 246, 246, 1.0))))
                      ),
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Scaffold(
                      backgroundColor: Colors.black,
                      body: SfCartesianChart(
                          series: <LineSeries<Acc_zData,int>>[
                            LineSeries<Acc_zData, int>(
                              onRendererCreated: (ChartSeriesController controller3){
                                _chartSeriesController3=controller3;
                              },
                              dataSource: ZchartData!,
                              color: const Color.fromRGBO(
                                  190, 86, 11, 1.0),
                              xValueMapper: (Acc_zData value, _) =>value.time,
                              yValueMapper: (Acc_zData value, _) =>value.value,
                            )
                          ],
                          primaryXAxis: NumericAxis(
                              majorGridLines: const MajorGridLines(width: 0),
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              interval: 1,
                              title: AxisTitle(
                                  text: 'Time (s)',
                                  textStyle: const TextStyle(
                                      color: Color.fromRGBO(
                                          247, 246, 246, 1.0)))),
                          primaryYAxis: NumericAxis(
                              axisLine: const AxisLine(width: 0),
                              majorTickLines: const MajorTickLines(size: 0),
                              title: AxisTitle(
                                  text: 'Z AXIS(g)',
                                  textStyle: const TextStyle(
                                      color: Color.fromRGBO(
                                          247, 246, 246, 1.0))))
                      ),
                    )
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

