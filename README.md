# Employment Tribunal Full System - For Development / Testing Use Only

This project groups together all the components of the employment tribunal
system for development and test purposes and to perform end to end tests on them 
whilst developing the jadu replacement system.

This allows the test suite to test the entire system to live in this code base - as docker-compose can setup the entire system for you.

Of course, you can do it yourself without docker compose and this is getting easier and easier now we have switched to
all services running behind a single nginx server and using passenger to deal with the rails apps.
If you do want to go down this route, you are on your own for now !!  But, take a look at the diagram below and the files
in the docker/test_server folder - the docker-compose.yml and you can see the
different services and how they are setup to talk to one another - you need to achieve the same thing but running everything on localhost.

The above could be done using 'foreman' (which is partly done in bin/foreman) to bring everything together and if someone 
has the time to do this - or if someone requires that it is done and therefore justifying the time - 
then please reach out to me (Gary Taylor) - or just do it and share it !!

A diagram speaks a thousand words - so hopefully the diagram below will show what I mean.  This is how the docker environment
is setup.  Again, a similar environment using something like 'foreman' could also be setup with some careful configuration.

Also note that the 'test server' are intended to be as close to production as is possible from a config and general architecture point of view, not
performance / scaling.  Hence they run in 'production' environment, but configured to use a test SMTP (mailhog) and AWS/S3 server (minio).

The test SMTP server allows the test suite (via REST) or the developer (via a web page / web server - details further down vvvvv) to see what emails the
application(s) would have sent if they were really being sent to users.

The test AWS/S3 server allows normal S3 requests to take place - i.e. adding files to buckets, deleting them etc.. and these files being made available via
a URL which is accessible within the docker network (or outside if you setup port forwarding).  This means we can test without running up bills or even having
to enter any S3 credential which quite rightly, developers do not really want to do as it may run up bills on their card.
Note that this uses a server called 'minio' which is available for just about any platform.
Minio has a web interface at http://s3.et.127.0.0.1.nip.io:3100 (unless you have changed the domain or port - then adjust as necessary)

## Diagram Showing Test Servers and Test Framework Systems

![diagram 1](docs/diagram_showing_systems.png)

## Use Of 'Passenger' Gem

This project now uses the nginx web server and the 'passenger' gem. This allows the outside world (i.e. us !) to see just a single server
and not have to worry about setting port numbers etc.. for the 4 different services (api, et1, et3 and admin).  It is also
a closer setup to production where everything is behind 'nginx'

It is configured to use the same domain's whether you are working inside the docker network or on your local machine.

Whilst this does not matter 95% of the time, when dealing with pre signed URL's for Amazon S3 stuff - it is signed using
the hostname - so if you were using 's3.et.127.0.0.1' outside of docker and 's3.et' inside of docker - you would get
issues with the signature not matching amongst other problems.

# Cloning

This project is an umbrella project using git submodules (https://git-scm.com/docs/git-submodule).  This is for convenience so that all developers have the
same structure, meaning that docker-compose files etc.. can be setup to span across projects.


So, to clone - do 

```

git clone --recursive git@github.com:ministryofjustice/et-full-system.git

```

or if you already have cloned but forgot the '--recursive'

```
cd et-full-system

git submodule update --init

```

## Submodules Warning

If you are just running this and not making changes - you don't need to concern yourself with this section.

If you haven't used submodules before, its worth studying the docs a little (https://git-scm.com/docs/git-submodule) so that
you don't get yourself and others in a mess.

All of the submodules are checked out in the 'systems' folder and the thing to remember is that the top level git repository does
not store the contents of these folders, but instead it stores like a 'commit pointer' - so it is like saying - 'the code in this folder
comes from this external repository with this commit'

The first word of warning is when you first set it up and possibly when you do a 'git submodule update' - the 'child' git repositories
are in a 'detached head' state.  This means if you start to make changes, then go to commit - it might let you, but you are not
committing to a branch or anything - so it gets confused (I normally join it in feeling confused!!).  I think nowadays it gives you a warning, but its a bit late when youve
just spent all day implementing a fancy new feature in one of these sub projects.

So, if you want to edit any of these submodules in place (you can of course check out another copy of them to a completely isolated folder
, but that way you cannot see your changes in this project until they are pushed and you do a 'git submodule update') - then you should
change directory into the module you want to work on and checkout the branch you want - say 'develop' - then do your normal stuff
including creating new branches etc..

Don't worry too much about leaving it like this either.

However, remember if you commit these 'pointers' to this repository, you may well be changing it to point to a commit
in a branch of a submodule, so remember to create a branch of this repository as well - so that the 'develop' branch
always points to the 'develop' branch (or equivalent) of all of the submodules.  If you also want a branch for your feature that
you are working on, then your branch of this repository can contain pointers to wherever you like to suit your workflow - I would
recomment creating the same branch name for the submodule(s) you are working on and this repository - that way, you can say to
a colleague 'Can you check out this branch of the ET Full System repository and see if it works for you' - knowing that they will
have the right branches of all the submodules too.

Git has an alternative to submodules called a 'subtree' - but at this point in time, my knowledge of these is very limited
but if anyone else does know about them and if they would be better than submodules then we may consider changing.


# Initial Setting Up

The system is very configurable so it can be run on whichever ports you want etc..

# General Development / Testing Notes

## Testing

There are lots of things with regard to automated testing to consider - please read [this document](docs/automated_testing.md) for more details

## Development

If you want to develop parts of the system and use this framework for convenience - please read [this document](docs/development.md)

# Using The Framework

There are scripts in bin/dev to do docker-compose stuff.  Generally these are just shortcuts and accept the
same commands as the docker-compose command line.  So where you see 'up' and 'down' - that is a clue that it is just docker-compose
and you will be able to use other docker-compose command line switches such as '-d' (for detached so you dont view the output all the time).

Whilst we don't want to force you to use docker if you don't want to, right now, it is the only supported way of running this stuff
together.  But, remember these apps are just rails apps and are very configurable using environment variables etc.. so it won't be 
too hard to get it running using other means.

## Firing Up The Test Server

If you just want the defaults and port 3100 is available, simply skip the optional sections below


### (Optional) - Configuring environment variables

If, you are happy with the server running on port 3100 and the domain being 'et.127.0.0.1.nip.io' (so you dont need
to change your hosts file - see below) then you don't need to do anything with environment variables.

The key environment variables are :-

SERVER_DOMAIN - Defaults to 'et.127.0.0.1.nip.io' (correct for default server)
SERVER_PORT - Defaults to '3100' (correct for default server)

These environment variables are the same for both the server and the test suite (if automated test are
 required to be run) and should match.


This means that your default server should be available at http://et.127.0.0.1.nip.io:3100

### (Optional) - Configuring hosts file for shorter url

The servers have been configured to respond to <subdomain>.et.127.0.0.1.nip.io (a public DNS service that will respond with
127.0.0.1) AND <subdomain>.et . However, the latter needs setting up in your hosts file (or any other means that you have
available to add extra DNS stuff).

So, if you are on OSX or Linux - go into a terminal and type

```

sudo bash -c "echo '127.0.0.1       et et1.et et3.et api.et admin.et s3.et mail.et' >> /etc/hosts"

```

Or, if you are on windows - you need to do an equivalent thing.  Please help others once you find out what it is and
update this readme :-)

Once you have done this, you can access the server using this shorter url

http://<subdomain>.et:3100

Where <subdomain> is either et1, et3, admin, api, s3 or mail

### Starting The Server

If you are not changing any environment variables - simply run

```

./bin/dev/test_server up

```

Or, if you want to use the shorter domain (make sure you have modified your hosts file as above) :-

```

SERVER_DOMAIN=et ./bin/test_server up

``` 

Or, if you want a different port

```

SERVER_PORT=3200 ./bin/test_server up

```

or a combination of the above - you get the idea :-)

### Stopping The Server

If ctrl-c doesn't kill the server and associated processes you may occasionally need to do :-

```

./bin/dev/test_server down

```


## Running Tests

You can run tests either from a docker instance or from your local machine. 

However, now that we have the 'single server' approach where all the services are behind a single nginx server, it has
made it much easier to run the tests locally and there is less need to run them from inside docker.

But, the docker stuff hasn't been removed so it is there if you want it.

First, start up the test servers (see  'Firing Up The Test Server' above for more details) like this 

```

./bin/dev/test_server up

```

and wait for everything to settle and you will see the 'Passenger core running in multi-application mode' message near the end

### Running Tests Locally

If you just want to run the tests with the default browser (chromedriver) - once you have done a 'bundle install' you 
can just run cucumber as normal - no external services to run etc...

Note that if you have a non default port or domain when running your server (see the optional sections in 'Firing Up The Server' above),
then you will need to use the same environment variables when running cucumber etc...

So, running cucumber is as simple as :-


```

bundle exec cucumber

```

#### Running Tests With Selenium

If you want to run tests using selenium (so the browser doesn't keep popping up, moving your focus, switching desktops
and generally being annoying) then you will need a selenium server.

The test framework provides this selenium server running inside a VNC server so you can view it if you want.  The VNC 
server can also be used by the test suite to record video of failing tests.  Note that the test framework also provides
a docker instance for running stuff from inside the docker network which in this case is wasted as we are not doing so.

Of course, you are free to provide your own selenium server, but the instructions below apply to using the docker version.

To start the test framework :-

```

./bin/dev/test_framework up

```

and from then on, when running cucumber, specify the browser in the DRIVER environment variable.  To use chrome do the following :-

```

DRIVER=chrome bundle exec cucumber

```

### Running Tests From Inside Docker

Start up the test environment like this :-

```
./bin/dev/test_framework up

```

adding '-d' at the end if you dont want to follow the logs etc..

once the test_framework is up and running - it is just idle doing nothing until you ask it to do something - so I would guess you would
want to run cucumber. However, this is just a 'container' with ruby on it and setup ready for you to go.  So, like any other ruby environment
you need to do a bundle install first (and every time you add a new gem to the Gemfile in THIS project, not the child projects) - like this :-

```

./bin/dev/test_exec bundle install

```

Then, to run cucumber :-


```

./bin/dev/test_exec bundle exec cucumber

```

or, if you prefer to just have a session open inside the 'test machine' - then do :-

```

./bin/dev/test_exec bash

```

then just type in commands as normal - note the app is inside the '/app' folder in the docker machine.

### Video Recording In Tests

Video recording is enabled in the docker version of the test framework - it can also be used if not using docker, however, you
will need to setup a vnc server which contains the 'desktop' that the test suite is talking to via selenium so is more involved.

Video recording can be expensive in terms of time, so it can also be controller by you when running tests.

By default, everything is recorded, but anything but failing tests are thrown away.

To change this behaviour, set the RECORD_VIDEO environment variable before running the test to one of the following values

* on_failure (default) - means record everything but throw away passing tests - useful for seeing what went wrong when developing
* false - means don't record anything
* true - means record everything
* @tag1,@tag2,@anyothertag,~@butnotthisone - Uses cucumber tagging to work out whether to or not (these tags can be anything you want). Useful for presentational purposes for example

#### Video Recording - How It Works

Any docker images with the browser name ending in 'debug' from selenium includes a running VNC server so that you can watch the tests (see below for more details).
So, in the 'Test Framework' dockerfile, the python command line tool called 'vnc2flv' is installed.

In features/support/record_video.rb - this not only makes the decision before and after each scenario whether to record, throw away the
recording etc... - but also, the filename of the recording, which directory it goes into etc..  It then hands over to 'test_common/video_recorder.rb' to do the work.

vnc2flv needs to be told which VNC server to record from.  By default, this is assumed to to be the same server that selenium is running on (determined
by the SELENIUM_URL environment variable).  However, if you are running your own stuff outside of docker and want to use this, you can set the RECORD_VNC_FROM environment
variable to a url that looks like "vnc://host:port"


### Watching Your Tests Run

When developing locally, you can have a browser window visible which is great whilst debugging, but very annoying when you want to get
on with something else whilst the tests are running.

With the docker version, the browser is not launched on the local machine, but inside a docker container where you can't see it - so
it won't annoy you.  But, what happens when you want to see it ?  Simple, you connect a vnc client to the port forwarded by the selenium service.
This port is random to start with (use 'docker ps' when the test suite is uo and look for '5900' in selenium service), but you can lock it down to
a known free port by setting the SELENIUM_VNC_PORT environment variable.  Note that there is a password setup by default which is 'secret'

## Re Building Docker Images

Occasionally, if the Dockerfile has changed - things will need re building. If you are asked to rebuild, just add '--build' onto
the end of the 'up' command and it will force a re build of all our containers.

## More details if you want to know more :---

In the docker folder, there are a few folders each with at least a docker-compose.yml file in

Here are what they are for :-

### docker/test_servers

Will run all of the servers to run tests against or to manually test against

#### Environment Variables

There are some special environment variables too :-

##### ETAPI_DB_PORT

If specified then the db port will be forwarded to the specified port on the local machine for use in development so another rails instance can share it.
If not specified, port 0 is used which means 'a random port' - use 'docker ps' to see where the ports are forwarded

e.g

```
ETAPI_DB_PORT=5433

```

##### ETAPI_REDIS_PORT

If specified, then the redis port for the API server will be forwarded to the specified port on the local machine for use in development so another rails instance can share it.
If not specified, port 0 is used which means 'a random port' - use 'docker ps' to see where the ports are forwarded.

e.g.

```

ETAPI_REDIS_PORT=6379

```

##### ETAPI_PORT

If specified then the API port will be forwarded to the specified port.
As above, if not specified, a random port is assigned and you will have to use 'docker ps' to find out which

e.g.

```

ETAPI_PORT=3200

```

##### ET1_PORT

If specified then the ET1 server port will be forwarded to the specified port.
As above, if not specified, a random port is assigned and you will have to use 'docker ps' to find out which

```

ET1_PORT=3300

```

##### JADU_API

If specified (see example) then an external JADU API is used by ET. As standard, this points to the internal 'etapi' service in the docker-compose file.  This is only overriden in development if you want to develop using an external rails instance instead of the docker container.
Only valid for the ET1 system

Example to use port 3000 on your local machine

```
JADU_API=http://host.docker.internal:3000/api/v1/
```

##### ET_API_URL

If specified (see example) then any system that needs to talk to the central API will use this value.  If not specified,
the default is 'http://et_api:8080/api' which is correct for when the test servers are running within docker

Example to use port 3000 on your local machine (i.e. when doing work on the API) when the other servers are
within docker.

```
ET_API_URL=http://host.docker.internal:3000/api

```

note that because ET1 is a docker container, you must use the ip or hostname of your machine or host.docker.internal and NOT localhost.

##### S3_PORT

If specified, the internal amazon/s3 compatible server is exposed on this port - else on a random port (use 'docker ps' to find out which)


### docker/test_framework

Used to run the test suite - generally you would grab a bash session using

```
docker-compose run test bash
```

and then do normal ruby stuff such as bundle exec rspec

but, don't forget, this is what the scripts in bin/dev do !!

## Environment Variables For Test Suite

### SERVER_PORT

### SERVER_DOMAIN

### ADMIN_BASE_URL

The url where the admin lives (including the 'admin' part of the url).  Note that this is from the viewpoint of
the machine where the browser is running so even if running the test code outside of docker, if you are using the
docker selenium server - it is on the docker network so you will need to use the docker based url for it

### ADMIN_USERNAME

The admin username (defaults to admin@example.com - same as seed data)

### ADMIN_PASSWORD

The admin password (defaults to password - same as seed data)

### RECORD_VIDEO

Controls video recording during the test run - can be one of the following values

* on_failure (default) - means record everything but throw away passing tests - useful for seeing what went wrong when developing
* false - means don't record anything
* true - means record everything
* @tag1,@tag2,@anyothertag,~@butnotthisone - Uses cucumber tagging to work out whether to or not (these tags can be anything you want).  Can be useful for presentational purposes

### RECORD_VNC_FROM

If your VNC server is not on port 5900 on the same server that provides the selenium services, you can control where to record video
 from by setting this value to something like this :- "vnc://host:port"
 
### SELENIUM_VNC_PORT

If set, the VNC port that selenium exposes will be forwarded to this port.  Otherwise, it is random

### SELENIUM_PORT

The selenium port that the tests talk to can be set using this.  If not set, it is random.
This could be useful if you wanted to use the docker setup for all of its supporting services, but run the actual tests in ruby on
your local machine.  Without this, your code would not know which port to connect to.

### ATOS_API_URL

Until searching through zip files for filenames is implemented in the admin, using the ATOS API to verify the output
is an acceptible way of doing things.  It may even always be acceptible ?  So, we specify the base URL of the ATOS API here.

for example :-

```

ATOS_API_URL=http://et_api:8080/atos_api

```

### ET1_URL

If specified, whenever the test suite wants an ET1 page - the url is prefixed with this value.  The default is
'http://et1:8080/'

### ET3_URL

If specified, whenever the test suite wants an ET3 page - the url is prefixed with this value.  The default is
'http://et3:8080/'


# Running The Test Suite Locally

## Preparation - Servers

Make sure you have the ports you want to use free and start up the test servers with them exposed - such as :-

```
ETAPI_PORT=3000 ET_ADMIN_PORT=3001 S3_PORT=3002 ET1_PORT=3003 ./bin/dev/test_servers up
```

## Preparation - Test Framework


### Exposing the ports

The 'test' service in the test framework is not going to be required (as you are effectively running it locally) - however,
no harm in starting up the test framework as it provides the selenium service

```

SELENIUM_PORT=4444 SELENIUM_VNC_PORT=5901 ./bin/dev/test_framework up

```

### Setting Up Video Recording (Optional)

The suite will run without this, but its well worth having when things go wrong as it provides a nice video of it going wrong

#### First, install python and pip

You may already have this - try typing 'pip' and see if you get command not found.  If you do then continue :-

For OSX

```

brew install python

```

or if you already have python but no pip

```

sudo easy_install pip

```

For Linux (debian based - e.g. ubuntu)

```
apt-get install python python-dev python-pip

```

For Windows

I don't know - but if someone finds out, please update this readme

#### Next, install vnc2flv

Using pip, install vnc2flv as follows

```

sudo pip install vnc2flv

```

and you should get :-

```
Installing collected packages: vnc2flv
  Running setup.py install for vnc2flv ... done
Successfully installed vnc2flv-20100207


```

## Running The Test Suite

The .env file provided gives the defaults assumed above - the API is running on port 3000, the admin on port 3001, the
fake S3 server on port 3002, ET1 on port 3003 and selenium on port 4444.

So, if you want to go with this - just go ahead and run

```

bundle exec cucumber


```

# Running Everything Without Docker

'foreman' has been configured to run everything as well.  It is more prone to port clashes, but may suit you better

## Dependencies

* nodejs
* npm
* postgresql - if not installed, use Postgres.app to run as required (osx)
* redis - if not installed, use Redis.app to run as required ('brew cask install redis-app' on OSX)
* mailhog - ('brew install mailhog' on OSX)
* pdftk - (see https://www.pdflabs.com/tools/pdftk-server/)
