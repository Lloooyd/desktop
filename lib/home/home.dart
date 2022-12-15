// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:desktop/common/constant.dart';
import 'package:desktop/common/dialog.dart';
import 'package:desktop/controller/userController.dart';
import 'package:desktop/home/dashboard.dart';
import 'package:desktop/home/welcome.dart';
import 'package:desktop/login/login.dart';
import 'package:desktop/lookup/forms.dart';
import 'package:desktop/lookup/student.dart';
import 'package:desktop/model/dashboard_count_model.dart';
import 'package:desktop/model/menuModel.dart';
import 'package:desktop/model/permissionModel.dart';
import 'package:desktop/model/userModel.dart';
import 'package:desktop/request/approved.dart';
import 'package:desktop/request/completed.dart';
import 'package:desktop/request/forpickup.dart';
import 'package:desktop/request/forreview.dart';
import 'package:desktop/request/rejected.dart';
import 'package:desktop/settings/permission.dart';
import 'package:desktop/settings/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserController userController = Get.find();
  UserModel user = UserModel();
  List<PermissionModel> permissions = [];

  int selectedIndex = 0;
  int isHover = 0;
  bool isLoading = false;
  bool isHideMenu = false;
  bool isHoverMenu = false;
  String selectedHeader = "D A S H B O A R D";

  bool is_dashboard = false;
  bool is_request = false;
  bool is_settings_user = false;
  bool is_settings_permission = false;
  bool is_lookup_student = false;
  bool is_lookup_forms = false;

  bool is_lookup = false;
  bool is_settings = false;



  @override
  void initState() {
    super.initState();

    user = userController.user.value;
    permissions = userController.permissions.value as List<PermissionModel>;
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

    if (is_settings_user || is_settings_permission) {
      is_settings = true;
    }

    if (is_lookup_student || is_lookup_forms) {
      is_lookup = true;
    }
  }

  TextStyle titleStyleMenu = kNormalText(false);
  TextStyle titleStyleItem = kNormalText(false);

  Color setColor(index) {
    if (selectedIndex == index) {
      return kSelectorColor;
    } else if (isHover == index) {
      // return kHoverColor;
      return const Color.fromARGB(255, 245, 151, 122);
    } else {
      return Colors.transparent;
    }
  }

  Future<void> handleMenuClick(MenuModel item) async {
    print('handleMenuClick');

    setState(() {
      selectedHeader = item.header;
      selectedIndex = item.index;
    });
  }

  loadingCallback(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  Widget menuItem(MenuModel menu) {
    return InkWell(
      onTap: () => menu.title == "Logout"
          ? Get.offAll(const LoginPage())
          : handleMenuClick(menu),
      onHover: (value) {
        setState(() {
          isHover = menu.index;
        });
      },
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: setColor(menu.index),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 8,
                ),
                Icon(menu.icon),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Text(
                    menu.title,
                    style: titleStyleItem,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bodyDisplay() {
    //welcome
    if (selectedIndex == 0) {
      return WelcomePage(loadingCallback: loadingCallback);
    }

    //dashboard
    if (selectedIndex == 1) {
      return DashboardPage(loadingCallback: loadingCallback);
    }

    //request
    if (selectedIndex == 21) {
      return ForReviewPage(
        loadingCallback: loadingCallback,
      );
    }

    if (selectedIndex == 22) {
      return ApprovedPage(
        loadingCallback: loadingCallback,
      );
    }

    if (selectedIndex == 23) {
      return ForPickupPage(
        loadingCallback: loadingCallback,
      );
    }

    if (selectedIndex == 24) {
      return CompletedPage(
        loadingCallback: loadingCallback,
      );
    }

    if (selectedIndex == 25) {
      return RejectedPage(
        loadingCallback: loadingCallback,
      );
    }

    //lookup
    if (selectedIndex == 3) {
      //resident
      return StudentPage(loadingCallback: loadingCallback);
    } else if (selectedIndex == 4) {
      //barangay
      return FormsPage(loadingCallback: loadingCallback);
    }

    //settings
    if (selectedIndex == 5) {
      return UserPage(loadingCallback: loadingCallback);
    } else if (selectedIndex == 6) {
      return PermissionPage(loadingCallback: loadingCallback);
    }

    return WelcomePage(loadingCallback: loadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedHeader,
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 16,
              fontFeatures: [FontFeature.proportionalFigures()],
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: kSelectorColor,
        elevation: 15,
        leading: InkWell(
          onHover: (value) {
            setState(() {
              isHoverMenu = value;
            });
          },
          onTap: () {
            setState(() {
              isHideMenu = isHideMenu ? false : true;
            });
          },
          child: Icon(
            Icons.table_rows_rounded,
            color: isHoverMenu ? Colors.deepOrangeAccent : Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if (!isHideMenu)
              SizedBox(
                width: 300,
                child: ListView(
                  children: [
                    menuItem(
                      MenuModel(
                          title: "Home",
                          header: "H O M E",
                          icon: Icons.home_rounded,
                          index: 0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    if (is_dashboard)
                      menuItem(
                        MenuModel(
                            title: "Dashboard",
                            header: "D A S H B O A R D",
                            icon: Icons.dashboard_rounded,
                            index: 1),
                      ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.app_shortcut,
                      ),
                      title: Text('Request', style: titleStyleMenu),
                      children: [
                        menuItem(
                          MenuModel(
                              title: "For Review",
                              header: "R E Q U E S T - F O R  R E V I E W",
                              icon: Icons.content_copy,
                              index: 21),
                        ),
                        menuItem(
                          MenuModel(
                              title: "Approved",
                              header: "R E Q U E S T - A P P R O V E D",
                              icon: Icons.check_circle_outline,
                              index: 22),
                        ),
                        menuItem(
                          MenuModel(
                              title: "For Pickup",
                              header: "R E Q U E S T - F O R  P I C K U P",
                              icon: Icons.local_taxi,
                              index: 23),
                        ),
                        menuItem(
                          MenuModel(
                              title: "Completed",
                              header: "R E Q U E S T - C O M P L E T E D",
                              icon: Icons.check_circle,
                              index: 24),
                        ),
                        menuItem(
                          MenuModel(
                              title: "Rejected",
                              header: "R E Q U E S T - R E J E C T E D ",
                              icon: Icons.cancel_presentation,
                              index: 25),
                        ),
                      ],
                    ),
                    if (is_request)
                      const SizedBox(
                        height: 10.0,
                      ),
                    if (is_lookup)
                      ExpansionTile(
                        leading: const Icon(
                          Icons.table_view_rounded,
                        ),
                        title: Text('Lookup', style: titleStyleMenu),
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          if (is_lookup_student)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                              child: menuItem(
                                MenuModel(
                                    title: "Student",
                                    header: "L O O K U P - S T U D E N T",
                                    icon: Icons.people_rounded,
                                    index: 3),
                              ),
                            ),
                          if (is_lookup_forms)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                              child: menuItem(
                                MenuModel(
                                    title: "Forms",
                                    header: "L O O K U P - F O R M S",
                                    icon: Icons.location_city_rounded,
                                    index: 4),
                              ),
                            ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    if (is_settings)
                      ExpansionTile(
                        leading: const Icon(
                          Icons.settings_rounded,
                        ),
                        title: Text('Settings', style: titleStyleMenu),
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          if (is_settings_user)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                              child: menuItem(
                                MenuModel(
                                    title: "User",
                                    header: "S E T T I N G S - U S E R",
                                    icon: Icons.people_rounded,
                                    index: 5),
                              ),
                            ),
                          if (is_settings_permission)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                              child: menuItem(
                                MenuModel(
                                    title: "Permission",
                                    header:
                                        "S E T T I N G S - P E R M I S S I O N",
                                    icon: Icons.admin_panel_settings_rounded,
                                    index: 6),
                              ),
                            ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    menuItem(
                      MenuModel(
                        title: "Logout",
                        header: "",
                        icon: Icons.logout_rounded,
                        index: 7,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),

            // second column
            Expanded(
              child: bodyDisplay(),
            ),
          ],
        ),
      ),
    );
  }
}
