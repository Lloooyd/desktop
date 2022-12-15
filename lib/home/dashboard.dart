// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';

import 'package:desktop/common/constant.dart';
import 'package:desktop/common/dialog.dart';
import 'package:desktop/controller/loadingController.dart';
import 'package:desktop/model/dashboard_count_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  final Function loadingCallback;
  const DashboardPage({
    Key? key,
    required this.loadingCallback,
  }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  LoadingController loadingController = Get.put(LoadingController());
  bool isHoverRefresh = false;

  final scrollController = ScrollController(initialScrollOffset: 0);
  final List<PlutoColumn> columns = [];
  final List<PlutoRow> rows = [];
  final List<PlutoColumn> columns2 = [];
  final List<PlutoRow> rows2 = [];
  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();

     dashboardInfo();
    

    columns.addAll([
      PlutoColumn(
        title: "Assistance",
        field: 'description',
        type: PlutoColumnType.text(),
        width: 200.0,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Total Count",
        field: 'totalcount',
        type: PlutoColumnType.text(),
        width: 160.0,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Total Amount",
        field: 'totalamount',
        type: PlutoColumnType.text(),
        width: 160.0,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
    ]);

    columns2.addAll([
      PlutoColumn(
        title: "Medicine",
        field: 'description',
        type: PlutoColumnType.text(),
        width: 200.0,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Stock In",
        field: 'stockin',
        type: PlutoColumnType.text(),
        width: 160.0,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Stock Out",
        field: 'stockout',
        type: PlutoColumnType.text(),
        width: 160.0,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Available",
        field: 'available',
        type: PlutoColumnType.text(),
        width: 160.0,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
    ]);

    initLoad();
  }

  Future<void> initLoad() async {
    try {
      print('initLoad 1');

      setState(() {
        loadingController.setValue(true);
      });

      setState(() {
        loadingController.setValue(false);
      });

      print('initLoad 2');
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }
  
  DashboardCountModel dashboardCount = DashboardCountModel();
  
    Future<void> dashboardInfo() async {
      try {
        var client = http.Client();
        var url = Uri.parse("$kUrl/request/counts-per-status");
        var resp = await client.get(url, headers: kHeader);
        if (resp.statusCode == 200) {
          var sample = jsonDecode(resp.body);
          // Map<String, dynamic> jsonData = jsonDecode(sample[0]);
          dashboardCount = DashboardCountModel.fromJson(sample[0]);
        } else {
          // Dialogs.errorDialog(context, kNetworkErrorMessage);
        }
      } catch (error) {
        Dialogs.errorDialog(context, kRuntimeErrorMessage);
      }
    }
    

  @override
  Widget build(BuildContext context) {


    if (loadingController.loading.value) return kLoading();

    return Column(
      children: [
        SizedBox(height: 20.0),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: kHoverColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 20.0,
                      ),
                      Container(
                        // width: 180,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.dashboard_rounded,
                                color: kPrimaryColor,
                                size: 25.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "APPROVED REQUEST",
                                style: kHeaderStyle(),
                              ),
                              const SizedBox(
                                width: 30.0,
                              ),
                             ( dashboardCount.approvedCount != null &&  dashboardCount.approvedCount != 0) ? AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  // padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.010),
                                  // width: MediaQuery.of(context).size.width * 0.010,
                                  // height: MediaQuery.of(context).size.width * 0.05,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    border: Border.all(
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                    child:  Text(
                                      dashboardCount.approvedCount.toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ): Container()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: kHoverColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 20.0,
                      ),
                      Container(
                        //width: 180,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.dashboard_rounded,
                                color: kPrimaryColor,
                                size: 25.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "PENDING REQUEST",
                                style: kHeaderStyle(),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              (dashboardCount.pendingCount != null && dashboardCount.pendingCount != 0) ? AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    border: Border.all(
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                    child:  Text(
                                      dashboardCount.pendingCount.toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ): Container()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: kHoverColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 20.0,
                      ),
                      Container(
                        // width: 180,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.dashboard_rounded,
                                color: kPrimaryColor,
                                size: 25.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "COMPLETED REQUEST",
                                style: kHeaderStyle(),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              (dashboardCount.completedCount != null && dashboardCount.completedCount != 0) ? AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    border: Border.all(
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                    child:  Text(
                                      dashboardCount.completedCount.toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ): Container()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: kHoverColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 20.0,
                      ),
                      Container(
                        // width: 180,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.dashboard_rounded,
                                color: kPrimaryColor,
                                size: 25.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "FOR PICKUP",
                                style: kHeaderStyle(),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              (dashboardCount.forpickupCount != null && dashboardCount.forpickupCount != 0) ? AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    border: Border.all(
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                    child:  Text(
                                      dashboardCount.forpickupCount.toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ): Container()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
