cask "duckdock-app" do
  version "0.2.63"
  sha256 "5bc3e26402b001da567db9f9ef1ef9f05d98105574d48e603ec8f056f993d7c0"

  url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.63/duckdock-macos-arm64.app.zip"
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
