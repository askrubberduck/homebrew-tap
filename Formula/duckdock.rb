class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.43"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.43/duckdock-darwin-arm64"
      sha256 "7330387ebc9bac58cc3e3988be83cd6c57e505bb20e85b353082a3dec31b5dbf"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.43/duckdock-darwin-arm64"
      sha256 "7330387ebc9bac58cc3e3988be83cd6c57e505bb20e85b353082a3dec31b5dbf"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.43/duckdock-linux-x64.gz"
      sha256 "5a898bdf6449886cad515f2cfda07d31ac382a52913b819ecd47e676f48abb62"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.43/duckdock-linux-arm64.gz"
      sha256 "3193770b988b84f11495becaf7e719a11b03acbf00bb140a9f30f74eee6ec301"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.43/duckdock-linux-x64.gz"
    sha256 "5a898bdf6449886cad515f2cfda07d31ac382a52913b819ecd47e676f48abb62"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.43/duckdock-linux-arm64.gz"
    sha256 "3193770b988b84f11495becaf7e719a11b03acbf00bb140a9f30f74eee6ec301"
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
