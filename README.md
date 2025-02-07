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

**With MADE, all these challenges are addressed!**

## Prerequisites

All you need is `git`, `docker` and `docker-compose`. 

## Overview / Structure
The core of `MADE` is `git`, `docker` and `docker-compose`, as mentioned before.

Here is your text rewritten in better English while maintaining the structure:

---

### **The Core of MADE: Git, Docker, and Docker Compose**  

As previously mentioned, the foundation of **MADE** is built on **Git**, **Docker**, and **Docker Compose**.  

#### **Git – Version Control and Flexible App Combinations**  
- With **Git**, you can manage different versions of your applications effortlessly. You can **checkout any commit**, for example:  
  - The frontend is on **feature branch X**,  
  - The backend is on the **main branch**, etc.  
- This allows you to create and test **any combination** of your applications **quickly and easily**.  

✅ **Using Git Submodules**  
- A **Git submodule** is simply a reference to another Git repository.  
- Since each of your microservices likely has its **own separate Git repository**, you can leverage submodules to link them together.  
- If you're using a **monorepo**, the concept remains the same—except that instead of submodules, different microservices reside in **separate folders** within your monorepo.  

---

#### **Docker – Building and Packaging Applications**  
- **Docker** is essential for **building and packaging** your applications into **Docker images**.  
- The **same Docker images** used for local development will also be deployed to **staging** and **production** environments (e.g., **Google Cloud, Microsoft Azure**).  
- Your **CI/CD pipeline should always use the same Dockerfile**, ensuring that the **exact same image** tested locally is deployed to production.  

---

#### **Docker Compose – Microservice Orchestration and Automated Testing**  
- **Docker Compose** is used to **define, configure, and run** your entire microservice environment in a structured way.  
- It also enables you to include and start **automated tests** within the composed environment.  

With this approach, you ensure that **your local development setup closely mirrors the production environment**, making debugging and testing far more effective.

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
