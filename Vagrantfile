VAGRANTFILE_API_VERSION = "2"

# define hostname
$ip = "192.168.50.6"
NAME = "odi-vagrant"

unless Vagrant.has_plugin?("vagrant-proxyconf")
  puts 'Installing vagrant-proxyconf Plugin...'
  system('vagrant plugin install vagrant-proxyconf')
end

# get host time zone for setting VM time zone, if possible
# can override in env section below
offset_sec = Time.now.gmt_offset
if (offset_sec % (60 * 60)) == 0
  offset_hr = ((offset_sec / 60) / 60)
  timezone_suffix = offset_hr >= 0 ? "-#{offset_hr.to_s}" : "+#{(-offset_hr).to_s}"
  SYSTEM_TIMEZONE = 'Etc/GMT' + timezone_suffix
else
  # if host time zone isn't an integer hour offset, fall back to UTC
  SYSTEM_TIMEZONE = 'UTC'
end

$upgrade = <<-SCRIPT
yum update -y
yum upgrade -y
yum install -y kernel
yum install -y kernel-devel
yum install -y gcc
SCRIPT


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "deo/centos7-gui"
  config.vm.define NAME
  
  config.vm.box_check_update = false
  
  # change memory size
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.name = NAME
	v.gui = true
  end

  # VM hostname
  config.vm.hostname = NAME
  config.vm.network "private_network", ip: $ip

  # Provision everything on the first run

  config.vm.provision "shell", path: "install_odi.sh"

end
