import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starter_forge/core/theme/theme_bloc/theme_bloc.dart';
import 'package:starter_forge/core/theme/theme_bloc/theme_event.dart';
import 'package:starter_forge/core/theme/theme_bloc/theme_state.dart';
import 'package:starter_forge/core/widgets/loading_indicator.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:starter_forge/features/profile/presentation/bloc/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileView();
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    // Get isDarkMode from ThemeBloc's state
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        // Use aliased state
        listener: (context, state) {
          if (state.status == ProfileStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: colorScheme.error,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading ||
              state.status == ProfileStatus.initial) {
            return const Center(child: AppLoader());
          }
          return ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              _ThemeToggleCard(colorScheme: colorScheme, textTheme: textTheme),
              _ProfileHeader(
                state: state,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              // state is ProfileBlocState.ProfileState
              const SizedBox(height: 24),
              _SectionTitle(
                textTheme: textTheme,
                title: 'Personal Information',
              ),
              const SizedBox(height: 8),
              _InfoCard(
                isDarkMode: isDarkMode,
                colorScheme: colorScheme,
                children: [
                  _InfoRow(
                    icon: Icons.person_outline,
                    label: 'Name',
                    value: state.name,
                    textTheme: textTheme,
                  ),

                  _InfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: state.email,
                    textTheme: textTheme,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionTitle(textTheme: textTheme, title: 'About Me'),
              const SizedBox(height: 8),
              _InfoCard(
                isDarkMode: isDarkMode,
                colorScheme: colorScheme,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                    child: Text(
                      state.bio.isEmpty ? 'No bio available.' : state.bio,
                      style: textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionTitle(textTheme: textTheme, title: 'Appearance'),
              const SizedBox(height: 8),

              // Removed isDarkMode from here, as it's fetched from ThemeBloc state
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

class _ThemeToggleCard extends StatelessWidget {
  const _ThemeToggleCard({required this.colorScheme, required this.textTheme});
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      // Use aliased state
      builder: (context, themeState) {
        // themeState is ThemeBlocState.ThemeState
        final isCardDarkMode = themeState
            .isDarkMode; // Or calculate based on themeState.themeMode if needed for card's own border
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: colorScheme.outlineVariant.withValues(
                alpha: isCardDarkMode ? 0.3 : 0.5,
              ),
            ),
          ),
          color: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Theme',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SegmentedButton<ThemeMode>(
                  segments: const <ButtonSegment<ThemeMode>>[
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode_outlined),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      label: Text('System'),
                      icon: Icon(Icons.brightness_auto_outlined),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode_outlined),
                    ),
                  ],
                  selected: <ThemeMode>{
                    themeState.themeMode,
                  }, // Use themeMode from ThemeBloc's state
                  onSelectionChanged: (Set<ThemeMode> newSelection) {
                    context.read<ThemeBloc>().add(
                      UpdateTheme(newSelection.first),
                    ); // Use aliased event
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.state,
    required this.colorScheme,
    required this.textTheme,
  });

  final ProfileState state;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: colorScheme.primaryContainer,
          backgroundImage:
              state.profileImageUrl.isNotEmpty &&
                  state.profileImageUrl.startsWith('http')
              ? NetworkImage(state.profileImageUrl)
              : (state.profileImageUrl.isNotEmpty
                        ? AssetImage(state.profileImageUrl)
                        : null)
                    as ImageProvider?,
          child: state.profileImageUrl.isEmpty
              ? Icon(
                  Icons.person,
                  size: 60,
                  color: colorScheme.onPrimaryContainer,
                )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          state.name,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          state.email,
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.textTheme});

  final String title;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.isDarkMode,
    required this.colorScheme,
    required this.children,
  });

  final bool isDarkMode;
  final ColorScheme colorScheme;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(
            alpha: isDarkMode ? 0.3 : 0.5,
          ),
        ),
      ),
      color: colorScheme.surface,
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.textTheme,
  });

  final IconData icon;
  final String label;
  final String value;
  final TextTheme textTheme;
  final bool isSensitive = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2, // Give more space to value
            child: Text(
              value.isEmpty ? 'N/A' : value,
              style: textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: isSensitive ? 1 : 2,
            ),
          ),
        ],
      ),
    );
  }
}
