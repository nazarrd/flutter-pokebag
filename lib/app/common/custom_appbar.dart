import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../modules/home/controllers/home_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {Key? key, required this.appBar, required this.title, this.page})
      : super(key: key);
  final AppBar appBar;
  final String title;
  final String? page;

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (_) => AppBar(
        backgroundColor: _.isDark.value ? null : const Color(0XFFD84C5A),
        centerTitle: false,
        title: Text(
          '${title.capitalize}',
          style: GoogleFonts.rubik(fontWeight: FontWeight.w600),
        ),
        actions: page == 'home'
            ? [
                IconButton(
                  splashRadius: 20,
                  icon: const Icon(Icons.catching_pokemon),
                  onPressed: () => _.viewPokeBag(),
                ),
                SizedBox(
                  height: 3.h,
                  width: 12.w,
                  child: Switch(
                    activeColor: Colors.grey[600],
                    value: _.isDark.value,
                    onChanged: (value) {
                      _.box.write('isDark', value);
                      _.isDark.toggle();
                      _.update();
                    },
                    activeThumbImage:
                        const AssetImage('assets/icons/dark-icon.png'),
                    inactiveThumbImage:
                        const AssetImage('assets/icons/light-icon.png'),
                  ),
                ),
                SizedBox(width: 3.w)
              ]
            : page == "pokeBag"
                ? [
                    TextButton(
                      child: Text(
                        'Delete All',
                        style: GoogleFonts.rubik(color: Colors.white),
                      ),
                      onPressed: () {
                        _.box.remove('pokeBag');
                        _.storageList.clear();
                        _.pokeBag.clear();
                        _.update();
                      },
                    ),
                    SizedBox(width: 3.w)
                  ]
                : [],
      ),
    );
  }
}
