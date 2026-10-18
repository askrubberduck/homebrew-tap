class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.9"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.9/duckdock-darwin-arm64"
      sha256 "2741ab38b37d1a663112345540ae7b822a8cbd4be2a798a1a364185cfcc474cd"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.9/duckdock-darwin-arm64"
      sha256 "2741ab38b37d1a663112345540ae7b822a8cbd4be2a798a1a364185cfcc474cd"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.9/duckdock-linux-x64.gz"
      sha256 "69cc2a3526345c3c0b6a38fa49c0f8a6f02466880fd0c0a5fa9efe82b220469d"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.9/duckdock-linux-arm64.gz"
      sha256 "8321a62aeab29686cc4f92a15d9abc85a28f9b2f6fb54c520bd1dd72e7dc4f0e"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.9/duckdock-linux-x64.gz"
    sha256 "69cc2a3526345c3c0b6a38fa49c0f8a6f02466880fd0c0a5fa9efe82b220469d"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.9/duckdock-linux-arm64.gz"
    sha256 "8321a62aeab29686cc4f92a15d9abc85a28f9b2f6fb54c520bd1dd72e7dc4f0e"
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
