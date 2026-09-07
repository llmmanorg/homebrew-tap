# GENERATED FILE -- DO NOT EDIT. Rendered from packaging/homebrew/llmman.rb.in
# in github.com/llmmanorg/llmman and pushed here by its CI on every release.
#
# Installs the prebuilt release binary: building from source would need Go
# and Rust on every user's machine for a binary CI has already built and
# tested for these exact platforms.
class Llmman < Formula
  desc "Run any agent on any model, models stored as OCI images"
  homepage "https://github.com/llmmanorg/llmman"
  version "0.1.350"
  license "Apache-2.0"

  # Bare binaries, not tarballs, so Homebrew cannot infer the version from
  # the URL; hence the explicit `version` above.
  on_macos do
    # No x86_64-apple-darwin build is published; this gives Intel users a
    # clear Homebrew error instead of a 404.
    depends_on arch: :arm64

    url "https://github.com/llmmanorg/llmman/releases/download/v0.1.350/llmman-aarch64-apple-darwin"
    sha256 "066b3dbeca38314684e473e4dbe7122139a4b707fd0c6e8ec8ff23ed01d288e0"
  end

  on_linux do
    on_intel do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.350/llmman-x86_64-unknown-linux-gnu"
      sha256 "da289f849a0e310ced850839dc9594ed4a9aa7265e725d22f80878d76cc2c754"
    end
    on_arm do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.350/llmman-aarch64-unknown-linux-gnu"
      sha256 "bee03a3d357bc6e64b069024e2344fcaaa33d5682c9e0a701baedc7e2e1a6044"
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
