class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.20"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.20/duckdock-darwin-arm64"
      sha256 "edab59d19c18c2e4b13b1578fe8c085015ce2a632711830c7762268136bf880f"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.20/duckdock-darwin-arm64"
      sha256 "edab59d19c18c2e4b13b1578fe8c085015ce2a632711830c7762268136bf880f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.20/duckdock-linux-x64.gz"
      sha256 "b2bc7d2c3df39f88aa1b8fc6ecc3fdcd4e329e864a34a67e3dfdffc89c29c519"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.20/duckdock-linux-arm64.gz"
      sha256 "5037a54f3d9783d675f83998c21eb35401ab69de05d319b4e74e6c13c5047b6e"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.20/duckdock-linux-x64.gz"
    sha256 "b2bc7d2c3df39f88aa1b8fc6ecc3fdcd4e329e864a34a67e3dfdffc89c29c519"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.20/duckdock-linux-arm64.gz"
    sha256 "5037a54f3d9783d675f83998c21eb35401ab69de05d319b4e74e6c13c5047b6e"
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
