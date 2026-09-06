# GENERATED FILE -- DO NOT EDIT. Rendered from packaging/homebrew/llmman.rb.in
# in github.com/llmmanorg/llmman and pushed here by its CI on every release.
#
# Installs the prebuilt release binary: building from source would need Go
# and Rust on every user's machine for a binary CI has already built and
# tested for these exact platforms.
class Llmman < Formula
  desc "Run any agent on any model, models stored as OCI images"
  homepage "https://github.com/llmmanorg/llmman"
  version "0.1.338"
  license "Apache-2.0"

  # Bare binaries, not tarballs, so Homebrew cannot infer the version from
  # the URL; hence the explicit `version` above.
  on_macos do
    # No x86_64-apple-darwin build is published; this gives Intel users a
    # clear Homebrew error instead of a 404.
    depends_on arch: :arm64

    url "https://github.com/llmmanorg/llmman/releases/download/v0.1.338/llmman-aarch64-apple-darwin"
    sha256 "3f6363272a4b2b0cd5cf8c3127fcec350653f193728d50c45dd7de5481db3e6e"
  end

  on_linux do
    on_intel do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.338/llmman-x86_64-unknown-linux-gnu"
      sha256 "f3ba5ddf7e57c4bccd5a104e44ac601347925c0899933d573047dc2d6ccb6180"
    end
    on_arm do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.338/llmman-aarch64-unknown-linux-gnu"
      sha256 "278e3834a40d18dbdb9c70cc486323e147694f463bf86a30274f94c4f54073c2"
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
