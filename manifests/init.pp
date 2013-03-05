# == Class: nss
#
# This module manages nss of a Linux system.
# The Name Service System is a core feature in Linux and as such
# is not installable, so by simply including this class using the defaults will
# do next to nothing. Instead refer to the number of sub name spaced
# classes such as nss::ldap or the define nss::directive unless you want
# to fully manage nsswitch.conf via other means
#
# === Parameters
#
# [*source*]
#   Path to static Puppet file to use for nsswitch.conf
#   Valid values: <tt>puppet:///modules/mymodule/path/to/file.conf</tt>
#
# [*content*]
#   Content to use for nsswitch.conf
#   Valid values: <tt>content</tt>
#
# === Sample Usage
#
# include nss
#
class nss (
  $source   = 'UNDEF',
  $content  = 'UNDEF'
) {

  include nss::params

  $source_real = $source ? {
    'UNDEF' => $nss::params::source,
    default => $source
  }
  $content_real = $content ? {
    'UNDEF' => $nss::params::content,
    default => $content
  }

  if $source_real != '' and $content_real != '' {
    fail('Parameter source and content cannot be set at the same time.')
  } elsif $source_real != '' {
    File ['nsswitch/config'] {
      source => $source_real
    }
  } else {
    File ['nsswitch/config'] {
      content => $content_real
    }
  }

  file { 'nsswitch/config':
    ensure  => file,
    path    => $nss::params::config_file,
    owner   => root,
    group   => root,
  }

}
