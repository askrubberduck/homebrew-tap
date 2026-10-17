class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.2"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.2/duckdock-darwin-arm64"
      sha256 "9a0e979ed99a49d2fc464d03f2104729b619ebe52b4297ccc1058ac91d2e33f0"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.2/duckdock-darwin-arm64"
      sha256 "9a0e979ed99a49d2fc464d03f2104729b619ebe52b4297ccc1058ac91d2e33f0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.2/duckdock-linux-x64.gz"
      sha256 "d0682cb4ed20176916da5aff60b2d30e51ec96af7b5fed6498b5704617537972"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.2/duckdock-linux-arm64.gz"
      sha256 "1e1e908d307b1105d7cfb82739ab5cd6f3e87a7cf3cb3ff2773cd38f05280e94"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.2/duckdock-linux-x64.gz"
    sha256 "d0682cb4ed20176916da5aff60b2d30e51ec96af7b5fed6498b5704617537972"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.2/duckdock-linux-arm64.gz"
    sha256 "1e1e908d307b1105d7cfb82739ab5cd6f3e87a7cf3cb3ff2773cd38f05280e94"
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
