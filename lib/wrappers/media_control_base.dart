import 'package:audio_service/audio_service.dart';
import 'package:media_kit/media_kit.dart';

AudioServiceConfig get audioServiceConfig => const AudioServiceConfig(
      androidNotificationChannelId: 'nl.jknaapen.fladder.channel.playback',
      androidNotificationChannelName: 'Video playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      rewindInterval: Duration(seconds: 10),
      fastForwardInterval: Duration(seconds: 15),
      androidNotificationChannelDescription: "Playback",
      androidShowNotificationBadge: true,
    );

abstract class MediaControlBase {
  Future<void> init() {
    throw UnimplementedError();
  }

  Player setup() {
    throw UnimplementedError();
  }

  Future<void> seek(Duration position) {
    throw UnimplementedError();
  }

  Future<void> play() {
    throw UnimplementedError();
  }

  Future<void> fastForward() {
    throw UnimplementedError();
  }

  Future<void> rewind() {
    throw UnimplementedError();
  }

  Future<void> setSpeed(double speed) {
    throw UnimplementedError();
  }

  Future<void> pause() {
    throw UnimplementedError();
  }

  Future<void> stop() {
    throw UnimplementedError();
  }

  void playOrPause() {
    throw UnimplementedError();
  }

  Future<void> setSubtitleTrack(SubtitleTrack subtitleTrack) {
    throw UnimplementedError();
  }

  Future<void> setAudioTrack(AudioTrack subtitleTrack) {
    throw UnimplementedError();
  }
}
