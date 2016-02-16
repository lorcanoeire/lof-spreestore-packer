require 'aws-sdk'
require 'json'
require 'dotenv'

Dotenv.load

def execute(command)
  puts "==> Executing command: #{command}"
  sh(command)
end

desc "Check if AWS credentials are specified"
task :check_aws_environment do
  abort "Error, environment variable AWS_ACCESS_KEY_ID is not set" unless ENV['AWS_ACCESS_KEY_ID']
  abort "Error, environment variable AWS_SECRET_ACCESS_KEY is not set" unless ENV['AWS_SECRET_ACCESS_KEY']
end

desc "Packer build with ansible. 'd' for debug, prod or non_prod for environment"
task :packer_ansible_build, [:ami, :debug, :environment] => [:check_aws_environment] do |t, args|

  build_number = Time.now.to_i

  execute("packer build #{args[:debug] ? '-debug ' : ''}"\
        " -var-file=templates/staging/defaults.var"\
        " -var 'base_ami=#{args[:ami]}'"\
        " -var 'base_ami_name=Spreestore Staging AMI'"\
        " -var 'build_name=local_build'"\
        " -var 'build_number=#{build_number}'"\
        " -var 'build_revision=local_build'"\
        " -var 'vault_environment=#{args[:environment]}'"\
        " templates/staging/spreestore-staging.json")
end
