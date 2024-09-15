import 'package:background_downloader/background_downloader.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'background_download_provider.g.dart';

@Riverpod(keepAlive: true)
FileDownloader backgroundDownloader(BackgroundDownloaderRef ref) {
  return FileDownloader()
    ..trackTasks()
    ..configureNotification(
      running: TaskNotification('Downloading', 'file: {filename}'),
      complete: TaskNotification('Download finished', 'file: {filename}'),
      paused: TaskNotification('Download paused', 'file: {filename}'),
      progressBar: true,
    );
}
