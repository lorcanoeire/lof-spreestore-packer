require 'aws-sdk'
require 'json'

def find_base_ami(previous_build_result)
  result = JSON.parse(File.read(previous_build_result))
  result['ami']
end

def execute(command)
  puts "==> Executing command: #{command}"
  sh(command)
end

def ami_type
  'tbc...'
end

def aws_configure
  Aws.config[:credentials] = Aws::Credentials.new(
    ENV['AWS_ACCESS_KEY_ID'],
    ENV['AWS_SECRET_ACCESS_KEY'])
  Aws.config[:region] = ENV['AWS_DEFAULT_REGION'] || 'ap-southeast-2'
end

def aws_find_ami(build_name, build_number, build_revision)
  filters = [
    { name: 'tag:Build-Name', values: [build_name], },
    { name: 'tag:Build-Number', values: [build_number], },
    { name: 'tag:Build-Revision', values: [build_revision], },
  ]
  aws_configure
  aws_ec2 = Aws::EC2::Client.new
  matches = aws_ec2.describe_images({ filters: filters }).images
  abort "Could not find the AMI matching the following filters: #{filters}" if matches.empty?
  matches[0]
end

def export_build_result(file, ami)
  File.open(file, 'w') do |f|
    f.write(JSON.pretty_generate({
      'ami' => {
      'id'   => ami.image_id,
      'type' => ami_type,
      'name' => ami.name,
      'date' => ami.creation_date,
    }}))
  end
end

desc "Checking that the AWS credentials are specified"
task :check_aws_environment do
  abort "Error, environment variable AWS_ACCESS_KEY_ID is not set" unless ENV['AWS_ACCESS_KEY_ID']
  abort "Error, environment variable AWS_SECRET_ACCESS_KEY is not set" unless ENV['AWS_SECRET_ACCESS_KEY']
end

desc "packer build with ansible. 'd' for debug, prod or non_prod for environment"
task :packer_ansible_build, [:ami, :debug, :environment] => [:check_aws_environment] do |t, args|
  build_number = Time.now.to_i

  execute("packer build #{args[:debug] ? '-debug ' : ''}"\
        " -var-file=templates/staging/defaults.var"\
        " -var 'base_ami=#{args[:ami]}'"\
        " -var 'base_ami_name=Spreestore Staging AMI'"\
        " -var 'type=#{ami_type}'"\
        " -var 'build_name=local_build'"\
        " -var 'build_number=#{build_number}'"\
        " -var 'build_revision=local_build'"\
        " -var 'vault_environment=#{args[:environment]}'"\
        " templates/staging/spreestore-staging.json")
end
