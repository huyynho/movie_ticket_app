import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:movie_ticket/config/color/color.dart';
import 'package:movie_ticket/config/route/routes.dart';
import 'package:movie_ticket/model/movie_model.dart';
import 'movie_controller.dart';
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
    context.loaderOverlay.show();

    return Scaffold(
      appBar: AppBar(
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
          IconButton(
            iconSize: 30,
            color: Colors.white,
            icon: const Icon(Icons.account_circle_sharp),
            onPressed: () {
              _movieController.addMovies(
                  id: '1',
                  title: 'Kính Vạn Hoa',
                  description:
                      "Sau sự thành công của hai phim điện ảnh chuyển thể từ hai tác phẩm đình đám của nhà văn Nguyễn Nhật Ánh, một tác phẩm nổi bật khác của nhà văn hiện đại thành công nhất Việt Nam chuẩn bị được đưa lên màn ảnh rộng: “Kính Vạn Hoa”.",
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/movie-ticket-a5c4e.appspot.com/o/poster%2Fkinhvanhoa.jpg?alt=media&token=ef1b7413-d6d0-4a3a-9cfb-1e5e4256daaf",
                  premiereDate: Timestamp.fromDate(DateTime(2024, 12, 31)),
                  genre: "Hài, Phiêu lưu, Học đường",
                  country: "Việt Nam",
                  trailerUrl: "https://www.youtube.com/watch?v=2bPYkOeCqPw",
                  rating: 5,
                  imageGallery: [],
                  durationMinutes: 180);
            },
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
                    autoPlayAnimationDuration: const Duration(milliseconds: 5000),
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
                      color:Colors.grey.withOpacity(0.7),
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
                  // Text Input
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
                      Get.toNamed(AppRouterName.details);
                    },
                    child: MovieCard(movie: movie)
                    );
                },
              );
            }),
          ),
        ],
      ),

      // Bottom Menu
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'My Ticket',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
          currentIndex: _movieController.selectedIndex.value,
          selectedItemColor: AppColor.primary,
          onTap: (index) {
            _movieController.changeIndex(index);
            switch (index) {
              case 0:
                break;
              case 1:
                // Get.toNamed('/ticket');
                break;
              case 2:
                // Get.toNamed('/settings');
                break;
            }
          },
        );
      }),
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
                        '${movie.durationMinutes ?? 0} ${'minutes'.tr}',
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
