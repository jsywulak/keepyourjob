hello, stelligent.
===========

This repo contains a CloudFormation template that spins up a "Hello, Stelligent!" sample application.

To run this, you'll need the [AWS CLI tools installed and configured](https://aws.amazon.com/cli/). Once that's done, run this command:

    aws cloudformation create-stack --stack-name HelloStelligent-`date +%Y%m%d%H%M%S` --template-body "`cat hellostelligent.template`"  --disable-rollback  --output json --timeout-in-minutes 60 --region eu-west-1

(The region part is important, since Elastic Beanstalk only looks in buckets in the same region, apparently? The application code is stored in EU-West-1.)

(Also, leave the stack name as-is, the test looks up the CloudFormation stack via the name.)

To run the tests, you need to have Ruby and the AWS SDK Core Gem installed. Instructions for installing Ruby [are here](https://www.ruby-lang.org/en/downloads/). Once that is done, to install the AWS SDK Core Gem, punch in

    gem install aws-sdk-core --pre

You'll also need to export your AWS access credentials to environment variables so the SDK can find them. (You can find these on the [IAM control panel](https://console.aws.amazon.com/iam/home?region=eu-west-1#))

    export AWS_ACCESS_KEY_ID=youraccesskey
    export AWS_SECRET_ACCESS_KEY=yoursecretkey
    
(If you're running Windows, savings vars is [handled a little differently.](http://ss64.com/nt/set.html))

Once the CloudFormation stack is complete, you can go to the [Elastic Beanstalk console](https://console.aws.amazon.com/elasticbeanstalk/) and select the "Hello Stelligent" application. At the top of the page it will list a URL that will take you to the "Hello, Stelligent" page.

Once that's done, just run the test script with ruby:

    ruby test_environment.rb

If anything goes wrong it'll spit out a stack trace, and if everything works it'll print out OK.

Once you're done looking at the stack and running tests, you can delete the stack from the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation/). The name of the stack will start with "hellostelligent" follow by a timestamp.
