# Kilo CLI Commands and Project Notes

## Project Structure
- Main app: `lib/main.dart`
- Screens: `lib/presentation/views/`
- Widgets: `lib/presentation/widgets/`
- Cubit/Bloc: `lib/presentation/cubit/`
- Models: `lib/data/models/`
- Repositories: `lib/data/repositories/`
- Constants: `lib/core/constants/`

## Key Screens
- `schedule_screen.dart` - Barber schedule/booking screen with statistics
- `dashboard_view.dart` - Main dashboard with insights and today's bookings
- `barber_management_screen.dart` - Staff management
- `client_management_screen.dart` - Client directory

## Important Patterns
- Uses BLoC/Cubit for state management
- Route through `AppCubit` for navigation state
- `AppLoaded` state contains all business data (barbers, services, reservations, branches, offers)
- Statistics in ScheduleScreen calculate revenue and bookings from `state.todayReservations`

## Commands
- Clear cache: `Remove-Item .kilo -Recurse -Force`
- List files: `Get-ChildItem "path"`
- Read file: `Get-Content "path"`
- Write file: `Set-Content "path" -Value "content"`
- Search: `Select-String -Path "*.dart" -Pattern "search_term"`

## Testing
- Run `flutter test` for tests
- Check `analysis_options.yaml` for lint rules
- Use `flutter analyze` for static analysis

## Common Issues Fixed
- ScheduleScreen: Added booking button, statistics card, toggle functionality
- Fixed `_buildHeader` - removed duplicate and added moon icon
- Fixed `_buildStatisticsCard` - calculates revenue and bookings from reservations
- Fixed `_showBookingDialog` - properly creates new reservations