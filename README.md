# 🐱 Cat Cuddle

A cozy iOS game where you cuddle, feed, and play with adorable virtual cats.

## About

Cat Cuddle lets you choose a cat companion and interact with it through three different game modes. The more you play, the happier your cat gets — reach 100% happiness to trigger a celebration!

## Game Modes

- **Cuddle** — Drag your finger across the screen to pet your cat. Hearts and sparkles fly as the purr intensity builds up.
- **Treats** — Drag fish, meat, and shrimp treats to your cat's mouth. Each treat gives a different happiness boost.
- **Feather Wand** — Tilt your phone to swing a feather wand. Your cat tracks it and pounces when it gets close enough!

## Features

- 3 built-in cats to choose from
- Add your own cat photo — background is automatically removed using Vision
- Smooth animations and glassmorphism UI
- CoreMotion accelerometer support for the wand toy (with simulator fallback)
- Floating hearts, sparkles, and a full-screen celebration at max happiness

## Tech Stack

- SwiftUI
- CoreMotion
- Vision + CoreImage (background removal)
- PhotosUI
- AVFoundation
- Combine

## Architecture

Clean MVVM with a multi-file structure:

```
CatCudding/
├── Models/           — Cat, FloatingElement, Treat
├── DesignSystem/     — Colors, backgrounds, glass card
├── Services/         — Background removal (Vision)
├── ViewModels/       — GameState (all game logic)
└── Views/
    ├── Shared/       — Reusable UI components
    ├── Components/   — Cat view, wand, treats, effects
    └── Screens/      — Welcome, Selection, Game
```

## Requirements

- iOS 17+
- Xcode 16+

---

Made with 🐾 by [Hacer Irmak Selçuk](https://github.com/hacerirmak)
