import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../common/custom_appbar.dart';
import '../../../common/loading.dart';
import '../controllers/home_controller.dart';

class PokebagView extends GetView {
  const PokebagView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (_) {
        return Scaffold(
          appBar: CustomAppBar(
            appBar: AppBar(),
            title: 'Poke Bag',
            page: 'pokeBag',
          ),
          body: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: _.pokeBag.isEmpty
                ? const Loading(assets: 'no_data')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _.pokeBag.length,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final data = _.pokeBag[index];
                      return GestureDetector(
                        onTap: () {
                          _.box.remove('pokeBag');
                          _.storageList.clear();
                          _.pokeBag.clear();
                          _.update();
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.nickName.capitalize!,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.rubik(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 0.25.h),
                                    Text(
                                      data.realName.capitalize!,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.rubik(fontSize: 16),
                                    ),
                                    SizedBox(height: 2.h),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.h,
                                  width: 15.h,
                                  child: CachedNetworkImage(
                                    imageUrl: data.image,
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
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
