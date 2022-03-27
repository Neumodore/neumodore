import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/domain/services/clickup/clickup_api.dart';
import 'package:neumodore/infra/services/deep_links.dart';
import 'package:url_launcher/url_launcher.dart';

import 'clickup_page.dart';

class ClickupController extends GetxController {
  DeepLinkService _deepLinking;
  ClickupApiService clickupService;
  PageController pageController;

  var _fetchedTeams, _fetchedSpaces, _fetchedLists, _fetchedStatuses;

  StreamSubscription<Uri> _fromLinkSubscription;

  String fromStatus;

  String toStatus;

  dynamic _selectedList;

  dynamic _fetchedTasks;

  List<dynamic> get teams {
    return _fetchedTeams != null ? _fetchedTeams['teams'] : [];
  }

  List<dynamic> get spaces {
    return _fetchedSpaces != null ? _fetchedSpaces['spaces'] : [];
  }

  List<dynamic> get lists {
    return _fetchedLists != null ? _fetchedLists['lists'] : [];
  }

  List<dynamic> get statuses {
    return _fetchedStatuses != null ? _fetchedStatuses['statuses'] : [];
  }

  List<bool> originStatus = [];

  ClickupController(this.clickupService, this._deepLinking);

  @override
  void onInit() async {
    super.onInit();
    pageController = PageController(keepPage: true);

    this._fromLinkSubscription =
        _deepLinking.linkOpenSubject.listen(_whenComeFromLink);

    if (this.clickupService.isLoggedIn) {}
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
    _fromLinkSubscription.cancel();
  }

  void loadPageData() async {
    _fetchedTeams = await clickupService.getAuthorizedTeams();
  }

  void goToPage(num number) {
    update();
    pageController.animateToPage(
      number,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInCirc,
    );
  }

  void chooseTeam(data) async {
    _fetchedSpaces = await clickupService.getSpacesFromTeam(data["id"]);
    goToPage(1);
  }

  void chooseSpace(data) async {
    _fetchedLists = await clickupService.getListsFromSpace(data["id"]);
    goToPage(2);
  }

  void chooseList(data) async {
    _fetchedStatuses = await clickupService.getStatusesFromList(data["id"]);
    _selectedList = data;
    originStatus = statuses.map((v) => false).toList();
    destinationStatus = originStatus;
    goToPage(3);
  }

  void setOrigin(int index) {
    originStatus = originStatus.map((e) => false).toList();
    originStatus[index] = !originStatus[index];
    fromStatus = statuses[index]["status"];
    update();
  }

  List<bool> destinationStatus = [];
  void setDestination(int index) {
    destinationStatus = destinationStatus.map((e) => false).toList();
    destinationStatus[index] = !destinationStatus[index];
    toStatus = statuses[index]["status"];
    update();
  }

  void _whenComeFromLink(Uri value) async {
    if (value.path == '/clickup') {
      print("/clickup?code=");
      print(value.queryParameters['code']);
      print(value.toString());
      await clickupService.authorizeClient(value.queryParameters['code']);
      await Get.toNamed(ClickupPage.name);
    }
  }

  void authenticateOrLaunchClickup() async {
    if (this?.clickupService?.authorizationToken != null) {
      _fetchedTeams = await clickupService.getAuthorizedTeams();
      await Get.toNamed(ClickupPage.name);
    } else {
      final String clientId = "BUXTWDZ8OIY1ZTL4XGQQFVP0EMM0NPB5";
      final String redirectUri = "https://neumodore.herokuapp.com";
      await launch(
          "https://app.clickup.com/api?client_id=$clientId&redirect_uri=$redirectUri/clickup");
    }
  }

  closeClickupPage() async {
    await refreshTasks();
    Get.back();
  }

  Future refreshTasks() async {
    _fetchedTasks =
        await clickupService.getTasksFromList(this._selectedList["id"]);
    update();
  }

  fromTasks() {
    return _fetchedTasks?.where((task) {
          return task["status"]["status"] == fromStatus;
        }) ??
        [];
  }

  PageController activePageView = PageController();

  void closeTask() async {
    final task = await _fetchedTasks[activePageView.page.toInt() - 1];
    final updated = await clickupService.updateTaskStatus(task["id"], toStatus);
    _fetchedTasks[activePageView.page.toInt()] = updated;
    update();

    Get.snackbar(
      "task_closed".tr,
      "press_undo_to_revert_changes".tr,
      snackStyle: SnackStyle.FLOATING,
      mainButton: FlatButton(
        child: Text("undo".tr),
        onPressed: reopenTask,
      ),
      duration: Duration(seconds: 10),
    );
  }

  void reopenTask() async {
    final task = await _fetchedTasks[activePageView.page.toInt() - 1];
    final updated =
        await clickupService.updateTaskStatus(task["id"], fromStatus);
    _fetchedTasks[activePageView.page.toInt()] = updated;
    Get.back();
    update();
  }
}
