import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_ticket/model/seat_detail_model.dart';
import 'package:movie_ticket/model/seat_model.dart';
import 'package:movie_ticket/utils/common_value/common_message.dart';
import 'package:movie_ticket/utils/firebase/firebase_seat.dart';

class SeatController extends GetxController {
  final SeatService _service = SeatService();
  RxBool isLoading = false.obs;
  Rx<SeatModel> seatData = SeatModel('', '', 0, 0, []).obs;
  List<SeatDetailModel> seatDetail = <SeatDetailModel>[].obs;
  RxList<String> selectedSeats = <String>[].obs;
  RxString selectedSeatNames = ''.obs;
  RxList<String> availableShowtimes = ['18:00', '20:00', '22:00'].obs;
  RxList<String> availableCinemas =
      ['Cinema Ha Noi', 'Cinema Sai Gon', 'Cinema Vung Tau'].obs;
  RxString selectedShowtime = ''.obs;
  RxString selectedCinema = ''.obs;
  RxDouble totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();

    if (availableShowtimes.isNotEmpty) {
      selectedShowtime.value = availableShowtimes[0];
    }
    if (availableCinemas.isNotEmpty) {
      selectedCinema.value = availableCinemas[0];
    }
  }

  @override
  void onReady() async {}

  void getSeatByMovieId(String movieId) async {
    isLoading.value = true;
    SeatModel? result = await _service.getSeatsByMovieId(movieId);

    if (result != null) {
      seatData.value = result;
      seatDetail.assignAll(result.seatDetails ?? []);
    } else {
      seatData.value = SeatModel('', '', 0, 0, []);
    }

    isLoading.value = false;
  }

  void seatSelection(String seatName, double price) {
    if (selectedSeats.contains(seatName)) {
      selectedSeats.remove(seatName);
    } else {
      selectedSeats.add(seatName);
    }

    selectedSeatNames.value = selectedSeats.join(',');
    totalPrice.value = selectedSeats.length * price;
  }

  Future<void> addSeat({
    String? id,
    required String movieId,
    required int numberOfRow,
    required int numberOfColumn,
    required List<SeatDetailModel> seatDetails,
  }) async {
    isLoading.value = true;

    final SeatModel seat = SeatModel(
      id,
      movieId,
      numberOfRow,
      numberOfColumn,
      seatDetails,
    );

    String resultAdd = await _service.addSeat(seat);
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
      Get.showSnackbar(
        GetSnackBar(
          title: CommonMessage.success,
          message: CommonMessage.addSeatSuccess,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        ),
      );
    }
    isLoading.value = false;
  }
}
