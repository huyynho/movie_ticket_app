import 'package:get/get.dart';
import 'package:movie_ticket/model/ticket_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_ticket/utils/firebase/firebase_ticket.dart';

class MyTicketController extends GetxController {
  final TicketService _ticketService = TicketService();
  List<TicketModel> tickets = <TicketModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    Get.put(FirebaseAuth.instance);
    getTicketsByUserId();
  }

  Future<void> getTicketsByUserId() async {
    isLoading.value = true;
    final userId = Get.find<FirebaseAuth>().currentUser?.uid;
    final result = await _ticketService.getTicketsByUserId(userId ?? "");
    result.sort((a, b) => b.purchaseDate!.compareTo(a.purchaseDate!));
    tickets.assignAll(result);
    isLoading.value = false;
  }
}
