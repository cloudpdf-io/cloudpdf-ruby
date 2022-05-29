Gem::Specification.new do |spec|
  spec.name          = "cloudpdf"
  spec.version       = "1.0.0"
  spec.authors       = ["Bob Singor"]
  spec.email         = ["hello@cloudpdf.io"]

  spec.summary       = "Ruby wrapper for the CloudPDF API"
  spec.homepage      = "https://github.com/cloudpdf-io/cloudpdf-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = ""
  # spec.metadata["changelog_uri"] = ""

  spec.add_dependency "httparty"
  spec.add_dependency "jwt", '~> 2.0.0'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end