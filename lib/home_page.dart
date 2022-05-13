import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:receipt_reader/storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.storage}) : super(key: key);

  final Storage storage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Map<String, dynamic> receiptData;

  List<PieChartSectionData> sectionData = [];
  List<BarChartGroupData> barChartData = [];
  Map<String, dynamic> totalAggregate = {};
  late Map<String, dynamic> weekdayAggregate = {};
  int touchIndex = -1;
  static const Color textColor = Colors.black;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffdfdfdc),
      body: FutureBuilder(
        future: getData(),
        builder:(context, snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            return ListView(
              children: <Widget> [
                SafeArea(
//                  color: const Color(0xff2c4260),
                  child: AspectRatio(
                    aspectRatio: 4/3,
                    child:PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions || pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                                  touchIndex = -1;
                                  return;
                            }
                            touchIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;

                          });
                        }),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: sectionData,
                      ),
                    ),
                  ),
                ),
                // BAR GRAPH GOES HERE
                Padding(
                  padding: const EdgeInsets.all(8),
//                  color: const Color(0xff2c4260),
                  child: AspectRatio(
                    aspectRatio: 4/3,
                    child: BarChart(
                      BarChartData(
                        titlesData: titlesData,
                        barGroups: barChartData,
                        gridData: FlGridData(show: true),
                        maxY: 500,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }

  Future<Map<String, dynamic>> getData() async {
    Future<Map<String, dynamic>>? data = widget.storage.read();
    receiptData = await data;
    totalAggregate.clear();
    weekdayAggregate.clear();
    for (String k in receiptData.keys) {
      // Date conversion for bar chart
      var date = convertDate(receiptData[k]["date"]);
      var date1 = DateTime.parse(date);

      // Aggregate data for weekdays
      if (weekdayAggregate.containsKey(date1.weekday.toString())) {
        weekdayAggregate[date1.weekday.toString()] += double.parse(receiptData[k]["total"]);
      }
      else {
        weekdayAggregate[date1.weekday.toString()] = double.parse(receiptData[k]["total"]);
      }

      if (totalAggregate.containsKey(receiptData[k]["place"])) {
        totalAggregate[receiptData[k]["place"]] += double.parse(receiptData[k]["total"]);
      }
      else {
        totalAggregate[receiptData[k]["place"]] = double.parse(receiptData[k]["total"]);
      }
    }

    barChartData.clear();
    for (int i = 1; i < 8; i++) {
      barChartData.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: weekdayAggregate.containsKey(i.toString()) ? weekdayAggregate[i.toString()] : 0,
              gradient: _barsGradient,
            )
          ],
        ),
      );
    }

    int i = 0;
    final isTouched = i == touchIndex;
    final fontSize = isTouched ? 25.0 : 16.0;
    final radius = isTouched ? 60.0 : 50.0;
    sectionData.clear();
    for (String k in totalAggregate.keys) {
      sectionData.add(
        PieChartSectionData(
          color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          value: totalAggregate[k],
          title: k,
          radius: radius,
          titleStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: fontSize,
          ),
        ),
      );
    }
    return totalAggregate;
  }
  
  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        interval: 1,
        getTitlesWidget: leftTitles,
      ),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 100) {
      text = '\$100';
    } else if (value == 200) {
      text = '\$200';
    } else if (value == 300) {
      text = '\$300';
    } else if (value == 400) {
      text = '\$400';
    } else if (value == 500) {
      text = '\$500';
    } else {
      return Container();
    }
    return Text(text, style: style);
  }

  final _barsGradient = const LinearGradient(
    colors: [
      Colors.lightBlueAccent,
      Colors.greenAccent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

   Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = 'Mn';
        break;
      case 2:
        text = 'Te';
        break;
      case 3:
        text = 'Wd';
        break;
      case 4:
        text = 'Tu';
        break;
      case 5:
        text = 'Fr';
        break;
      case 6:
        text = 'St';
        break;
      case 7:
        text = 'Sn';
        break;
      default:
        text = '';
        break;
    }
    return Center(child: Text(text, style: style));
  }

  String convertDate(String initDate) {
    String newDate = "";
    String day;
    String month;
    String year;

    var temp = initDate.split("/");

    month = temp[0];
    day = temp[1];
    year = temp[2];

    if (year.length == 2) {
      year = "20" + year;
    }
    if (month.length == 1) {
      month = "0" + month;
    }
    if (day.length == 1) {
      day = "0" + day;
    }

    newDate = year + "-" + month + "-" + day;

    return newDate;
  }

}