require 'tempfile'
require 'json'
require 'English'
require 'open3'
+ENV['PACKER_LOG'] = '1'

module Packer
  class Runner
    class ErrorInvalidConfig < RuntimeError
    end

    def initialize(config)
      @config = config
    end

    def run(command, args={})
      config_file = Tempfile.new('')
      config_file.write(@config)
      config_file.close

      args_combined = ''
      args.each do |name, value|
        args_combined += "-var \"#{name}=#{value}\""
      end

     
      packer_command = "packer #{command} -machine-readable #{args_combined} -on-error=abort #{config_file.path}"

      Open3.popen2e(packer_command) do |stdin, out, wait_thr|
        yield(out) if block_given?
        return wait_thr.value
      end
    end
  end
end
