require 'spec_helper'

describe 'nss::directive' do

  # set depending facts
  let (:facts) { {
    :operatingsystem  => 'Ubuntu'
  } }

  context 'with database => passwd, service => ldap' do
    let (:title) { 'passwd_ldap' }
    let (:name) { 'passwd_ldap' }
    let (:params) { {
      :database => 'passwd',
      :service  => 'ldap'
    } }
    it do should contain_exec('nss_add_passwd_ldap').with(
      'command' => "sed -i 's/^passwd:\\(.*\\)/passwd:\\1 ldap/g' /etc/nsswitch.conf",
      'unless'  => "grep '^passwd:' /etc/nsswitch.conf | grep 'ldap'"
    ) end
  end

  context 'with ensure => absent, database => passwd, service => ldap' do
    let (:title) { 'passwd_ldap' }
    let (:name) { 'passwd_ldap' }
    let (:params) { {
      :ensure   => 'absent',
      :database => 'passwd',
      :service  => 'ldap'
    } }
    it do should contain_exec('nss_remove_passwd_ldap').with(
      'command' => "sed -i 's/^\\(passwd:.*\\)ldap\\(.*\\)$/\\1\\2/g' /etc/nsswitch.conf",
      'onlyif'  => "grep '^passwd:' /etc/nsswitch.conf | grep 'ldap'"
    ) end
  end

  context 'with database => bogus, service => bill' do
    let (:title) { 'bogus_bill' }
    let (:name) { 'bogus_bill' }
    let (:params) { {
      :database => 'bogus',
      :service  => 'bill'
    } }
    it do
      expect {
        should contain_class('nss::params')
      }.to raise_error(Puppet::Error, /"bogus" does not match /)
    end
  end

end
