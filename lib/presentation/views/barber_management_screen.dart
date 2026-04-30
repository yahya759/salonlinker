import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/barber_model.dart';
import '../cubit/app_cubit.dart';
import '../widgets/add_barber_dialog.dart';
import '../widgets/barber_card.dart';

class BarberManagementScreen extends StatelessWidget {
  final String locale;

  const BarberManagementScreen({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 40),
          _buildSectionTitle(context),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                if (state is AppLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AppError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is AppLoaded) {
                  return _buildBarbersGrid(context, state.barbers);
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.get('barberManagement', locale),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.get('staffDirectory', locale),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.get('ourBarbers', locale),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => showAddBarberDialog(context, locale),
          icon: const Icon(Icons.person_add_alt_1, size: 16),
          label: Text(AppStrings.get('addNewBarber', locale)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.border,
            foregroundColor: AppColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarbersGrid(BuildContext context, List<Barber> barbers) {
    if (barbers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.content_cut,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.get('noBarbers', locale),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => showAddBarberDialog(context, locale),
              icon: const Icon(Icons.add),
              label: Text(AppStrings.get('addNewBarber', locale)),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisExtent: 380,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: barbers.length,
      itemBuilder: (context, index) => BarberCard(
        barber: barbers[index],
        locale: locale,
        key: ValueKey(barbers[index].id),
      ),
    );
  }
}
