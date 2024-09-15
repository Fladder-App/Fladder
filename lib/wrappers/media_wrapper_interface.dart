import 'package:audio_service/audio_service.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class MediaPlayback extends BaseAudioHandler {
  Player? _player;
  VideoController? _controller;
  Player? get player => _player;
  VideoController? get controller => _controller;

  Player setPlayer(Player player) => _player = player;
  VideoController setController(VideoController player) => _controller = player;

  Future<void> setVolume(double volume) async => _player?.setVolume(volume);

  Future<void> setSubtitleTrack(SubtitleTrack track) async => _player?.setSubtitleTrack(track);
  List<SubtitleTrack> get subTracks => _player?.state.tracks.subtitle ?? [];
  SubtitleTrack get subtitleTrack => _player?.state.track.subtitle ?? SubtitleTrack.no();

  Future<void> setAudioTrack(AudioTrack track) async => _player?.setAudioTrack(track);
  List<AudioTrack> get audioTracks => _player?.state.tracks.audio ?? [];
  AudioTrack get audioTrack => _player?.state.track.audio ?? AudioTrack.no();

  @override
  Future<void> seek(Duration position) async => player?.seek(position);

  @override
  Future<void> play() async {
    await player?.play();
    return super.play();
  }

  Future<void> open(
    Playable playable, {
    bool play = true,
  }) async {
    return player?.open(playable, play: play);
  }

  @override
  Future<void> fastForward() async {
    if (player != null) {
      await player!.seek(player!.state.position + const Duration(seconds: 30));
    }
    return super.fastForward();
  }

  @override
  Future<void> rewind() async {
    if (player != null) {
      await player?.seek(player!.state.position - const Duration(seconds: 10));
    }
    return super.rewind();
  }

  @override
  Future<void> setSpeed(double speed) async {
    await player?.setRate(speed);
    return super.setSpeed(speed);
  }

  @override
  Future<void> pause() async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [MediaControl.play],
    ));
    await player?.pause();
    return super.pause();
  }
}
