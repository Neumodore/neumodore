import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/app/features/clickup/clickup_controller.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_button.dart';
import 'package:neumodore/shared/helpers/colors.dart';

class ClickupPage extends StatelessWidget {
  static String name = '/clickup-login';
  final ClickupController _ctrl = Get.find();

  ClickupPage() {
    _ctrl.loadPageData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClickupController>(
      builder: (_) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            leading: SizedBox(),
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: _buildTopBar(context),
          ),
        ),
        body: PageView(
          controller: _.pageController,
          allowImplicitScrolling: false,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildChooseTeams(_),
            _buildChooseSpaces(_),
            _buildChooseListToBurn(_),
            _chooseWhereFromAndToStatus(context, _),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'clickup_login'.tr,
              style:
                  Theme.of(context).textTheme.headline6.copyWith(fontSize: 28),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: NeumoButton(
                onPressed: () {
                  Get.back();
                },
                child: Icon(Icons.chevron_left),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView _buildChooseTeams(ClickupController _) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext context, int index) {
        final data = _.teams.elementAt(index);
        return GestureDetector(
          onTap: () {
            _ctrl.chooseTeam(data);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ClayContainer(
              depth: 10,
              customBorderRadius: BorderRadius.circular(50),
              color: Color.lerp(HexColor.fromHex(data["color"]),
                  Theme.of(context).backgroundColor, 0.8),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      data["name"] ?? "Title",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: _.teams.length,
    );
  }

  Widget _buildChooseSpaces(ClickupController _) {
    return Container(
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.all(8),
        itemCount: _.spaces.length,
        itemBuilder: (BuildContext context, int index) {
          final data = _.spaces.elementAt(index);
          return GestureDetector(
            onTap: () {
              _ctrl.chooseSpace(data);
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClayContainer(
                depth: 10,
                customBorderRadius: BorderRadius.circular(50),
                color: Theme.of(context).backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        data["name"] ?? "Title",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChooseListToBurn(ClickupController _) {
    return Container(
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.all(8),
        itemCount: _.lists.length,
        itemBuilder: (BuildContext context, int index) {
          final data = _.lists.elementAt(index);
          return GestureDetector(
            onTap: () {
              _ctrl.chooseList(data);
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClayContainer(
                depth: 10,
                customBorderRadius: BorderRadius.circular(50),
                color: Theme.of(context).backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        data["name"] ?? "Title",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _chooseWhereFromAndToStatus(context, ClickupController _) {
    return Container(
      height: 50,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Select The Origin Status:"),
              )
            ],
          ),
          ToggleButtons(
            isSelected: _.originStatus,
            children: _.statuses.map((e) {
              var name = e['status'] ?? 'name';
              return Container(
                height: 50,
                padding: const EdgeInsets.all(10),
                color: Color.lerp(
                  HexColor.fromHex(e["color"]),
                  Theme.of(context).backgroundColor.withOpacity(0.2),
                  0.8,
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              );
            }).toList(),
            constraints: BoxConstraints.tightFor(),
            selectedColor: Colors.white,
            fillColor: Colors.white.withOpacity(0.5),
            disabledColor: Colors.black,
            onPressed: _.setOrigin,
          )
        ],
      ),
      // child: ListView.builder(
      //   physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      //   padding: const EdgeInsets.all(8),
      //   itemCount: _.statuses.length,
      //   scrollDirection: Axis.horizontal,
      //   itemBuilder: (BuildContext context, int index) {
      //     final data = _.statuses.elementAt(index);
      //     return Padding(
      //       padding: const EdgeInsets.all(15.0),
      //       child: GestureDetector(
      //         onTap: () {
      //           print(data);
      //         },
      //         child: ClayContainer(
      //           depth: 10,
      //           customBorderRadius: BorderRadius.circular(50),
      //           color: Color.lerp(
      //             HexColor.fromHex(data["color"]),
      //             Theme.of(context).backgroundColor,
      //             0.8,
      //           ),
      //           child: Padding(
      //             padding: const EdgeInsets.all(15.0),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: <Widget>[
      //                 Text(
      //                   data["status"] ?? "Title",
      //                   style: Theme.of(context).textTheme.bodyText2,
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
