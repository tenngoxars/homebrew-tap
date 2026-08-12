# typed: strict
# frozen_string_literal: true

# Kuraya Homebrew Formula —— brew install tenngoxars/tap/kuraya
#
# mac 仅 Apple Silicon（GitHub 已无 Intel macOS runner），url/sha256 放顶层
# （Homebrew 不允许 on_arm 块内含 url/sha256，readall --arch=all 会因此失败）。
# 发布流水线（Kuraya 仓库 .github/workflows/release.yml 的 update-tap job）
# 在配了 TAP_TOKEN 时会自动更新本文件的 version/url/sha256。
class Kuraya < Formula
  desc "影片刮削与编目工具"
  homepage "https://github.com/tenngoxars/Kuraya"

  # 版本由 URL 自动推断（含 v0.2.0），无需显式 version
  url "https://github.com/tenngoxars/Kuraya/releases/download/v0.7.5/Kuraya-0.7.5-mac-arm64.zip"
  sha256 "19459c0232e6031c88140748025d738c27b55fcf62b54ef7b6a507b202d9efa8"

  def install
    libexec.install Dir["*"]
    # zip 根是 Kuraya/ 目录（含可执行文件与 _internal 依赖），shim 指向可执行文件本身
    bin.write_exec_script libexec/"Kuraya"/"Kuraya"
  end

  # brew 会把 formula 环境的 LANG 清空并固定 LC_ALL=en_US.UTF-8，
  # 无法用环境变量判断语言，改读 macOS 系统语言（AppleLanguages）。
  def caveats
    langs = `defaults read -g AppleLanguages 2>/dev/null`.to_s
    if langs.match?(/zh-Hant|zh[_-](TW|HK|MO)/i)
      <<~EOS
        設定寫在程式目錄旁的 设置.ini，brew upgrade 會被重置，升級後重新設定即可。
        點擊封面播放：首次執行 kuraya 會自動把隨包的 Kuraya.app 裝入 ~/Applications 並註冊協定。
      EOS
    elsif langs.match?(/zh/i)
      <<~EOS
        配置写在程序目录旁的 设置.ini, brew upgrade 会被重置, 升级后重新设置即可。
        点击封面播放: 首次运行 kuraya 会自动把随包的 Kuraya.app 装入 ~/Applications 并注册协议。
      EOS
    else
      <<~EOS
        Configuration lives in 设置.ini next to the program folder; brew upgrade resets it, so reconfigure after upgrading.
        Click-to-play: the first run of kuraya installs the bundled Kuraya.app into ~/Applications and registers the protocol.
      EOS
    end
  end

  test do
    system "#{bin}/Kuraya", "--version"
  end
end
