#!/bin/bash

# Define environment variables

export SECUDIR=/home/aceuser/app/sap/sec
export PATH=$PATH:/home/aceuser/app/sap/sapcrypto
export USER=sapservicetst
#create directories
mkdir -m 777 /home/aceuser/app/sap/sec

# Define variables
PSE_FILE=CLIENT.pse
USERNAME=sapservicetst
PASS_PHRASE=changeit
DIST_NAME="CN=TST, OU=IT, O=ISL, C=IN"
SERVER_CRT=/home/aceuser/app/sap/SERVER.crt
CLIENT_CRT=CLIENT.crt

#Run commands to generate keystore and other files
cd $SECUDIR


# Create the private key (.pse file)
echo "Creating private key ($PSE_FILE)..."
sapgenpse gen_pse -v -p $PSE_FILE -x $PASS_PHRASE "$DIST_NAME"
if [ $? -ne 0 ]; then
  echo "Error: Failed to generate PSE file."
  exit 1
fi

# Generate cred_v2 file for the specified username
echo "Generating credential file (cred_v2)..."
sapgenpse seclogin -p $PSE_FILE -O $USERNAME -x $PASS_PHRASE
if [ $? -ne 0 ]; then
  echo "Error: Failed to generate credential file."
  exit 1
fi

# Export the certificate from CLIENT.pse
echo "Exporting certificate from $PSE_FILE..."
sapgenpse export_own_cert -v -p $PSE_FILE -o $CLIENT_CRT -x $PASS_PHRASE
if [ $? -ne 0 ]; then
  echo "Error: Failed to export certificate."
  exit 1
fi

# Import the SAP system certificate into the private key
echo "Importing SAP system certificate..."
sapgenpse maintain_pk -v -a $SERVER_CRT -p $PSE_FILE -x $PASS_PHRASE
if [ $? -ne 0 ]; then
  echo "Error: Failed to import SAP system certificate."
  exit 1
fi

echo "SAP client configuration completed successfully."
