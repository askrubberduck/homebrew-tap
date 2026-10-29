cask "duckdock-app" do
  version "0.2.56"
  sha256 "cc04ec29d23bf29ac786e2e5303c6c9f3b4fbf261a80fcbda612fb5c2019476b"

  url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.56/duckdock-macos-arm64.app.zip"
  name "duckdock"
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"

  depends_on arch: :arm64
  depends_on :macos

  app "duckdock.app"

  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/duckdock.app"]
  end

  zap trash: [
    "~/Library/Application Support/dev.askrubberduck.duckdock",
    "~/Library/Caches/dev.askrubberduck.duckdock",
    "~/Library/HTTPStorages/dev.askrubberduck.duckdock",
    "~/Library/Preferences/dev.askrubberduck.duckdock.plist",
    "~/Library/Saved Application State/dev.askrubberduck.duckdock.savedState",
    "~/Library/WebKit/dev.askrubberduck.duckdock",
  ]

  caveats "duckdock.app is unsigned; its quarantine flag is removed on install."
end
