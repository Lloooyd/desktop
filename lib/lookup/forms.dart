// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:desktop/common/constant.dart';
import 'package:desktop/common/dialog.dart';
import 'package:desktop/controller/loadingController.dart';
import 'package:desktop/model/lookupModel.dart';
import 'package:desktop/model/rowInsertModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class FormsPage extends StatefulWidget {
  final Function loadingCallback;
  const FormsPage({
    Key? key,
    required this.loadingCallback,
  }) : super(key: key);

  @override
  State<FormsPage> createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage> {
  LoadingController loadingController = Get.put(LoadingController());
  List<LookUpModel> models = [];

  bool isHoverAddNew = false;
  bool isHoverRefresh = false;

  TextEditingController descriptionController = TextEditingController();

  final scrollController = ScrollController(initialScrollOffset: 0);
  final List<PlutoColumn> columns = [];
  final List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();

    columns.addAll([
      PlutoColumn(
        title: 'Id',
        field: 'id',
        type: PlutoColumnType.text(),
        textAlign: PlutoColumnTextAlign.right,
        width: 70.0,
        minWidth: 70,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: 'Forms',
        field: 'description',
        type: PlutoColumnType.text(),
        width: 400.0,
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
          width: 200.0,
          minWidth: 200.0,
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
                    onTap: () => handleOnEditClick(rendererContext.row),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  kDeleteButton(
                    onTap: () => handleOnDeleteClick(
                      context,
                      rendererContext.row,
                    ),
                  )
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

      await reqList();

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
      var url = Uri.parse("$kUrl/forms/list");
      var resp = await client.get(url, headers: kHeader);
      if (resp.statusCode == 200) {
        models = lookUpModelFromJson(resp.body);
        rows.clear();
        for (var item in models) {
          rows.add(
            PlutoRow(
              cells: {
                'id': PlutoCell(value: item.id),
                'description': PlutoCell(value: item.description),
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

  Future<bool> reqExist(description, newdescription, isedit) async {
    try {
      var body = convert.json.encode(
        {
          'description': description,
          'newdescription': newdescription,
          'isedit': isedit,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/forms/exist");
      var resp = await client.post(url, headers: kHeader, body: body);
      var tmp = lookUpModelFromJson(resp.body);
      if (tmp.isNotEmpty) {
        return true;
      }

      return false;
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
      throw Exception(error.toString());
    }
  }

  Future<int?> reqAdd(description) async {
    try {
      var body = convert.json.encode(
        {
          'description': description,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/forms/add");
      var resp = await client.post(url, headers: kHeader, body: body);
      if (resp.statusCode == 200) {
        var tmp = rowInsertModelFromJson(resp.body);
        return tmp.insertId;
      }
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Future<void> reqUpdate(id, description) async {
    try {
      var body = convert.json.encode(
        {
          'id': id,
          'description': description,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/forms/update");
      await client.post(url, headers: kHeader, body: body);
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Future<void> reqDelete(id) async {
    try {
      var body = convert.json.encode(
        {
          'id': id,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/forms/delete");
      await client.post(url, headers: kHeader, body: body);
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  void handleOnAddClick() async {
    try {
      var model = LookUpModel();
      model.description = "";
      descriptionController.text = "";

      var result = await lookUpEntry(context, model);
      if (result == DialogAction.yes) {
        model.id = await reqAdd(descriptionController.text);

        final newRows = stateManager.getNewRows(count: 1);
        newRows[0].cells['id']?.value = model.id;
        newRows[0].cells['description']?.value = descriptionController.text;
        newRows[0].cells['edit']?.value = '';

        stateManager.appendRows(newRows);
        stateManager.setCurrentCell(
          newRows.first.cells.entries.first.value,
          stateManager.refRows.length - 1,
        );

        stateManager.moveScrollByRow(
          PlutoMoveDirection.down,
          stateManager.refRows.length - 2,
        );

        stateManager.setKeepFocus(true);

        await Dialogs.successDialog(context, "Successfully saved.");
      }
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  void handleOnEditClick(PlutoRow row) async {
    try {
      var model = LookUpModel();
      model.id = row.cells['id']?.value;
      model.description = row.cells['description']?.value;
      model.isEdit = true;

      descriptionController.text = row.cells['description']?.value;

      var result = await lookUpEntry(context, model);
      if (result == DialogAction.yes) {
        await reqUpdate(
          model.id,
          descriptionController.text,
        );

        setState(() {
          row.cells['description']!.value = descriptionController.text;
        });
        await Dialogs.successDialog(context, "Successfully saved.");
      }
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  void handleOnDeleteClick(context, row) async {
    var id = row.cells['id']?.value;
    var description = row.cells['description']?.value;
    var result = await Dialogs.deleteDialog(
        context, "Are you sure wou want to delete ($description)?");
    if (result == DialogAction.yes) {
      await reqDelete(id);

      setState(() {
        stateManager.removeRows([row]);
      });
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
                  onTap: () => handleOnAddClick(),
                  onHover: (value) {
                    setState(() {
                      isHoverAddNew = value;
                    });
                  },
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Container(
                    width: 180,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isHoverAddNew
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
                            Icons.add_circle_rounded,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Add New Entry",
                            style: kButtonStyle(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
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

  Future<DialogAction> lookUpEntry(context, LookUpModel model) async {
    bool isHoverButtonNo = false;
    bool isHoverButtonYes = false;
    bool isRequiredDesc = false;

    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        void handleBtnSaveClick(setState) async {
          if (descriptionController.text == "") {
            setState(() {
              isRequiredDesc = true;
            });
          }

          //check if exist
          if (model.isEdit == true) {
            //for edit validation
            try {
              var exist = await reqExist(
                  model.description, descriptionController.text, true);
              if (exist) {
                await Dialogs.errorDialog(context, "Forms already exist.");
                return;
              }
            } catch (error) {
              return;
            }
          } else {
            //for insert validation
            var exist = await reqExist(descriptionController.text, "", false);
            if (exist) {
              await Dialogs.errorDialog(context, "Forms already exist.");
              return;
            }
          }

          Navigator.of(context).pop(DialogAction.yes);
        }

        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Container(
            decoration: BoxDecoration(
              color: kSelectorColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            height: 60.0,
            child: Center(
              child: Text(
                'Add New Forms',
                style: GoogleFonts.lato(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                // height: 200,
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                      child: Text(
                        'Description',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: kLightColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: 1,
                        maxLength: 100,
                        onChanged: (value) => {
                          setState(() {
                            isRequiredDesc = false;
                          })
                        },
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black),
                        decoration: InputDecoration(
                          counterText: "",
                          labelStyle: GoogleFonts.lato(color: Colors.grey),
                          hintStyle: GoogleFonts.lato(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: kSelectorColor),
                          ),
                        ),
                      ),
                    ),
                    if (isRequiredDesc)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                        child: kRequired(),
                      ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () =>
                              Navigator.of(context).pop(DialogAction.cancel),
                          onHover: (value) {
                            setState(() {
                              isHoverButtonNo = value;
                            });
                          },
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isHoverButtonNo
                                  ? Colors.deepOrangeAccent
                                  : kSelectorColor,
                              border: Border.all(
                                color: Colors.blueGrey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: 120,
                            height: 50,
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        InkWell(
                          onTap: () => handleBtnSaveClick(setState),
                          onHover: (value) {
                            setState(() {
                              isHoverButtonYes = value;
                            });
                          },
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isHoverButtonYes
                                  ? Colors.deepOrangeAccent
                                  : kSelectorColor,
                              border: Border.all(
                                color: Colors.blueGrey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: 120,
                            height: 50,
                            child: Center(
                              child: Text(
                                "Save",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
    return (action != null) ? action : DialogAction.cancel;
  }
}
