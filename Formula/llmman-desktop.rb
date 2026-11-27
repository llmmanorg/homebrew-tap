# GENERATED FILE -- DO NOT EDIT. Rendered from packaging/homebrew/Formula/llmman-desktop.rb.in
# in github.com/llmmanorg/llmman and pushed here by its CI on every release.
# Linux only: macOS installs llmman.app from the cask of the same name.
class LlmmanDesktop < Formula
  desc "Tray icon that opens llmman's web UI and keeps a local llmman serve running"
  homepage "https://github.com/llmmanorg/llmman"
  version "0.1.726"
  license "Apache-2.0"

  depends_on :linux
  depends_on "llmman"

  on_linux do
    on_intel do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.726/llmman-desktop-x86_64-unknown-linux-gnu"
      sha256 "eb2b642d1e263bbb00a6ba68c97d97f7a6bead7575ad737b73953eccc553e205"
    end
    on_arm do
      url "https://github.com/llmmanorg/llmman/releases/download/v0.1.726/llmman-desktop-aarch64-unknown-linux-gnu"
      sha256 "3b280e3acc4fdf4bd69b3e4af84855480025c78e7ec1487da154027e851c466d"
    end
  end

  # The launcher icon; the same file packaging/desktop-dmg.sh makes llmman.app's icon from.
  resource "icon" do
    url "https://github.com/llmmanorg/llmman/releases/download/docs-assets/llmman-desktop-icon-512.png"
    sha256 "97c10798327876bfe2937ee8c963632e5f777e39016f7fdcedceb3668acf271c"
  end

  def install
    bin.install Dir["llmman-desktop-*"].first => "llmman-desktop"

    resource("icon").stage do
      (share/"icons/hicolor/512x512/apps").install "llmman-desktop-icon-512.png" => "llmman-desktop.png"
    end

    # opt_* paths survive upgrades; the versioned Cellar paths do not.
    (share/"applications").mkpath
    (share/"applications/llmman-desktop.desktop").write <<~EOS
      [Desktop Entry]
      Type=Application
      Name=llmman
      Comment=Tray icon for llmman: opens the web UI and keeps llmman serve running
      Exec=#{opt_bin}/llmman-desktop
      Icon=#{opt_share}/icons/hicolor/512x512/apps/llmman-desktop.png
      Categories=Utility;Network;
      Terminal=false
      StartupNotify=false
    EOS
  end

  # Homebrew's prefix is not in XDG_DATA_DIRS, so link the entry where every
  # desktop environment looks. ln_sf replaces a link left by an earlier version.
  # Newer Homebrews run post_install sandboxed, without write access to the
  # home directory: then the caveats say how to link it by hand.
  def post_install
    applications_dir.mkpath
    FileUtils.ln_sf opt_share/"applications/llmman-desktop.desktop", applications_dir/"llmman-desktop.desktop"
  rescue SystemCallError
    nil
  end

  def caveats
    tray = "The tray icon needs a StatusNotifierItem host: KDE has one, GNOME needs its AppIndicator extension."
    if (applications_dir/"llmman-desktop.desktop").symlink?
      "llmman now shows up in your application menu. #{tray}\n"
    else
      <<~EOS
        Homebrew could not add llmman to your application menu. Link it once with:
          mkdir -p "${XDG_DATA_HOME:-~/.local/share}/applications" && ln -sf #{opt_share}/applications/llmman-desktop.desktop "${XDG_DATA_HOME:-~/.local/share}/applications/"
        #{tray}
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmman-desktop --version")
  end

  private

  # post_install runs with an isolated HOME, so ask the account database.
  def applications_dir
    data_home = ENV.fetch("XDG_DATA_HOME", "")
    data_home = "#{Etc.getpwuid.dir}/.local/share" if data_home.empty?
    Pathname.new(data_home)/"applications"
  end
end
