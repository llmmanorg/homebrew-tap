# GENERATED FILE -- DO NOT EDIT. Rendered from packaging/homebrew/Formula/llmman.rb.in
# in github.com/llmmanorg/llmman and pushed here by its CI on every release.
#
# Installs the prebuilt release binary: building from source would need Go
# and Rust on every user's machine for a binary CI has already built and
# tested for these exact platforms.
class Llmman < Formula
  desc "Run any agent on any model, models stored as OCI images"
  homepage "https://github.com/llmmanorg/llmman"
  version "0.1.564"
  license "Apache-2.0"

  # Bare binaries, not tarballs, so Homebrew cannot infer the version from
  # the URL; hence the explicit `version` above.
  on_macos do
    # No x86_64-apple-darwin build is published; this gives Intel users a
    # clear Homebrew error instead of a 404.
    depends_on arch: :arm64

    url "https://github.com/llmmanorg/llmman/releases/download/v0.1.564/llmman-aarch64-apple-darwin"
    sha256 "17408a1ddacf9dea0227fbede9eab9258034084136474baa6a948e23caeb093d"
  end

  on_linux do
    on_intel do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.564/llmman-x86_64-unknown-linux-gnu"
      sha256 "4bb2e27a2a1e4def5b4181e94f2f3d43adacc52d0f257fa12abaa9598875ce8b"
    end
    on_arm do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.564/llmman-aarch64-unknown-linux-gnu"
      sha256 "3e4d63f3ea0f1006fc40318e98091f3e21964805e4f54e767c983e6d5a526407"
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
