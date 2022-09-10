[![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/interoperability-soap)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Finteroperability-soap&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Finteroperability-soap)
 [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Finteroperability-soap&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Finteroperability-soap)
# interoperability-test
I started from iris-interoperability-template. It contained a simple interoperablity solution which reads data from Reddit, filters it, and directs outputs into files or sends via email.

## Error encountered
```
the --mount option requires BuildKit. Refer to https://docs.docker.com/go/buildkit/ to learn how to build images with BuildKit enabled
ERROR: Service 'iris' failed to build : Build failed
```
## Workaround
My docker-compose installation did not support BuildKit. So I built the image separately and used the image in docker-compose.yaml.
```
DOCKER_BUILDKIT=1 sudo docker build --no-cache --progress=plain --tag testint .
```
## Why interoperability-test?

My team works on IRIS interoperability solution running on Red Hat OpenShift Kubernetes Container Platform. We are trying to implement CI/CD, but we are missing testing tool. We are making changes to our POC interfaces. I wanted to see what can be done with Unit Testing tools provided by InterSystems.

We are working on POC interface. Below is a screenshot of a visual trace in Health Connect:
![screenshot](https://github.com/oliverwilms/bilder/blob/main/TracePOCinHC.PNG)

IncomingPOCFile Service reads a file and sends it to BPL process. Next step is sending an Authorization request to an external system (DMLSS). After Auth request is approved, another request is sent to DMLSS to retrieve data. Finally a stream is created and sent to POCResponseFile operation.

We are not connected to DMLSS during build time or during this unit testing. I decided to simulate the interaction with DMLSS. I created an Authorization process to provide the authorization. The Authorization request is sent to this Production due to System Default Settings which are shown on the screenshot below. It is received by Generic REST Service which sends a request to POC Auth BPL. POC Auth BPL simulates the response from DMLSS.

## Problem encountered

I need another REST Service and BPL to process the second request to DMLSS after the Authorization. Once I added a second service, requests from this Production did not route as expected. I could still reach the Services from Postman.

## Solution

Use a REST class without using Generic REST Services, at minimum for one request type (Api or Auth).

![screenshot](https://github.com/oliverwilms/bilder/blob/main/testint.PNG)

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation: ZPM

Open IRIS Namespace with Interoperability Enabled.
Open Terminal and call:
USER>zpm "install interoperability-test"

## Installation: Docker
Clone/git pull the repo into any local directory

```
$ git clone https://github.com/oliverwilms/interoperability-test.git
```

Open the terminal in this directory and run:

```
DOCKER_BUILDKIT=1 sudo docker build --no-cache --progress=plain --tag testint .
$ docker-compose up -d
```

## How to Run UnitTest

```
$ docker-compose up -d
sudo docker exec -it interoperability-test_iris_1 iris session iris
zpm "test interoperability-test -only -v"
```

## How to Run interoperability-test

Open the [production](http://localhost:57700/csp/user/EnsPortal.ProductionConfig.zen?PRODUCTION=dc.Demo.Production) and start it.
File Passthrough Service looks for a file in /irisdev/app/data/. If found, then file content is sent to POC File BPL.
If the process completes successfully, a response file will be sent to POC Response File Operation and we should find a file in /usr/irissys/mgr/output/.

You can view the [BPL](http://localhost:57700/csp/user/EnsPortal.BPLEditor.zen?BP=dc.POC.ProcessPOCFileRequest.bpl) 
![screenshot](https://github.com/oliverwilms/bilder/blob/main/interoperability-test_BPL.png)
