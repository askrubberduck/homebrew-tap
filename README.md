# homebrew-tap

Homebrew tap for askrubberduck tools.

## duckdock

Install (Homebrew 7 loads a third-party tap only once you trust it):

```sh
brew tap askrubberduck/tap
brew trust --tap askrubberduck/tap
brew install askrubberduck/tap/duckdock              # CLI and TUI
brew install --cask askrubberduck/tap/duckdock-app   # macOS app (Apple silicon)
```

Update. Each duckdock release updates this tap; `brew update` fetches it:

```sh
brew update
brew upgrade duckdock
brew upgrade --cask duckdock-app
```

Force. If `brew info askrubberduck/tap/duckdock` still shows an old version, or to reinstall the same one:

```sh
brew update --force
brew reinstall duckdock
brew reinstall --cask duckdock-app
```

A running host daemon keeps its old version until it restarts; the app offers the restart.
