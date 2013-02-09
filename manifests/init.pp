# == Class: nss
#
# This module manages nss of a Linux system.
# The Name Service System is a core feature in Linux and as such
# is not installable, so by simply including this class using the defaults will
# do next to nothing. Instead refer to the number of sub name spaced
# classes such as nss::ldap or the define nss::directive
#
# === Parameters
#
# [*source*]
#   Path to static Puppet file to use
#   Valid values: <tt>puppet:///modules/mymodule/path/to/file.conf</tt>
#
# [*template*]
#   Path to ERB puppet template file to use
#   Valid values: <tt>mymodule/path/to/file.conf.erb</tt>
#
# [*parameters*]
#   Parameters to provide if using custom template
#   Valid values: hash, ex:  <tt>{ 'option' => 'value' }</tt>
#
# === Requires: see Modulefile
#
# === Sample Usage
#
# include nss
#
# === Author
#
# Johan Lyheden <johan.lyheden@artificial-solutions.com>
#
class nss ( $source = $nss::params::source,
            $template = $nss::params::template,
            $parameters = {} ) inherits nss::params {

  $manage_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_file_content = $template ? {
    ''        => undef,
    default   => template($template),
  }

  file { $nss::params::config_file:
    ensure  => file,
    owner   => root,
    group   => root,
    content => $manage_file_content,
    source  => $manage_file_source
  }
}