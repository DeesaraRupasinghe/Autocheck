import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Large primary action button for the app
/// Follows design system: min 48px height, 16.0 border radius
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 56, // Above min touch target of 48px
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 24),
                    const SizedBox(width: 12),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}

/// Secondary outlined button
/// Follows design system: min 48px height, 16.0 border radius
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 56, // Above min touch target of 48px
      child: OutlinedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 24),
              const SizedBox(width: 12),
            ],
            Text(text),
          ],
        ),
      ),
    );
  }
}

/// Info card with icon for home screen features
/// Follows design system: 16.0 border radius, soft shadows, 16px internal padding
class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: isDark ? null : AppTheme.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cardColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        size: 28,
                        color: cardColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Health score display widget with color coding
class HealthScoreWidget extends StatelessWidget {
  final int score;
  final double size;
  final bool showLabel;

  const HealthScoreWidget({
    super.key,
    required this.score,
    this.size = 120,
    this.showLabel = true,
  });

  Color get _scoreColor {
    if (score >= 70) return AppTheme.riskGreen;
    if (score >= 40) return AppTheme.riskYellow;
    return AppTheme.riskRed;
  }

  String get _riskLabel {
    if (score >= 70) return 'Safe';
    if (score >= 40) return 'Medium Risk';
    return 'High Risk';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: score / 100,
                strokeWidth: 12,
                backgroundColor: _scoreColor.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$score',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _scoreColor,
                      ),
                ),
                Text(
                  '/100',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ],
        ),
        if (showLabel) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: _scoreColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _riskLabel,
              style: TextStyle(
                color: _scoreColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Risk indicator badge with stadium border (pill shape)
class RiskBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const RiskBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  factory RiskBadge.safe() => const RiskBadge(
        label: 'Safe',
        color: AppTheme.riskGreen,
        icon: Icons.check_circle,
      );

  factory RiskBadge.warning() => const RiskBadge(
        label: 'Warning',
        color: AppTheme.riskYellow,
        icon: Icons.warning,
      );

  factory RiskBadge.danger() => const RiskBadge(
        label: 'Danger',
        color: AppTheme.riskRed,
        icon: Icons.error,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20), // Stadium/pill shape
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state placeholder
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: AppTheme.spacingLg),
              ElevatedButton(
                onPressed: onButtonPressed,
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading overlay with soft card
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  boxShadow: AppTheme.softShadow,
                ),
                padding: const EdgeInsets.all(AppTheme.spacingXl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    if (message != null) ...[
                      const SizedBox(height: AppTheme.spacingMd),
                      Text(message!),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Section header with optional action
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (actionText != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionText!),
          ),
      ],
    );
  }
}

/// Styled card with soft shadow following the design system
class StyledCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const StyledCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: isDark ? null : AppTheme.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppTheme.spacingMd),
            child: child,
          ),
        ),
      ),
    );
  }
}
