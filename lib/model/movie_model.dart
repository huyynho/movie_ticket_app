import 'package:cloud_firestore/cloud_firestore.dart';

class MovieModel {
  final String? id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final Timestamp? premiereDate;
  final String? genre;
  final String? country;
  final String? trailerUrl;
  final double? rating;
  final List<String>? imageGallery;
  final int? durationMinutes;
  final double? price;

  MovieModel(
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.premiereDate,
    this.genre,
    this.country,
    this.trailerUrl,
    this.rating,
    this.imageGallery,
    this.durationMinutes,
    this.price,
  );

  // Object for fetch from Firebase
  factory MovieModel.fromDocument(DocumentSnapshot doc) {
    return MovieModel(
      doc.id,
      doc.get('title'),
      doc.get('description'),
      doc.get('imageUrl'),
      doc.get('premiereDate'),
      doc.get('genre'),
      doc.get('country'),
      doc.get('trailerUrl'),
      (doc.get('rating') as num?)?.toDouble(),
      List<String>.from(doc.get('imageGallery') ?? []),
      doc.get('durationMinutes'),
      (doc.get('price') as num?)?.toDouble(),
    );
  }

  // Object for saving to Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'premiereDate': premiereDate,
      'genre': genre,
      'country': country,
      'trailerUrl': trailerUrl,
      'rating': rating,
      'imageGallery': imageGallery,
      'durationMinutes': durationMinutes,
      'price': price
    };
  }
}
