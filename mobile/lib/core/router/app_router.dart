import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import '../services/onboarding_service.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/verification_code_screen.dart';
import '../../features/auth/screens/new_password_screen.dart';
import '../../features/couple/screens/connect_partner_choice_screen.dart';
import '../../features/couple/screens/invite_code_screen.dart';
import '../../features/couple/screens/enter_partner_code_screen.dart';
import '../../features/couple/screens/connection_success_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/tasks/screens/tasks_screen.dart';
import '../../features/finances/screens/finances_screen.dart';
import '../../features/finances/screens/finance_bill_form_screen.dart';
import '../../features/finances/screens/finance_bill_details_screen.dart';
import '../../features/checkin/screens/checkin_screen.dart';
import '../../features/checkin/screens/checkin_history_screen.dart';
import '../../features/us/screens/us_hub_screen.dart';
import '../../features/notes/screens/notes_screen.dart';
import '../../features/missions/screens/missions_screen.dart';
import '../../features/weekly_summary/screens/weekly_summary_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/agenda/screens/agenda_screen.dart';
import '../../features/agenda/screens/agenda_event_form_screen.dart';
import '../../features/agenda/screens/agenda_event_details_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/settings/screens/notification_settings_screen.dart';
import '../../features/security/screens/security_screen.dart';
import '../../features/premium/screens/premium_screen.dart';
import '../../features/tasks/screens/task_form_screen.dart';
import '../../features/tasks/screens/task_details_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);
  final onboardingService = ref.watch(onboardingServiceProvider);
  
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final isAuthenticated = authService.isAuthenticated;
      final isConnecting = authService.isConnectingPartner;
      final path = state.uri.path;

      final onboardingCompleted = await onboardingService.isCompleted();
      
      if (path == '/splash') {
        return null;
      }

      if (!onboardingCompleted && path != '/onboarding') {
        return '/onboarding';
      }

      if (!onboardingCompleted && path == '/onboarding') {
        return null;
      }
      
      if (!isAuthenticated) {
        if (path == '/login' ||
            path == '/register' ||
            path == '/forgot-password' ||
            path == '/verification-code' ||
            path == '/new-password') {
          return null;
        }
        return '/login';
      }
      
      if (isConnecting && !path.startsWith('/connect-partner')) {
        return '/connect-partner';
      }
      
      if (isConnecting && path.startsWith('/connect-partner')) {
        return null;
      }
      
      if (path == '/login' || path == '/register') {
        return '/home';
      }
      
      return null;
    },
    routes: [
      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // Splash
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Auth
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/verification-code',
        builder: (context, state) {
          final extra = state.extra;
          final email = extra is Map ? (extra['email'] as String?) : null;
          return VerificationCodeScreen(email: email ?? '');
        },
      ),
      GoRoute(
        path: '/new-password',
        builder: (context, state) {
          final extra = state.extra;
          final email = extra is Map ? (extra['email'] as String?) : null;
          return NewPasswordScreen(email: email ?? '');
        },
      ),
      
      // Connect Partner
      GoRoute(
        path: '/connect-partner',
        builder: (context, state) => const ConnectPartnerChoiceScreen(),
      ),
      GoRoute(
        path: '/connect-partner/invite',
        builder: (context, state) => const InviteCodeScreen(),
      ),
      GoRoute(
        path: '/connect-partner/enter',
        builder: (context, state) => const EnterPartnerCodeScreen(),
      ),
      GoRoute(
        path: '/connection-success',
        builder: (context, state) => const ConnectionSuccessScreen(),
      ),
      
      // Main App (Bottom Navigation)
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const TasksScreen(),
          ),
          GoRoute(
            path: '/tasks/new',
            builder: (context, state) => const TaskFormScreen(),
          ),
          GoRoute(
            path: '/tasks/:id',
            builder: (context, state) => TaskDetailsScreen(taskId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/agenda',
            builder: (context, state) => const AgendaScreen(),
          ),
          GoRoute(
            path: '/agenda/new',
            builder: (context, state) => const AgendaEventFormScreen(),
          ),
          GoRoute(
            path: '/agenda/:id',
            builder: (context, state) => AgendaEventDetailsScreen(eventId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/finances',
            builder: (context, state) => const FinancesScreen(),
          ),
          GoRoute(
            path: '/finances/new',
            builder: (context, state) => const FinanceBillFormScreen(),
          ),
          GoRoute(
            path: '/finances/:id',
            builder: (context, state) => FinanceBillDetailsScreen(billId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/checkin',
            builder: (context, state) => const CheckinScreen(),
          ),
          GoRoute(
            path: '/checkin/history',
            builder: (context, state) => const CheckinHistoryScreen(),
          ),
          GoRoute(
            path: '/us',
            builder: (context, state) => const UsHubScreen(),
          ),
          GoRoute(
            path: '/notes',
            builder: (context, state) => const NotesScreen(),
          ),
          GoRoute(
            path: '/missions',
            builder: (context, state) => const MissionsScreen(),
          ),
          GoRoute(
            path: '/weekly-summary',
            builder: (context, state) => const WeeklySummaryScreen(),
          ),
        ],
      ),
      
      // Profile & Settings
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/notifications',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/security',
        builder: (context, state) => const SecurityScreen(),
      ),
      GoRoute(
        path: '/premium',
        builder: (context, state) => const PremiumScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Página não encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Voltar para o início'),
            ),
          ],
        ),
      ),
    ),
  );
});

class MainNavigation extends StatefulWidget {
  final Widget child;
  
  const MainNavigation({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Hoje',
      route: '/home',
    ),
    NavigationItem(
      icon: Icons.task_outlined,
      selectedIcon: Icons.task,
      label: 'Tarefas',
      route: '/tasks',
    ),
    NavigationItem(
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
      label: 'Agenda',
      route: '/agenda',
    ),
    NavigationItem(
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet,
      label: 'Finanças',
      route: '/finances',
    ),
    NavigationItem(
      icon: Icons.favorite_outline,
      selectedIcon: Icons.favorite,
      label: 'Nós ❤️',
      route: '/us',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final currentIndex = switch (path) {
      _ when path.startsWith('/tasks') => 1,
      _ when path.startsWith('/agenda') => 2,
      _ when path.startsWith('/finances') => 3,
      _ when path.startsWith('/us') => 4,
      _ => 0,
    };

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        destinations: _navigationItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon),
                label: item.label,
              ),
            )
            .toList(),
        onDestinationSelected: (index) => context.go(_navigationItems[index].route),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
  
  NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}
