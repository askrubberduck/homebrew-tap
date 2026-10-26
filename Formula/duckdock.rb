class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.35"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.35/duckdock-darwin-arm64"
      sha256 "1853cdf88bc083d4e4f4dae648136e923e28639a51a150425898c0d5a189a367"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.35/duckdock-darwin-arm64"
      sha256 "1853cdf88bc083d4e4f4dae648136e923e28639a51a150425898c0d5a189a367"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.35/duckdock-linux-x64.gz"
      sha256 "d3d670d01cb9545dd8dadfbf676b8129d184a8247e10fc1986f417f306520172"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.35/duckdock-linux-arm64.gz"
      sha256 "7edfec366ee38f6586be429adbcc00ed4b7f48279929b7bfd280843027782ff5"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.35/duckdock-linux-x64.gz"
    sha256 "d3d670d01cb9545dd8dadfbf676b8129d184a8247e10fc1986f417f306520172"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.35/duckdock-linux-arm64.gz"
    sha256 "7edfec366ee38f6586be429adbcc00ed4b7f48279929b7bfd280843027782ff5"
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
