#  MADE - (M)icroservice Test (A)nd (D)evelopment (E)nvironment

## What is MADE ?


First of all, MADE is not a tool. It is a method or technique designed to manage and test your microservices in a reproducible and reliable way. MADE is primarily intended for **local** development and testing (mainly functional tests). However, if your CI/CD pipeline supports **Docker Compose**, you can even apply the same approach to deploy your applications to **staging** or **production**.  

---

### **Scenario:**  
Imagine you have a microservice-based architecture consisting of:  
- A **frontend** (e.g., React, Angular)  
- A **backend** (e.g., Kotlin, Python, Java, etc.)  
- A **database** (e.g., MongoDB, PostgreSQL)  
- Additional **third-party services** (e.g., Elasticsearch, Keycloak for authentication & authorization)  
- Automated **integration and/or system tests**  

Managing, configuring, running, testing, and maintaining all these applications in a **composed environment** can be challenging. This is where **MADE** comes into play!  

---

### **The Concept of MADE:**  
1. **Manage the source code** of all required microservices – using **Git**  
2. **Build all applications** – using **Docker**  
3. **Compose, configure, start, and run** all applications and tests in a reproducible and reliable way – using **Docker Compose**  

---

### **Key Developer Requirements:**  
✔ **Local and independent development:** Work entirely on your machine without requiring a **constant internet connection**—especially useful when coding on the go (Shoutout to DB 😉).  

✔ **Reliable and reproducible test setups:** If it works for one developer, it must work for everyone else as well.  

✔ **Early-stage testing of incomplete features:** Developers should be able to **test against partially implemented code**. For example, if the backend API is changing, frontend developers should still be able to start working against the new API as early as possible.  

✔ **No reliance on central test environments:** No need for **shared cloud test clusters** that often cause conflicts and errors due to multiple developers working on them simultaneously.  

---

### **With MADE, all these challenges are addressed!**

## Prerequisites

All you need is `git`, `docker` and `docker-compose`. 

## Overview / Structure
The core of `MADE` is `git`, `docker` and `docker-compose`, as mentioned before.

* With `git` you can manage the versions of your apps. You can checkout any commit you want i.e. frontend has feature-branch X, backend has master-branch etc.. 
By that you can create any combination of your apps very fast and easily. 
    * Here we use `git submodules`. A git submodule is just a reference to another git repo. 
    Since all your apps should already have a separate git repo, we can leverage that! In case you use a monorepo, the approach stays the same except that a submodule is now a folder in your monorepo.
* `docker` (of course ;-) ) is needed to build and package your apps into docker images. 
Same images will be deployed to your production/staging environment (ie. GoogleCloud, MS Azure) since your CI/CD pipeline SHOULD use the same Dockerfile. By that you test locally the same image which will be deployed to production later.
* `docker-compose` gives us a tool to compose and configure the microservice environment. We will also use it to include and start the automated tests. 

<table><tr><td>
<img align="center" src="./docs/pics/overview_it_platform.png" width="800">
</td></tr></table>

### Automated tests

Since we can setup our entire microservice environment locally, we can also execute tests against this environment, in best case automated tests. 
The tests are managed in a separate gitsubmodule which also includes a Dockerfile. So its treated as ordinary microservice/app.

In this microservice we manage the tests which you can write in any language and with any framework you want. 
We have used  [behave](https://behave.readthedocs.io/en/latest/) (BDD tests) and for automated UI tests we used [Cypress](https://www.cypress.io/). But feel free use whatever you like!

### Managing secrets in MADE (optionally)
One specific requirement we had in the past, was that we also wanted to access from local running apps to remote databases in our clouds (i.e. GCloud).
For that you need to store the secrets, such as passwords or api-keys, somehow.

To avoid comitting/pushing those secrets to `git` we use the `env` folder approach. 
That means we have a folder `made/env` which is ignored by `git` (see .gitignore). 
In that folder we store the secrets in special .env-files which are used then by `docker-compose`.

## Alternative approaches for MADE

## Monorepo instead of git-submodules
Instead of using `gitsubmodules` you can also apply the `Monorepo` approach. This is a bit easier because you don't have to struggle with `git submodules` which can be cumbersome sometimes.


## Using docker-images instead git-submodules
Another approach is to use directly docker images in the `docker-compose` instead of git submodules. 
So you specify directly the image name and pull it from the docker registry then.

Drawback: 
* You always need to trigger the CI/CD pipeline, so that the docker image is build. That takes time and requires an internet connection.
* Another problem is that you need to create specific tags for docker images which refers then to specific docker test image. 
You also need to maintain these tags in your docker-compose.
* When you test with many different docker test images, you will need more space in the registry and maybe also some house-keeping.
* More pipeline jobs will be triggered which produced more load on your CI/CD pipeline.
