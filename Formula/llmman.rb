# GENERATED FILE -- DO NOT EDIT. Rendered from packaging/homebrew/llmman.rb.in
# in github.com/llmmanorg/llmman and pushed here by its CI on every release.
#
# Installs the prebuilt release binary: building from source would need Go
# and Rust on every user's machine for a binary CI has already built and
# tested for these exact platforms.
class Llmman < Formula
  desc "Run any agent on any model, models stored as OCI images"
  homepage "https://github.com/llmmanorg/llmman"
  version "0.1.352"
  license "Apache-2.0"

  # Bare binaries, not tarballs, so Homebrew cannot infer the version from
  # the URL; hence the explicit `version` above.
  on_macos do
    # No x86_64-apple-darwin build is published; this gives Intel users a
    # clear Homebrew error instead of a 404.
    depends_on arch: :arm64

    url "https://github.com/llmmanorg/llmman/releases/download/v0.1.352/llmman-aarch64-apple-darwin"
    sha256 "b454b27b98b7723f4f6bef682dc205a0812a1fc523307d424c6586134dba4aae"
  end

  on_linux do
    on_intel do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.352/llmman-x86_64-unknown-linux-gnu"
      sha256 "f4d1a7928bf327a3036977eba8449d09e0bfefea541daa03534722dc8566492f"
    end
    on_arm do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.352/llmman-aarch64-unknown-linux-gnu"
      sha256 "58a8835be053cc8bf356f9ede044211da745a46ab0a8512dbfe74b51df4fe62f"
    end
  end

  def install
    # The staged file keeps its llmman-<triple> asset name.
    bin.install Dir["llmman-*"].first => "llmman"
  end

  def caveats
    <<~EOS
      llmman downloads a llama.cpp build matching your GPU on first use. To
      get started:

        llmman launch claude --model qwen3.8

      Models and cached llama.cpp builds live under ~/.local/share/llmman.
    EOS
  end

  test do
    # CI writes this version into Cargo.toml before building, so the
    # binary reports it.
    assert_match version.to_s, shell_output("#{bin}/llmman --version")
    # `--version` is handled by clap before any llmman code runs; `list`
    # against an empty store exercises the storage layer and must exit 0
    # with no rows.
    assert_empty shell_output("#{bin}/llmman list").strip
  end
end
