part of '../map_part.dart';

class ProgressLine extends StatelessWidget {
  final bool isCompleted;

  const ProgressLine({super.key, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 2,
      color: isCompleted ? AppColors.success : colorScheme.outlineVariant,
    );
  }
}
