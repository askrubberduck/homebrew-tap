class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.31"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.31/duckdock-darwin-arm64"
      sha256 "3d3acf21fcdb3d91fc2bbb8f22f58e7ea2761ea05c90f2264169ed7eb2531ffc"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.31/duckdock-darwin-arm64"
      sha256 "3d3acf21fcdb3d91fc2bbb8f22f58e7ea2761ea05c90f2264169ed7eb2531ffc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.31/duckdock-linux-x64.gz"
      sha256 "9ae270b323e011543ca7d925fef3462c630b67a3cc885efc113ac76055347701"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.31/duckdock-linux-arm64.gz"
      sha256 "9ff3b3e406e4541a9cc5b03fc567e334dcd4a53b677dd60e557976137bd85d4a"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.31/duckdock-linux-x64.gz"
    sha256 "9ae270b323e011543ca7d925fef3462c630b67a3cc885efc113ac76055347701"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.31/duckdock-linux-arm64.gz"
    sha256 "9ff3b3e406e4541a9cc5b03fc567e334dcd4a53b677dd60e557976137bd85d4a"
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
