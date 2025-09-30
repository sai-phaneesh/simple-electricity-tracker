import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'houses_shared_widgets.dart';
import 'package:electricity/features/houses/presentation/bloc/houses_bloc.dart';

class HousesDesktopLayout extends StatelessWidget {
  const HousesDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HousesBloc, HousesState>(
      builder: (context, state) {
        if (state is HousesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HousesError) {
          return ErrorWidgetHouses(
            message: state.message,
            onRetry: () => context.read<HousesBloc>().add(LoadHouses()),
          );
        }

        if (state is HousesLoaded) {
          return Column(
            children: [
              const SearchAndFilters(),
              Expanded(
                child: HousesGrid(houses: state.houses, crossAxisCount: 3),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
