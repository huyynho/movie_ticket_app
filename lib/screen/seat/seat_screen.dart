import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:movie_ticket/config/color/color.dart';
import 'package:movie_ticket/model/movie_model.dart';
import 'package:movie_ticket/model/seat_detail_model.dart';
import 'package:movie_ticket/screen/seat/seat_controller.dart';
import 'package:movie_ticket/utils/common_value/common_status.dart';

class SeatScreen extends StatefulWidget {
  final MovieModel movie;

  SeatScreen({required this.movie});

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  late SeatController _seatController;

  @override
  void initState() {
    super.initState();
    _seatController = Get.put(SeatController());
    _seatController.getSeatByMovieId(widget.movie.id ?? "");
  }

  @override
  Widget build(BuildContext context) {
    ever(
      _seatController.isLoading,
      (_) => {
        if (_seatController.isLoading.value)
          {context.loaderOverlay.show()}
        else
          {context.loaderOverlay.hide()},
      },
    );
    context.loaderOverlay.show();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title:
            Text('selectSeats'.tr, style: const TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text("screen".tr,
              style: const TextStyle(
                  color: AppColor.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const Divider(color: AppColor.grey, thickness: 5),
          const SizedBox(height: 16),

          // Color Instruction
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                colorInstruction(AppColor.primary, 'booked'.tr),
                colorInstruction(AppColor.yellow, 'selected'.tr),
                colorInstruction(AppColor.grey, 'available'.tr),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Seat Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final seatData = _seatController.seatData.value;

                if (seatData.numberOfColumn! <= 0 ||
                    seatData.seatDetails!.isEmpty) {
                  return Center(
                    child: Text(
                      'noSeatsAvailable'.tr,
                      style: const TextStyle(color: AppColor.grey),
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: seatData.numberOfColumn ?? 0,
                    childAspectRatio: 1,
                  ),
                  itemCount: seatData.seatDetails!.length,
                  itemBuilder: (context, index) {
                    SeatDetailModel seatDetail = seatData.seatDetails![index];
                    String seatName = '${seatDetail.row}${seatDetail.column}';

                    return Obx(() {
                      Color seatColor;
                      bool isSelected = _seatController.selectedSeats.contains(seatName);

                      // Check status to fill color
                      if (seatDetail.status == CommonStatus.booked) {
                        seatColor = AppColor.primary;
                      } else if (isSelected) {
                        seatColor = AppColor.yellow;
                      } else {
                        seatColor = AppColor.grey;
                      }

                      // Seat Name
                      return GestureDetector(
                        onTap: seatDetail.status != CommonStatus.booked
                            ? () => _seatController.seatSelection(seatName, widget.movie.price ?? 0.0)
                            : null,
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: seatColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              seatName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),
          ),

          // Showtime and Cinema
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Showtime
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'showtime'.tr,
                        style: TextStyle(
                            color: Colors.grey.shade300, fontSize: 16),
                      ),
                      Obx(() => DropdownButton<String>(
                            dropdownColor: AppColor.grey,
                            value: _seatController.selectedShowtime.value,
                            underline: const SizedBox.shrink(),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            items: _seatController.availableShowtimes
                                .map((showtime) => DropdownMenuItem<String>(
                                      value: showtime,
                                      child: Text(
                                        showtime,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              _seatController.selectedShowtime.value =
                                  value ?? "";
                            },
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Cinema Location
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  decoration: BoxDecoration(
                    color: AppColor.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'cinemaLocation'.tr,
                        style: TextStyle(
                            color: Colors.grey.shade300, fontSize: 16),
                      ),
                      Obx(() => DropdownButton<String>(
                            dropdownColor: Colors.grey.shade900,
                            value: _seatController.selectedCinema.value,
                            underline: const SizedBox.shrink(),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            items: _seatController.availableCinemas
                                .map((cinema) => DropdownMenuItem<String>(
                                      value: cinema,
                                      child: Text(
                                        cinema,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              _seatController.selectedCinema.value =
                                  value ?? "";
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Ticket Detail
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Ticket Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Movie: ${widget.movie.title}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() => Text(
                                'Seat Number: ${_seatController.selectedSeatNames.value}',
                                style: const TextStyle(
                                    color: AppColor.grey, fontSize: 14),
                              )),
                          const SizedBox(height: 8),
                          Obx(() => Text(
                                'Showtime: ${_seatController.selectedShowtime.value}',
                                style: const TextStyle(
                                    color: AppColor.grey, fontSize: 14),
                              )),
                          const SizedBox(height: 8),
                          Obx(() => Text(
                                'Cinema: ${_seatController.selectedCinema.value}',
                                style: const TextStyle(
                                    color: AppColor.grey, fontSize: 14),
                              )),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),

                    // Divider
                    Container(
                      width: 1,
                      height: 100,
                      color: Colors.grey,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),

                    // Total Amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(() {
                          final formattedPrice = NumberFormat('#,###').format(_seatController.totalPrice.value);
                          return Text(
                            '${formattedPrice}',
                            style: const TextStyle(
                              color: AppColor.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                        const Text(
                          'VND',
                          style: TextStyle(
                            color: AppColor.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Payment Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'paymentNow'.tr,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget colorInstruction(Color color, String label) {
  return Row(
    children: [
      Container(
        width: 20,
        height: 20,
        color: color,
      ),
      const SizedBox(width: 4),
      Text(label),
    ],
  );
}
