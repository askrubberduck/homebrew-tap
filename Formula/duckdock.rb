class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.41"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.41/duckdock-darwin-arm64"
      sha256 "269c0743618a229d8b5593cc554faea66d3745a0bc3182c8dd041a95c2f4098b"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.41/duckdock-darwin-arm64"
      sha256 "269c0743618a229d8b5593cc554faea66d3745a0bc3182c8dd041a95c2f4098b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.41/duckdock-linux-x64.gz"
      sha256 "551fe99eedde3c96f03ce87e2762c13d58c520f0060f35bf75e7f2c1ac631a18"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.41/duckdock-linux-arm64.gz"
      sha256 "511a4ecfe52bd8642e64f18b33677f7ee530b1f1e29d48fa6c51bfe72877faa3"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.41/duckdock-linux-x64.gz"
    sha256 "551fe99eedde3c96f03ce87e2762c13d58c520f0060f35bf75e7f2c1ac631a18"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.41/duckdock-linux-arm64.gz"
    sha256 "511a4ecfe52bd8642e64f18b33677f7ee530b1f1e29d48fa6c51bfe72877faa3"
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
