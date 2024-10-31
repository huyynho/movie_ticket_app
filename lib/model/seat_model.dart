import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_ticket/model/seat_detail_model.dart';

class SeatModel {
  final String? id;
  final String? movieId;
  final int? numberOfRow;
  final int? numberOfColumn;
  final List<SeatDetailModel>? seatDetails;

  SeatModel(
    this.id,
    this.movieId,
    this.numberOfRow,
    this.numberOfColumn,
    this.seatDetails,
  );

  factory SeatModel.fromDocument(DocumentSnapshot doc) {
    var seatDetailsFromDoc = doc.get('seatDetails') as List<dynamic>? ?? [];

    List<SeatDetailModel> seatDetails = seatDetailsFromDoc
        .map((detail) => SeatDetailModel.fromJson(detail))
        .toList();

    return SeatModel(
      doc.id,
      doc.get('movieId'),
      doc.get('numberOfRow') as int,
      doc.get('numberOfColumn') as int,
      seatDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movieId': movieId,
      'numberOfRow': numberOfRow,
      'numberOfColumn': numberOfColumn,
      'seatDetails': seatDetails?.map((seat) => seat.toJson()).toList(),
    };
  }
}
