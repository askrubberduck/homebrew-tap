class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.33"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.33/duckdock-darwin-arm64"
      sha256 "385c2df7e7c5112582ef8ca7d8562e1b65af05212a83f7f5c971dc28c0ae56e2"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.33/duckdock-darwin-arm64"
      sha256 "385c2df7e7c5112582ef8ca7d8562e1b65af05212a83f7f5c971dc28c0ae56e2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.33/duckdock-linux-x64.gz"
      sha256 "c4ebdab921c5aaa8abd451c7723676ccc85edef4a863207c8541bbf59e96cbae"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.33/duckdock-linux-arm64.gz"
      sha256 "41acc2d55738c746bbfc17b954f15d7d222d87a49005d430a24774d2126379d3"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.33/duckdock-linux-x64.gz"
    sha256 "c4ebdab921c5aaa8abd451c7723676ccc85edef4a863207c8541bbf59e96cbae"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.33/duckdock-linux-arm64.gz"
    sha256 "41acc2d55738c746bbfc17b954f15d7d222d87a49005d430a24774d2126379d3"
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
