# GENERATED FILE -- DO NOT EDIT. Rendered from packaging/homebrew/Casks/llmman-desktop.rb.in
# in github.com/llmmanorg/llmman and pushed here by its CI on every release.
# macOS only: Linux installs the formula of the same name. llmman.app already
# bundles llmman, so there is nothing to depend on.
cask "llmman-desktop" do
  version "0.1.726"
  sha256 "9c801c020386173b7f608413f8ad362159f036d09631fa326fdf134854906bd8"

  url "https://github.com/llmmanorg/llmman/releases/download/v0.1.726/llmman-desktop-aarch64-apple-darwin.dmg"
  name "llmman"
  desc "Tray icon that opens llmman's web UI and keeps a local llmman serve running"
  homepage "https://github.com/llmmanorg/llmman"

  # No Intel build is published: fail with a clear error, not a 404.
  depends_on arch: :arm64
  # LSMinimumSystemVersion (11.0) in packaging/desktop-dmg.sh.
  depends_on macos: ">= :big_sur"

  app "llmman.app"

  # Ad hoc signed, not notarized: without this Gatekeeper blocks a Launchpad launch.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/llmman.app"]
  end
end
