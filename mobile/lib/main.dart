import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/services/firebase_service.dart';
import 'core/utils/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Environment.init();
  await FirebaseService.instance.initialize();
  
  runApp(
    const ProviderScope(child: DuoDayApp()),
  );
}

class DuoDayApp extends ConsumerWidget {
  const DuoDayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'DuoDay',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          routerConfig: router,
        );
      },
    );
  }
}
