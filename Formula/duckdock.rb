class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.7"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.7/duckdock-darwin-arm64"
      sha256 "22b0c483b52c2a6e48efbf2692acde79115cc83f9994529fc050f1917bc483fa"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.7/duckdock-darwin-arm64"
      sha256 "22b0c483b52c2a6e48efbf2692acde79115cc83f9994529fc050f1917bc483fa"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.7/duckdock-linux-x64.gz"
      sha256 "647381f38bde6b3f4393e84caa23acd59b3b67fac4fa6f2e06a26cc3da66b903"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.7/duckdock-linux-arm64.gz"
      sha256 "512eec0f76b83b1e1015a5ef6d95af6623c14d6ba983242d21c9b9de491ee2e8"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.7/duckdock-linux-x64.gz"
    sha256 "647381f38bde6b3f4393e84caa23acd59b3b67fac4fa6f2e06a26cc3da66b903"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.7/duckdock-linux-arm64.gz"
    sha256 "512eec0f76b83b1e1015a5ef6d95af6623c14d6ba983242d21c9b9de491ee2e8"
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
