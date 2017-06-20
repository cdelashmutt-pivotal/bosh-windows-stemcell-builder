require 'rspec/core/rake_task'
require 'mkmf'
require 'fileutils'
require 'tempfile'

require_relative '../../exec_command'

def windows?
  (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
end

namespace :run do
  desc 'Run bosh-windows-acceptance-tests (BWATS)'
  task :bwats, [:iaas] do |t, args|
    root_dir = File.expand_path('../../../..', __FILE__)
    build_dir = File.join(root_dir,'build')

    ginkgo = File.join(build_dir, windows? ? 'gingko.exe' : 'ginkgo')
    test_path = File.join(
      root_dir, 'src', 'github.com', 'cloudfoundry-incubator',
      'bosh-windows-acceptance-tests'
    )
    ENV["CONFIG_JSON"] = args.extras[0] || File.join(build_dir,"config.json")
    ENV["GOPATH"] = root_dir
    exec_command("#{ginkgo} -r -v #{test_path}")
  end
end
