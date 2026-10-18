class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.8"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.8/duckdock-darwin-arm64"
      sha256 "c7453d5d4b7b13023132ee1e2c97618226b2450be0be494860c030833dc4ca12"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.8/duckdock-darwin-arm64"
      sha256 "c7453d5d4b7b13023132ee1e2c97618226b2450be0be494860c030833dc4ca12"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.8/duckdock-linux-x64.gz"
      sha256 "ea269c097bdf73f6fd71e9cccdc828695d9b05b024c391a8fb9cfd5195e1e804"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.8/duckdock-linux-arm64.gz"
      sha256 "a7ede1c8f71f10d5b6b6bc80a7195c64a5faad71424c7fff55b84794f7afc9a0"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.8/duckdock-linux-x64.gz"
    sha256 "ea269c097bdf73f6fd71e9cccdc828695d9b05b024c391a8fb9cfd5195e1e804"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.8/duckdock-linux-arm64.gz"
    sha256 "a7ede1c8f71f10d5b6b6bc80a7195c64a5faad71424c7fff55b84794f7afc9a0"
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
