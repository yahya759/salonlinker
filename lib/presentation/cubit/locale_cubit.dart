import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class LocaleState extends Equatable {
  const LocaleState();
  @override
  List<Object?> get props => [];
}

class LocaleInitial extends LocaleState {
  const LocaleInitial();
}

class LocaleChanged extends LocaleState {
  final String locale;
  const LocaleChanged(this.locale);
  @override
  List<Object?> get props => [locale];
}

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleInitial());

  void changeLocale(String locale) {
    emit(LocaleChanged(locale));
  }

  void toggleLocale() {
    final currentLocale = state is LocaleChanged
        ? (state as LocaleChanged).locale
        : 'ar';
    final newLocale = currentLocale == 'ar' ? 'en' : 'ar';
    emit(LocaleChanged(newLocale));
  }

  String get currentLocale =>
      state is LocaleChanged ? (state as LocaleChanged).locale : 'ar';
}
