require 'packer/config'
require 'timecop'

describe Packer::Config do
  before(:each) do
    Timecop.freeze(Time.now.getutc)
  end

  after(:each) do
    Timecop.return
  end

  describe 'VSphereAddUpdates' do
    describe 'builders' do
      it 'returns the expected builders' do
        builders = Packer::Config::VSphereAddUpdates.new(
          output_directory: 'output_directory',
          num_vcpus: 1,
          mem_size: 1000,
          administrator_password: 'password',
          source_path: 'source_path'
        ).builders
        expect(builders[0]).to eq(
          'type' => 'vmware-vmx',
          'source_path' => 'source_path',
          'headless' => false,
          'boot_wait' => '2m',
          'communicator' => 'winrm',
          'winrm_username' => 'Administrator',
          'winrm_password' => 'password',
          'winrm_timeout' => '6h',
          'winrm_insecure' => true,
          'vm_name' => 'packer-vmx',
          'shutdown_command' => "C:\\Windows\\System32\\shutdown.exe /s",
          'shutdown_timeout' => '1h',
          'vmx_data' => {
            'memsize' => '1000',
            'numvcpus' => '1',
            'displayname' => "packer-vmx-#{Time.now.getutc.to_i}"
          },
          'output_directory' => 'output_directory'
        )
      end
    end

    describe 'provisioners' do
      it 'returns the expected provisioners' do
        allow(SecureRandom).to receive(:hex).and_return("some-password")

        provisioners = Packer::Config::VSphereAddUpdates.new(
          output_directory: 'output_directory',
          num_vcpus: 1,
          mem_size: 1000,
          administrator_password: 'password',
          source_path: 'source_path'
        ).provisioners

        expect(provisioners).to eq(
          [
            Packer::Config::Provisioners::BOSH_PSMODULES,
            Packer::Config::Provisioners::NEW_PROVISIONER,
            Packer::Config::Provisioners.install_windows_updates,
            Packer::Config::Provisioners::GET_LOG,
            Packer::Config::Provisioners::CLEAR_PROVISIONER
          ].flatten
        )
      end
    end
  end

  describe 'VSphere' do
    describe 'builders' do
      it 'returns the expected builders' do
        builders = Packer::Config::VSphere.new(
          output_directory: 'output_directory',
          num_vcpus: 1,
          mem_size: 1000,
          product_key: 'key',
          organization: 'me',
          owner: 'me',
          administrator_password: 'password',
          source_path: 'source_path'
        ).builders
        expect(builders[0]).to eq(
          'type' => 'vmware-vmx',
          'source_path' => 'source_path',
          'headless' => false,
          'boot_wait' => '2m',
          'shutdown_command' => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -Command Invoke-Sysprep -IaaS vsphere -NewPassword password -ProductKey key -Owner me -Organization me',
          'shutdown_timeout' => '1h',
          'communicator' => 'winrm',
          'ssh_username' => 'Administrator',
          'winrm_username' => 'Administrator',
          'winrm_password' => 'password',
          'winrm_timeout' => '1h',
          'winrm_insecure' => true,
          'vm_name' => 'packer-vmx',
          'vmx_data' => {
            'memsize' => '1000',
            'numvcpus' => '1',
            'displayname' => "packer-vmx-#{Time.now.getutc.to_i}"
          },
          'output_directory' => 'output_directory',
          'skip_clean_files' => true
        )
      end
    end

    describe 'provisioners' do
      it 'returns the expected provisioners' do
        stemcell_deps_dir = Dir.mktmpdir('vsphere')
        ENV['STEMCELL_DEPS_DIR'] = stemcell_deps_dir

        allow(SecureRandom).to receive(:hex).and_return('some-password')

        provisioners = Packer::Config::VSphere.new(
          output_directory: 'output_directory',
          num_vcpus: 1,
          mem_size: 1000,
          product_key: 'key',
          organization: 'me',
          owner: 'me',
          administrator_password: 'password',
          source_path: 'source_path'
        ).provisioners
        expect(provisioners).to eq(
          [
            Packer::Config::Provisioners::BOSH_PSMODULES,
            Packer::Config::Provisioners::NEW_PROVISIONER,
            Packer::Config::Provisioners::INSTALL_CF_FEATURES,
            Packer::Config::Provisioners.install_windows_updates,
            Packer::Config::Provisioners::PROTECT_CF_CELL,
            Packer::Config::Provisioners::lgpo_exe,
            Packer::Config::Provisioners::install_agent('vsphere'),
            Packer::Config::Provisioners.download_windows_updates('output_directory'),
            Packer::Config::Provisioners::OPTIMIZE_DISK,
            Packer::Config::Provisioners::COMPRESS_DISK,
            Packer::Config::Provisioners::CLEAR_PROVISIONER,
          ].flatten
        )

        FileUtils.rm_rf(stemcell_deps_dir)
        ENV.delete('STEMCELL_DEPS_DIR')
      end
    end
  end
end
