import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:ui' as ui;
import 'main.dart';
import 'color.dart';
late double currentValue=0;
late double currentvalue1=0;
late double c11;
late double c22;
List<String> traceDust =[];
class SalesData {
  final int year;
  final double sales;
  SalesData(this.year, this.sales);
}

class XData {
  final int time;
  final double value;
  XData(this.time, this.value);
}

// class LinearSales{
//   final int index;
//   final int sales;
//   LinearSales({required this.index,required this.sales});
// }

class SensorPage extends StatefulWidget {
  //const SensorPage({Key? key, required this.device}) : super(key: key);
  //final BluetoothDevice device;

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  final String SERVICE_UUID = "7fafc202-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a9";
  bool isReady = true;
  StreamController <String> stream =StreamController();
  List<String> traceDust=[];
  List<double> traceDust1=[];
  // int max = 20;
  // int min = 10;
  // double currentValue=0;
  List<SalesData> chartData=[];
  List<XData> XchartData=[];
  late BluetoothCharacteristic characteristic1;
  ChartSeriesController? _chartSeriesController;
  ChartSeriesController? _chartSeriesController1;
  // late Timer _timer;
  @override
  void initState() {
    super.initState();
    isReady = true;
    //Isolate.spawn(connectToDevice(), isReady);
    // Isolate.spawn(connectToDevice(),"10");
    sleep(Duration(milliseconds: 500));
    Timer.periodic(const Duration(milliseconds: 500),(timer)
    {
      //print("HE");
      print(DateTime.now().toString());
      connectToDevice();

    }
    );
    // _timer= Timer.periodic(Duration(milliseconds: 500), (timer) {
    //   currentValue = (Random().nextDouble());
    //
    //   stream.add("123");
    // });

  }

  int tim =0;
  int tim1=0;
  _getSeriesData() {
    if(traceDust1.length==0)
    {
      List<SalesData> data = [
        SalesData(0, 10),
        // SalesData(2, Random().nextDouble()),
        // SalesData(3, Random().nextDouble()),
        // SalesData(4, Random().nextDouble()),
        // SalesData(5, 10),
        // SalesData(6, 10),
      ];
      List<charts.Series<SalesData, int>> series = [
        charts.Series(
            id: "Sales",
            data: data,
            domainFn: (SalesData series, _) => series.year,
            measureFn: (SalesData series, _) => series.sales,
            colorFn: (SalesData series, _) => charts.MaterialPalette.blue.shadeDefault
        )
      ];
      return series;
    }
    else{
      print("else");
      print(tim);
      print(traceDust1[tim]);
      print(traceDust1.length);
      chartData.add(SalesData(tim, traceDust1[tim]));
      tim++;
      // chartData.removeAt(0);
      // _chartSeriesController?.updateDataSource(addedDataIndex: chartData.length - 1, removedDataIndex: 0);

      if(chartData.length>22)
      {

        chartData.removeAt(0);
        _chartSeriesController?.updateDataSource(addedDataIndex: chartData.length-1, removedDataIndex: 0);
      }
      //print(chartData);
    }
    // List<charts.Series<LinearSales, int>> data =[];

  }
  _getSeriesData1() {
    if(traceDust.length==0)
    {
      List<XData> xdata = [
        XData(0, 1),
        // XData(2, Random().nextDouble()),
        // XData(3, Random().nextDouble()),
        // XData(4, Random().nextDouble()),
        // XData(5, 10),
        // XData(6, 10),
      ];
      List<charts.Series<XData, int>> series1 = [
        charts.Series(
            id: "value",
            data: xdata,
            domainFn: (XData series1, _) => series1.time,
            measureFn: (XData series1, _) => series1.value,
            colorFn: (XData series1, _) => charts.MaterialPalette.blue.shadeDefault
        )
      ];
      return series1;
    }
    else{
      print("elsex");
      print(tim1);
      print(traceDust[tim1]);
      print(traceDust.length);
      XchartData.add(XData(tim1, traceDust1[tim1]));
      tim1++;
      // chartData.removeAt(0);
      // _chartSeriesController?.updateDataSource(addedDataIndex: chartData.length - 1, removedDataIndex: 0);

      if(XchartData.length>22)
      {

        XchartData.removeAt(0);
        _chartSeriesController1?.updateDataSource(addedDataIndex: XchartData.length-1, removedDataIndex: 0);
      }
      //print(chartData);
    }
    // List<charts.Series<LinearSales, int>> data =[];

  }
  connectToDevice() async {
    // if (widget.device != null) {
    //   _Pop();
    //   return;
    // }
    // _timer= Timer.periodic(Duration(milliseconds: 500), (timer)
    // new Timer(const Duration(milliseconds: 500),()
    //     {
    if (!isReady) {
      disconnectFromDevice();
      //_Pop();
    }
    //     } );
    else{
      print("object");
      discoverServices();
    }


    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   currentValue = (Random().nextDouble());
    //print(currentValue.toString());
    //build(context);
    // if (!isReady) {
    //   disconnectFromDevice();
    //   _Pop();
    // }
    // });
    // print("123");
    //await widget.device.connect();

  }

  disconnectFromDevice() {
    // if (widget.device == null) {
    //   _Pop();
    //   return;
    // }

    //widget.device.disconnect();
  }

  discoverServices() async {
    // if (widget.device == null) {
    //   _Pop();
    //   return;
    // }
    //
    //print("123");

    stream.add("110");{
      setState(() {
        isReady= true;
      });
    }
    // List<BluetoothService> services = await widget.device.discoverServices();
    // services.forEach((service) {
    //   if (service.uuid.toString() == SERVICE_UUID) {
    //     service.characteristics.forEach((characteristic) {
    //       if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
    //         characteristic.setNotifyValue(!characteristic.isNotifying);
    //         stream = characteristic.value;
    //
    //         setState(() {
    //           isReady = true;
    //         });
    //       }
    //     });
    //   }
    // });
    //
    // if (!isReady) {
    //   _Pop();
    // }

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
                  disconnectFromDevice();
                  Navigator.of(context).pop(true);
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return FindDevicesScreen();
                  }));
                },
                child: new Text('Yes')),
          ],
        ) );
    return false;
  }
  // Future<bool> _onWillPop() async{
  //     showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: Text('Are you sure?'),
  //             content: Text('Do you want to disconnect device and go back?'),
  //             actions: <Widget>[
  //               new FlatButton(
  //                   onPressed: () => Navigator.of(context).pop(false),
  //                   child: new Text('No')),
  //               new FlatButton(
  //                   onPressed: () {
  //                     disconnectFromDevice();
  //                     Navigator.of(context).pop(true);
  //                   },
  //                   child: new Text('Yes')),
  //             ],
  //           );
  //         }
  //     );
  //     return false;
  // }

  _Pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // if(traceDust1.length>1)
    //   {
    //     //print(traceDust1[0].toString());
    //
    //   }

    // Oscilloscope oscilloscope = Oscilloscope(
    //   showYAxis: true,
    //   yAxisColor: Colors.orange,
    //   //padding: 20.0,
    //   strokeWidth: 1.0,
    //   margin: const EdgeInsets.all(20.0),
    //   backgroundColor: Colors.black,
    //   traceColor: Colors.white,
    //   yAxisMax: 5.0,
    //   yAxisMin: -5.0,
    //   dataSet: traceDust,
    // );
    // Oscilloscope oscilloscope1 = Oscilloscope(
    //   showYAxis: true,
    //   yAxisColor: Colors.yellow,
    //   //padding: 20.0,
    //   strokeWidth: 1.0,
    //   margin: const EdgeInsets.all(20.0),
    //   backgroundColor: Colors.black,
    //   traceColor: Colors.white,
    //   yAxisMax: 5.0,
    //   yAxisMin: -5.0,
    //   dataSet: traceDust1,
    // );
    //print(isReady.toString()+"!");
    // _getSeriesData();
    // _getSeriesData1();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
            title: Row(children: [
              Image.asset('assets/images/UMClogo2.jpg'),
              Container(
                padding: const EdgeInsets.all(35.0),
                child: Text('IMU Sensor'),
              )
            ],)//Text('IMU Sensor'),
          //centerTitle: true,
        ),
        body: Container(
            child: Container(
              child: StreamBuilder<String>(
                stream: stream.stream,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  print(snapshot);
                  // if (snapshot.hasError)
                  //   return Text('Error: ${snapshot.error}');

                  if (snapshot.connectionState ==
                      ConnectionState.active) {
                     currentValue =(Random().nextInt(20)*1);

                     var testvalue = _dataParser([45, 49, 52, 48, 46, 57, 50, 59, 51, 46, 50, 55, 59, 52, 46, 53, 52, 59]);
                     print(testvalue.split(";").toString());
                     traceDust= testvalue.split(";");
                     //traceDust.add(double.tryParse(t[0])?? 0);
                     //List<String> t= testvalue.split(";");
                     print(traceDust[1]);
                     currentValue = (double.tryParse(traceDust[1])!)*100;
                     print(currentValue);
                     currentValue =(30);
                     print(currentValue);
                    //currentValue = _dataParser(snapshot.data);
                     currentvalue1 = (60);
                    // print(currentValue);

                    //traceDust.add(double.parse(currentValue));

                    //print(traceDust.toString()+"3");
                    //traceDust1.add(double.parse(currentvalue1));
                    //_getSeriesData1();
                    //_getSeriesData();
                    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text('Current value from IMU',
                                        style:TextStyle(fontSize: 18)),
                                    Container(
                                        child:Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                    Text('Pitch:${(_dataParser([45, 49, 52, 48, 46, 57, 50, 59]))}°',
                                        style:const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,color: Color.fromRGBO(
                                            190, 86, 11, 1.0))),
                                    Text('Roll:${currentvalue1.toStringAsFixed(2)}°',
                                        style:const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,color: Color.fromRGBO(
                                            192, 108, 132, 1))),
                                    // Text('Battery:0 v',
                                    //     style:const TextStyle(
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 24,color: Color.fromRGBO(
                                    //         6, 78, 20, 1.0))),
                                       ] )),
                                    Container(
                                        child:Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Text('Pitch:${(_dataParser([45, 49, 52, 48, 46, 57, 50, 59]))}°',
                                                  style:const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 24,color: Color.fromRGBO(
                                                      190, 86, 11, 1.0))),
                                              Text('Roll:${currentvalue1.toStringAsFixed(2)}°',
                                                  style:const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 24,color: Color.fromRGBO(
                                                      192, 108, 132, 1))),
                                              // Text('Battery:0 v',
                                              //     style:const TextStyle(
                                              //         fontWeight: FontWeight.bold,
                                              //         fontSize: 24,color: Color.fromRGBO(
                                              //         6, 78, 20, 1.0))),
                                            ] )),
                                    Container(
                                        child:Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Text('Pitch:${(_dataParser([45, 49, 52, 48, 46, 57, 50, 59]))}°',
                                                  style:const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 24,color: Color.fromRGBO(
                                                      190, 86, 11, 1.0))),
                                              Text('Roll:${currentvalue1.toStringAsFixed(2)}°',
                                                  style:const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 24,color: Color.fromRGBO(
                                                      192, 108, 132, 1))),
                                              // Text('Battery:0 v',
                                              //     style:const TextStyle(
                                              //         fontWeight: FontWeight.bold,
                                              //         fontSize: 24,color: Color.fromRGBO(
                                              //         6, 78, 20, 1.0))),
                                            ] )),
                                  ]),
                            ),
                            // Expanded(
                            //     flex: 1,
                            //     child:Scaffold(
                            //       backgroundColor: Colors.black,
                            //       body: SfCartesianChart(
                            //           series: <LineSeries<XData, int>>[
                            //             LineSeries<XData, int>(
                            //               onRendererCreated: (ChartSeriesController controller1){
                            //                 _chartSeriesController1 = controller1;
                            //               },
                            //               dataSource: XchartData,
                            //               color: const Color.fromRGBO(
                            //                   190, 86, 11, 1.0),
                            //               xValueMapper: (XData value, _) =>value.time,
                            //               yValueMapper: (XData value, _) =>value.value,
                            //             )
                            //           ],
                            //           primaryXAxis: NumericAxis(
                            //               majorGridLines: const MajorGridLines(width: 0),
                            //               edgeLabelPlacement: EdgeLabelPlacement.shift,
                            //               interval: 1,
                            //               title: AxisTitle(
                            //                   text: 'Time (s)',
                            //                   textStyle: const TextStyle(
                            //                       color: Color.fromRGBO(
                            //                           247, 246, 246, 1.0)))),
                            //           primaryYAxis: NumericAxis(
                            //               axisLine: const AxisLine(width: 0),
                            //               majorTickLines: const MajorTickLines(size: 0),
                            //               title: AxisTitle(
                            //                   text: 'X AXIS(°)',
                            //                   textStyle: const TextStyle(
                            //                       color: Color.fromRGBO(
                            //                           247, 246, 246, 1.0))))),
                            //     )
                            //   //oscilloscope,
                            // ),
                            // Expanded(
                            //     flex: 1,
                            //     //child: oscilloscope1
                            //     child: Scaffold(
                            //       backgroundColor: Colors.black,
                            //       body: SfCartesianChart(
                            //           series: <LineSeries<SalesData, int>>[
                            //             LineSeries<SalesData, int>(
                            //               onRendererCreated: (ChartSeriesController controller){
                            //                 _chartSeriesController = controller;
                            //               },
                            //               dataSource: chartData,
                            //               color: const Color.fromRGBO(192, 108, 132, 1),
                            //               xValueMapper: (SalesData sales, _) =>sales.year,
                            //               yValueMapper: (SalesData sales, _) =>sales.sales,
                            //             )
                            //           ],
                            //           primaryXAxis: NumericAxis(
                            //               majorGridLines: const MajorGridLines(width: 0),
                            //               edgeLabelPlacement: EdgeLabelPlacement.shift,
                            //               interval: 1,
                            //               title: AxisTitle(
                            //                   text: 'Time (s)',
                            //                   textStyle: const TextStyle(
                            //                       color: Color.fromRGBO(
                            //                           247, 246, 246, 1.0)))),
                            //           primaryYAxis: NumericAxis(
                            //               axisLine: const AxisLine(width: 0),
                            //               majorTickLines: const MajorTickLines(size: 0),
                            //               title: AxisTitle(
                            //                   text: 'Y AXIS(°)',
                            //                   textStyle: const TextStyle(
                            //                       color: Color.fromRGBO(
                            //                           247, 246, 246, 1.0))))),
                            //     )
                            //   //charts.LineChart(_getSeriesData(), animate: true,),
                            // )
                            Expanded(
                                flex: 5,
                                child: Column(
                                    children: <Widget>[
                                      Container(
                                        color: const Color.fromARGB(
                                            255, 3, 3, 3),
                                        child: Center(
                                          child: CustomPaint(
                                            // 使用CustomPaint
                                            size: Size(width, width),
                                            painter: DialPainter(),
                                          ),
                                        ),
                                      ),
                                    ]
                                )
                            ),
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
                                                elevation: 10.0,
                                                child: FlatButton(
                                                    onPressed: () {

                                                    },
                                                    child: new Padding(
                                                      padding: new EdgeInsets.all(10.0),
                                                      child: new Text(
                                                        'Acc chart',
                                                        style: new TextStyle(color: Colors.white, fontSize: 10.0),
                                                      ),
                                                    )
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child:new Card(
                                                color: createMaterialColor(Color.fromARGB(255, 28, 41, 152)),
                                                elevation: 10.0,
                                                child: FlatButton(
                                                    onPressed: () {
                                                      // reset_x = (double.tryParse(traceDust[1])!);
                                                      // reset_y = (double.tryParse(traceDust[2])!)*-1;
                                                      // resetcurrentValue = (double.tryParse(traceDust[1])!);
                                                      // print("reset"+resetcurrentValue.toString());
                                                      // print("C"+currentValue.toString());
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
                                                elevation: 10.0,
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
                                                      // Navigator.push(context,
                                                      //     MaterialPageRoute(builder: (context) {
                                                      //       return SleepRoute();
                                                      //     }));
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
                                                      padding: new EdgeInsets.all(10.0),
                                                      child: new Text(
                                                        '休眠設定',
                                                        style: new TextStyle(color: Colors.white, fontSize: 10.0),
                                                      ),
                                                    )
                                                ),
                                              ),

                                            ),

                                          ],
                                        )

                                    )
                                  ],
                                )
                            )
                          ],
                        ));
                  } else {
                    return Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('Check the connection',
                                  style:TextStyle(fontSize: 18)),
                            ]));//Text(,'Check the stream');
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
    print(width);
    print(currentValue);
    print(currentvalue1);

    var z = sqrt((currentValue*currentValue)+(currentvalue1*currentvalue1));
    print(z);
    if(z>90)
      {
        z=90;
        c11 = (90)*(cos((atan2(currentvalue1, currentValue))))*(width-40)/180;
        c22 = (90)*(sin((atan2(currentvalue1, currentValue))))*(width-40)/-180;
      }
    else
      {
        c11 = (z)*(cos((atan2(currentvalue1, currentValue))))*(width-40)/180;
        c22 = (z)*(sin((atan2(currentvalue1, currentValue))))*(width-40)/-180;
      }
    // var currentValue123 =currentValue*(cos((atan2(currentvalue1, currentValue))));
    // var currentvalue1234 =currentvalue1*(sin((atan2(currentvalue1, currentValue))));
    // print(currentValue123);
    // print(currentvalue1234);
    //c11=(currentValue123-10)*(width)/180;
    //c22=(currentvalue1234-10)*(width)/-180;
    // c11=(90-10)*(cos((atan2(currentvalue1, currentValue))))*(width)/180;
    // c22=(90-10)*(sin((atan2(currentvalue1, currentValue))))*(width)/-180;

    print(c11);
    print(c22);
    print((cos((atan2(currentvalue1, currentValue)))));
    print((sin((atan2(currentvalue1, currentValue)))));
    canvas.translate(c11,c22);

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