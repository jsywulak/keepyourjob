require 'aws-sdk-core'

cfn = Aws::CloudFormation.new(region: "eu-west-1")

hellostelligent = nil

cfn.describe_stacks.stacks.each do |stack|
  if stack.stack_name.include? "HelloStelligent"
    hellostelligent = stack
    break
  end
end

if hellostelligent.nil?                                then raise "Couldn't find HelloStelligent stack. Did you run the CloudFormation template?" end
if hellostelligent.stack_status != "CREATE_COMPLETE"   then raise "Stack isn't complete yet; wait for the Stack to be in CREATE_COMPLETE status before running the tests" end

env = nil
cfn.describe_stack_resources(stack_name: hellostelligent.stack_name).stack_resources.each do |resource|
  if resource.resource_type == "AWS::ElasticBeanstalk::Environment"
    env = resource
    break
  end
end

if env.nil? then raise "Couldn't find the environment in the CloudFormation stack... this shouldn't happen and there's no way to recover. Sorry. :(" end

ebs = Aws::ElasticBeanstalk.new(region: "eu-west-1")
load_balancer = ebs.describe_environment_resources(environment_name: env.physical_resource_id).environment_resources.load_balancers.first

elb = Aws::ElasticLoadBalancing.new(region: "eu-west-1")
elb_dns = elb.describe_load_balancers(load_balancer_names: [load_balancer.name]).load_balancer_descriptions.first.dns_name

url = "http://#{elb_dns}/"

response = Net::HTTP.get_response(URI.parse(url).host, URI.parse(url).path)

if response.code != "200"     then raise "Non 200 code returned!" end
if response.body.length == 0  then raise "No data receieved" end

puts "OK"