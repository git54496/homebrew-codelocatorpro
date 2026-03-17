class Grab < Formula
  desc "Android UI grab CLI for CodeLocatorPRO"
  homepage "https://github.com/git54496/codelocatorpro"
  url "https://github.com/git54496/codelocatorpro/archive/refs/tags/v0.2.2.tar.gz"
  version "0.2.2"
  sha256 "d039e82cc18d3a61a839cd712cb5d25a2762a86f893d86b8067c1e1575b92cb7"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/git54496/codelocatorpro.git", branch: "main"

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
    assert_equal "0.2.2", version_output
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
