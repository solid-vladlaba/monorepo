import 'package:ci_integration/client/github_actions/models/workflow_run.dart';
import 'package:ci_integration/client/github_actions/models/workflow_runs_page.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("WorkflowRunsPage", () {
    const totalCount = 1;
    const page = 1;
    const perPage = 1;
    const nextPageUrl = 'url';
    const values = [WorkflowRun(id: 1), WorkflowRun(id: 2)];

    test(
      "creates an instance with the given values",
      () {
        final runsPage = WorkflowRunsPage(
          totalCount: totalCount,
          page: page,
          perPage: perPage,
          nextPageUrl: nextPageUrl,
          values: values,
        );

        expect(runsPage.totalCount, equals(totalCount));
        expect(runsPage.page, equals(page));
        expect(runsPage.perPage, equals(perPage));
        expect(runsPage.nextPageUrl, equals(nextPageUrl));
        expect(runsPage.values, equals(values));
      },
    );
  });
}
