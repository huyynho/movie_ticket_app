import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:movie_ticket/model/movie_model.dart';
import 'package:movie_ticket/model/user_model.dart';
import 'package:movie_ticket/utils/common_value/common_message.dart';
import 'package:movie_ticket/utils/firebase/firebase_movie.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_ticket/utils/firebase/firebase_user.dart';

class MovieController extends GetxController {
  final MovieService _movieService = MovieService();
  final UserService _useService = UserService();
  List<MovieModel> movieData = <MovieModel>[].obs;
  RxList<String> imageCarousels = <String>[].obs;
  RxBool isLoading = false.obs;
  RxInt index = 1.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
 
  @override
  void onInit() {
    super.onInit();
    Get.put(FirebaseAuth.instance);
    getUserByUserId();
  }

  @override
  void onReady() async {
    await getData();
  }

  Future<void> getUserByUserId() async {
    isLoading.value = true;
    final userId = Get.find<FirebaseAuth>().currentUser?.uid;
    currentUser.value = await _useService.getUserByUserId(userId ?? "");
    isLoading.value = false;
  }

  Future<void> getData() async {
    isLoading.value = true;

    final futures = [
      getImageCarousels(),
      getAndFilterMovies(""),
    ];

    await Future.wait(futures);

    isLoading.value = false;
  }

  Future<void> getImageCarousels() async {
    final ListResult result =
        await FirebaseStorage.instance.ref('carousel').listAll();
    imageCarousels.clear();

    for (var ref in result.items) {
      String downloadURL = await ref.getDownloadURL();
      imageCarousels.add(downloadURL);
    }
  }

  Future<void> getAndFilterMovies(String search) async {
    List<MovieModel> result = await _movieService.getAllMovies();

    movieData.assignAll(result);

    // Filter movie with search
    if (search.isNotEmpty) {
      List<MovieModel> filteredList = List.from(movieData.where((movie) =>
          movie.title?.toLowerCase().contains(search.toLowerCase()) ?? false));

      movieData.assignAll(filteredList);
    }
  }

  Future<void> addMovies({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required Timestamp premiereDate,
    required String genre,
    required String country,
    required String trailerUrl,
    required double rating,
    required List<String> imageGallery,
    required int durationMinutes,
    required double price,
  }) async {
    isLoading.value = true;

    final MovieModel movie = MovieModel(
      id,
      title,
      description,
      imageUrl,
      premiereDate,
      genre,
      country,
      trailerUrl,
      rating,
      imageGallery,
      durationMinutes,
      price
    );

    String resultAdd = await _movieService.addMovie(movie);
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
          message: CommonMessage.addMovieSuccess,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        ),
      );
    }
    isLoading.value = false;
  }
}
