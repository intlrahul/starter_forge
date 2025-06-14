import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_forge/core/widgets/loading_indicator.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_bloc.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_event.dart';
import 'package:starter_forge/features/user_details/presentation/bloc/user_details_state.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key, required this.detailsNumber});

  final String detailsNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details for #$detailsNumber')),
      body: BlocListener<UserDetailsBloc, UserDetailsState>(
        listenWhen: (previous, current) {
          // Only listen if isSuccess changes to true, or if an error message appears,
          // or if submission status changes (to avoid unnecessary listener calls)
          return (previous.isSuccess != current.isSuccess &&
                  current.isSuccess == true) ||
              (previous.errorMessage != current.errorMessage &&
                  current.errorMessage != null) ||
              previous.isSubmitting != current.isSubmitting;
        },
        listener: (context, state) {
          if (state.errorMessage != null && !state.isSubmitting) {
            // Show error only if not submitting anymore
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
          // Check if the submission was successful AND the success state is newly true
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User details saved successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(
                  seconds: 1,
                ), // Shorter duration before popping
              ),
            );
            // Dismiss the page after a short delay to allow SnackBar to be seen
            Future.delayed(const Duration(milliseconds: 1200), () {
              if (context.mounted && context.canPop()) {
                // Check if the page can be popped
                context.pop(); // Pop the current route (UserDetailsScreen)
              }
            });
          }
        },
        child: const UserDetailsForm(),
      ),
    );
  }
}

// ... UserDetailsForm remains the same as before
class UserDetailsForm extends StatefulWidget {
  const UserDetailsForm({super.key});

  @override
  State<UserDetailsForm> createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<UserDetailsBloc>();
    _nameController.text = bloc.state.name;
    _emailController.text = bloc.state.email;

    _nameController.addListener(() {
      bloc.add(UserNameChanged(_nameController.text));
    });

    _emailController.addListener(() {
      bloc.add(UserEmailChanged(_emailController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          BlocBuilder<UserDetailsBloc, UserDetailsState>(
            builder: (context, state) {
              return TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                ),
                keyboardType: TextInputType.name,
                enabled: !state.isSubmitting,
              );
            },
          ),
          const SizedBox(height: 16),
          BlocBuilder<UserDetailsBloc, UserDetailsState>(
            builder: (context, state) {
              return TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: !state.isSubmitting,
              );
            },
          ),
          const SizedBox(height: 32),
          BlocBuilder<UserDetailsBloc, UserDetailsState>(
            buildWhen: (previous, current) =>
                previous.isSubmitting != current.isSubmitting,
            builder: (context, state) {
              if (state.isSubmitting) {
                return const Center(child: AppLoader());
              }
              return ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  context.read<UserDetailsBloc>().add(
                    const UserDetailsSubmitted(),
                  );
                },
                child: const Text('Submit Details'),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
