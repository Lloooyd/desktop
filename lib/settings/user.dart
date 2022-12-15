// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:crypto/crypto.dart';
import 'package:desktop/common/constant.dart';
import 'package:desktop/common/dialog.dart';
import 'package:desktop/controller/loadingController.dart';
import 'package:desktop/model/userModel.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  final Function loadingCallback;
  const UserPage({Key? key, required this.loadingCallback}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  LoadingController loadingController = Get.put(LoadingController());
  List<UserModel> models = [];

  bool isHoverAddNew = false;
  bool isHoverRefresh = false;

  TextEditingController firstnameController = TextEditingController();
  TextEditingController middlenameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final scrollController = ScrollController(initialScrollOffset: 0);
  final List<PlutoColumn> columns = [];
  final List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();

    columns.addAll([
      PlutoColumn(
        title: 'Last Name',
        field: 'lastname',
        type: PlutoColumnType.text(),
        width: 200.0,
        enableContextMenu: false,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: 'First Name',
        field: 'firstname',
        type: PlutoColumnType.text(),
        width: 200.0,
        enableContextMenu: false,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: 'Middle Name',
        field: 'middlename',
        type: PlutoColumnType.text(),
        width: 200.0,
        enableContextMenu: false,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: 'User Name',
        field: 'username',
        type: PlutoColumnType.text(),
        width: 200.0,
        enableContextMenu: false,
        enableColumnDrag: false,
        enableRowDrag: false,
        enableDropToResize:false,
      ),
      PlutoColumn(
        title: 'Email',
        field: 'email',
        type: PlutoColumnType.text(),
        width: 200.0,
        enableContextMenu: false,
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
      var url = Uri.parse("$kUrl/user/list");
      var resp = await client.get(url, headers: kHeader);
      if (resp.statusCode == 200) {
        models = userModelFromJson(resp.body);
        rows.clear();
        for (var item in models) {
          rows.add(
            PlutoRow(
              cells: {
                'lastname': PlutoCell(value: item.lastname),
                'firstname': PlutoCell(value: item.firstname),
                'middlename': PlutoCell(value: item.middlename),
                'username': PlutoCell(value: item.username),
                'email': PlutoCell(value: item.email),
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

  Future<bool> reqExist(username, oldusername, isedit) async {
    try {
      var body = convert.json.encode(
        {
          'username': username,
          'oldusername': oldusername,
          'isedit': isedit,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/user/exist");
      var resp = await client.post(url, headers: kHeader, body: body);
      var tmp = userModelFromJson(resp.body);
      if (tmp.isNotEmpty) {
        return true;
      }

      return false;
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);

      return true;
    }
  }

  Future<void> reqAdd(UserModel model) async {
    try {
      var body = convert.json.encode(
        {
          'lastname': model.lastname,
          'firstname': model.firstname,
          'middlename': model.middlename,
          'username': model.username,
          'password': model.password,
          'email': model.email,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/user/add");
      await client.post(url, headers: kHeader, body: body);
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Future<void> reqUpdate(UserModel model, newusername) async {
    try {
      var body = convert.json.encode(
        {
          'lastname': model.lastname,
          'firstname': model.firstname,
          'middlename': model.middlename,
          'username': newusername,
          'password': model.password,
          'email': model.email,
          'oldusername': model.username,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/user/update");
      await client.post(url, headers: kHeader, body: body);
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Future<void> reqDelete(username) async {
    try {
      var body = convert.json.encode(
        {
          'username': username,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/user/delete");
      await client.post(url, headers: kHeader, body: body);
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  void handleOnAddClick() async {
    try {
      var model = UserModel();
      model.lastname = "";
      model.firstname = "";
      model.middlename = "";
      model.username = "";
      model.password = "";
      model.email = "";

      lastnameController.text = "";
      firstnameController.text = "";
      middlenameController.text = "";
      usernameController.text = "";
      passwordController.text = "";
      emailController.text = "";

      var result = await entryForm(context, model);
      if (result == DialogAction.yes) {
        //set new model
        model.lastname = lastnameController.text;
        model.firstname = firstnameController.text;
        model.middlename = middlenameController.text;
        model.username = usernameController.text;
        model.email = emailController.text;

        var bytes = convert.utf8.encode(passwordController.text);
        var digest = sha256.convert(bytes);
        model.password = digest.toString();

        await reqAdd(model);

        final newRows = stateManager.getNewRows(count: 1);
        newRows[0].cells['lastname']!.value = lastnameController.text;
        newRows[0].cells['firstname']!.value = firstnameController.text;
        newRows[0].cells['middlename']!.value = middlenameController.text;
        newRows[0].cells['username']!.value = usernameController.text;
        newRows[0].cells['email']!.value = emailController.text;
        newRows[0].cells['edit']!.value = '';

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
      var model = UserModel();
      model.lastname = row.cells['lastname']!.value;
      model.firstname = row.cells['firstname']!.value;
      model.middlename = row.cells['middlename']!.value;
      model.username = row.cells['username']!.value;
      model.email = row.cells['email']!.value;
      model.password = "****";
      model.isedit = true;

      lastnameController.text = row.cells['lastname']!.value;
      firstnameController.text = row.cells['firstname']!.value;
      middlenameController.text = row.cells['middlename']!.value;
      usernameController.text = row.cells['username']!.value;
      emailController.text = row.cells['email']!.value;

      var result = await entryForm(context, model);
      if (result == DialogAction.yes) {
        //set new model
        model.lastname = lastnameController.text;
        model.firstname = firstnameController.text;
        model.middlename = middlenameController.text;
        model.email = emailController.text;

        var bytes = convert.utf8.encode(passwordController.text);
        var digest = sha256.convert(bytes);
        model.password = digest.toString();

        await reqUpdate(
          model,
          usernameController.text,
        );

        setState(() {
          row.cells['lastname']!.value = lastnameController.text;
          row.cells['firstname']!.value = firstnameController.text;
          row.cells['middlename']!.value = middlenameController.text;
          row.cells['username']!.value = usernameController.text;
          row.cells['email']!.value = emailController.text;
        });
        await Dialogs.successDialog(context, "Successfully saved.");
      }
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  void handleOnDeleteClick(context, row) async {
    var username = row.cells['username']!.value;
    var result = await Dialogs.deleteDialog(
        context, "Are you sure wou want to delete ($username)?");
    if (result == DialogAction.yes) {
      await reqDelete(username);

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

  Future<DialogAction> entryForm(context, UserModel model) async {
    bool isHoverButtonNo = false;
    bool isHoverButtonYes = false;
    bool isLastnameRequired = false;
    bool isFirstnameRequired = false;
    bool isMiddlenameRequired = false;
    bool isUsernameRequired = false;
    bool isPasswordRequired = false;
    bool isEmailRequired = false;
    bool isEmailValid = true;

    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        void handleBtnSaveClick(setState) async {
          if (lastnameController.text == "") {
            setState(() {
              isLastnameRequired = true;
            });
          }

          if (firstnameController.text == "") {
            setState(() {
              isFirstnameRequired = true;
            });
          }

          if (middlenameController.text == "") {
            setState(() {
              isMiddlenameRequired = true;
            });
          }

          if (emailController.text == "") {
            setState(() {
              isEmailRequired = true;
            });
          } else {
            if (!EmailValidator.validate(emailController.text)) {
              setState(() {
                isEmailValid = false;
              });
            }
          }

          if (usernameController.text == "") {
            setState(() {
              isUsernameRequired = true;
            });
          }

          if (passwordController.text == "") {
            setState(() {
              isPasswordRequired = true;
            });
          }

          if (lastnameController.text == "" ||
              firstnameController.text == "" ||
              middlenameController.text == "" ||
              emailController.text == "" ||
              usernameController.text == "" ||
              passwordController.text == "") {
            return;
          }

          if (!isEmailValid) {
            return;
          }

          //check if exist
          if (model.isedit == true) {
            //for edit validation
            var exist =
                await reqExist(usernameController.text, model.username, true);
            if (exist) {
              await Dialogs.errorDialog(context, "Username already exist.");
              return;
            }
          } else {
            //for insert validation
            var exist = await reqExist(usernameController.text, "", false);
            if (exist) {
              await Dialogs.errorDialog(context, "Username already exist.");
              return;
            }
          }

          Navigator.of(context).pop(DialogAction.yes);
        }

        Widget textbox(controller, obscureText, setState) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              controller: controller,
              maxLines: 1,
              maxLength: 100,
              obscureText: obscureText,
              onChanged: (value) => {
                setState(() {
                  isLastnameRequired = false;
                  isFirstnameRequired = false;
                  isMiddlenameRequired = false;
                  isEmailRequired = false;
                  isUsernameRequired = false;
                  isPasswordRequired = false;
                  isEmailValid = true;
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
                'Add New User',
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: kLabel('Lastname'),
                                ),
                                textbox(lastnameController, false, setState),
                                if (isLastnameRequired)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: kRequired(),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: kLabel('Firstname'),
                                ),
                                textbox(firstnameController, false, setState),
                                if (isFirstnameRequired)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: kRequired(),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: kLabel('Middlename'),
                                ),
                                textbox(middlenameController, false, setState),
                                if (isMiddlenameRequired)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: kRequired(),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: kLabel('Email'),
                                ),
                                textbox(emailController, false, setState),
                                if (isEmailRequired)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: kRequired(),
                                  ),
                                if (!isEmailValid)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: kInvalidEmail(),
                                  ),
                              ],
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: kLabel('Username'),
                                ),
                                textbox(usernameController, false, setState),
                                if (isUsernameRequired)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: kRequired(),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: kLabel('Password'),
                                ),
                                textbox(passwordController, true, setState),
                                if (isPasswordRequired)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: kRequired(),
                                  ),
                              ],
                            ),
                          )
                        ],
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
