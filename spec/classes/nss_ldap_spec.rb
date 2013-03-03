require 'spec_helper'

describe 'nss::ldap' do

  # set depending facts
  let (:facts) { {
    :operatingsystem  => 'Ubuntu'
  } } 

  context 'with default params' do
    it do should contain_package('nss_ldap').with(
      'ensure'  => 'present',
      'name'    => 'libnss-ldapd'
    ) end
    it do should contain_nss__directive('passwd_ldap').with(
      'ensure'    => 'present',
      'service'   => 'ldap',
      'database'  => 'passwd',
      'require'   => 'Package[nss_ldap]'
    ) end
    it do should contain_nss__directive('group_ldap').with(
      'ensure'    => 'present',
      'service'   => 'ldap',
      'database'  => 'group',
      'require'   => 'Package[nss_ldap]'
    ) end
    it do should contain_nss__directive('shadow_ldap').with(
      'ensure'    => 'present',
      'service'   => 'ldap',
      'database'  => 'shadow',
      'require'   => 'Package[nss_ldap]'
    ) end 
  end

  context 'with autoupgrade => true' do
    let (:params) { {
      :autoupgrade  => true
    } }
    it do should contain_package('nss_ldap').with(
      'ensure'  => 'latest'
    ) end
  end

  context 'with ensure => purged' do
    let (:params) { {
      :ensure => 'purged'
    } }
    it do should contain_nss__directive('passwd_ldap').with(
      'ensure'  => 'absent'
    ) end
    it do should contain_nss__directive('group_ldap').with(
      'ensure'  => 'absent'
    ) end
    it do should contain_nss__directive('shadow_ldap').with(
      'ensure'  => 'absent'
    ) end
  end

  context 'with invalid operatingsystem' do
    let (:facts) { {
      :operatingsystem => 'beos'
    } }
    it do
      expect {
        should contain_class('pam::params')
      }.to raise_error(Puppet::Error, /Unsupported operatingsystem beos/)
    end
  end

end
