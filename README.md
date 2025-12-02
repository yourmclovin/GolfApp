# GolfApp

A lightweight iOS + watchOS golf app clone. MVP focuses on GPS scoring, course database, and stats tracking.

## Features (MVP)

- **Course Search**: Browse 500+ courses locally
- **GPS Scoring**: Real-time distance to green, score tracking per hole
- **Stats**: Track rounds, average score, GIR, putts
- **watchOS**: Minimal scoring interface on wrist
- **Local-First**: All data stored locally with SwiftData

## Tech Stack

- **Swift 6** / **SwiftUI**
- **SwiftData** for persistence
- **Shared Framework** (GolfKit) for iOS + watchOS
- **Core Location** for GPS
- **XCTest** for unit tests

## Project Structure

```
GolfApp/
├── GolfKit/                    # Shared framework
│   ├── Models/
│   │   ├── GolfCourse.swift
│   │   ├── Hole.swift
│   │   ├── Round.swift
│   │   └── RoundStats.swift
│   ├── Services/
│   │   ├── CourseService.swift
│   │   ├── LocationService.swift
│   │   └── StatsService.swift
│   └── GolfKit.swift
├── GolfApp/                    # iOS app
│   ├── App/
│   │   └── GolfAppApp.swift
│   ├── ViewModels/
│   │   ├── RoundViewModel.swift
│   │   └── CourseListViewModel.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── CourseSearchView.swift
│   │   ├── RoundScoringView.swift
│   │   └── StatsView.swift
│   └── Resources/
│       └── courses.json
├── GolfAppWatch/               # watchOS app
│   ├── App/
│   │   └── GolfAppWatchApp.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   └── WatchRoundView.swift
│   └── Resources/
│       └── courses.json
├── GolfKitTests/
│   ├── StatsServiceTests.swift
│   └── CourseServiceTests.swift
└── scripts/
    └── scrape_courses.py
```

## Getting Started

### 1. Generate Course Data

```bash
cd scripts
python3 scrape_courses.py
# Outputs: courses.json
```

Copy `courses.json` to:
- `GolfApp/Resources/courses.json`
- `GolfAppWatch/Resources/courses.json`

### 2. Open in Xcode

```bash
open GolfApp.xcodeproj
```

### 3. Run Tests

```bash
xcodebuild test -scheme GolfKitTests
```

## Roadmap

- **v0.1 (MVP)**: Course search, GPS scoring, basic stats
- **v0.2**: Plays Like distances, club recommendation
- **v0.3**: Shot tracker, detailed stats
- **v0.4**: Premium paywall (RevenueCat)
- **v0.5**: AR view, social features

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## License

MIT
