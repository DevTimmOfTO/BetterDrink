# BetterDrink documentation

This directory has deeper reference material for anyone working on the codebase, beyond what's
in the top-level [README](../README.md) (which is aimed at users/installers) and
[CLAUDE.md](../CLAUDE.md) (a terse orientation for AI coding assistants).

- **[ARCHITECTURE.md](ARCHITECTURE.md)** — the layered `screens/ → providers/ → services/` stack,
  directory-by-directory, plus the notification/background-isolate flow and theming.
- **[FEATURES.md](FEATURES.md)** — each feature (hydration, sugar, alcohol, leaderboard,
  settings) walked end-to-end through the code, from screen down to storage.
- **[DATA_PERSISTENCE.md](DATA_PERSISTENCE.md)** — every `shared_preferences` key in the app,
  what it stores, and any migration/retention behavior around it.
- **[TESTING.md](TESTING.md)** — what's tested, how to run tests, and how to add more.
- **[CONTRIBUTING.md](CONTRIBUTING.md)** — setup, conventions, and the checklist for a PR.

If you're new here, read ARCHITECTURE.md first, then FEATURES.md for whichever feature you're
about to touch.
