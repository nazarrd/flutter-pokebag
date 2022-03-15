import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../common/custom_appbar.dart';
import '../../../common/loading.dart';
import '../controllers/home_controller.dart';
import 'detail_view.dart';

class HomeView extends GetView {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (_) {
        return Scaffold(
          appBar:
              CustomAppBar(appBar: AppBar(), title: 'Pokedex', page: 'home'),
          body: _.pokemonList.isEmpty
              ? const Loading()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ListData(controller: _),
                    !_.isRefresh.value && _.isLoading.value
                        ? Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Transform.scale(
                              scale: 0.75,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0XFFD84C5A),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
        );
      },
    );
  }
}

class _ListData extends StatelessWidget {
  const _ListData({Key? key, required this.controller}) : super(key: key);
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: LazyLoadScrollView(
          onEndOfPage: () => controller.getPokemon(controller.nextURL),
          child: RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: controller.pokemonList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
              itemBuilder: (context, index) {
                final data = controller.pokemonList[index];
                return GestureDetector(
                  onTap: () {
                    controller.getDetail('${data.url}');
                    Get.to(() => DetailView(data: data));
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data.name?.capitalize}',
                            style: GoogleFonts.rubik(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: SizedBox(
                              height: 15.h,
                              width: 15.h,
                              child: CachedNetworkImage(
                                imageUrl: '${data.image}',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                placeholder: (context, url) => Center(
                                  child: Transform.scale(
                                    scale: 2,
                                    child: const Loading(),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
