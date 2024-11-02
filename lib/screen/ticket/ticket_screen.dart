import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:movie_ticket/config/color/color.dart';
import 'package:movie_ticket/config/route/routes.dart';
import 'package:movie_ticket/model/ticket_model.dart';
import 'package:movie_ticket/controller/seat_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketScreen extends StatefulWidget {
  final TicketModel ticket;

  TicketScreen({required this.ticket});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late SeatController _seatController;

  @override
  void initState() {
    super.initState();
    _seatController = Get.put(SeatController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Reset data
            _seatController.selectedSeatNames.value = '';
            _seatController.totalPrice.value = 0;
            _seatController.getSeatByMovieId(widget.ticket.movieId ?? "");
            Get.back();
          },
        ),
        title: Text('ticket'.tr, style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // QR
            Center(
              child: QrImageView(
                data: widget.ticket.id.toString(),
                version: QrVersions.auto,
                size: 200,
              ),
            ),
            const SizedBox(height: 20),

            // Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "messageTicket".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),

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
                              '${'movie'.tr}: ${widget.ticket.movieTitle}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${'seatNumber'.tr}: ${widget.ticket.seatNumbers}',
                              style: const TextStyle(
                                  color: AppColor.grey, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${'showtime'.tr}: ${widget.ticket.showtime}',
                              style: const TextStyle(
                                  color: AppColor.grey, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${'cinemaLocation'.tr}: ${widget.ticket.cinemaLocation}',
                              style: const TextStyle(
                                  color: AppColor.grey, fontSize: 14),
                            ),
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
                          Text(
                            'totalAmount'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${NumberFormat('#,###').format(widget.ticket.amount)}',
                            style: const TextStyle(
                              color: AppColor.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
            const SizedBox(height: 20),

            // Back to Home
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
                  Get.offNamed(AppRouterName.home);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'backToHome'.tr,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.home, color: Colors.white),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
