import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/graphs/sparkline_graph.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/view_models/performance_sparkline_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/no_data_placeholder.dart';

/// A [SparklineGraph] that displays the performance metric.
class PerformanceSparklineGraph extends StatelessWidget {
  /// A [PerformanceSparklineViewModel] with data to display.
  final PerformanceSparklineViewModel performanceSparkline;

  /// Creates [PerformanceSparklineGraph] with the given [performanceSparkline].
  ///
  /// The [performanceSparkline] must not be `null`.
  const PerformanceSparklineGraph({
    Key key,
    @required this.performanceSparkline,
  })  : assert(performanceSparkline != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (performanceSparkline.performance.isEmpty) {
      return const NoDataPlaceholder();
    }

    final sparklineTheme = MetricsTheme.of(context).performanceSparklineTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            CommonStrings.duration(performanceSparkline.value),
            style: sparklineTheme.textStyle,
          ),
        ),
        Expanded(
          child: SparklineGraph(
            data: performanceSparkline.performance,
            strokeColor: sparklineTheme.strokeColor,
            fillColor: sparklineTheme.fillColor,
          ),
        ),
      ],
    );
  }
}
