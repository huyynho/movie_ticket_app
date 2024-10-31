import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  final String? id;
  final String? movieId;
  final String? movieTitle;
  final String? userId;
  final String? showtime;
  final String? seatNumbers;
  final String? cinemaLocation;
  final double? amount;
  final Timestamp? purchaseDate;
  final bool? paymentStatus;

  TicketModel(
    this.id,
    this.movieId,
    this.movieTitle,
    this.userId,
    this.showtime,
    this.seatNumbers,
    this.cinemaLocation,
    this.amount,
    this.purchaseDate,
    this.paymentStatus,
  );

  // Object for fetch from Firebase
factory TicketModel.fromDocument(DocumentSnapshot doc) {
  return TicketModel(
    doc.id,
    doc.get('movieId'),
    doc.get('movieTitle'),
    doc.get('userId'),
    doc.get('showtime'),
    doc.get('seatNumbers'),
    doc.get('cinemaLocation'),
    (doc.get('amount') as num?)?.toDouble(),
    doc.get('purchaseDate'),
    doc.get('paymentStatus'),
  );
}

  // Object for saving to Firebase
  Map<String, dynamic> toMap() {
    return {
      'movieId': movieId,
      'movieTitle': movieTitle,
      'userId': userId,
      'showtime': showtime,
      'seatNumbers': seatNumbers,
      'cinemaLocation': cinemaLocation,
      'amount': amount,
      'purchaseDate': purchaseDate,
      'paymentStatus': paymentStatus,
    };
  }
}
