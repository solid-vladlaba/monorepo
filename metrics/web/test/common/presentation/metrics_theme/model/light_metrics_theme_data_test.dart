import 'package:metrics/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("LightMetricsThemeData", () {
    test(
      "creates a variation theme",
      () {
        final lightMetricsThemeData = LightMetricsThemeData();

        expect(lightMetricsThemeData.metricsWidgetTheme, isNotNull);
        expect(lightMetricsThemeData.metricsColoredBarTheme, isNotNull);
        expect(lightMetricsThemeData.inactiveWidgetTheme, isNotNull);
        expect(lightMetricsThemeData.projectGroupCardTheme, isNotNull);
        expect(lightMetricsThemeData.addProjectGroupCardTheme, isNotNull);
        expect(lightMetricsThemeData.deleteDialogTheme, isNotNull);
        expect(lightMetricsThemeData.projectGroupDialogTheme, isNotNull);
        expect(lightMetricsThemeData.metricsButtonTheme, isNotNull);
        expect(lightMetricsThemeData.textFieldTheme, isNotNull);
        expect(lightMetricsThemeData.dropdownTheme, isNotNull);
        expect(lightMetricsThemeData.dropdownItemTheme, isNotNull);
        expect(lightMetricsThemeData.loginTheme, isNotNull);
        expect(lightMetricsThemeData.projectMetricsTableTheme, isNotNull);
        expect(lightMetricsThemeData.buildNumberScorecardTheme, isNotNull);
        expect(lightMetricsThemeData.performanceSparklineTheme, isNotNull);
        expect(lightMetricsThemeData.projectBuildStatusTheme, isNotNull);
        expect(lightMetricsThemeData.toggleTheme, isNotNull);
        expect(lightMetricsThemeData.userMenuButtonTheme, isNotNull);
        expect(lightMetricsThemeData.userMenuTheme, isNotNull);
        expect(lightMetricsThemeData.textPlaceholderTheme, isNotNull);
        expect(lightMetricsThemeData.inputPlaceholderTheme, isNotNull);
        expect(lightMetricsThemeData.circlePercentageTheme, isNotNull);
        expect(lightMetricsThemeData.toastTheme, isNotNull);
        expect(lightMetricsThemeData.pageTitleTheme, isNotNull);
        expect(lightMetricsThemeData.graphIndicatorTheme, isNotNull);
      },
    );
  });
}
