require 'spec_helper'

describe 'nss' do

  # set depending facts
  let (:facts) { {
    :operatingsystem  => 'Ubuntu'
  } } 

  context 'with default params' do
    it do should contain_file('nsswitch/config').with(
      'ensure'    => 'file',
      'owner'     => 'root',
      'group'     => 'root',
      'path'      => '/etc/nsswitch.conf'
    ).without(['source','content']) end
  end

  context 'with source => puppet:///modules/mymodule/myfile' do
    let (:params) { {
      :source => 'puppet:///modules/mymodule/myfile'
    } }
    it do should contain_file('nsswitch/config').with(
      'content'   => nil,
      'source'    => 'puppet:///modules/mymodule/myfile'
    ) end
  end

  context 'with content => "some content"' do
    let (:params) { {
      :content => 'some content'
    } }
    it do should contain_file('nsswitch/config').with(
      'content'   => 'some content',
      'source'    => nil
    ) end
  end

  context 'with source => puppet:///modules/mymodule/myfile, content => "some content"' do
    let (:params) { {
      :source   => 'puppet:///modules/mymodule/myfile',
      :content  => 'some content'
    } }
    it do
      expect {
        should contain_class('nss::params')
      }.to raise_error(Puppet::Error, /Parameter source and content cannot be set at the same time/)
    end
  end

  context 'with invalid operatingsystem' do
    let (:facts) { {
      :operatingsystem => 'beos'
    } }
    it do
      expect {
        should contain_class('nss::params')
      }.to raise_error(Puppet::Error, /Unsupported operatingsystem beos/)
    end
  end

end
