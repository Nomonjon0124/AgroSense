part of '../map_part.dart';

class ProgressDot extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;

  const ProgressDot({super.key, required this.isActive, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color:
        isCompleted
            ? AppColors.success
            : (isActive ? AppColors.primary : AppColors.border),
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.border,
          width: 2,
        ),
      ),
      child:
      isCompleted
          ? const Icon(Icons.check, size: 8, color: Colors.white)
          : null,
    );
  }
}