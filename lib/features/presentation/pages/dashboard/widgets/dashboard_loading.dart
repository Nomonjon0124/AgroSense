import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Dashboard loading widgeti
class DashboardLoadingWidget extends StatelessWidget {
  const DashboardLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(16),

            /// Header skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(width: 150, height: 28),
                    const Gap(8),
                    _SkeletonBox(width: 120, height: 16),
                  ],
                ),
                _SkeletonBox(width: 100, height: 40, borderRadius: 20),
              ],
            ),

            const Gap(24),

            /// Weather card skeleton
            _SkeletonBox(width: double.infinity, height: 200, borderRadius: 20),

            const Gap(24),

            /// Forecast header skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SkeletonBox(width: 130, height: 20),
                _SkeletonBox(width: 60, height: 16),
              ],
            ),

            const Gap(12),

            /// Forecast cards skeleton
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _SkeletonBox(
                      width: 70,
                      height: 100,
                      borderRadius: 16,
                    ),
                  ),
                ),
              ),
            ),

            const Gap(24),

            /// Field status header skeleton
            _SkeletonBox(width: 100, height: 20),

            const Gap(16),

            /// Field status cards skeleton
            ...List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SkeletonBox(
                  width: double.infinity,
                  height: 80,
                  borderRadius: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton box widgeti
class _SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(
              alpha: _animation.value,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}
