import 'package:background_downloader/background_downloader.dart' as dl;

class DownloadStream {
  final String id;
  final dl.DownloadTask? task;
  final double progress;
  final dl.TaskStatus status;
  DownloadStream({
    required this.id,
    this.task,
    required this.progress,
    required this.status,
  });

  DownloadStream.empty()
      : id = '',
        task = null,
        progress = -1,
        status = dl.TaskStatus.notFound;

  bool get hasDownload => progress != -1.0 && status != dl.TaskStatus.notFound && status != dl.TaskStatus.complete;

  DownloadStream copyWith({
    String? id,
    dl.DownloadTask? task,
    double? progress,
    dl.TaskStatus? status,
  }) {
    return DownloadStream(
      id: id ?? this.id,
      task: task ?? this.task,
      progress: progress ?? this.progress,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'DownloadStream(id: $id, task: $task, progress: $progress, status: $status)';
  }
}
