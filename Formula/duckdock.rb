class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.10"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.10/duckdock-darwin-arm64"
      sha256 "845b633865e5f4ddbfe3da4e33fbe3be87bcaf94d98a8cfb80944d75af4017c6"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.10/duckdock-darwin-arm64"
      sha256 "845b633865e5f4ddbfe3da4e33fbe3be87bcaf94d98a8cfb80944d75af4017c6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.10/duckdock-linux-x64.gz"
      sha256 "ff3c0c176f9f333b9ca6e7b99189ab435d2bd32b2563b002ab6bdfe35cbfa0c5"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.10/duckdock-linux-arm64.gz"
      sha256 "b851b0ec467edc695dfb0a3377d5b50bdd53d8896ea7a331919d2b2dca0f70f7"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.10/duckdock-linux-x64.gz"
    sha256 "ff3c0c176f9f333b9ca6e7b99189ab435d2bd32b2563b002ab6bdfe35cbfa0c5"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.10/duckdock-linux-arm64.gz"
    sha256 "b851b0ec467edc695dfb0a3377d5b50bdd53d8896ea7a331919d2b2dca0f70f7"
  end

  def install
    # Raw download keeps its name; Homebrew gunzips the .gz ones to duckdock-linux-<arch>.
    bin.install Dir["duckdock-*"].first => "duckdock"
    chmod 0755, bin/"duckdock" # downloads and gunzip carry no exec bit
    %w[linux-x64 linux-arm64].each do |t|
      resource(t).stage { (lib/"duckdock").install Dir["duckdock-*"].first => "duckdock-#{t}" }
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duckdock --version")
  end
end
