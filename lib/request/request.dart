// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:desktop/common/constant.dart';
import 'package:desktop/common/dialog.dart';
import 'package:desktop/controller/loadingController.dart';
import 'package:desktop/model/studentModel.dart';
import 'package:desktop/model/rowInsertModel.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class RequestPage extends StatefulWidget {
  final Function loadingCallback;
  const RequestPage({
    Key? key,
    required this.loadingCallback,
  }) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  LoadingController loadingController = Get.put(LoadingController());
  List<StudentModel> models = [];

  bool isHoverRefresh = false;

  final scrollController = ScrollController(initialScrollOffset: 0);
  final List<PlutoColumn> columns = [];
  final List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();

    columns.addAll([
      PlutoColumn(
        title: "Forms",
        field: 'forms',
        type: PlutoColumnType.text(),
        width: 300.0,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Req. Date",
        field: 'reqdate',
        type: PlutoColumnType.text(),
        width: 150.0,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Last Name" ,
        field: 'lastname' ,
        type: PlutoColumnType.text() ,
        width: 200.0,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "First Name",
        field: 'firstname',
        type: PlutoColumnType.text(),
        width: 200.0,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Middle Name",
        field: 'middlename',
        type: PlutoColumnType.text(),
        width: 200.0,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Status",
        field: 'status',
        type: PlutoColumnType.text(),
        width: 150.0,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
          title: '',
          field: 'edit',
          type: PlutoColumnType.text(),
          width: 160.0,
          minWidth: 160.0,
          enableContextMenu: false,
          readOnly: true,
          enableColumnDrag: false,
          enableRowDrag: false,
          enableDropToResize:false,
          renderer: (rendererContext) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  kEditButton(
                    onTap: () => {},
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  kDeleteButton(
                    onTap: () => {},
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  kPasswordButton(
                    onTap: () => {},
                  ),
                ]);
          }),
    ]);

    initLoad();
  }

  Future<void> initLoad() async {
    try {
      setState(() {
        loadingController.setValue(true);
      });

      // await Future.wait([
      //   reqList(),
      // ]);

      setState(() {
        loadingController.setValue(false);
      });
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Future<void> reqList() async {
    try {
      var client = http.Client();
      var url = Uri.parse("$kUrl/request/list");
      var resp = await client.post(url, headers: kHeader);
      print(resp.body);
      if (resp.statusCode == 200) {
        models = studentModelFromJson(resp.body);
        rows.clear();

        for (var item in models) {
          print(item.toJson().toString());
          rows.add(
            PlutoRow(
              key: Key(item.toJson().toString()),
              cells: {
                'sno': PlutoCell(value: item.sno),
                'lastname': PlutoCell(value: item.lastname),
                'firstname': PlutoCell(value: item.firstname),
                'middlename': PlutoCell(value: item.middlename),
                'program': PlutoCell(value: item.program),
                'major': PlutoCell(value: item.major),
                'yearlevel': PlutoCell(value: item.yearlevel),
                'email': PlutoCell(value: item.email),
                'mobile': PlutoCell(value: item.mobile),
                'address': PlutoCell(value: item.address),
                'edit': PlutoCell(value: ''),
              },
            ),
          );
        }
      } else {
        Dialogs.errorDialog(context, kNetworkErrorMessage);
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
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
          child: Container(
            height: 80,
            decoration: const BoxDecoration(
              color: kHoverColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20.0,
                ),
                InkWell(
                  onTap: () => initLoad(),
                  onHover: (value) {
                    setState(() {
                      isHoverRefresh = value;
                    });
                  },
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Container(
                    width: 180,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isHoverRefresh
                          ? Colors.deepOrangeAccent
                          : kSelectorColor,
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Refresh",
                            style: kButtonStyle(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PlutoGrid(
                columns: columns,
                rows: rows,
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  stateManager = event.stateManager;
                   
                  event.stateManager
                      .setSelectingMode(PlutoGridSelectingMode.row);
                }),
          ),
        )
      ],
    );
  }
}
