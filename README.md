# TDA Multi Mapper (Max for Live)

A Max for Live device for [TDAbleton](https://docs.derivative.ca/TDAbleton) that takes one data stream from TouchDesigner and maps it to multiple Ableton Live parameters, each with its own scaling. Incoming TD data is passed through unfiltered.

## Files

- `device/TDA_Multi_Mapper.amxd` – the device
- `device/mappingSub.maxpat` – mapping slot abstraction (must sit next to the device)

Both go in TDAbleton's `TouchDesigner` folder (TD: `Samples/TDAbleton/Live 11+/TouchDesigner`, Live: `MIDI Remote Scripts/TouchDesigner`).

## Versions

Each release is a git tag (`v10.10`, …). Download any version from the **Tags** / **Releases** page.

## Workflow (Terminal, from this folder)

| What | Command |
|---|---|
| First time on a Mac | `bash scripts/setup.sh` |
| Save a new version to GitHub | `bash scripts/push.sh "what changed" 10.11` |
| Get the latest (other Mac / after a TD or Live update) | `bash scripts/install.sh` |

The TouchDesigner folder is the working folder: edit and save the device there, then push.
