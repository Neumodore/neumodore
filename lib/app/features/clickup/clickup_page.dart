import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumodore/app/widgets/neumorphic/neumo_button.dart';
import 'package:neumodore/infra/controllers/purchases_controller/purchases_controller.dart';

class ClickupPage extends StatelessWidget {
  static String name = '/purchases';
  final ClickupController _settingsCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          leading: SizedBox(),
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: _buildTopBar(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GetBuilder<PurchasesController>(
          builder: (_) => ListView.builder(
            physics: AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            itemBuilder: (ctx, idx) {
              return _buildProductRow(context, _, idx);
            },
            itemCount: _?.products?.length ?? 10,
          ),
        ),
      ),
    );
  }

  Padding _buildProductRow(
      BuildContext context, PurchasesController _, int idx) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: ClayContainer(
          emboss: true,
          spread: 10,
          curveType: CurveType.convex,
          color: Theme.of(context).backgroundColor,
          borderRadius: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.local_drink,
                  size: 40,
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          _?.products?.elementAt(idx)?.skuDetail?.title ??
                              "Title",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ),
                    Text(
                      _?.products?.elementAt(idx)?.description ?? "Description",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Spacer(),
                        Text(
                          _?.products?.elementAt(idx)?.price ?? "Price",
                          style: Theme.of(context).textTheme.button,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Row _buildStepperRow(
    BuildContext context, {
    String name,
    String value,
    onPlus,
    onMinus,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            name,
            style: Theme.of(context).textTheme.button,
          ),
        ),
        _buildStepper(
          context,
          value: value,
          onPlus: onPlus,
          onMinus: onMinus,
        ),
      ],
    );
  }

  Widget _buildStepper(
    BuildContext context, {
    String value,
    VoidCallback onPlus,
    VoidCallback onMinus,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: NeumoButton(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Icon(Icons.remove),
            onPressed: onMinus,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            value,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: NeumoButton(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Icon(Icons.add),
            onPressed: onPlus,
          ),
        )
      ],
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
              'purchases_title'.tr,
              style:
                  Theme.of(context).textTheme.headline6.copyWith(fontSize: 28),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: NeumoButton(
                onPressed: () {
                  Get.offAndToNamed('/settings');
                },
                child: Icon(Icons.chevron_left),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClickupController {}
