const _exceptions = {
  'TaskException': TaskException.new,
  'TaskFileSystemException': TaskFileSystemException.new,
  'TaskUrlException': TaskUrlException.new,
  'TaskConnectionException': TaskConnectionException.new,
  'TaskResumeException': TaskResumeException.new,
  'TaskHttpException': TaskHttpException.new
};

/// Contains Exception information associated with a failed [Task]
///
/// The [exceptionType] categorizes and describes the exception
/// The [description] is typically taken from the platform-generated
/// exception message, or from the plugin. The localization is undefined
/// For the [TaskHttpException], the [httpResponseCode] is only valid if >0
/// and may offer details about the nature of the error
base class TaskException implements Exception {
  final String description;

  TaskException(this.description);

  String get exceptionType => 'TaskException';

  /// Create object from JSON Map
  factory TaskException.fromJsonMap(Map<String, dynamic> jsonMap) {
    final typeString = jsonMap['type'] as String? ?? 'TaskException';
    final exceptionType = _exceptions[typeString];
    final description = jsonMap['description'] as String? ?? '';
    if (exceptionType != null) {
      if (typeString != 'TaskHttpException') {
        return exceptionType(description);
      } else {
        final httpResponseCode = jsonMap['httpResponseCode'] as int? ?? -1;
        return exceptionType(description, httpResponseCode);
      }
    }
    return TaskException('Unknown');
  }

  /// Create object from String description of the type, and parameters
  factory TaskException.fromTypeString(String typeString, String description,
      [int httpResponseCode = -1]) {
    final exceptionType = _exceptions[typeString] ?? TaskException.new;
    if (typeString != 'TaskHttpException') {
      return exceptionType(description);
    } else {
      return exceptionType(description, httpResponseCode);
    }
  }

  /// Return JSON Map representing object
  Map<String, dynamic> toJsonMap() =>
      {'type': exceptionType, 'description': description};

  @override
  String toString() {
    return '$exceptionType: $description';
  }
}

final class TaskFileSystemException extends TaskException {
  TaskFileSystemException(super.description);

  @override
  String get exceptionType => 'TaskFileSystemException';
}

final class TaskUrlException extends TaskException {
  TaskUrlException(super.description);

  @override
  String get exceptionType => 'TaskUrlException';
}

final class TaskConnectionException extends TaskException {
  TaskConnectionException(super.description);

  @override
  String get exceptionType => 'TaskConnectionException';
}

final class TaskResumeException extends TaskException {
  TaskResumeException(super.description);

  @override
  String get exceptionType => 'TaskResumeException';
}

final class TaskHttpException extends TaskException {
  final int httpResponseCode;

  TaskHttpException(super.description, this.httpResponseCode);

  @override
  String get exceptionType => 'TaskHttpException';

  @override
  Map<String, dynamic> toJsonMap() =>
      {...super.toJsonMap(), 'httpResponseCode': httpResponseCode};

  @override
  String toString() {
    return '$exceptionType, response code $httpResponseCode: $description';
  }
}
