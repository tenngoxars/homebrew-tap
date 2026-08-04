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
  url "https://github.com/tenngoxars/Kuraya/releases/download/v0.4.0/Kuraya-0.4.0-mac-arm64.zip"
  sha256 "351f93368e41fc4d6dcd56e48606451da46b1cc34888993b82f779881383a804"

  def install
    libexec.install Dir["*"]
    # zip 根是 Kuraya/ 目录（含可执行文件与 _internal 依赖），shim 指向可执行文件本身
    bin.write_exec_script libexec/"Kuraya"/"Kuraya"
  end

  def caveats
    <<~EOS
      配置写在程序目录旁的 设置.ini, brew upgrade 会被重置, 升级后重新设置即可。
      点击封面播放: 首次运行 kuraya 会自动把随包的 Kuraya.app 装入 ~/Applications 并注册协议。
    EOS
  end

  test do
    system "#{bin}/Kuraya", "--version"
  end
end
