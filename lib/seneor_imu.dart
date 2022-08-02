import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';

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
   List<double> traceDust=[];
   List<double> traceDust1=[];
   // int max = 20;
   // int min = 10;
   // double currentValue=0;
   List<SalesData> chartData=[];
   List<XData> XchartData=[];
   ChartSeriesController? _chartSeriesController;
  ChartSeriesController? _chartSeriesController1;
   // late Timer _timer;
  @override
  void initState() {
    super.initState();
    isReady = true;
    Timer.periodic(const Duration(milliseconds: 500),(timer)
    {
      //print("HE");
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
      XchartData.add(XData(tim1, traceDust[tim1]));
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
    stream.add("123");{
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
                     var currentValue =(Random().nextDouble()).toString();
                     //currentValue = _dataParser(snapshot.data);
                     var currentvalue1 = (Random().nextDouble()).toString();
                    // print(currentValue);

                     traceDust.add(double.parse(currentValue));

                     //print(traceDust.toString()+"3");
                     traceDust1.add(double.parse(currentvalue1));
                     _getSeriesData1();
                     _getSeriesData();
                    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text('Current value from IMU',
                                        style:TextStyle(fontSize: 18)),
                                    Text('X:${currentValue}',
                                        style:const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,color: Color.fromRGBO(
                                            190, 86, 11, 1.0))),
                                    Text('Y:${currentvalue1}',
                                        style:const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,color: Color.fromRGBO(
                                            192, 108, 132, 1)))
                                  ]),
                            ),
                             Expanded(
                               flex: 1,
                               child:Scaffold(
                                 backgroundColor: Colors.black,
                                 body: SfCartesianChart(
                                     series: <LineSeries<XData, int>>[
                                       LineSeries<XData, int>(
                                         onRendererCreated: (ChartSeriesController controller1){
                                           _chartSeriesController1 = controller1;
                                         },
                                         dataSource: XchartData,
                                         color: const Color.fromRGBO(
                                             190, 86, 11, 1.0),
                                         xValueMapper: (XData value, _) =>value.time,
                                         yValueMapper: (XData value, _) =>value.value,
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
                                      text: 'X AXIS(°)',
                                      textStyle: const TextStyle(
                                          color: Color.fromRGBO(
                                              247, 246, 246, 1.0))))
                                 ),
                               )
                               //oscilloscope,
                             ),
                            Expanded(
                              flex: 1,
                              //child: oscilloscope1
                              child: Scaffold(
                                backgroundColor: Colors.black,
                                body: SfCartesianChart(
                                  series: <LineSeries<SalesData, int>>[
                                  LineSeries<SalesData, int>(
                                      onRendererCreated: (ChartSeriesController controller){
                                        _chartSeriesController = controller;
                                      },
                                      dataSource: chartData,
                                      color: const Color.fromRGBO(192, 108, 132, 1),
                                      xValueMapper: (SalesData sales, _) =>sales.year,
                                      yValueMapper: (SalesData sales, _) =>sales.sales,
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
                                      text: 'Y AXIS(°)',
                                      textStyle: const TextStyle(
                                          color: Color.fromRGBO(
                                              247, 246, 246, 1.0))))),
                              )
                              //charts.LineChart(_getSeriesData(), animate: true,),
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