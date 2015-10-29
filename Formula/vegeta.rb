require "language/go"

class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v5.9.0.tar.gz"
  sha256 "408cd5e3fcac9970668c2b9cb855aa3da4b6991d08b326fce3c48dbc57d40b44"

  bottle do
    cellar :any_skip_relocation
    sha256 "f931f2e9e9b30749728d1c3753c0763afb11a0e086ce9a0616337c68685c5094" => :el_capitan
    sha256 "9a075caf5287795b6ae27a469afb5a6b0d77bcc87d856b2c3b20186f2f8b560e" => :yosemite
    sha256 "45acababb4d359610d56320443e7fe1b3f3d9ef00e2dffd6a1ebc03565205a12" => :mavericks
    sha256 "6ebf4739e99568b697ec7eabbd703b9ecf332fef4e6180d6535340f819b87a42" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/bmizerany/perks" do
    url "https://github.com/bmizerany/perks.git",
      :revision => "d9a9656a3a4b1c2864fdb44db2ef8619772d92aa"
  end

  go_resource "github.com/streadway/quantile" do
    url "https://github.com/streadway/quantile.git",
      :revision => "b0c588724d25ae13f5afb3d90efec0edc636432b"
  end

  def install
    mkdir_p buildpath/"src/github.com/tsenart/"
    ln_s buildpath, buildpath/"src/github.com/tsenart/vegeta"
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X main.Version #{version}", "-o", "vegeta"
    bin.install "vegeta"
  end

  test do
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", "GET http://localhost/")
    pipe_output("#{bin}/vegeta report", output)
  end
end
