# GENERATED FILE -- DO NOT EDIT. Rendered from packaging/homebrew/Formula/llmman.rb.in
# in github.com/llmmanorg/llmman and pushed here by its CI on every release.
#
# Installs the prebuilt release binary: building from source would need Go
# and Rust on every user's machine for a binary CI has already built and
# tested for these exact platforms.
class Llmman < Formula
  desc "Run any agent on any model, models stored as OCI images"
  homepage "https://github.com/llmmanorg/llmman"
  version "0.1.547"
  license "Apache-2.0"

  # Bare binaries, not tarballs, so Homebrew cannot infer the version from
  # the URL; hence the explicit `version` above.
  on_macos do
    # No x86_64-apple-darwin build is published; this gives Intel users a
    # clear Homebrew error instead of a 404.
    depends_on arch: :arm64

    url "https://github.com/llmmanorg/llmman/releases/download/v0.1.547/llmman-aarch64-apple-darwin"
    sha256 "b8973ece2fc834cab7135688e92a918c43ec546e6d0eb8eac42d41cf6c2eb58f"
  end

  on_linux do
    on_intel do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.547/llmman-x86_64-unknown-linux-gnu"
      sha256 "97dd41f3e5e88f8ac90b98c4321abf5f426cfa6394f1a0e0ea222b5dacb03c0e"
    end
    on_arm do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.547/llmman-aarch64-unknown-linux-gnu"
      sha256 "2b6a95243a83d28498074b8a7db0df1da2b2a4d7d4408450c1a4f023a3f3d6cf"
    end
  end

  def install
    # The staged file keeps its llmman-<triple> asset name.
    bin.install Dir["llmman-*"].first => "llmman"
  end

  # `serve` runs in the foreground and logs to stderr, so launchd/systemd
  # can own it directly. See README.md for usage.
  service do
    run [opt_bin/"llmman", "serve"]
    keep_alive true
    # Launchd's default PATH omits the Homebrew prefix, where docker/podman
    # and llama-server usually live.
    environment_variables PATH: std_service_path_env
    working_dir var
    log_path var/"log/llmman.log"
    error_log_path var/"log/llmman.log"
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
