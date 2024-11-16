import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:movie_ticket/model/ticket_model.dart';
import 'package:movie_ticket/utils/checker/network_checker.dart';
import 'package:movie_ticket/utils/common_value/collection_name.dart';
import 'package:movie_ticket/utils/common_value/common_message.dart';
import 'package:movie_ticket/utils/firebase/firebase_instance.dart';
import 'package:uuid/uuid.dart';

Future<String> handleCommonErrorFirebase(
    {required void Function() handleFunc}) async {
  String errorNetwork = await CheckersUtils.checkNetworkError();
  if (errorNetwork.isEmpty) {
    try {
      handleFunc();
    } on FirebaseAuthException catch (e) {
      return e.message ?? CommonMessage.commonError;
    } catch (_) {
      return CommonMessage.commonError;
    }
    return '';
  } else {
    return errorNetwork;
  }
}

class TicketService {
  //# Add ticket
  Future<String> addTicket(TicketModel ticket) async {
    return await handleCommonErrorFirebase(handleFunc: () async {
      await fireStoreInstance
          .collection(CollectionName.tickets)
          .doc(const Uuid().v1())
          .set(ticket.toMap());
    });
  }

  //# Update ticket
  Future<String> updateTicket(TicketModel ticket) async {
    return await handleCommonErrorFirebase(handleFunc: () async {
      await fireStoreInstance
          .collection(CollectionName.tickets)
          .doc(ticket.id)
          .update(ticket.toMap());
    });
  }

  //# Get ticket by id
  Future<TicketModel?> getTicketById(String id) async {
    TicketModel? ticket;
    await handleCommonErrorFirebase(handleFunc: () async {
      DocumentSnapshot snapshot = await fireStoreInstance
          .collection(CollectionName.tickets)
          .doc(id)
          .get();
      if (snapshot.exists) {
        ticket = TicketModel.fromDocument(snapshot);
      }
    });
    return ticket;
  }

  //# Get all ticket
  Future<List<TicketModel>> getAllTicket() async {
    final QuerySnapshot querySnapshot =
        await fireStoreInstance.collection(CollectionName.tickets).get();

    final List<TicketModel> tickets =
        querySnapshot.docs.map((doc) => TicketModel.fromDocument(doc)).toList();

    return tickets;
  }

  // Get tickets by movieId
  Future<List<TicketModel>> getTicketsByMovieId(String movieId) async {
    List<TicketModel> tickets = [];
    await handleCommonErrorFirebase(handleFunc: () async {
      QuerySnapshot querySnapshot = await fireStoreInstance
          .collection(CollectionName.tickets)
          .where('movieId', isEqualTo: movieId)
          .get();

      tickets = querySnapshot.docs
          .map((doc) => TicketModel.fromDocument(doc))
          .toList();
    });
    return tickets;
  }

  // Delete ticket by id
  Future<String> deleteTicket(String id) async {
    return await handleCommonErrorFirebase(handleFunc: () async {
      await fireStoreInstance
          .collection(CollectionName.tickets)
          .doc(id)
          .delete();
    });
  }

  // Get tickets by userId
  Future<List<TicketModel>> getTicketsByUserId(String userId) async {
    final QuerySnapshot querySnapshot = await fireStoreInstance
        .collection(CollectionName.tickets)
        .where('userId', isEqualTo: userId)
        .get();

    final List<TicketModel> tickets =
        querySnapshot.docs.map((doc) => TicketModel.fromDocument(doc)).toList();

    return tickets;
  }
}
