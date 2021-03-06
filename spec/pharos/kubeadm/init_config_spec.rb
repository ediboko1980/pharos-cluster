require "pharos/phases/configure_master"

describe Pharos::Kubeadm::InitConfig do
  let(:master) { Pharos::Configuration::Host.new(address: 'test', private_address: 'private', role: 'master') }
  let(:config_hosts_count) { 1 }

  let(:config) { Pharos::Config.new(
      hosts: (1..config_hosts_count).map { |i| Pharos::Configuration::Host.new(role: 'worker') },
      network: {
        service_cidr: '1.2.3.4/16',
        pod_network_cidr: '10.0.0.0/16'
      },
      addons: {},
      etcd: {}
  ) }

  subject { described_class.new(config, master) }

  describe '#generate' do

    it 'comes with correct master addresses' do
      config.hosts << master
      config = subject.generate
      expect(config.dig('localAPIEndpoint', 'advertiseAddress')).to eq('private')
    end
  end
end
