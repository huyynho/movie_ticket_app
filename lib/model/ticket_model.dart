import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  final String? id;
  final String? movieId;
  final String? cinemaId;
  final String? userId;
  final String? showtime;
  final List<String>? seatNumbers;
  final double? amount;
  final Timestamp? purchaseDate;
  final bool? paymentStatus;

  TicketModel(
    this.id,
    this.movieId,
    this.cinemaId,
    this.userId,
    this.showtime,
    this.seatNumbers,
    this.amount,
    this.purchaseDate,
    this.paymentStatus,
  );

  //# Object for fetch from Firebase
  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      map['id'],
      map['movieId'],
      map['cinemaId'],
      map['userId'],
      map['showtime'],
      List<String>.from(map['seatNumbers'] ?? []),
      (map['amount'] as num?)?.toDouble(),
      map['purchaseDate'],
      map['paymentStatus'],
    );
  }

  //# Object for saving to Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movieId': movieId,
      'cinemaId': cinemaId,
      'userId': userId,
      'showtime': showtime,
      'seatNumbers': seatNumbers,
      'amount': amount,
      'purchaseDate': purchaseDate,
      'paymentStatus': paymentStatus,
    };
  }
}
