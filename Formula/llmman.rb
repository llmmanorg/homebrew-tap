# GENERATED FILE -- DO NOT EDIT. Rendered from packaging/homebrew/llmman.rb.in
# in github.com/llmmanorg/llmman and pushed here by its CI on every release.
#
# Installs the prebuilt release binary: building from source would need Go
# and Rust on every user's machine for a binary CI has already built and
# tested for these exact platforms.
class Llmman < Formula
  desc "Run any agent on any model, models stored as OCI images"
  homepage "https://github.com/llmmanorg/llmman"
  version "0.1.349"
  license "Apache-2.0"

  # Bare binaries, not tarballs, so Homebrew cannot infer the version from
  # the URL; hence the explicit `version` above.
  on_macos do
    # No x86_64-apple-darwin build is published; this gives Intel users a
    # clear Homebrew error instead of a 404.
    depends_on arch: :arm64

    url "https://github.com/llmmanorg/llmman/releases/download/v0.1.349/llmman-aarch64-apple-darwin"
    sha256 "62ed25fbacc9fbca646d9ccfe1f9862dab670788e7685f6edea1ee2face84694"
  end

  on_linux do
    on_intel do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.349/llmman-x86_64-unknown-linux-gnu"
      sha256 "3f3e3d53384da9370e7f3e8cb092adce53c6b0d5076a4b18710938ab64d3cd0c"
    end
    on_arm do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.349/llmman-aarch64-unknown-linux-gnu"
      sha256 "df3cdd5ccdbd4c719aeedb30da03eaa5c2f3f72c69b0ffdd8eb569def4f9724f"
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
