require 'aws-sdk'
require 'json'
require 'dotenv/tasks'

def execute(command)
  puts "==> Executing command: #{command}"
  sh(command)
end

desc "Check if required environment variables are specified"
task :check_environment => :dotenv do
  abort "Error, environment variable AWS_ACCESS_KEY_ID is not set" unless ENV['AWS_ACCESS_KEY_ID']
  abort "Error, environment variable AWS_SECRET_ACCESS_KEY is not set" unless ENV['AWS_SECRET_ACCESS_KEY']
  abort "Error, environment variable ANSIBLE_CONFIG is not set" unless ENV['ANSIBLE_CONFIG']
  system('echo "Using Ansible Configuration: $ANSIBLE_CONFIG"')
end

desc "Packer build with ansible. ami, vpc_id, 'd' for debug, prod or non_prod for environment"
task :packer_ansible_build, [:ami,:vpc_id,:environment,:name,:debug] => [:check_environment] do |t, args|

  build_number = Time.now.strftime("%H.%M %d %B")

  execute("packer build #{args[:debug] ? '-debug ' : ''}"\
        " -var 'vpc_id=#{args[:vpc_id]}'"\
        " -var 'base_ami=#{args[:ami]}'"\
        " -var 'type=Ubuntu Server 14.04 LTS'"\
        " -var 'base_ami_name=#{args[:name]} staging AMI'"\
        " -var 'build_name=#{args[:name]}'"\
        " -var 'build_number=#{build_number}'"\
        " -var 'build_revision=local_build'"\
        " -var 'vault_environment=#{args[:environment]}'"\
        " templates/staging/staging.json")
end

desc "Pull Galaxy Dependancies"
task :galaxy => [:check_environment] do |t, args|
  execute("/usr/local/bin/ansible-galaxy install -r galaxy.yml")
end
