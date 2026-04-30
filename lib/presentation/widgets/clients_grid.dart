import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../cubit/locale_cubit.dart';
import 'client_card.dart';

class ClientsGrid extends StatelessWidget {
  final List<dynamic> users;
  final bool loading;

  const ClientsGrid({
    super.key,
    required this.users,
    required this.loading,
  });

  String _getLocale(BuildContext context) {
    final state = context.watch<LocaleCubit>().state;
    if (state is LocaleChanged) {
      return state.locale;
    }
    return 'ar';
  }

  @override
  Widget build(BuildContext context) {
    final locale = _getLocale(context);

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_off_outlined,
              size: 80,
              color: AppColors.border,
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.get('noUsersFound', locale),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) => ClientCard(
        user: users[index],
        locale: locale,
      ),
    );
  }
}
