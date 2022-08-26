ARG IMAGE=intersystemsdc/irishealth-community
ARG IMAGE=intersystemsdc/iris-community
FROM $IMAGE

WORKDIR /home/irisowner/irisbuild

COPY --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} . .

ARG TESTS=0
ARG MODULE="interoperability-sample"
ARG NAMESPACE="USER"

RUN \ 
    iris start IRIS && \
	iris session IRIS < iris.script && \
    ([ $TESTS -eq 0 ] || iris session iris -U $NAMESPACE "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly
