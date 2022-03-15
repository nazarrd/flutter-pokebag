import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../common/custom_appbar.dart';
import '../../../common/loading.dart';
import '../../../common/shimmer.dart';
import '../controllers/home_controller.dart';
import '../models/pokemon_model.dart';

class DetailView extends GetView {
  const DetailView({Key? key, required this.data}) : super(key: key);
  final Results data;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (_) {
        final number = _.random(0, 2);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(appBar: AppBar(), title: '${data.name}'),
          floatingActionButton: _.isLoading.value
              ? null
              : FloatingActionButton(
                  onPressed: number == 0
                      ? () {
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          _.snackBar('Sorry, lady luck not in your side!');
                        }
                      : () {
                          _.addPokeBag(
                            url: '${data.url}',
                            image: '${data.image}',
                            realName: '${data.name}',
                          );
                        },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  highlightElevation: 0,
                  child: Transform.scale(
                    scale: 5,
                    child: const Loading(),
                  ),
                ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeWidget(controller: _),
              const Spacer(),
              _ImageWidget(data: data),
              const Spacer(),
              _MovesWidget(controller: _),
            ],
          ),
        );
      },
    );
  }
}

class _MovesWidget extends StatelessWidget {
  const _MovesWidget({Key? key, required this.controller}) : super(key: key);
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: controller.isDark.value ? Colors.white12 : Colors.black12,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 5),
            child: Text(
              'Moves',
              style: GoogleFonts.rubik(
                color: controller.isDark.value ? Colors.white : Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: controller.isLoading.value
                    ? Wrap(
                        children: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].map(
                          (value) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, bottom: 10),
                              child: SizedBox(
                                width: controller.random(20, 30).w,
                                height: 5.h,
                                child:
                                    Shimmers(isDark: controller.isDark.value),
                              ),
                            );
                          },
                        ).toList(),
                      )
                    : Wrap(
                        children: controller.pokemonDetail.moves!.map(
                          (text) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  '${text.move?.name?.capitalize}',
                                  style: GoogleFonts.rubik(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget({Key? key, required this.data}) : super(key: key);
  final Results data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 25.h,
        width: 25.h,
        child: CachedNetworkImage(
          imageUrl: '${data.image}',
          imageBuilder: (context, imageProvider) => Container(
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
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}

class _TypeWidget extends StatelessWidget {
  const _TypeWidget({Key? key, required this.controller}) : super(key: key);
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.h,
      margin: const EdgeInsets.all(16),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: controller.isLoading.value
            ? ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 20.w,
                      height: 2.h,
                      child: Shimmers(isDark: controller.isDark.value),
                    ),
                  );
                },
              )
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: controller.pokemonDetail.types?.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      child: Text(
                        '${controller.pokemonDetail.types?[index].type?.name?.capitalize}',
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
