# Contributing to GolfApp

## Branch Strategy

- `main`: Production-ready code
- `develop`: Integration branch for features
- `feature/*`: Feature branches (e.g., `feature/shot-tracker`)
- `fix/*`: Bug fixes (e.g., `fix/gps-accuracy`)

## Commit Messages

Use conventional commits:

```
feat: add course search filtering
fix: correct GPS distance calculation
test: add StatsService unit tests
docs: update README
```

## Pull Requests

1. Create feature branch from `develop`
2. Make changes, write tests
3. Push and open PR to `develop`
4. Ensure CI passes
5. Merge to `develop`, then to `main` for releases

## Testing

All new features must include unit tests:

```bash
xcodebuild test -scheme GolfKitTests
```

Aim for >80% code coverage.
