// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously, unnecessary_null_comparison, unrelated_type_equality_checks
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:desktop/common/constant.dart';
import 'package:desktop/common/dialog.dart';
import 'package:desktop/controller/loadingController.dart';
import 'package:desktop/controller/userController.dart';
import 'package:desktop/model/permissionModel.dart';
import 'package:desktop/model/userModel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PermissionPage extends StatefulWidget {
  final Function loadingCallback;
  const PermissionPage({Key? key, required this.loadingCallback})
      : super(key: key);

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  final myKey = GlobalKey<DropdownSearchState<UserController>>();
  LoadingController loadingController = Get.put(LoadingController());
  List<PermissionModel> permissions = [];
  List<UserModel> users = [];
  UserModel selectedUser = UserModel();

  bool isHoverSave = false;
  bool isHoverRefresh = false;

//checkbox
  bool is_request = false;
  bool is_dashboard = false;
  bool is_settings_user = false;
  bool is_settings_permission = false;
  bool is_lookup_student = false;
  bool is_lookup_forms = false;

  final scrollController = ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    super.initState();

    initLoad();
  }

  Future<void> initLoad() async {
    try {
      setState(() {
        loadingController.setValue(true);
      });

      await reqUsers();
      await reqPermissions();

      setState(() {
        loadingController.setValue(false);
      });
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Future<void> reqUsers() async {
    try {
      var client = http.Client();
      var url = Uri.parse("$kUrl/user/list");
      var resp = await client.get(url, headers: kHeader);
      if (resp.statusCode == 200) {
        users = userModelFromJson(resp.body);
        if (users.isNotEmpty) {
          selectedUser = users[0];
        }
      } else {
        Dialogs.errorDialog(context, kNetworkErrorMessage);
      }
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Future<void> reqPermissions() async {
    try {
      permissions = [];
      if (selectedUser == null) return;

      var body = convert.json.encode(
        {
          'username': selectedUser.username,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/permission/list");
      var resp = await client.post(url, headers: kHeader, body: body);
      if (resp.statusCode == 200) {
        permissions = permissionModelFromJson(resp.body);

        is_dashboard = false;
        is_request = false;
        is_settings_user = false;
        is_settings_permission = false;
        is_lookup_student = false;
        is_lookup_forms = false;

        if (permissions.isNotEmpty) {
          for (var item in permissions) {
            switch (item.module) {
              case "dashboard":
                is_dashboard = item.allowed! == 1 ? true : false;
                break;
              case "request":
                is_request = item.allowed! == 1 ? true : false;
                break;
              case "settings_user":
                is_settings_user = item.allowed! == 1 ? true : false;
                break;
              case "settings_permission":
                is_settings_permission = item.allowed! == 1 ? true : false;
                break;
              case "lookup_student":
                is_lookup_student = item.allowed! == 1 ? true : false;
                break;
              case "lookup_forms":
                is_lookup_forms = item.allowed! == 1 ? true : false;
                break;
              default:
            }
          }
        }
      }
    } catch (error) {
      print('reqPermissions : $error');
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Future<void> reqUpdate(module, allowed) async {
    try {
      permissions = [];
      if (selectedUser == null) return;

      var body = convert.json.encode(
        {
          'username': selectedUser.username,
          'module': module,
          'allowed': allowed ? 1 : 0,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/permission/update");
      await client.post(url, headers: kHeader, body: body);
    } catch (error) {
      print('reqPermissions : $error');
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Future<void> handleSelectedUserChanged(value) async {
    try {
      setState(() {
        loadingController.setValue(true);
      });

      selectedUser = value;
      await reqPermissions();

      setState(() {
        loadingController.setValue(false);
      });
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Future<void> handleSaveClick() async {
    try {
      if (selectedUser == null) {
        Dialogs.errorDialog(context, "Pls. select user.");
        return;
      }

      var response = await Dialogs.confirmationDialog(
          context, "Permission", "Are you sure you want to update permission?");
      if (response == DialogAction.yes) {
        setState(() {
          loadingController.setValue(true);
        });

        await Future.wait([
          reqUpdate("dashboard", is_dashboard),
          reqUpdate("request", is_request),
          reqUpdate("settings_user", is_settings_user),
          reqUpdate("settings_permission", is_settings_permission),
          reqUpdate("lookup_student", is_lookup_student),
          reqUpdate("lookup_forms", is_lookup_forms),
        ]);

        setState(() {
          loadingController.setValue(false);
        });

        Dialogs.successDialog(context, "Permissions successfuly updated.");
      }
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loadingController.loading.value) return kLoading();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 10, 8.0, 0),
          child: Container(
            height: 80,
            decoration: const BoxDecoration(
              color: kHoverColor,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: kLabel("Permission"),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10),
          child: kLabel("Select user"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 10),
          child: Row(
            children: [
              Expanded(
                child: DropdownSearch<UserModel>(
                  key: myKey,
                  popupProps: PopupPropsMultiSelection.menu(
                    showSearchBox: true,
                  ),
                  itemAsString: (UserModel u) => u.userAsString(),
                  items: users,
                  selectedItem: selectedUser,
                  onChanged: (item) => handleSelectedUserChanged(item),
                ),
              ),
              Expanded(child: Container()),
              Expanded(child: Container()),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              controller: scrollController,
              children: [
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Main',
                    style: kNormalText(false),
                  ),
                  children: [
                    items(
                      "Dashboard",
                      is_dashboard,
                      "dashboard",
                    ),
                    items(
                      "Request",
                      is_request,
                      "request",
                    ),
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Lookup',
                    style: kNormalText(false),
                  ),
                  children: [
                    items(
                      "Student",
                      is_lookup_student,
                      "lookup_student",
                    ),
                    items(
                      "Forms",
                      is_lookup_forms,
                      "lookup_forms",
                    ),
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'Settings',
                    style: kNormalText(false),
                  ),
                  children: [
                    items(
                      "User",
                      is_settings_user,
                      "settings_user",
                    ),
                    items(
                      "Permission",
                      is_settings_permission,
                      "settings_permission",
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 20.0,
                      ),
                      InkWell(
                        onTap: () => handleSaveClick(),
                        onHover: (value) {
                          setState(() {
                            isHoverSave = value;
                          });
                        },
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Container(
                          width: 180,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isHoverSave
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
                                  Icons.save_rounded,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Update",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
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
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget items(label, data, module) {
    return Row(
      children: [
        SizedBox(width: 20),
        Checkbox(
          value: data,
          onChanged: (item) {
            setState(() {
              switch (module) {
                case "dashboard":
                  is_dashboard = item!;
                  break;
                case "request":
                  is_request = item!;
                  break;
                case "settings_user":
                  is_settings_user = item!;
                  break;
                case "settings_permission":
                  is_settings_permission = item!;
                  break;
                case "lookup_student":
                  is_lookup_student = item!;
                  break;
                case "lookup_forms":
                  is_lookup_forms = item!;
                  break;
                default:
              }
            });
          },
        ),
        SizedBox(width: 10),
        Text(
          label,
          style: kNormalText(false),
        ),
      ],
    );
  }
}
