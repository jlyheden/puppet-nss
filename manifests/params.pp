class nss::params {
  $valid_databases = [ 'aliases', 'ethers', 'group', 'hosts', 'netgroup', 'networks', 'passwd', 'protocols', 'publickey', 'rpc', 'services', 'shadow' ]
  $config_file = '/etc/nsswitch.conf'
  $template = undef
  $source = undef
  $nss_ldap_package = 'libnss-ldap'
  $ensure = 'present'
  $autoupgrade = false
}