import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../screens/movie_detail_screen.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // بيانات تجريبية للأفلام
  final List<Movie> _popularMovies = [
    Movie(
        id: 1,
        title: 'فيلم أكشن',
        overview: 'وصف فيلم الأكشن المثير.',
        posterUrl: 'https://image.tmdb.org/t/p/w500/6KErczPBROKz1e_y0Y4pGCNmpj.jpg',
        backdropUrl:
            'https://image.tmdb.org/t/p/original/6KErczPBROKz1e_y0Y4pGCNmpj.jpg',
        voteAverage: 8.5,
        releaseDate: '2024-01-15',
        genres: ['أكشن', 'مغامرة']),
    Movie(
        id: 2,
        title: 'فيلم كوميدي',
        overview: 'وصف الفيلم الكوميدي المضحك.',
        posterUrl: 'https://image.tmdb.org/t/p/w500/vqzL62DSB3Q2u5bA2L3TIs2Q08g.jpg',
        backdropUrl:
            'https://image.tmdb.org/t/p/original/vqzL62DSB3Q2u5bA2L3TIs2Q08g.jpg',
        voteAverage: 7.8,
        releaseDate: '2024-02-20',
        genres: ['كوميديا']),
    Movie(
        id: 3,
        title: 'فيلم دراما',
        overview: 'وصف الفيلم الدرامي المؤثر.',
        posterUrl: 'https://image.tmdb.org/t/p/w500/7WsyChQLEftuUjliC2joVjB5Iur.jpg',
        backdropUrl:
            'https://image.tmdb.org/t/p/original/7WsyChQLEftuUjliC2joVjB5Iur.jpg',
        voteAverage: 9.1,
        releaseDate: '2023-11-30',
        genres: ['دراما', 'رومانسي']),
  ];

  final List<Movie> _topRatedMovies = [
    Movie(
        id: 4,
        title: 'فيلم خيال علمي',
        overview: 'وصف فيلم الخيال العلمي المذهل.',
        posterUrl: 'https://image.tmdb.org/t/p/w500/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg',
        backdropUrl:
            'https://image.tmdb.org/t/p/original/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg',
        voteAverage: 9.5,
        releaseDate: '2024-03-10',
        genres: ['خيال علمي', 'إثارة']),
    Movie(
        id: 5,
        title: 'فيلم رعب',
        overview: 'وصف فيلم الرعب المخيف.',
        posterUrl: 'https://image.tmdb.org/t/p/w500/A7EByudX0eOzlkQ2V1UWPvfBKD3.jpg',
        backdropUrl:
            'https://image.tmdb.org/t/p/original/A7EByudX0eOzlkQ2V1UWPvfBKD3.jpg',
        voteAverage: 8.9,
        releaseDate: '2023-10-25',
        genres: ['رعب', 'غموض']),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أفلامي', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // منطق البحث
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategorySection(context, 'الأكثر شهرة', _popularMovies),
            const SizedBox(height: 24),
            _buildCategorySection(context, 'الأعلى تقييماً', _topRatedMovies),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
      BuildContext context, String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16.0 : 8.0,
                  right: index == movies.length - 1 ? 16.0 : 0,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(movie: movie),
                      ),
                    );
                  },
                  child: MovieCard(movie: movie),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
