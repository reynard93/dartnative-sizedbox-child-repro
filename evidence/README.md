# Evidence — 2026-09-28

`xiaomi-profile.mp4` is a recording of the included `lib/main.dart` running on
a physical Xiaomi phone, Android 16, in profile mode. The automatic reveal
changes `Visible` to true; A remains blank and B shows `CHILD`. Two subsequent
Toggle taps hide and then reveal B, while A remains blank.

The published MP4 is H.264, 768-by-984 pixels, approximately 15.11 seconds.
The original capture was requested with `screenrecord --time-limit 20`; its
encoded timeline ends earlier. The file's duration, not the requested limit,
is the reported video duration. Its image was cropped from the 1280-by-2772
screen to `(x=0, y=144, width=1280, height=1640)` and scaled to 768-by-984.
This removes the status bar and empty space below the controls. There is no
speed change, rearrangement, added overlay or replacement of application pixels.
The entire tested UI, including both rows and Toggle, remains visible.

The `before.png` and `after.png` screenshots use the same crop and scale.
They show the false state and the first automatic true state, respectively.

## Capture sequence

After installing the profile build:

```sh
adb -s <device> shell am force-stop dev.dojojojo.repro.sized_box_child_repro
adb -s <device> shell am start -n dev.dojojojo.repro.sized_box_child_repro/.MainActivity
# Start recording after the reproduction UI appears, before its four-second timer.
adb -s <device> shell screenrecord --time-limit 20 --bit-rate 3000000 /sdcard/sizedbox-repro.mp4
```

While the recording ran, two ordinary button taps were sent after the automatic
reveal, with approximately 3.5 seconds between them. The matching unmodified
state-change marker lines are in `profile-logcat.txt`. Logs are filtered to this
reproduction's markers; VM-service URLs and unrelated device/app logs are not
published. The timestamps are device-local time.

## Supporting files

- `profile-build-run.txt`: initial `dn run --profile --no-resident` output from
  the prepared source-only directory, including automatic dependency resolution.
- `analyze.txt`: successful native analysis of `lib`.
- `sdk-version.txt` and `device.txt`: tested SDK and Android build environment.
- `doctor-summary.txt`: the diagnostic summary from `dn doctor -v`, with local
  SDK paths and device identifiers redacted. Verbose discovery dumps and
  unrelated devices are omitted; reported versions are unchanged.

The screenshots and one-second samples from the actual video were visually
reviewed before publication. The full app's earlier image-cache investigation
is not needed to run or observe this reduced example.
