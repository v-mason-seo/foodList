import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

import '../service/ads.dart';
import 'bus_service.dart';
import 'model/busSchedule.dart';

class BusScheduleScreen extends StatefulWidget {
  final BusSchedule busSchedule;
  BusScheduleScreen({Key key, this.busSchedule}) : super(key: key);

  @override
  _BusScheduleScreenState createState() => _BusScheduleScreenState();
}

class _BusScheduleScreenState extends State<BusScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    final BusService busService = Provider.of<BusService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("버스", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: widget.busSchedule.bookmark == true
                    ? Icon(Icons.bookmark)
                    : Icon(Icons.bookmark_border),
            onPressed: () {
              busService.setBookmark( widget.busSchedule );
            },
          )
        ],
      ),
      body: Container(
        // margin: EdgeInsets.only(
        //     bottom: Ads().getMargin(MediaQuery.of(context).size.height)),
        child: _getBodyWidget(),
      ),
    );
  }

  Widget _busInfoView() {
    return Container(
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: widget.busSchedule.gowork == true ? Colors.red : Colors.blueAccent,
            ),
            //color: widget.busSchedule.gowork == true ? Colors.red : Colors.blueAccent,
            child: Text(
              (widget.busSchedule.gowork == true ? "출근" : "퇴근"),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),   
          widget.busSchedule.holiday == true ?
            Container(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: widget.busSchedule.holiday == true ? Colors.orange : Colors.blueAccent,
              ),
              child: Text(
                ( "휴일"),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ) :
          Container(),
          SizedBox(
            width: 10,
          ),
          Text(
            widget.busSchedule.start,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Icon(Icons.keyboard_arrow_right),
          ),
          Text(
            widget.busSchedule.end,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      )),
      height: 80,
    );
  }

  Widget _getBodyWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          _busInfoView(),
          _buildBusTable(),
          // Flexible(
          //   child: HorizontalDataTable(
          //     leftHandSideColumnWidth: 110,
          //     rightHandSideColumnWidth: max(MediaQuery.of(context).size.width - 100, (widget.busSchedule.schedule.length * 60).toDouble()) ,
          //     isFixedHeader: true,
          //     headerWidgets: _getTitleWidget(),
          //     leftSideItemBuilder: _generateFirstColumnRow,
          //     rightSideItemBuilder: _generateRightHandSideColumnRow,
          //     itemCount: widget.busSchedule.route.length,
          //     rowSeparatorWidget: const Divider(
          //       color: Colors.black54,
          //       height: 1.0,
          //       thickness: 0.0,
          //     ),
          //   ),
          // )
        ],
      ),
      //height: MediaQuery.of(context).size.height,
    );
  }

  Widget _buildBusTable() {
    return Expanded(
      child: StickyHeadersTable(
        columnsLength: widget.busSchedule.schedule.length,
        rowsLength: widget.busSchedule.route.length,
        //-----------------------------------------------------
        columnsTitleBuilder: (i) => TableCell.stickyRow(
              //model.tableList[0][i+1].value,
              '${(i+1)}',
              textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
              colorBg : Colors.teal.withOpacity(0.2)
            ),
        //-----------------------------------------------------
        rowsTitleBuilder: (i) => TableCell.stickyColumn(
              widget.busSchedule.route[i],
              textStyle: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black),
              colorBg: Colors.teal.withOpacity(0.07)
            ),
        //-----------------------------------------------------
        contentCellBuilder: (i, j) => TableCell.content(
          widget.busSchedule.schedule[i][j],
          textStyle: TextStyle(fontSize: 13.0, color: Colors.black87),
          colorBg : j % 2 == 0 ? Colors.grey[100] : Colors.white
        ),
        //-----------------------------------------------------
        legendCell: TableCell.legend(
          '경유지\\횟수',
          textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
          colorBg : Colors.teal.withOpacity(0.2),
        ),
        //-----------------------------------------------------
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    List<Widget> titleWigetList = [];
    titleWigetList.add(_getTitleItemWidget('경유지\\횟수', 80));

    for (var i = 0; i < widget.busSchedule.schedule.length; i++) {
      titleWigetList.add(_getTitleItemWidget((i + 1).toString(), 60));
    }
    return titleWigetList;
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(widget.busSchedule.route[index]),
      width: 100,
      height: 60,
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    // return Container();
    
    var schedule = widget.busSchedule.schedule;
    List<Widget> rowList = [];

    for (var rowIdx = 0; rowIdx < schedule.length; rowIdx++) {
      List<String> routeSchedule = schedule[rowIdx] ;

      rowList.add(Container(
        child: Text(routeSchedule[index] != "" ? routeSchedule[index].toString() : ""),
        width: 60,
        height: 60,
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        alignment: Alignment.center,
         color: (rowIdx % 2 == 1) ? Colors.grey[100] : Colors.white,
      ));
    }
    // schedule.forEach((routeSchedule) {
    //         rowList.add(Container(
    //     child: Text(routeSchedule.schedule[index] != "" ? routeSchedule.schedule[index].toString() : ""),
    //     width: 60,
    //     height: 60,
    //     padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
    //     alignment: Alignment.center,
    //     //  color: (rowIdx % 2 == 0) ? Colors.grey[100] : Colors.white,
    //   ));
    // });

    return Row(children: rowList);
  }
}




class TableCell extends StatelessWidget {
  TableCell.content(
      this.text, {
        this.textStyle,
        this.cellDimensions = CellDimensions.base,
        this.colorBg = Colors.white,
        this.onTap,
      })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _colorHorizontalBorder = Colors.black12,
        _colorVerticalBorder = Colors.black12,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.zero;

  TableCell.legend(
      this.text, {
        this.textStyle,
        this.cellDimensions = CellDimensions.base,
        this.colorBg = Colors.amber,
        this.onTap,
      })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _colorHorizontalBorder = Colors.white,
        _colorVerticalBorder = Colors.white,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.only(left: 24.0);

  TableCell.stickyRow(
      this.text, {
        this.textStyle,
        this.cellDimensions = CellDimensions.base,
        this.colorBg = Colors.amber,
        this.onTap,
      })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _colorHorizontalBorder = Colors.white,
        _colorVerticalBorder = Colors.white,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.zero;

  TableCell.stickyColumn(
      this.text, {
        this.textStyle,
        this.cellDimensions = CellDimensions.base,
        this.colorBg = Colors.white,
        this.onTap,
      })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _colorHorizontalBorder = Colors.white,
        _colorVerticalBorder = Colors.black12,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.only(left: 24.0);

  final CellDimensions cellDimensions;

  final String text;
  final Function onTap;

  final double cellWidth;
  final double cellHeight;

  final Color colorBg;
  final Color _colorHorizontalBorder;
  final Color _colorVerticalBorder;

  final TextAlign _textAlign;
  final EdgeInsets _padding;

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cellWidth,
        height: cellHeight,
        padding: _padding,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Text(
                  text,
                  style: textStyle,
                  maxLines: 2,
                  textAlign: _textAlign,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.1,
              color: _colorVerticalBorder,
            ),
          ],
        ),
        decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: _colorHorizontalBorder),
              right: BorderSide(color: _colorHorizontalBorder),
            ),
            color: colorBg),
      ),
    );
  }
}