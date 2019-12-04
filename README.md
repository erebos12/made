# Blueprint MADE - (M)icroservice Test (A)nd (D)evelopment (E)nvironment

## What is MADE ?

Imagine you have a microservice architecture with a frontend (e.g. Ract/Angular), 
backend (Kotlin, Python, Java, ...), a database (Mongo, PostgreSQL, ...) and other third-party services (i.e. ElasticSearch, KeyCloak for AAA).
Maybe you also have some automated integration and/or system-tests.

How can you then configure, run, test and maintain all these apps in a composed environment?
Here comes `MADE` into play!

The idea is:

1. Manage source-code of all required microservices - `using git (specifically git-submodules)`
2. Build all apps (with Docker, of couse ;-) ) - `using Docker`
3. Compose, configure, start and run all apps and tests in a reproducible and reliable way - `using Docker-Compose`

Other requirements developers may have:
1. Develop locally and independently on your machine. So no permanent internet connection required. Especially useful when you are sitting in the train (Greetz to DB ;-))
2. Setup for tests must be reliable and reproducible. When its working for one developer then it must also work for any other developer!
3. Developers want to be able to test against "incomplete" features/code. Imagine backend API changes and the frontend developer wants to code against this new API in a very early stage.
4. No central test environments (like test-clusters in the cloud) which you need to share with other developers. Error-Prone and many conflicts are related to that.

All this will be covered by the MADE!

## Prerequisites

All you need is `git`, `docker` and `docker-compose`. 

## Overview / Structure
The core of `MADE` is `git`, `docker` and `docker-compose`, as mentioned before.

* With `git` you can manage the versions of your apps. You can checkout any commit you want i.e. frontend has feature-branch X, backend has master-branch etc.. 
By that you can create any combination of your apps very fast and easily. 
* `docker` (of course ;-) ) is needed to build and package your apps into docker images. 
Same images will be deployed to your production/staging environment (ie. GoogleCloud, MS Azure) since your CI/CD pipeline SHOULD use the same Dockerfile.
* `docker-compose` gives us a tool to compose and configure the microservice environment. We will also use it to include and start the automated tests. 

<table><tr><td>
<img align="center" src="./docs/pics/overview_it_platform.png" width="800">
</td></tr></table>

### Automated tests

Since we can setup our entire microservice environment locally, we can also execute tests against this environment, in best case automated tests. 
The tests are managed in a separate gitsubmodule which also includes a Dockerfile. So its treated a normal microservice/app.

In this microservice we manage the tests which you can write in any language and with any framework you want. 
We use the BDD approach with the Python BDD framework `behave` and for UI tests we used `Cypress`. But feel free use whatever you like!

## Working with MADE

### Clone me
```
git clone --recursive git@gitlab.pwc.delivery:fs-acc-devops/platform_blueprint.git
```

### Create your own git repo of platform
Remove `.git` folder because this is the git repo for this blueprint. 
I guess you wanna create your own platform repo ;-).
```
$ rm -rf .git
$ git init
```

### Adding a git submodule (microserice)

You add a new gitsubmodule, in other words another git-repo, just execute in MADE root-folder:
```
~made$ git submodule add git@gitlab.pwc.delivery:/awsome_app.git
```
After that you can execute:
```
~made$ git submodule
5201ad9806d8f9d4d18ff296dcb433f86bf7c5c4 awsome_app (heads/master)
```