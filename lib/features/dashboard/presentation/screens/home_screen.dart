import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_forge/features/dashboard/presentation/counter/counter_cubit.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming CounterCubit is provided higher up the tree
    return const _HomeScreenContent();
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.water_damage_sharp),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            tooltip: 'Notifications',
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.person_outline,
              ), // Or Icons.account_circle_outlined
              tooltip: 'Profile',
              onPressed: () {
                context.goNamed('profile'); // Navigate to profile screen
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        // Ensures content isn't obscured by notches or system UI
        child: ListView(
          // Use ListView for scrollability if content grows
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          children: <Widget>[
            _buildGreeting(context, textTheme), // Placeholder name
            const SizedBox(height: 24),
            _buildCounterCard(context, textTheme, colorScheme),
            const SizedBox(height: 24),
            _buildSectionTitle(context, textTheme, 'Quick Actions'),
            const SizedBox(height: 12),
            _buildActionItem(
              context,
              icon: Icons.article_outlined,
              title: 'View Report #123',
              subtitle: 'Access details and user information',
              onTap: () => context.go('/details/123'),
            ),
            _buildActionItem(
              context,
              icon: Icons.description_outlined,
              title: 'Manage Document #456',
              subtitle: 'Review and update user data',
              onTap: () => context.go('/details/456'),
            ),
            // Add more ActionItems or other sections like charts, recent activity, etc.
            // Example:
            const SizedBox(height: 24),
            _buildSectionTitle(context, textTheme, 'Analytics Overview'),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              child: Container(
                height: 150,
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Chart or Graph Placeholder',
                    style: textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: FloatingActionButton.extended(
                heroTag: 'decrement_fab_home_professional',
                onPressed: () => context.read<CounterCubit>().decrement(),
                icon: const Icon(Icons.remove_circle_outline),
                label: const Text('Decrease'),
                backgroundColor:
                    colorScheme.surfaceContainerHighest, // M3 style
                foregroundColor: colorScheme.primary,
                elevation: 1.0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FloatingActionButton.extended(
                heroTag: 'increment_fab_home_professional',
                onPressed: () => context.read<CounterCubit>().increment(),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Increase'),
                backgroundColor: colorScheme.primary, // M3 style
                foregroundColor: colorScheme.onPrimary,
                elevation: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, TextTheme textTheme) {
    final userName = context.watch<ProfileBloc>().state.name;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, $userName!',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome back to your dashboard.',
          style: textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCounterCard(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Card(
      elevation: 0.5, // Subtle elevation
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Counter Value',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                BlocBuilder<CounterCubit, int>(
                  builder: (context, count) {
                    return Text(
                      '$count',
                      style: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
            Icon(
              Icons.show_chart_rounded, // Or any relevant icon
              size: 36,
              color: colorScheme.primary.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    TextTheme textTheme,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0), // Adjust as needed
      child: Text(
        title,
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0, // Flat design for list items
      margin: const EdgeInsets.symmetric(vertical: 6.0),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0), // Match card's border radius
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Icon(icon, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
