class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.28"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.28/duckdock-darwin-arm64"
      sha256 "12fff71bb8a3d768830b7feb1b8d7c2fac8cdd00eb0569f644f8c7303bc8224e"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.28/duckdock-darwin-arm64"
      sha256 "12fff71bb8a3d768830b7feb1b8d7c2fac8cdd00eb0569f644f8c7303bc8224e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.28/duckdock-linux-x64.gz"
      sha256 "ee8da55cc9dadd2ebedd060dccd76dadba897dd38748abebe68e54f6a29dc102"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.28/duckdock-linux-arm64.gz"
      sha256 "80505f82277ee02942c37eb8a4c92d3fe31e506de9f3877d8dce0981a8629309"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.28/duckdock-linux-x64.gz"
    sha256 "ee8da55cc9dadd2ebedd060dccd76dadba897dd38748abebe68e54f6a29dc102"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.28/duckdock-linux-arm64.gz"
    sha256 "80505f82277ee02942c37eb8a4c92d3fe31e506de9f3877d8dce0981a8629309"
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
