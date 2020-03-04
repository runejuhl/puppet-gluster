require 'spec_helper'

describe 'gluster::repo::apt', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let :pre_condition do
        'require ::gluster::params'
      end

      case facts[:osfamily]
      when 'Debian'
        context 'with all defaults' do
          it { is_expected.to contain_class('gluster::repo::apt') }
          it { is_expected.to compile.with_all_deps }
          it 'installs' do
            is_expected.to contain_apt__source('glusterfs-LATEST').with(
              repos: 'main',
              location: "https://download.gluster.org/pub/gluster/glusterfs/7/LATEST/Debian/#{facts[:lsbdistcodename]}/#{facts[:architecture]}/apt/"
            )
          end
        end
        context 'unsupported architecture' do
          let :facts do
            super().merge(
              architecture: 'zLinux'
            )
          end

          it 'does not install' do
            expect do
              is_expected.to create_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-gluster.pub')
            end.to raise_error(Puppet::Error, %r{not yet supported})
          end
        end
        context 'latest Gluster with priority' do
          let :params do
            {
              priority: '700'
            }
          end

          it 'installs' do
            is_expected.to contain_apt__source('glusterfs-LATEST').with(
              repos: 'main',
              location: "https://download.gluster.org/pub/gluster/glusterfs/7/LATEST/Debian/#{facts[:lsbdistcodename]}/#{facts[:architecture]}/apt/",
              pin: '700'
            )
          end
        end

        context 'Specific Gluster release 4.1' do
          let :params do
            {
              release: '4.1'
            }
          end

          it 'installs' do
            is_expected.to contain_apt__source('glusterfs-LATEST').with(
              repos: 'main',
              key: {
                'id' => 'EED3351AFD72E5437C050F0388F6CDEE78FA6D97',
                'key_source' => 'https://download.gluster.org/pub/gluster/glusterfs/4.1/rsa.pub'
              },
              location: "https://download.gluster.org/pub/gluster/glusterfs/4.1/LATEST/Debian/#{facts[:lsbdistcodename]}/amd64/apt/"
            )
          end
        end

        context 'Specific Gluster release 3.12' do
          let :params do
            {
              release: '3.12'
            }
          end

          it 'installs' do
            is_expected.to contain_apt__source('glusterfs-LATEST').with(
              repos: 'main',
              key: {
                'id' => '8B7C364430B66F0B084C0B0C55339A4C6A7BD8D4',
                'key_source' => 'https://download.gluster.org/pub/gluster/glusterfs/3.12/rsa.pub'
              },
              location: "https://download.gluster.org/pub/gluster/glusterfs/01.old-releases/3.12/LATEST/Debian/#{facts[:lsbdistcodename]}/amd64/apt/"
            )
          end
        end
      end
    end
  end
end
