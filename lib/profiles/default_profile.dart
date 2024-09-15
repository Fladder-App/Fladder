import 'package:fladder/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:fladder/profiles/web_profile.dart';
import 'package:flutter/foundation.dart';

const DeviceProfile defaultProfile = kIsWeb
    ? webProfile
    : DeviceProfile(
        maxStreamingBitrate: 120000000,
        maxStaticBitrate: 120000000,
        musicStreamingTranscodingBitrate: 384000,
        directPlayProfiles: [
          DirectPlayProfile(
            type: DlnaProfileType.video,
          ),
          DirectPlayProfile(
            type: DlnaProfileType.audio,
          )
        ],
        transcodingProfiles: [
          TranscodingProfile(
            audioCodec: 'aac,mp3,mp2',
            container: 'ts',
            maxAudioChannels: '2',
            protocol: MediaStreamProtocol.hls,
            type: DlnaProfileType.video,
            videoCodec: 'h264',
          ),
        ],
        containerProfiles: [],
        subtitleProfiles: [
          SubtitleProfile(format: 'vtt', method: SubtitleDeliveryMethod.$external),
          SubtitleProfile(format: 'ass', method: SubtitleDeliveryMethod.$external),
          SubtitleProfile(format: 'ssa', method: SubtitleDeliveryMethod.$external),
        ],
      );
