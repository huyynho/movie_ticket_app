import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:movie_ticket/config/color/color.dart';
import 'package:movie_ticket/config/route/routes.dart';
import 'package:movie_ticket/model/movie_model.dart';
import '../../controller/movie_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class MovieScreen extends StatefulWidget {
  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late MovieController _movieController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _movieController = Get.put(MovieController());
  }

  @override
  Widget build(BuildContext context) {
    ever(
      _movieController.isLoading,
      (_) => {
        if (_movieController.isLoading.value)
          {context.loaderOverlay.show()}
        else
          {context.loaderOverlay.hide()},
      },
    );
    // context.loaderOverlay.show();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.primary,
        title: Text(
          'titleApp'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Row(
            children: [
              Obx(() => Text(
                    _movieController.currentUser.value?.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              IconButton(
                iconSize: 30,
                color: Colors.white,
                icon: const Icon(Icons.account_circle_sharp),
                onPressed: () {
                  showAccountInfo(context);
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Carousel Slider
          Obx(() {
            return Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 5000),
                    onPageChanged: (index, reason) {
                      _movieController.index.value = index;
                    },
                  ),
                  items: _movieController.imageCarousels.map((item) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Center(
                          child: Image.network(
                            item,
                            fit: BoxFit.fill,
                            height: 250,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // Index Display
                Positioned(
                  top: 16,
                  right: 60,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    child: Obx(() => Text(
                          '${_movieController.index.value + 1}/${_movieController.imageCarousels.length}',
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              ],
            );
          }),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Search Text
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'searchMovie'.tr,
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      onChanged: (value) {
                        // _movieController.getAndFilterMovies(value);
                      },
                    ),
                  ),
                  // Search Icon
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _movieController
                          .getAndFilterMovies(_searchController.text);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Movie
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: _movieController.movieData.length,
                itemBuilder: (context, index) {
                  final movie = _movieController.movieData[index];
                  return GestureDetector(
                      onTap: () {
                        if (movie != null) {
                          Get.toNamed(AppRouterName.detail, arguments: movie);
                        }
                      },
                      child: MovieCard(movie: movie));
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final MovieModel movie;

  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.imageUrl ?? '',
                height: 120,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),

            // Movie details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie title
                  Text(
                    movie.title ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Rating Stars
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < (movie.rating ?? 0).round()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ),
                  const SizedBox(height: 8),

                  // Genre
                  Text(
                    movie.genre ?? '',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Duration Minutes & PremiereDate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${movie.durationMinutes} ${'minutes'.tr}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(movie.premiereDate!.toDate()),
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showAccountInfo(BuildContext context) {
  final MovieController controller = Get.find<MovieController>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "accountInfo".tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 20),
            // Name
            Text(
              "${'name'.tr}: ${controller.currentUser.value?.name ?? ''}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            // Email
            Text(
              "${'email'.tr}:  ${controller.currentUser.value?.email ?? ''}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColor.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(AppRouterName.login);
                    },
                    child: Text(
                      "logOut".tr,
                      style: const TextStyle(color: AppColor.primary),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColor.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "close".tr,
                      style: const TextStyle(color: AppColor.grey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
