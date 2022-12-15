// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:desktop/common/constant.dart';
import 'package:desktop/common/dialog.dart';
import 'package:desktop/controller/loadingController.dart';
import 'package:desktop/custom-widget/dropdown.dart';
import 'package:desktop/model/studentModel.dart';
import 'package:desktop/model/rowInsertModel.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class StudentPage extends StatefulWidget {
  final Function loadingCallback;
  const StudentPage({
    Key? key,
    required this.loadingCallback,
  }) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  LoadingController loadingController = Get.put(LoadingController());
  List<StudentModel> models = [];

  bool isHoverAddNew = false;
  bool isHoverRefresh = false;
  bool isHoverImport = false;

  TextEditingController snoController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController middlenameController = TextEditingController();
  TextEditingController programController = TextEditingController();
  TextEditingController majorController = TextEditingController();
  TextEditingController yearLevelController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final scrollController = ScrollController(initialScrollOffset: 0);
  final List<PlutoColumn> columns = [];
  final List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();

    columns.addAll([
      PlutoColumn(
        title: "Student No.",
        field: 'sno',
        type: PlutoColumnType.text(),
        width: 150.0,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Last Name",
        field: 'lastname',
        type: PlutoColumnType.text(),
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
        title: "Program",
        field: 'program',
        type: PlutoColumnType.text(),
        width: 150.0,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Major",
        field: 'major',
        type: PlutoColumnType.text(),
        width: 150.0,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Year Level",
        field: 'yearlevel',
        type: PlutoColumnType.text(),
        width: 150.0,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Email",
        field: 'email',
        type: PlutoColumnType.text(),
        width: 150.0,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Mobile",
        field: 'mobile',
        type: PlutoColumnType.text(),
        width: 150.0,
        enableContextMenu: false,
        readOnly: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: "Address",
        field: 'address',
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

      await Future.wait([
        reqList(),
      ]);

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
      var url = Uri.parse("$kUrl/student/list");
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

  Future<bool> reqExist(lastname, firstname, middlename, newlastname,
      newfirstname, newmiddlename, isedit) async {
    try {
      var body = convert.json.encode(
        {
          'name': '$lastname$firstname$middlename',
          'newname': '$newlastname$newfirstname$newmiddlename',
          'isedit': isedit,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/student/exist");
      var resp = await client.post(url, headers: kHeader, body: body);
      var tmp = studentModelFromJson(resp.body);
      if (tmp.isNotEmpty) {
        return true;
      }

      return false;
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);

      return true;
    }
  }

  Future<int?> reqAdd(StudentModel model) async {
    try {
      var body = convert.json.encode(
        {
          'sno': model.sno,
          'lastname': model.lastname,
          'firstname': model.firstname,
          'middlename': model.middlename,
          'program': model.program,
          'major': model.major,
          'yearlevel': model.yearlevel,
          'email': model.email,
          'mobile': model.mobile,
          'address': model.address,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/student/insert");
      var resp = await client.post(url, headers: kHeader, body: body);
      if (resp.statusCode == 200) {
        var tmp = rowInsertModelFromJson(resp.body);
        return tmp.insertId;
      }
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Future<void> reqUpdate(
      StudentModel model, String sno, String lastname) async {
    try {
      var body = convert.json.encode(
        {
          'sno': model.sno,
          'lastname': model.lastname,
          'firstname': model.firstname,
          'middlename': model.middlename,
          'program': model.program,
          'major': model.major,
          'yearlevel': model.yearlevel,
          'email': model.email,
          'mobile': model.mobile,
          'address': model.address,
          'oldsno': sno,
          'oldlastname': lastname,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/student/update");
      await client.post(url, headers: kHeader, body: body);
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Future<void> reqDelete(sno, lastname) async {
    try {
      var body = convert.json.encode(
        {
          'sno': sno,
          'lastname': lastname,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/student/delete");
      var resp = await client.post(url, headers: kHeader, body: body);
      print(resp.body);
    } catch (error) {
      print(error);
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  void handleOnAddClick() async {
    try {
      var model = StudentModel();
      model.sno = "";
      model.lastname = "";
      model.firstname = "";
      model.middlename = "";
      model.program = "";
      model.major = "";
      model.yearlevel = "";
      model.email = "";
      model.mobile = "";
      model.address = "";

      snoController.text = "";
      lastnameController.text = "";
      firstnameController.text = "";
      middlenameController.text = "";
      programController.text = "";
      majorController.text = "";
      yearLevelController.text = "";
      emailController.text = "";
      mobileController.text = "";
      addressController.text = "";

      var result = await formEntry(context, model);
      if (result == DialogAction.yes) {
        model.sno = snoController.text;
        model.lastname = lastnameController.text;
        model.firstname = firstnameController.text;
        model.middlename = middlenameController.text;
        model.program = programController.text;
        model.major = majorController.text;
        model.yearlevel = yearLevelController.text;
        model.email = emailController.text;
        model.mobile = mobileController.text;
        model.address = addressController.text;

        model.id = await reqAdd(model);

        final newRows = stateManager.getNewRows(count: 1);
        newRows[0].cells['sno']?.value = model.sno;
        newRows[0].cells['lastname']?.value = model.lastname;
        newRows[0].cells['firstname']?.value = model.firstname;
        newRows[0].cells['middlename']?.value = model.middlename;
        newRows[0].cells['program']?.value = model.program;
        newRows[0].cells['major']?.value = model.major;
        newRows[0].cells['yearlevel']?.value = model.yearlevel;
        newRows[0].cells['email']?.value = model.email;
        newRows[0].cells['mobile']?.value = model.mobile;
        newRows[0].cells['address']?.value = model.address;
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
      var model = StudentModel();
      model.sno = row.cells['sno']?.value;
      model.lastname = row.cells['lastname']?.value;
      model.firstname = row.cells['firstname']?.value;
      model.middlename = row.cells['middlename']?.value;
      model.program = row.cells['program']?.value;
      model.major = row.cells['major']?.value;
      model.yearlevel = row.cells['yearlevel']?.value;
      model.email = row.cells['email']?.value;
      model.mobile = row.cells['mobile']?.value;
      model.address = row.cells['address']?.value;
      model.isEdit = true;

      snoController.text = row.cells['sno']?.value;
      lastnameController.text = row.cells['lastname']?.value;
      firstnameController.text = row.cells['firstname']?.value;
      middlenameController.text = row.cells['middlename']?.value;
      programController.text = row.cells['program']?.value;
      majorController.text = row.cells['major']?.value;
      yearLevelController.text = row.cells['yearlevel']?.value;
      emailController.text = row.cells['email']?.value;
      mobileController.text = row.cells['mobile']?.value;
      addressController.text = row.cells['address']?.value;

      var sno = row.cells['sno']?.value;
      var lastname = row.cells['lastname']?.value;

      var result = await formEntry(context, model);
      if (result == DialogAction.yes) {
        model.sno = snoController.text;
        model.lastname = lastnameController.text;
        model.firstname = firstnameController.text;
        model.middlename = middlenameController.text;
        model.program = programController.text;
        model.major = majorController.text;
        model.yearlevel = yearLevelController.text;
        model.email = emailController.text;
        model.mobile = mobileController.text;
        model.address = addressController.text;

        await reqUpdate(model, sno, lastname);

        setState(() {
          row.cells['sno']?.value = model.sno;
          row.cells['lastname']?.value = model.lastname;
          row.cells['firstname']?.value = model.firstname;
          row.cells['middlename']?.value = model.middlename;
          row.cells['program']?.value = model.program;
          row.cells['major']?.value = model.major;
          row.cells['yearlevel']?.value = model.yearlevel;
          row.cells['email']?.value = model.email;
          row.cells['mobile']?.value = model.mobile;
          row.cells['address']?.value = model.address;
        });
        await Dialogs.successDialog(context, "Successfully saved.");
      }
    } catch (error) {
      print(error);
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  void handleOnDeleteClick(context, row) async {
    var sno = row.cells['sno']?.value;
    var lastname = row.cells['lastname']?.value;
    var firstname = row.cells['firstname']?.value;
    var middlename = row.cells['middlename']?.value;

    var result = await Dialogs.confirmationDialog(
        context, "STUDENT", "Are you sure you want to delete?");
    if (result == DialogAction.yes) {
      await reqDelete(sno, lastname);

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
                const SizedBox(
                  width: 10.0,
                ),
                InkWell(
                  onTap: () => {},
                  onHover: (value) {
                    setState(() {
                      isHoverImport = value;
                    });
                  },
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Container(
                    width: 180,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isHoverImport
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
                            Icons.import_contacts_rounded,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Import",
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

  Future<DialogAction> formEntry(context, StudentModel model) async {
    bool isHoverButtonNo = false;
    bool isHoverButtonYes = false;

    bool isRequiredSno = false;
    bool isRequiredLastName = false;
    bool isRequiredFirstName = false;
    bool isRequiredMiddleName = false;
    bool isRequiredProgram = false;
    bool isRequiredEmail = false;

    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        void handleBtnSaveClick(setState) async {
          if (snoController.text == "") {
            isRequiredSno = true;
          }

          if (lastnameController.text == "") {
            isRequiredLastName = true;
          }

          if (firstnameController.text == "") {
            isRequiredFirstName = true;
          }

          if (middlenameController.text == "") {
            isRequiredMiddleName = true;
          }

          if (programController.text == "") {
            isRequiredProgram = true;
          }

          if (emailController.text == "") {
            isRequiredEmail = true;
          } else {
            if (!EmailValidator.validate(emailController.text)) {
              setState(() {
                isRequiredEmail = true;
              });
            }
          }

          if (isRequiredSno ||
              isRequiredLastName ||
              isRequiredFirstName ||
              isRequiredMiddleName ||
              isRequiredProgram ||
              isRequiredEmail) {
            setState(() {});
            return;
          }

          var result = await Dialogs.confirmationDialog(
              context, "STUDENT", "Are you sure you want to save?");
          if (result != DialogAction.yes) {
            return;
          }

          //check if exist
          if (model.isEdit == true) {
            var exist = await reqExist(
              model.lastname,
              model.firstname,
              model.middlename,
              lastnameController.text,
              firstnameController.text,
              middlenameController.text,
              true,
            );
            if (exist) {
              await Dialogs.errorDialog(context,
                  "${lastnameController.text}, ${firstnameController.text} ${middlenameController.text}  already exist.");
              return;
            }
          } else {
            var exist = await reqExist(
              lastnameController.text,
              firstnameController.text,
              middlenameController.text,
              "",
              "",
              "",
              false,
            );
            if (exist) {
              await Dialogs.errorDialog(context,
                  "${lastnameController.text}, ${firstnameController.text} ${middlenameController.text}  already exist.");
              return;
            }
          }

          Navigator.of(context).pop(DialogAction.yes);
        }

        Widget textbox(controller, setState, isRequired) {
          return TextFormField(
            controller: controller,
            maxLines: 1,
            maxLength: 100,
            onChanged: (value) => {
              setState(() {
                isRequiredSno = false;
                isRequiredLastName = false;
                isRequiredFirstName = false;
                isRequiredMiddleName = false;
                isRequiredProgram = false;
                isRequiredEmail = false;
              })
            },
            style: kNormalText(false),
            decoration: InputDecoration(
              counterText: "",
              labelStyle: GoogleFonts.lato(color: Colors.grey),
              hintStyle: GoogleFonts.lato(color: Colors.grey),
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: isRequired ? Colors.red : kSelectorColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: isRequired ? Colors.red : Colors.orangeAccent),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: isRequired ? Colors.red : kSelectorColor),
              ),
            ),
          );
        }

        Widget item(label, controller, isRequired, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: kLabel(label),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: textbox(controller, setState, isRequired),
              ),
            ],
          );
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
                'STUDENT',
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
                width: 700,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FocusTraversalGroup(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  item(
                                    'Lastname',
                                    lastnameController,
                                    isRequiredLastName,
                                    setState,
                                  ),
                                  item(
                                    'Firstname',
                                    firstnameController,
                                    isRequiredFirstName,
                                    setState,
                                  ),
                                  item(
                                    'Middlename',
                                    middlenameController,
                                    isRequiredMiddleName,
                                    setState,
                                  ),
                                  item(
                                    'Email',
                                    emailController,
                                    isRequiredEmail,
                                    setState,
                                  ),
                                  item(
                                    'Mobile no.',
                                    mobileController,
                                    false,
                                    setState,
                                  ),
                                  item(
                                    'Address',
                                    addressController,
                                    false,
                                    setState,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                item(
                                  'Student no.',
                                  snoController,
                                  isRequiredSno,
                                  setState,
                                ),
                                item(
                                  'Program',
                                  programController,
                                  isRequiredProgram,
                                  setState,
                                ),
                                item(
                                  'Major',
                                  majorController,
                                  false,
                                  setState,
                                ),
                                DropdownButtonWidget(title: 'Year Level', controller: yearLevelController),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 40.0,
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
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
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
