import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/utils/Navigation/navigation.dart';
import 'package:enjaz/features/floorplan/screen/directory_search_screen.dart';
import 'package:enjaz/features/floorplan/screen/floor_plan_screen.dart';
import 'package:enjaz/features/place/cubit/place_cubit.dart';
import 'package:enjaz/features/place/data/model/place_model.dart';
import 'package:enjaz/features/place/widget/place_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Entry point for the floor-plan feature (slice 1). Lets the user pick a
/// floor/place, then opens its interactive seating chart. Self-provides the
/// [PlaceCubit] so it can be dropped directly into the root tab stack.
class FloorPlanEntryScreen extends StatelessWidget {
  const FloorPlanEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaceCubit(),
      child: const _FloorPlanEntryBody(),
    );
  }
}

class _FloorPlanEntryBody extends StatefulWidget {
  const _FloorPlanEntryBody();

  @override
  State<_FloorPlanEntryBody> createState() => _FloorPlanEntryBodyState();
}

class _FloorPlanEntryBodyState extends State<_FloorPlanEntryBody> {
  PlaceModel? _selected;

  void _open() {
    final id = _selected?.id;
    if (id == null || id.isEmpty) return;
    Navigation.push(FloorPlanScreen(floorId: id));
  }

  @override
  Widget build(BuildContext context) {
    final canOpen = _selected?.id != null && _selected!.id!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Floor Map'),
        backgroundColor: AppColors.xprimaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'directory_title'.tr(),
            icon: const Icon(Icons.search),
            onPressed: () => Navigation.push(const DirectorySearchScreen()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Select a floor / place to open its seating chart.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            PlaceDropdown(
              onChanged: (p) => setState(() => _selected = p),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: canOpen ? _open : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.xprimaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.map_outlined),
              label: const Text('Open Floor Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
