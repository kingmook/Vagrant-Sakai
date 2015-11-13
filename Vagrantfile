Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-6.7"
  
  	config.vm.define "sakaidev" do |sakaidev|
		sakaidev.vm.hostname = "sakaidev.sakaiproject.org"
	end
	
	config.ssh.username = 'root'
	config.ssh.password = 'vagrant'
	config.ssh.insert_key = 'true'
		
	config.vm.network :forwarded_port, guest: 8080, host: 8888
	config.vm.network :forwarded_port, guest: 8000, host: 5005
	
	config.vm.provision :shell, :path => "install.sh"
  
end