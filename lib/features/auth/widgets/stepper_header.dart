import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class StepperHeader extends StatelessWidget {
  const StepperHeader({
    super.key,
    required this.currentStep,
    required this.labels,
  });

  final int currentStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (index) {
        final bool isActive = index <= currentStep;
        final bool isCurrent = index == currentStep;
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  if (index == labels.length - 1) const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: isCurrent ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isActive ? AppColors.primary : const Color(0xFFE0E0E0),
                    width: 1.2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isCurrent ? Colors.white : AppColors.textSecondary,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                labels[index],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isCurrent ? AppColors.textPrimary : AppColors.textSecondary,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                    ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
