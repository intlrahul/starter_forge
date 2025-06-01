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
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
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
          // ... (rest of the ProfileBloc builder logic remains the same, ensure to use ProfileBlocState.ProfileState where needed)

          // Profile Success State
          return ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              // ... (_buildProfileHeader, _buildSectionTitle, _buildInfoCard, _buildInfoRow methods remain the same)
              _buildProfileHeader(
                context,
                state,
                colorScheme,
                textTheme,
              ), // state is ProfileBlocState.ProfileState
              const SizedBox(height: 24),
              _buildSectionTitle(textTheme, 'Personal Information'),
              const SizedBox(height: 8),
              _buildInfoCard(
                colorScheme,
                isDarkMode,
                children: [
                  _buildInfoRow(
                    context,
                    Icons.person_outline,
                    'Name',
                    state.name,
                    textTheme,
                  ),
                  _buildInfoRow(
                    context,
                    Icons.email_outlined,
                    'Email',
                    state.email,
                    textTheme,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(textTheme, 'About Me'),
              const SizedBox(height: 8),
              _buildInfoCard(
                colorScheme,
                isDarkMode,
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
              _buildSectionTitle(textTheme, 'Appearance'),
              const SizedBox(height: 8),
              _buildThemeToggleCard(
                context,
                colorScheme,
                textTheme,
              ), // Removed isDarkMode from here, as it's fetched from ThemeBloc state
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  // ... _buildProfileHeader, _buildSectionTitle, _buildInfoCard, _buildInfoRow methods remain the same

  Widget _buildThemeToggleCard(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    // Removed isDarkMode parameter
    // Use BlocBuilder or context.watch to get the current ThemeBloc state for selected segment
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
  // Helper methods for _ProfileView (_buildProfileHeader, etc.)
  // These should be part of the _ProfileView class or passed `context` if they need it.
  // For brevity, I'll keep them as they were, assuming they are part of _ProfileView or refactored.
  // Make sure they use `ProfileBlocState.ProfileState` if they access the profile state.

  Widget _buildProfileHeader(
    BuildContext context,
    ProfileState state,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
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

  Widget _buildSectionTitle(TextTheme textTheme, String title) {
    return Text(
      title,
      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildInfoCard(
    ColorScheme colorScheme,
    bool isDarkMode, {
    required List<Widget> children,
  }) {
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

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    TextTheme textTheme, {
    bool isSensitive = false,
  }) {
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
