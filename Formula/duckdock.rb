class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.98"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.98/duckdock-linux-x64.gz"
    sha256 "6ec31199e922a18a3b8b01657775d69ef8f4cffb997904dab908d0acb048ecea"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.98/duckdock-linux-arm64.gz"
    sha256 "0afb97fbc87422296b3dfab0eb3b82d7bc29aa3f403d14f8817a7dddada8d5a7"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.98/duckdock-darwin-arm64"
    sha256 "07e5f652d2f423a216d2ca39aef834138d937488a818693c65b5a9cb88722629"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.98/duckdock-linux-x64.gz"
    sha256 "6ec31199e922a18a3b8b01657775d69ef8f4cffb997904dab908d0acb048ecea"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.98/duckdock-linux-arm64.gz"
    sha256 "0afb97fbc87422296b3dfab0eb3b82d7bc29aa3f403d14f8817a7dddada8d5a7"
  end

  def install
    # Raw download keeps its name; Homebrew gunzips the .gz ones to duckdock-linux-<arch>.
    bin.install Dir["duckdock-*"].first => "duckdock"
    chmod 0755, bin/"duckdock" # downloads and gunzip carry no exec bit
    %w[darwin-arm64 linux-x64 linux-arm64].each do |t|
      resource(t).stage { (lib/"duckdock").install Dir["duckdock-*"].first => "duckdock-#{t}" }
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duckdock --version")
  end
end
