import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokebag/app/modules/home/models/pokebag_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/pokemon_model.dart';
import '../models/pokemon_detail_model.dart';
import '../providers/dio_client.dart';
import '../views/pokebag_view.dart';

class HomeController extends GetxController {
  List<Results> pokemonList = [];
  PokemonDetail pokemonDetail = PokemonDetail();
  String? nextURL;
  var isLoading = false.obs, isRefresh = false.obs, isDark = false.obs;
  final box = GetStorage();
  List<PokeBag> pokeBag = [];
  List storageList = [];
  late TextEditingController textController;

  @override
  onInit() async {
    isDark.value = box.read('isDark') ?? false;
    pokemonList.clear();
    await getPokemon(nextURL);
    super.onInit();
  }

  @override
  onClose() {
    textController.dispose();
    super.onClose();
  }

  Future onRefresh() async {
    isRefresh(true);
    nextURL = null;
    pokemonList.clear();
    await getPokemon(null);
    isRefresh(false);
  }

  Future getPokemon(String? url) async {
    isLoading(true);
    update();
    await DioClient().getPokemon(url).then((value) {
      nextURL = value.next;
      for (int i = 0; i < num.parse('${value.results?.length}'); i++) {
        final data = value.results![i];
        pokemonList.add(data);
      }
    }).catchError((e) {
      snackBar(e);
    });
    isLoading(false);
    update();
  }

  Future getDetail(String url) async {
    isLoading(true);
    await DioClient().pokemonDetail(url).then((value) {
      pokemonDetail = value;
    }).catchError((e) {
      snackBar(e);
    });
    isLoading(false);
    update();
  }

  void viewPokeBag() async {
    pokeBag.clear();
    storageList = box.read('pokeBag') ?? [];
    if (storageList != []) {
      // restore data from get storage
      await restoreHistorys();
    }
    Get.to(() => const PokebagView());
  }

  void addPokeBag({String? url, String? image, String? realName}) async {
    textController = TextEditingController();
    await Get.defaultDialog(
      title: "Gotcha!",
      titlePadding: const EdgeInsets.only(top: 16, bottom: 10),
      titleStyle: GoogleFonts.rubik(fontWeight: FontWeight.bold, fontSize: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: Column(
        children: [
          Text(
            'Now enter your $realName nickname',
            style: GoogleFonts.rubik(fontSize: 15),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: textController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Nickname cannot be empty';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 7.5, 10, 7.5),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.blue,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    final listData = PokeBag(
                      url: '$box',
                      image: '$image',
                      realName: '$realName',
                      nickName: textController.text,
                    );

                    // add alarmTime to storage
                    addAndStoreHistory(listData);
                    Get.back();
                    successSave();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                        'Submit',
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.red[600],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  successSave() async {
    await Get.defaultDialog(
      title: "Gotcha!",
      titlePadding: const EdgeInsets.only(top: 16, bottom: 10),
      titleStyle: GoogleFonts.rubik(fontWeight: FontWeight.bold, fontSize: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: Column(
        children: [
          Text(
            'Your Pokemon is safe and sound in your pokebag.',
            style: GoogleFonts.rubik(fontSize: 15),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.back();
                    viewPokeBag();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                        'See PokeBag',
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.red[600],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                        'Close',
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void addAndStoreHistory(PokeBag data) {
    pokeBag.add(data);

    // temporary map that gets added to storage
    final storageMap = {};

    // for unique map keys
    final index = pokeBag.length;
    final urlKey = 'url$index';
    final imageKey = 'image$index';
    final realNameKey = 'realName$index';
    final nickNameKey = 'nickName$index';

    // adding pokeBag properties to temporary map
    storageMap[urlKey] = data.url;
    storageMap[imageKey] = data.image;
    storageMap[realNameKey] = data.realName;
    storageMap[nickNameKey] = data.nickName;

    // adding temp map to storageList
    storageList.add(storageMap);

    // adding list of maps to storage
    box.write('pokeBag', storageList);
  }

  Future restoreHistorys() async {
    // initializing list from storage
    String urlKey, imageKey, realNameKey, nickNameKey;
    // looping through the storage list to parse out History objects from maps
    for (int i = 0; i < storageList.length; i++) {
      final map = storageList[i];
      // index for retreival keys accounting for index starting at 0
      final index = i + 1;
      urlKey = 'url$index';
      imageKey = 'image$index';
      realNameKey = 'realName$index';
      nickNameKey = 'nickName$index';

      // recreating History objects from storage
      final listData = PokeBag(
        url: map[urlKey],
        image: map[imageKey],
        realName: map[realNameKey],
        nickName: map[nickNameKey],
      );

      // adding Historys back to your normal History list
      pokeBag.add(listData);
    }
  }

  int random(min, max) {
    return min + Random().nextInt(max - min);
  }

  void snackBar(text) {
    Get.snackbar(
      '',
      '',
      titleText: Container(),
      messageText: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black87,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.rubik(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
      barBlur: 0,
      overlayBlur: 0,
      isDismissible: true,
      colorText: Colors.white,
      backgroundColor: Colors.transparent,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      padding: const EdgeInsets.only(bottom: 30),
      forwardAnimationCurve: Curves.easeInOut,
    );
  }
}
