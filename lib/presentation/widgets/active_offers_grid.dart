import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../cubit/locale_cubit.dart';
import '../cubit/offer_cubit.dart';
import 'offer_card.dart';

class ActiveOffersGrid extends StatelessWidget {
  const ActiveOffersGrid({super.key});

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

    return BlocBuilder<OfferCubit, OfferState>(
      builder: (context, state) {
        if (state is OfferLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is OfferError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is OfferLoaded) {
          final offers = state.offers;

          if (offers.isEmpty) {
            return Center(
              child: Text(
                AppStrings.get('noOffers', locale),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return Column(
            children: [
              for (int i = 0; i < offers.length; i += 2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      SizedBox(
                        width: 350,
                        child: OfferCard(
                          offer: offers[i],
                          locale: locale,
                        ),
                      ),
                      if (i + 1 < offers.length)
                        SizedBox(
                          width: 350,
                          child: OfferCard(
                            offer: offers[i + 1],
                            locale: locale,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
