import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../cubit/app_cubit.dart';

class BarberToggleSwitch extends StatefulWidget {
  final int barberId;
  final bool currentValue;

  const BarberToggleSwitch({
    super.key,
    required this.barberId,
    required this.currentValue,
  });

  @override
  State<BarberToggleSwitch> createState() => _BarberToggleSwitchState();
}

class _BarberToggleSwitchState extends State<BarberToggleSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.currentValue;
  }

  @override
  void didUpdateWidget(covariant BarberToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentValue != widget.currentValue) {
      _value = widget.currentValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listener: (context, state) {
        if (state is AppLoaded) {
          final barber = state.barbers
              .where((b) => b.id == widget.barberId)
              .firstOrNull;
          if (barber != null && barber.isActive != _value) {
            setState(() => _value = barber.isActive);
          }
        }
      },
      child: Switch(
        value: _value,
        onChanged: (v) {
          setState(() => _value = v);
          context.read<AppCubit>().toggleBarberAvailability(widget.barberId, v);
        },
        activeTrackColor: AppColors.accentGreen,
      ),
    );
  }
}
