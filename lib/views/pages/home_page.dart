import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/utils/route/app_routes.dart';
import 'package:news_app/view_models/home_cubit/home_cubit.dart';
import 'package:news_app/views/widgets/custom_carousel_slider.dart';
import 'package:news_app/views/widgets/news_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context);
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.home,
        ),
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'News',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'App',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.searchRoute);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<HomeCubit, HomeState>(
              bloc: cubit,
              buildWhen: (prev, current) =>
                  current is SliderLoaded ||
                  current is SliderLoading ||
                  current is SliderError,
              builder: (context, state) {
                if (state is SliderLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is SliderLoaded) {
                  return CustomCarouselSlider(articles: state.articles);
                } else {
                  return const Center(
                    child: Text('Error loading slider'),
                  );
                }
              },
            ),
            const SizedBox(height: 7),
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  Text(
                    'Breaking News',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            BlocBuilder<HomeCubit, HomeState>(
              bloc: cubit,
              buildWhen: (prev, current) =>
                  current is GridViewsLoading ||
                  current is GridViewsLoaded ||
                  current is GridViewsError,
              builder: (context, state) {
                if (state is GridViewsLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is GridViewsLoaded) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.articles.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final article = state.articles[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            AppRoutes.productDetails,
                            arguments: article,
                          );
                        },
                        child: NewsCard(article: article),
                      );
                    },
                  );
                } else {
                  return const SizedBox(
                    height: 15,
                  );
                }
                // Add a return statement here
              },
            ),
          ],
        ),
      ),
    );
  }
}
