[TOC]

# Case Study 

The goal for this exercise is to create an end-to-end Proof-of-Concept for a products API, which will aggregate product data from multiple sources and return it as JSON to the caller

## Requirement

Build an application that performs the following actions: 

·    Responds to an HTTP GET request at /products/{id} and delivers product data as JSON (where {id} will be a number. 

·    Accepts an HTTP PUT request at the same path (/products/{id}), containing a JSON request body similar to the GET response, and updates the product’s price in the data store.

## Tools used 

ABAP stack is used to complete this task. [ABAP trail instance](https://account.hanatrial.ondemand.com/trial/#/home/trial) is available for developers. 

[Bonsai](https://bonsai.io/) is used as NoSQL DB.

[Postman](https://www.postman.com/) is used for testing the API.

# Installation

Instances of below two Services  are required.  Please set up and have the service key available for later use.

![](https://github.com/r3sm/CaseStudy-Target/blob/fdff0d731aa478ee300b1d0c5cdbd2e2ae1e275f/images/2021-06-23%2021_37_03-Trial%20Home%20_%20a2dfeccdtrial%20_%20trial%20_%20Instances%20and%20Subscriptions%20-%20SAP%20BTP%20Cockp.png)



[Free ABAP Trail account setup](https://developers.sap.com/tutorials/hcp-create-trial-account.html) 

## Setup Authorization and Trust Management Service Instance

Go to highlighted Service and create a service Instance and choose plant - apiaccess. Create a Service Key.

![](https://github.com/r3sm/CaseStudy-Target/blob/89ef84eb787e79f3cca4417a4e6ce129f5f3808d/images/2021-06-24%2001_27_54-Trial%20Home%20_%201f8cf486trial%20_%20trial%20_%20Service%20Marketplace%20-%20SAP%20BTP%20Cockpit.png)



## Clone the Source Repo

This repository can be cloned using [abapGit](https://docs.abapgit.org/) to your package. 

After the pull request, if you see any errors please follow the below sequence in activating the pulled repo objects. 

![](https://github.com/r3sm/CaseStudy-Target/blob/216ced0f7a7c55c1a2c4d22be71f9e6c1ca8f635/images/2021-06-23%2023_02_46-eclipse-workspace%20-%20Service%20Binding%20Y_SB_PRODUCTS_V4_WEB_API%20%5BTRL%5D%20%20-%20active,%20lo.png)



If you are already on the same instance and cannot be cloned, please proceed to next step. 

## Postman Setup

Since We need to test both GET and PUT calls , installing latest version of postman will be helpful before beginning the setup.

After setting up postman, import below files.

postman/Assessment Enironment template.postman_environment.json

postman/Target Case Study.postman_collection.json

### Setup Environment File

After importing the Environment template, please set the variable as per below.



![](https://github.com/r3sm/CaseStudy-Target/blob/89ef84eb787e79f3cca4417a4e6ce129f5f3808d/images/2021-06-23%2023_13_13-Postman.png)



![](https://github.com/r3sm/CaseStudy-Target/blob/89ef84eb787e79f3cca4417a4e6ce129f5f3808d/images/2021-06-23%2023_19_16-SS.png)

> **Make sure to choose this Environment before proceeding to next step.**

### AUTH Token Generation

After above setup is complete, final step is to generate an AUTH token to be able to start testing. 

Follow highlighted steps from Screen shots below to generate an access token and set it up for use. 

![](https://github.com/r3sm/CaseStudy-Target/blob/aa9f6373886dc4c49316643736dbd4a63011f110/images/2021-06-24%2001_09_21-Postman.png)



![](https://github.com/r3sm/CaseStudy-Target/blob/aa9f6373886dc4c49316643736dbd4a63011f110/images/2021-06-24%2001_09_56-Postman.png)



![](https://github.com/r3sm/CaseStudy-Target/blob/aa9f6373886dc4c49316643736dbd4a63011f110/images/2021-06-24%2001_10_07-Postman.png)



![](https://github.com/r3sm/CaseStudy-Target/blob/aa9f6373886dc4c49316643736dbd4a63011f110/images/2021-06-24%2001_10_19-Postman.png)



# Testing

​	Test scenarios are already part of the collection shared. 

​	Please run the folder 'Unit Test'

![](https://github.com/r3sm/CaseStudy-Target/blob/ed1b166a05918034ed0df268e6815a8c4abd5100/images/2021-06-24%2001_44_07-Postman.png)

![](https://github.com/r3sm/CaseStudy-Target/blob/ed1b166a05918034ed0df268e6815a8c4abd5100/images/2021-06-24%2001_50_16-.png)



**TEST RESULTS:**

![](https://github.com/r3sm/CaseStudy-Target/blob/ed1b166a05918034ed0df268e6815a8c4abd5100/images/2021-06-24%2001_51_02-Postman.png)



