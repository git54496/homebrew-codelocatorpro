class AndroidUiGrab < Formula
  desc "Android UI Grab CLI"
  homepage "https://github.com/git54496/android-ui-grab"
  url "https://github.com/git54496/android-ui-grab/archive/refs/tags/v0.2.5.tar.gz"
  version "0.2.5"
  sha256 "215af5d4622a99f8241ea3618727fa17ae44f1becda7ec241aedc483329767f3"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/git54496/android-ui-grab.git", branch: "main"

  depends_on "openjdk@17"

  def install
    cd "adapter" do
      system "./gradlew", "installDist", "--no-daemon"
      install_root = if (Pathname("build/install/grab")).exist?
        "build/install/grab"
      else
        Dir["build/install/*"].first
      end
      odie "installDist output not found under adapter/build/install" if install_root.nil?
      libexec.install Dir["#{install_root}/*"]
    end

    env = Language::Java.overridable_java_home_env("17")
    target = if (libexec/"bin/grab").exist?
      libexec/"bin/grab"
    else
      libexec/"bin/codelocator-adapter"
    end
    odie "CLI entry not found under #{libexec}/bin" unless target.exist?
    (bin/"grab").write_env_script target, env
  end

  test do
    version_output = shell_output("#{bin}/grab --version").strip
    assert_equal "0.2.5", version_output
    output = shell_output("#{bin}/grab list")
    assert_match "\"success\": true", output
  end

  def caveats
    <<~EOS
      `grab live` requires `adb` in PATH.
      Install it with:
        brew install --cask android-platform-tools
    EOS
  end
end
