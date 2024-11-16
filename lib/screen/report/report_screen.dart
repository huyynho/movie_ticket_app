import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:movie_ticket/config/color/color.dart';
import 'package:movie_ticket/config/route/routes.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../controller/report_controller.dart';

class ReportScreen extends StatefulWidget {
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late ReportController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ReportController());
  }

  @override
  Widget build(BuildContext context) {
    ever(
      _controller.isLoading,
      (_) {
        if (_controller.isLoading.value) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        automaticallyImplyLeading: false,
        title: Text('revenueReport'.tr,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        actions: [
          Row(
            children: [
              Obx(() => Text(
                    _controller.currentUser.value?.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              IconButton(
                iconSize: 30,
                color: Colors.white,
                icon: const Icon(Icons.account_circle_sharp),
                onPressed: () {
                  showAccountInfo(context);
                },
              ),
            ],
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Revenue
                Obx(() {
                  final formattedRevenue =
                      NumberFormat('#,###').format(_controller.revenue.value);
                  return Text(
                    '${'totalRevenue'.tr}: $formattedRevenue VND',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  );
                }),

                // PieChart
                const SizedBox(height: 30),
                Obx(() {
                  if (_controller.tickets.isEmpty) {
                    return Center(child: Text("noRevenueDataAvailable".tr));
                  }
                  return PieChartWidget(data: _controller.revenueData);
                }),

                // Movie Revenue Table
                const SizedBox(height: 20),
                Obx(() {
                  if (_controller.revenueData.isEmpty) {
                    return Center(child: Text("noRevenueDataAvailable".tr));
                  }
                  return MovieRevenueTable(data: _controller.revenueData);
                }),
              ],
            ),
          )),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final Map<String, double> data;

  PieChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: data,
      chartType: ChartType.ring,
      ringStrokeWidth: 40,
      chartRadius: MediaQuery.of(context).size.width / 2,
      chartValuesOptions: const ChartValuesOptions(
        showChartValuesInPercentage: true,
        showChartValueBackground: true,
      ),
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.bottom,
        legendTextStyle: TextStyle(fontSize: 12),
      ),
    );
  }
}

class MovieRevenueTable extends StatelessWidget {
  final Map<String, double> data;

  MovieRevenueTable({required this.data});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(
            label: Text('movie'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text('totalAmount'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: data.entries.map((entry) {
        final movieTitle = entry.key;
        final amount = entry.value;

        return DataRow(cells: [
          DataCell(Text(movieTitle)),
          DataCell(Text(
            NumberFormat('#,###').format(amount) + ' VND',
          )),
        ]);
      }).toList(),
    );
  }
}

void showAccountInfo(BuildContext context) {
  final ReportController controller = Get.find<ReportController>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "accountInfo".tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 20),
            // Name
            Text(
              "${'name'.tr}: ${controller.currentUser.value?.name ?? ''}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            // Email
            Text(
              "${'email'.tr}:  ${controller.currentUser.value?.email ?? ''}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColor.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(AppRouterName.login);
                    },
                    child: Text(
                      "logOut".tr,
                      style: const TextStyle(color: AppColor.primary),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColor.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "close".tr,
                      style: const TextStyle(color: AppColor.grey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
