cask "duckdock" do
  version "0.2.102"
  sha256 "89656385ae29ff4156da7219f3e9e0b79fe97c32a5e11ec6dafffd231d4fbf23"

  url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.102/duckdock-macos-arm64.app.zip"
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
