require 'spec_helper'
describe 'sumologic::install' do
  # stub out staging::file
  let(:pre_condition) { 'define staging::file($source, $target) {}' }

  let(:params) do
    { accessid: 'id', accesskey: 'key', user: 'bob', clobber: true, ephemeral: false, collector_name: 'node.domain',
      install_dir: '/usr/local/sumo', installer_url: 'https://example.com/installer', installer_file: '/var/run/sumo64.sh' }
  end

  it { should contain_class('sumologic::install') }

  it 'should download the collector installer' do
    should contain_staging__file('sumologic-installer').with_source('https://example.com/installer').with_target('/var/run/sumo64.sh')
  end

  it 'should run the collector installer, passing parameters on the commandline' do
    should contain_exec('install-sumologic-collector')
      .with_command('/bin/sh /var/run/sumo64.sh -q -dir /usr/local/sumo -VrunAs.username=bob -Vclobber=true -Vcollector.name=node.domain '\
                    '-Vsumo.accessid=id -Vsumo.accesskey=key -Vephemeral=false')
      .with_cwd('/var/run')
      .with_creates('/usr/local/sumo')
      .that_requires('Staging::File[sumologic-installer]')
  end
end
