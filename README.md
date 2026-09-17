# Meowdoku Live Solver 🐱👑

An intelligent real-time solver for **Meowdoku** and Queens-style logic puzzles, built with **Flutter Web** and powered by **VDO.Ninja** screensharing.

🌐 **Live Web Demo**: [https://kinecttheunknown.github.io/meowdoku_live_solver/](https://kinecttheunknown.github.io/meowdoku_live_solver/)

---

## Highlights

- 📺 **Live WebRTC Stream Ingestion**: Powered by [`vdoninja_sdk`](https://github.com/KinectTheUnknown/vdoninja-sdk-dart) for zero-latency video streaming from any iPhone screenshare.
- ⚡ **Zero-Copy Frame Extraction**: Direct browser canvas frame capture from HTML5 `<video>` elements without network overhead.
- 🎨 **Pure Dart Computer Vision**: Real-time board localization, cell slicing, and CIE-Lab perceptual color clustering into $N$ regions.
- 🧠 **Microsecond CSP Solver Engine**: Bitmask-accelerated backtracking algorithm with Forward Checking and Minimum Remaining Values (MRV) that solves boards in $< 2\text{ms}$.
- ✨ **Interactive Augmented Reality Overlay**: Displays glowing Cat and Queen markers directly over the live video stream, complete with a companion digital board editor.

---

## Documentation

For the complete architectural design, pipeline diagrams, and phased roadmap, see:
👉 **[PLAN.md](file:///c:/Users/DavidJosephXayavong/VSC/Repos/meowdoku_live_solver/PLAN.md)**

---

## Tech Stack

- **Framework**: Flutter Web (Dart 3.12+ / Flutter 3.44+)
- **Streaming**: `vdoninja_sdk` (VDO.Ninja WebRTC SDK)
- **Web Interop**: `package:web`, `dart:ui_web`
- **Vision & Solver**: Pure Dart (`image`, bitmask CSP backtracking)

---

## License

This project is licensed under the [MIT License](LICENSE).
