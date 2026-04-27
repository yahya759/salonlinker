import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/supabase/supabase_config.dart';
import 'presentation/cubit/app_cubit.dart';
import 'presentation/cubit/locale_cubit.dart';
import 'presentation/cubit/offer_cubit.dart';
import 'presentation/views/dashboard_view.dart';
import 'presentation/widgets/sidebar.dart';
import 'presentation/widgets/top_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();
  runApp(const BarbershopApp());
}

class BarbershopApp extends StatelessWidget {
  const BarbershopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()..loadAll()),
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => OfferCubit()..loadOffers()),
      ],
      child: MaterialApp(
        title: 'اليد والمقص',
        debugShowCheckedModeBanner: false, // Hidden banner
        theme: AppTheme.darkTheme,
        home: const DashboardScreen(),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state is LocaleChanged
        ? (context.watch<LocaleCubit>().state as LocaleChanged).locale
        : 'ar';

    final isRtl = locale == 'ar';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Row(
          children: [
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                final selectedIndex = state is AppLoaded
                    ? state.selectedNavIndex
                    : 0;

                return Sidebar(
                  selectedIndex: selectedIndex,
                  onNavTap: (i) => context.read<AppCubit>().selectNavItem(i),
                );
              },
            ),
            Expanded(
              child: Column(
                children: [
                  TopBar(onRefresh: () => context.read<AppCubit>().loadAll()),
                  const Expanded(child: DashboardView()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
