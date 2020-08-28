import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/common/presentation/toast/widgets/negative_toast.dart';
import 'package:metrics/common/presentation/toast/widgets/toast.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/widgets/metrics_table.dart';
import 'package:metrics/dashboard/presentation/widgets/project_groups_dropdown_menu.dart';
import 'package:metrics/dashboard/presentation/widgets/project_metrics_search_input.dart';
import 'package:provider/provider.dart';

/// The widget that allows to quickly get primary metrics
/// of all available projects.
class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

/// The logic and internal state for the [DashboardPage] widget.
class _DashboardPageState extends State<DashboardPage> {
  /// A [ProjectMetricsNotifier] needed to remove added listeners
  /// in the [dispose] method.
  ProjectMetricsNotifier _projectMetricsNotifier;

  @override
  void initState() {
    super.initState();
    _subscribeToProjectErrors();
  }

  @override
  Widget build(BuildContext context) {
    return MetricsScaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: ProjectMetricsSearchInput(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: ProjectGroupsDropdownMenu(),
                ),
              ],
            ),
          ),
          Expanded(
            child: MetricsTable(),
          ),
        ],
      ),
    );
  }

  /// Subscribes to project errors.
  void _subscribeToProjectErrors() {
    _projectMetricsNotifier = Provider.of<ProjectMetricsNotifier>(
      context,
      listen: false,
    );

    _projectMetricsNotifier.addListener(_projectsErrorListener);
  }

  /// Shows the [NegativeToast] with an error message
  /// if the projects error message is not null.
  void _projectsErrorListener() {
    final errorMessage = _projectMetricsNotifier.projectsErrorMessage;

    if (errorMessage != null && mounted) {
      showToast(context, NegativeToast(message: errorMessage));
    }
  }

  @override
  void dispose() {
    _projectMetricsNotifier.removeListener(_projectsErrorListener);
    super.dispose();
  }
}
