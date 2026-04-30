import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/app_cubit.dart';
import '../widgets/client_insights_panel.dart';
import '../widgets/client_search_bar.dart';
import '../widgets/clients_grid.dart';

class ClientDirectoryScreen extends StatefulWidget {
  final String locale;

  const ClientDirectoryScreen({super.key, required this.locale});

  @override
  State<ClientDirectoryScreen> createState() => _ClientDirectoryScreenState();
}

class _ClientDirectoryScreenState extends State<ClientDirectoryScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final allUsers = state is AppLoaded ? state.users : [];
        final users = _searchQuery.isEmpty
            ? allUsers
            : allUsers.where((u) {
                final query = _searchQuery.toLowerCase();
                return (u.name?.toLowerCase().contains(query) ?? false) ||
                    (u.email?.toLowerCase().contains(query) ?? false);
              }).toList();
        final loading = state is AppLoading;

        return SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClientSearchBar(
                        locale: widget.locale,
                        onSearchChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                      const SizedBox(height: 40),
                      ClientDirectoryHeader(locale: widget.locale),
                      const SizedBox(height: 24),
                      ClientFilterBar(locale: widget.locale),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 500,
                        child: ClientsGrid(users: users, loading: loading),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: ClientInsightsPanel(allUsers: users),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
