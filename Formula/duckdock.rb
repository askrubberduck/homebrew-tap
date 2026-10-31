class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.75"

  # macOS gets the cask, whose app carries this binary.
  depends_on :linux

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.75/duckdock-linux-x64.gz"
      sha256 "2ff73b7bbeea83a121ed793f27a70943401d59e511bdc099d4608aea52ed4c41"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.75/duckdock-linux-arm64.gz"
      sha256 "b754f6446e69cbdbb4731ce040237440c5c67879b14574a7a41bceceaf26f458"
    end
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.75/duckdock-darwin-arm64"
    sha256 "0b475aad05c5c0b4ac184885d9f46735e9fb8b159db399680dfba2a67caf1709"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.75/duckdock-linux-x64.gz"
    sha256 "2ff73b7bbeea83a121ed793f27a70943401d59e511bdc099d4608aea52ed4c41"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.75/duckdock-linux-arm64.gz"
    sha256 "b754f6446e69cbdbb4731ce040237440c5c67879b14574a7a41bceceaf26f458"
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
