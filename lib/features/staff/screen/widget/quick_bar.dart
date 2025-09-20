// lib/features/staff/widgets/quick_bar.dart
import 'package:flutter/material.dart';

class QuickBar extends StatelessWidget {
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onRefresh;
  final List<Widget>? filters;
  final Widget? extra;
  const QuickBar({
    super.key,
    required this.placeholder,
    this.onChanged,
    this.onRefresh,
    this.filters,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEFE4DE)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: onChanged,
                          decoration: InputDecoration(
                            hintText: placeholder,
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
        if (filters != null || extra != null) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...(filters ?? []),
                  if (extra != null) ...[
                    if (filters != null && filters!.isNotEmpty)
                      const SizedBox(width: 10),
                    extra!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class DropChip<T> extends StatelessWidget {
  final String label;
  final List<T> values;
  final T? value;
  final ValueChanged<T?> onChanged;
  const DropChip({
    super.key,
    required this.label,
    required this.values,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEFE4DE)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T?>(
          hint: Text(label),
          value: value,
          isDense: true,
          onChanged: onChanged,
          items: <DropdownMenuItem<T?>>[
            // const DropdownMenuItem<T?>(value: null, child: Text('All')),
            ...values.map(
              (e) => DropdownMenuItem<T?>(value: e, child: Text('$e')),
            ),
          ],
        ),
      ),
    );
  }
}
