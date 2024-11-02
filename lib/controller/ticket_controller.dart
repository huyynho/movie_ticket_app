import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_ticket/config/route/routes.dart';
import 'package:movie_ticket/model/ticket_model.dart';
import 'package:movie_ticket/utils/common_value/common_message.dart';
import 'package:movie_ticket/utils/firebase/firebase_seat.dart';
import 'package:movie_ticket/utils/firebase/firebase_ticket.dart';

class TicketController extends GetxController {
  final TicketService _ticketService = TicketService();
  final SeatService _seatService = SeatService();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    Get.put(FirebaseAuth.instance);
  }

  @override
  void onReady() async {}

  Future<void> addTicket({
    String? id,
    required String movieId,
    required String movieTitle,
    required String showtime,
    required String seatNumbers,
    required String cinemaLocation,
    required double amount,
    required Timestamp purchaseDate,
    required bool paymentStatus,
  }) async {
    if (seatNumbers.isEmpty) {
      Get.showSnackbar(
        GetSnackBar(
          title: CommonMessage.warning,
          message: CommonMessage.pleaseSelectYourSeat,
          backgroundColor: Colors.amber.shade700,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    isLoading.value = true;

    final userId = Get.find<FirebaseAuth>().currentUser?.uid;

    final TicketModel ticket = TicketModel(
        id,
        userId,
        movieId,
        movieTitle,
        showtime,
        seatNumbers,
        cinemaLocation,
        amount,
        purchaseDate,
        paymentStatus);

    String resultAdd = await _ticketService.addTicket(ticket);
    if (resultAdd.isNotEmpty) {
      Get.showSnackbar(
        GetSnackBar(
          title: CommonMessage.error,
          message: resultAdd,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      final List<String> selectedSeats = seatNumbers.split(',');
      await _seatService.updateSeatsStatus(ticket.movieId ?? "", selectedSeats);
      Get.showSnackbar(
        GetSnackBar(
          title: CommonMessage.success,
          message: CommonMessage.paymentSuccess,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        ),
      );
      Get.toNamed(AppRouterName.ticket, arguments: ticket);
    }
    isLoading.value = false;
  }
}
