
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "aliyun/cloudpush/version"

Gem::Specification.new do |spec|
  spec.name          = "aliyun-cloudpush"
  spec.version       = Aliyun::Cloudpush::VERSION
  spec.authors       = ["Jeff Lai"]
  spec.email         = ["winfield301@gmail.com"]

  spec.summary       = %q{aliyun cloud push}
  spec.description   = %q{aliyun cloud push}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
