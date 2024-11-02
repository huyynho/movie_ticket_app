import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_ticket/model/movie_model.dart';
import 'package:movie_ticket/utils/checker/network_checker.dart';
import 'package:movie_ticket/utils/common_value/collection_name.dart';
import 'package:movie_ticket/utils/common_value/common_message.dart';
import 'package:movie_ticket/utils/firebase/firebase_instance.dart';
import 'package:uuid/uuid.dart';

Future<String> handleCommonErrorFirebase({required void Function() handleFunc}) async {
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

class MovieService {
  //# Add movie
  Future<String> addMovie(MovieModel movie) async {
    return await handleCommonErrorFirebase(handleFunc: () async {
      await fireStoreInstance.collection(CollectionName.movies).doc(const Uuid().v1()).set(movie.toMap());
    });
  }

  //# Update movie
  Future<String> updateMovie(MovieModel movie) async {
    return await handleCommonErrorFirebase(handleFunc: () async {
      await fireStoreInstance.collection(CollectionName.movies).doc(movie.id).update(movie.toMap());
    });
  }

  //# Get by id
  Future<MovieModel?> getMovieById(String id) async {
    MovieModel? movie;
    await handleCommonErrorFirebase(handleFunc: () async {
      DocumentSnapshot snapshot = await fireStoreInstance.collection(CollectionName.movies).doc(id).get();
      if (snapshot.exists) {
        movie = MovieModel.fromDocument(snapshot);
      }
    });

    return movie;
  }

  // Get all movies
  Future<List<MovieModel>> getAllMovies() async {
    final QuerySnapshot querySnapshot = await fireStoreInstance.collection(CollectionName.movies).get();
    final List<MovieModel> result = querySnapshot.docs.map((e) => MovieModel.fromDocument(e)).toList();
    return result;
  }

  // Delete movie by id
  Future<String> deleteMovie(String id) async {
    return await handleCommonErrorFirebase(handleFunc: () async {
      await fireStoreInstance.collection(CollectionName.movies).doc(id).delete();
    });
  }
}
