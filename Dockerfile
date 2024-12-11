FROM --platform=linux/x86_64 cp.icr.io/cp/appc/ace-server-prod@sha256:7689c374a16a767aa9aa32422370282fbd48a3838a944f2566424bd56bdf0c92
USER root
RUN useradd -ms /bin/bash sapservicetst

WORKDIR .

#creating directories to copy files from host
RUN mkdir -m 777 /home/aceuser/app
RUN mkdir -m 777 /home/aceuser/app/sap
#Copying the entire SAP folder containing the SAP cryptographic library, The shell script to configure client side and the certificate imported from SAP server to be imported to client PSE file.
COPY /sap /home/aceuser/app/sap 

#Run script 
#providing execute permission to the shell script
RUN chmod +x /home/aceuser/app/sap/sapdocker.sh
USER sapservicetst
RUN whoami

#executing the shell script
RUN ./app/sap/sapdocker.sh
