require 'spec_helper'
describe 'sumologic' do
  let(:facts) { { fqdn: 'node.domain' } }

  # stub out staging::file
  let(:pre_condition) { 'define staging::file($source, $target) {}' }

  context 'with accessid and accesskey' do
    let(:params) { { accessid: 'id', accesskey: 'key' } }

    it { should contain_class('sumologic') }

    it 'should create the sumo user' do
      should contain_user('sumo').that_comes_before('Class[Sumologic::Install]')
    end

    it 'should pass parameters to sumologic::install' do
      should contain_class('sumologic::install')
        .with_accessid('id')
        .with_accesskey('key')
        .with_user('sumo')
        .with_clobber(false)
        .with_ephemeral(false)
        .with_collector_name('node.domain')
        .with_install_dir('/opt/SumoCollector')
        .with_installer_url('https://collectors.sumologic.com/rest/download/linux/64')
        .with_installer_file('/opt/sumo-installer.sh')
    end

    it 'should ensure the collector service is enabled and running' do
      should contain_service('collector')
        .with_enable(true)
        .with_ensure('running')
        .with_provider('init')
        .that_requires('Class[Sumologic::Install]')
    end

    context 'with manage_user=false' do
      let(:params) { super().merge(manage_user: false) }

      it { should_not contain_user('sumo') }
    end

    context 'with non-default parameters' do
      let(:params) do
        super().merge(user: 'bob', clobber: true, ephemeral: true, collector_name: 'special', install_dir: '/usr/local/SumoCollector',
                      installer_url: 'https://example.com/installer.sh', installer_file: '/tmp/sumo64.sh', service_provider: 'debian')
      end

      it 'should create the specified user' do
        should contain_user('bob').that_comes_before('Class[Sumologic::Install]')
      end

      it 'should pass parameters to sumologic::install' do
        should contain_class('sumologic::install')
          .with_accessid('id')
          .with_accesskey('key')
          .with_user('bob')
          .with_clobber(true)
          .with_ephemeral(true)
          .with_collector_name('special')
          .with_install_dir('/usr/local/SumoCollector')
          .with_installer_url('https://example.com/installer.sh')
          .with_installer_file('/tmp/sumo64.sh')
      end

      it 'should use the service provider to manage the service' do
        should contain_service('collector').with_provider('debian')
      end

      context 'with manage_user=false' do
        let(:params) { super().merge(manage_user: false) }

        it { should_not contain_user('bob') }
      end
    end
  end

  %i(accessid accesskey).each do |required_param|
    context "missing #{required_param}" do
      let(:params) { { accessid: 'id', accesskey: 'key' }.reject { |k, _| k == required_param } }

      it { should compile.and_raise_error(/accessid and accesskey are required/) }
    end
  end
end
