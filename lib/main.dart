import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokebag/app/modules/home/controllers/home_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'app/modules/home/bindings/home_binding.dart';
import 'app/modules/home/views/home_view.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(
      Obx(
        () {
          var isDark = Get.put(HomeController()).isDark.value;
          return GetMaterialApp(
            title: "Pokebag - Pokemon Bag",
            getPages: AppPages.routes,
            debugShowCheckedModeBanner: false,
            initialBinding: HomeBinding(),
            theme: isDark ? ThemeData.dark() : ThemeData(),
            home: ResponsiveSizer(
              builder: (context, orientation, deviceType) {
                return const HomeView();
              },
            ),
          );
        },
      ),
    ),
  );
}
