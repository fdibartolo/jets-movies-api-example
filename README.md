# Sample full Ruby Serverless, CI/CD project :muscle: :heart:

This is a demo [RubyOnJets](http://rubyonjets.com/) project meant to be used as a sample stack, during dev team coaching/training sessions :nerd_face:

## Prerequisites (besides ruby, right? :stuck_out_tongue_winking_eye:)
* [AWS account](https://aws.amazon.com/console/), free tier is more than enough
* [JRE](https://java.com/en/) 7+, in order to run a local isolated DynamoDB instance
* [Terraform](https://www.terraform.io/), **only if** deploying from local
* [Docker](https://docs.docker.com/get-docker/), **only if** deploying from local Jenkins container

> as of now, jets depends on ruby ~> 2.5, so make sure you use a revision under this version, 2.5.3 in my case. 

## Development

#### Database Setup
A few things needs to be done as a one-time-activity...
1. If not present, you need to download [DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.DownloadingAndRunning.html), to be used while running locally.
2. Extract the downloaded zip file into the `db` folder. Keep track of the folder name that was created while extracting the file (unless the name is _dynamodb_local_latest_ :+1:)

#### Database seed (optional)

_TBD_

#### Starting local instance

The project leverages [foreman](https://github.com/ddollar/foreman) in order to manage the different processes (web server and dynamodb).

> if the folder name while unzipping dynamodb is different than _dynamodb_local_latest_, you will need to update the 
 `./Procfile`. Also update it if for some reason, you have decided to extract/use it from somewhere else if your computer.

In order to start the local instance, just run:

  `$ bin/start`

> for the very first time, you might need to give executable permissions to the script: `chmod 777 bin/start`

_TBD delete rake task ??_

## Deploying to AWS

First thing we need to do is to create a AWS IAM user with the proper policy configuration, so all the resources can be created upon deploying the solution. This can be done through the [AWS console](https://aws.amazon.com/console/), or from the terminal leveraging the _aws-cli_. One way or the other, just follow the official doc: [Minimal Deploy IAM Policy](https://rubyonjets.com/docs/extras/minimal-deploy-iam/). 

<a name="keys"></a>
**Access keys**
If not done yet in the AWS console, go to IAM > Users > [_created user_] > Security Credentials tab, and create an access key pair... they will be used in a little bit.

Depending on how you want to deploy, follow one of the two options below:
* [from local workstation](#local)
* [from Jenkins pipeline](#jenkins)
 
<a name="local"></a>
## Deploying from local workstation

_TBD_
aws configure
JETS_AGREE

<a name="jenkins"></a>
## CI/CD with Jenkins pipeline

#### Build the container image
`$ docker image build -t jenkins-docker -f Dockerfile.ci `
 
#### Setup Jenkins for the first and only time
Spin up a container from the image we just built:
```
$ docker container run -d --name jenkinsci \
   -v /var/run/docker.sock:/var/run/docker.sock \
   -p 8080:8080 jenkins-docker
```
From the logs, grab the initial admin password. By running `docker logs`, you should find something like this:
```
*************************************************************
*************************************************************
*************************************************************

Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

123456789abcdef6a7280dcc03cd4d1d
```
Then, go to `http:\\localhost:8080` in order to complete the setup. When prompted, go with the option of _install suggested plugins_. 

#### Start and stop the container
From now on, you can just start and stop the container by running
````
// start
$ docker container start jenkinsci

// stop
$ docker container stop jenkinsci
````

#### Jenkins plugins & config
Two extra plugins needs to be installed, which can be done under the _Manage Jenkins > Manage Plugins_. Look for and install:
* [Pipeline: AWS Steps](https://plugins.jenkins.io/pipeline-aws)
* [CloudBees AWS Credentials](https://plugins.jenkins.io/aws-credentials)


Let's go ahead and create the user credentials to be used for deployment. This can be done under the _Credentials_ section. Go ahead and add a new item with:
* ID: **jets_iam_user**
* Access Key ID & Secret Access Key: keys generated [above](#keys) :top:

#### Job setup

_TBD_
