enum VideoPlayerState {
  minimized,
  fullScreen,
  disposed,
}

class MediaPlaybackModel {
  final VideoPlayerState state;
  final bool playing;
  final Duration position;
  final Duration lastPosition;
  final Duration duration;
  final Duration buffer;
  final bool completed;
  final bool errorPlaying;
  final bool buffering;
  MediaPlaybackModel({
    this.state = VideoPlayerState.disposed,
    this.playing = false,
    this.position = Duration.zero,
    this.lastPosition = Duration.zero,
    this.duration = Duration.zero,
    this.buffer = Duration.zero,
    this.completed = false,
    this.errorPlaying = false,
    this.buffering = false,
  });

  MediaPlaybackModel copyWith({
    VideoPlayerState? state,
    bool? playing,
    Duration? position,
    Duration? lastPosition,
    Duration? duration,
    Duration? buffer,
    bool? completed,
    bool? errorPlaying,
    bool? buffering,
  }) {
    return MediaPlaybackModel(
      state: state ?? this.state,
      playing: playing ?? this.playing,
      position: position ?? this.position,
      lastPosition: lastPosition ?? this.lastPosition,
      duration: duration ?? this.duration,
      buffer: buffer ?? this.buffer,
      completed: completed ?? this.completed,
      errorPlaying: errorPlaying ?? this.errorPlaying,
      buffering: buffering ?? this.buffering,
    );
  }
}
