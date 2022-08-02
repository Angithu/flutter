// import 'package:flutter/material.dart';
// import 'color.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'imu.dart';
// // class ChartRoute extends StatefulWidget {
// //   @override
// //   _ChartPageState createState() => _ChartPageState();
// // }
//
//
// class ChartRoute extends StatelessWidget{
//    const ChartRoute({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     // return MaterialApp(
//     //     // title: 'Flutter Demo',
//     //     theme: ThemeData(
//     //     primarySwatch: createMaterialColor(Color.fromARGB(255, 28, 41, 152)),
//     // ),
//     // );
//     return Scaffold(
//       appBar: AppBar(
//           title: Row(children: [
//             Image.asset('assets/images/UMClogo2.jpg'),
//             Container(
//               padding: const EdgeInsets.all(35.0),
//               child: Text('加速度'),
//             )
//           ],)
//         //title: Text('UMC Test IMU'),
//       ),
//       body: Builder(
//         builder: (BuildContext context) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                     flex: 1,
//                     child: Scaffold(
//                       backgroundColor: Colors.black,
//                       body: SfCartesianChart(
//                           series: <LineSeries<Acc_xData,int>>[
//                             LineSeries<Acc_xData, int>(
//                               onRendererCreated: (ChartSeriesController controller1){
//                                 chartSeriesController![0] = controller1;
//                                 print("chart123");
//                               },
//                               dataSource: XchartData,
//                               color: const Color.fromRGBO(
//                                   190, 86, 11, 1.0),
//                               xValueMapper: (Acc_xData value, _) =>value.time,
//                               yValueMapper: (Acc_xData value, _) =>value.value,
//                             )
//                           ],
//                           primaryXAxis: NumericAxis(
//                               majorGridLines: const MajorGridLines(width: 0),
//                               edgeLabelPlacement: EdgeLabelPlacement.shift,
//                               interval: 1,
//                               title: AxisTitle(
//                                   text: 'Time (s)',
//                                   textStyle: const TextStyle(
//                                       color: Color.fromRGBO(
//                                           247, 246, 246, 1.0)))),
//                           primaryYAxis: NumericAxis(
//                               axisLine: const AxisLine(width: 0),
//                               majorTickLines: const MajorTickLines(size: 0),
//                               title: AxisTitle(
//                                   text: 'X AXIS(g)',
//                                   textStyle: const TextStyle(
//                                       color: Color.fromRGBO(
//                                           247, 246, 246, 1.0))))
//                       ),
//                     )
//                 ),
//                 Expanded(
//                     flex: 1,
//                     child: Scaffold(
//                       backgroundColor: Colors.black,
//                       body: SfCartesianChart(
//                           series: <LineSeries<Acc_yData,int>>[
//                             LineSeries<Acc_yData, int>(
//                               onRendererCreated: (ChartSeriesController controller2){
//                                 _chartSeriesController2=controller2;
//                               },
//                               dataSource: YchartData,
//                               color: const Color.fromRGBO(
//                                   190, 86, 11, 1.0),
//                               xValueMapper: (Acc_yData value, _) =>value.time,
//                               yValueMapper: (Acc_yData value, _) =>value.value,
//                             )
//                           ],
//                           primaryXAxis: NumericAxis(
//                               majorGridLines: const MajorGridLines(width: 0),
//                               edgeLabelPlacement: EdgeLabelPlacement.shift,
//                               interval: 1,
//                               title: AxisTitle(
//                                   text: 'Time (s)',
//                                   textStyle: const TextStyle(
//                                       color: Color.fromRGBO(
//                                           247, 246, 246, 1.0)))),
//                           primaryYAxis: NumericAxis(
//                               axisLine: const AxisLine(width: 0),
//                               majorTickLines: const MajorTickLines(size: 0),
//                               title: AxisTitle(
//                                   text: 'Y AXIS(g)',
//                                   textStyle: const TextStyle(
//                                       color: Color.fromRGBO(
//                                           247, 246, 246, 1.0))))
//                       ),
//                     )
//                 ),
//                 Expanded(
//                     flex: 1,
//                     child: Scaffold(
//                       backgroundColor: Colors.black,
//                       body: SfCartesianChart(
//                           series: <LineSeries<Acc_zData,int>>[
//                             LineSeries<Acc_zData, int>(
//                               onRendererCreated: (ChartSeriesController controller3){
//                                 _chartSeriesController3=controller3;
//                               },
//                               dataSource: ZchartData,
//                               color: const Color.fromRGBO(
//                                   190, 86, 11, 1.0),
//                               xValueMapper: (Acc_zData value, _) =>value.time,
//                               yValueMapper: (Acc_zData value, _) =>value.value,
//                             )
//                           ],
//                           primaryXAxis: NumericAxis(
//                               majorGridLines: const MajorGridLines(width: 0),
//                               edgeLabelPlacement: EdgeLabelPlacement.shift,
//                               interval: 1,
//                               title: AxisTitle(
//                                   text: 'Time (s)',
//                                   textStyle: const TextStyle(
//                                       color: Color.fromRGBO(
//                                           247, 246, 246, 1.0)))),
//                           primaryYAxis: NumericAxis(
//                               axisLine: const AxisLine(width: 0),
//                               majorTickLines: const MajorTickLines(size: 0),
//                               title: AxisTitle(
//                                   text: 'Z AXIS(g)',
//                                   textStyle: const TextStyle(
//                                       color: Color.fromRGBO(
//                                           247, 246, 246, 1.0))))
//                       ),
//                     )
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       // body: Center(
//       //     child:RaisedButton(
//       //         child: Text("器材一"),
//       //         onPressed: (){
//       //           Navigator.maybePop(context);
//       //           ScaffoldMessenger.of(context).showSnackBar(
//       //             const SnackBar(content: Text('登出')),
//       //           );
//       //         }
//       //     )
//       // ),
//     );
//   }
// }