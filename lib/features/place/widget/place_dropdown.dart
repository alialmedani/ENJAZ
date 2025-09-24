import 'package:enjaz/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:enjaz/features/place/cubit/place_cubit.dart';
import 'package:enjaz/features/place/data/model/place_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaceDropdown extends StatefulWidget {
  final String? initialPlaceId;

  final ValueChanged<PlaceModel?>? onChanged;

  final InputDecoration? decoration;

  const PlaceDropdown({
    super.key,
    this.initialPlaceId,
    this.onChanged,
    this.decoration,
  });

  @override
  State<PlaceDropdown> createState() => _PlaceDropdownState();
}

class _PlaceDropdownState extends State<PlaceDropdown> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    context.read<PlaceCubit>().getPlaceParam.type = 1;
    _selectedId = widget.initialPlaceId;
  }

  PlaceModel? _findById(List<PlaceModel> items, String? id) {
    if (id == null) return null;
    for (final p in items) {
      if ((p.id?.toString() ?? '') == id) return p;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: PaginationList(
        repositoryCallBack: (data) {
          return context.read<PlaceCubit>().fetchPLaceServies(data);
        },

        listBuilder: (list) {
          final places = list.cast<PlaceModel>();

          return DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: _selectedId == null
                ? null
                : places.any((p) => (p.id?.toString() ?? '') == _selectedId)
                ? _selectedId
                : null,
            items: places
                .map(
                  (p) => DropdownMenuItem<String>(
                    value: (p.id?.toString() ?? ''),
                    child: Text(p.name ?? '—', overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (id) {
              setState(() => _selectedId = id);
              widget.onChanged?.call(_findById(places, id));
            },
            decoration:
                widget.decoration ??
                const InputDecoration(
                  hintText: 'Select place',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
            icon: const Icon(Icons.keyboard_arrow_down),
          );
        },
      ),
    );
  }
}
