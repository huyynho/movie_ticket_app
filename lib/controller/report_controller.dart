import 'package:get/get.dart';
import 'package:movie_ticket/model/ticket_model.dart';
import 'package:movie_ticket/model/user_model.dart';
import 'package:movie_ticket/utils/firebase/firebase_ticket.dart';
import 'package:movie_ticket/utils/firebase/firebase_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportController extends GetxController {
  final TicketService _ticketService = TicketService();
  final UserService _useService = UserService();
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  List<TicketModel> tickets = <TicketModel>[].obs;
  RxBool isLoading = true.obs;
  RxDouble revenue = 0.0.obs;
  var revenueData = <String, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    Get.put(FirebaseAuth.instance);
    getUserByUserId();
    getAllTicket();
  }

  Future<void> getUserByUserId() async {
    isLoading.value = true;
    final userId = Get.find<FirebaseAuth>().currentUser?.uid;
    currentUser.value = await _useService.getUserByUserId(userId ?? "");
    isLoading.value = false;
  }

  Future<void> getAllTicket() async {
    isLoading.value = true;
    final result = await _ticketService.getAllTicket();
    tickets.assignAll(result);
    revenue.value = tickets.fold(0.0, (sum, ticket) => sum + (ticket.amount ?? 0));

    Map<String, double> tempRevenueData = {};

    for (var ticket in tickets) {
      final movieTitle = ticket.movieTitle ?? 'Unknown';
      final ticketAmount = ticket.amount ?? 0.0;

      tempRevenueData[movieTitle] = (tempRevenueData[movieTitle] ?? 0) + ticketAmount;
    }

    revenueData.assignAll(tempRevenueData);

    isLoading.value = false;
  }
}
