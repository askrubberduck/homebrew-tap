cask "duckdock" do
  version "0.5.0"
  sha256 "25714fdb5c8b04780c70fbad63bac882482cf61b7f8b23ef2e0e1f5c1d8ca468"

  url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.0/duckdock-macos-arm64.app.zip"
  name "duckdock"
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"

  depends_on arch: :arm64
  depends_on :macos

  app "duckdock.app"
  # The app's sidecar; it finds the Linux host builds in Contents/Resources.
  binary "#{appdir}/duckdock.app/Contents/MacOS/duckdock"

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
