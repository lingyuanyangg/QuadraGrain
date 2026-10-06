# Validation

Validated in Max 9.1.3 on macOS at 44.1 kHz.

- Four stereo source buffers loaded through the same `live.drop` path used by the UI: 176,400 frames each.
- Mouse waveform selection updated the normalized IN/OUT controls and the Gen read regions.
- Primary granular recording produced nonzero stereo audio and active voice telemetry.
- Audio Freeze remained nonzero for the final second of a three-second interval after RUN was disabled and all primary voices had ended.
- Feedback regrain produced nonzero stereo output and approximately 0.9 active voices on average after the source was muted.
- Both granular layers decayed to digital silence after RUN and Feedback were disabled.
- JSON structure and dependency names were checked after generation.

The automated five-channel validation recording stores final L/R, scaled primary voice count, scaled regrain voice count, and a section marker in `validation/final_runtime.wav` in the development tree. It is intentionally excluded from the release package.
