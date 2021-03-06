import 'package:metrics/project_groups/domain/entities/project_group.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [DataModel] that represents the [ProjectGroup] entity.
class ProjectGroupData extends ProjectGroup implements DataModel {
  /// Creates the [ProjectGroupData] with the given [id], [name] and [projectIds].
  ProjectGroupData({
    String id,
    String name,
    List<String> projectIds,
  }) : super(id: id, name: name, projectIds: projectIds);

  /// Creates the [ProjectGroupData] using the [json] and the [documentId].
  ///
  /// Returns `null` if the given [json] is `null`.
  factory ProjectGroupData.fromJson(
    Map<String, dynamic> json,
    String documentId,
  ) {
    if (json == null) return null;

    return ProjectGroupData(
      id: documentId,
      name: json['name'] as String,
      projectIds: List.from(json['projectIds'] as List),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'projectIds': projectIds,
    };
  }
}
