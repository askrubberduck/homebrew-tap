# homebrew-tap

Homebrew tap for [waddleloop](https://github.com/askrubberduck/waddleloop) — governed multi-agent fleet orchestration.

```sh
brew install askrubberduck/tap/wl           # stable pointer
brew install askrubberduck/tap/wl@latest    # latest pointer
```

Both pointers install the same five binaries (`wl`, `wld`, `wl-mcp`, `wl-web`, `wltrust`).

## How the formulas are managed (do not hand-edit)

| File | Pointer | Updated by |
|---|---|---|
| `Formula/wl@latest.rb` | latest — most recent `vX.Y.Z` tag | GoReleaser, on every release (`waddleloop/.github/workflows/release.yml`) |
| `Formula/wl.rb` | stable — promoted after a soak window | `waddleloop/.github/workflows/promote-stable.yml` |

Promotion is one-way (`latest` → `stable`); stable never moves backward. Both
formulas point at the same signed artifacts on GitHub Releases (cosign keyless).

Neither formula exists until the first release / first promotion.
