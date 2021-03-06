import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';

/// A widget that displays the metrics page title with the navigate back arrow.
class MetricsPageTitle extends StatelessWidget {
  /// A title text to display.
  final String title;

  /// Creates the [MetricsPageTitle] with the given [title].
  ///
  /// The [title] must not be null.
  const MetricsPageTitle({
    Key key,
    @required this.title,
  })  : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).pageTitleTheme;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Tooltip(
            message: CommonStrings.navigateBack,
            child: TappableArea(
              onTap: () => _navigateBack(context),
              builder: (context, isHovered, child) => child,
              child: Image.network(
                'icons/arrow-back.svg',
                width: 32.0,
                height: 32.0,
                fit: BoxFit.contain,
                color: theme.iconColor,
              ),
            ),
          ),
        ),
        Text(
          title,
          style: theme.textStyle,
        ),
      ],
    );
  }

  /// Navigates back to the previous page.
  void _navigateBack(BuildContext context) {
    final _navigator = Navigator.of(context);

    if (_navigator.canPop()) {
      _navigator.pop();
    }
  }
}
