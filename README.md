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

This repository can be cloned using [abapGit](https://docs.abapgit.org/) to your package. 

After the pull request, if you see any errors follow the below sequence in activating the pulled repo objects. 

![](https://github.com/r3sm/CaseStudy-Target/blob/216ced0f7a7c55c1a2c4d22be71f9e6c1ca8f635/images/2021-06-23%2023_02_46-eclipse-workspace%20-%20Service%20Binding%20Y_SB_PRODUCTS_V4_WEB_API%20%5BTRL%5D%20%20-%20active,%20lo.png)







# Testing



