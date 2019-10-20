# @summary establishes various defaults for use in other gluster manifests
# @api private
# @author Scott Merrill <smerrill@covermymeds.com>
# @note Copyright 2014 CoverMyMeds, unless otherwise noted
#
class gluster::params {

  # parameters dealing with installation
  $install_server = true
  $install_client = true
  $release        = '7.3'
  $version        = 'LATEST'

  # Set distro/release specific names, repo versions, repo gpg keys, package versions, etc
  # if the user didn't specify a version, just use "installed" for package version.
  # if they did specify a version, assume they provided a valid one
  case $::osfamily {
    'RedHat': {
      $repo             = true
      $repo_key_source  = 'https://raw.githubusercontent.com/CentOS-Storage-SIG/centos-release-storage-common/master/RPM-GPG-KEY-CentOS-SIG-Storage'

      $server_package = $::operatingsystemmajrelease ? {
        # RHEL 6 and 7 provide Gluster packages natively
        /(6|7)/ => 'glusterfs-server',
        default => false
      }
      $client_package = $::operatingsystemmajrelease ? {
        /(6|7)/ => 'glusterfs-fuse',
        default => false,
      }

      $service_name = 'glusterd'
    }
    'Debian': {
      $repo            = true
      $server_package  = 'glusterfs-server'
      $client_package  = 'glusterfs-client'
      $service_name    = 'glusterd'
      $repo_key_source = "https://download.gluster.org/pub/gluster/glusterfs/${release}/rsa.pub"
    }
    'Archlinux': {
      $repo = false
      $server_package  = 'glusterfs'
      $client_package  = 'glusterfs'
      $service_name    = 'glusterd'
      $repo_key_source = undef
    }
    'Suse': {
      $repo = false
      $server_package  = 'glusterfs'
      $client_package  = 'glusterfs'
      $service_name    = 'glusterd'
      $repo_key_source = undef
    }
    default: {
      $repo = false
      # these packages are the upstream names
      $server_package  = 'glusterfs-server'
      $client_package  = 'glusterfs-fuse'
      $repo_key_source = undef
      $service_name    = 'glusterfs-server'
    }
  }


  # parameters dealing with a Gluster server instance
  $service_enable = true
  $service_ensure = true
  $pool = 'default'
  $export_resources = true

  # parameters dealing with bricks

  # parameters dealing with volumes
}
