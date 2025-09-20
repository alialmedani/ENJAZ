import 'package:enjaz/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:enjaz/features/FO/cubit/place_cubit.dart';
import 'package:enjaz/features/FO/data/model/place_model.dart';
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
      // عدّل الحقول حسب موديلك لو مش id/name
      if ((p.id?.toString() ?? '') == id) return p;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: PaginationList(
        // نفس اللي عندك: بينادي الكيوبت ويرجع Future<Result<List<PlaceModel>>>
        repositoryCallBack: (data) {
          return context.read<PlaceCubit>().fetchPLaceServies(data);
        },
      
        // بنينا الدروب داون مباشرة من الليست
        listBuilder: (list) {
          final places = list.cast<PlaceModel>();
      
          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: _selectedId == null
                ? null
                : places.any((p) => (p.id?.toString() ?? '') == _selectedId)
                ? _selectedId
                : null, // لو id مش موجودة ضمن الصفحة الحالية
            items: places
                .map(
                  (p) => DropdownMenuItem<String>(
                    value:
                        (p.id?.toString() ?? ''), // عدّل إذا id نوعه غير String
                    child: Text(
                      p.name ?? '—', // عدّل إذا اسم الحقل غير name
                      overflow: TextOverflow.ellipsis,
                    ),
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
