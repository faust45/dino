import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'utils.dart';
import 'state.dart';
import 'models/calendar.dart' as cal;
import 'utils/rx_value.dart';

void main() {
  // debugRepaintRainbowEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: autow(monthNavigation, cal.Calendar.currentDate),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: calendar()
        )
      ),
    );
  }
}

Widget monthNavigation(date) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: EdgeInsets.only(top: 3),
        child: IconButton(
          onPressed: () => emit(cal.CalPrevMonth()),
          icon: const Icon(Icons.navigate_before_sharp),
        )
      ),
      SizedBox(width: 10),
      Text(fmt.month(date)),
      SizedBox(width: 10),
      Padding(
        padding: EdgeInsets.only(top: 3),
        child: IconButton(
          onPressed: () => emit(cal.CalNextMonth()),
          icon: const Icon(Icons.navigate_next_sharp),
        )
      )
    ]
  );
}

Widget calendar() {
  var pageController = PageController(
    initialPage: cal.Calendar.currentPage,
  );
  
  var timeLine = timeRange([08, 00], [20, 00], [00, 30]);

  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      TimeSheets.lineWidth = (constraints.minWidth - TimeSheets.paddingRight) / cal.Calendar.daysOnScreen;
      
      return Scrollable(
        viewportBuilder: (BuildContext context, ViewportOffset offset) {
          return Semantics(
            tagForChildren: RenderViewport.useTwoPaneSemantics,
            child: Stack(
              children: [
                Viewport(
                  offset: offset,
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                          Container(
                            // height: double.infinity,
                            height: 1000,
                            width: double.infinity,
                            child: RepaintBoundary(
                              child: CustomPaint(
                                painter: TimeSheets(timeLine, cal.Calendar.daysOnScreen)
                              )
                            ),
                          )                          
                        ]
                      )
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 40),
                    Expanded(
                      child: autow(
                        (date) => PageView.builder(
                          onPageChanged: (page) => emit(cal.CalPageChanged(page)),
                          controller: pageController,
                          itemBuilder: (ctx, page) {
                            var selectedDays = cal.Calendar.daysByPage(page).toList();
                            
                            return Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Stack(
                                children: [
                                  daysLine(timeLine, selectedDays),
                                  Viewport(
                                    offset: offset,
                                    slivers: [
                                      SliverList(
                                        delegate: SliverChildListDelegate([
                                            autow(
                                              (value) => renderEvents(timeLine, selectedDays, cal.Calendar.eventsForDays(selectedDays)),
                                              cal.Calendar.onEventChanges
                                            )                           
                                          ]
                                        )
                                      )
                                    ],
                                  )
                                ]
                              )
                            );
                          }
                        ),
                        cal.Calendar.currentMonth
                      )
                    )
                  ]
                ),
              ]
            )
          );
        }
      );
    }
  );
}

Widget daysLine(timeLine, selectedDays) {
  return Container(
    child: Row(
      children: [
        for(var day in selectedDays)
        Expanded(
          child: Column(
            children: [
              Text(
                "${fmt.weekDay(day)}",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16
                )
              ),
              Text(
                "${day.day}",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14
                )
              )
            ]
          )
        )
      ]
    )
  );
}

Widget renderEvents(timeLine, selectedDays, events) {
  print(TimeSheets.lineWidth);
  var eventsWithCoords = events.map((cal.Event e) {
      int x = selectedDays.indexOf(e.startAt.beginningOfDay());
      int y = timeLine.indexOf(TimeOfDay.fromDateTime(e.startAt));
      return [x * TimeSheets.lineWidth + TimeSheets.paddingLeft, y * TimeSheets.cellHeight + TimeSheets.paddingTop];
  });

  print(eventsWithCoords);
  return Container(
    height: 1000,
    child: Stack(
      children: [
        for(var e in eventsWithCoords)
        Positioned(
          top: e[1],
          left: e[0],
          child: Container(child: Text("love"))
        )
      ]
    )
  );
}

class TimeSheets extends CustomPainter {

  int daysOnSceen;
  List<TimeOfDay> timeLine;
  static double lineWidth = 0, cellHeight = 40, paddingRight = 50, paddingLeft = 5, paddingTop = 8 + 65;
  
  TimeSheets(this.timeLine, this.daysOnSceen);
  
  @override
  void paint(Canvas canvas, Size size) {
    print("repaint timesheet");
    var paint = Paint()
    ..strokeWidth = 0.6
    ..color = Colors.grey;

    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 14.0,
    );

    
    for(var y = 0; y < this.timeLine.length; y++) {
      TextPainter tp = new TextPainter(
        text: TextSpan(
          text: timeOfDay(timeLine[y]),
          style: textStyle,
        ),
        textDirection: ui.TextDirection.ltr
      );
      tp.layout();
      tp.paint(canvas, new Offset(paddingLeft, paddingTop  - 8 + cellHeight * y));
      
      for(var x = 0; x <= this.daysOnSceen - 1; x++) {
        var p1 = Offset(
          lineWidth * x + paddingRight,
          cellHeight * y + paddingTop
        );
        var p2 = p1 + Offset(lineWidth - 10, 0);

        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(TimeSheets oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(TimeSheets oldDelegate) => false;
  
  List<int> getCellCoords(Offset pos) {
    var x = pos.dx - paddingRight;
    var y = pos.dy - paddingTop;
    var idy = ((y + cellHeight * 0.5) / cellHeight).round();
    var idx = ((x + lineWidth * 0.5) / lineWidth).round();

    return [idx, idy];
  }
}

String timeOfDay (TimeOfDay t) {
  final String hourLabel = _addLeadingZero(t.hour);
  final String minuteLabel = _addLeadingZero(t.minute);

  return '$hourLabel:$minuteLabel';
}

String _addLeadingZero(int value) {
  if (value < 10)
  return '0$value';
  return value.toString();
}

List<TimeOfDay> timeRange(start, end, inc) {
  List<TimeOfDay> res = [];
  var counth = start[0];
  var countm = start[1];
  var ih = inc[0];
  var im = inc[1];
  var endh = end[0];
  var endm = end[1];

  res.add(
    TimeOfDay(
      hour: counth,
      minute: countm
    )
  );
  while(counth < endh  || (counth == endh && countm < endm)) {
    counth += ih;
    countm += im;
    if (countm >= 60) {
      countm = countm - 60;
      counth += 1;
    }

    res.add(
      TimeOfDay(
        hour: counth,
        minute: countm
      )
    );
  }

  return res;
}
