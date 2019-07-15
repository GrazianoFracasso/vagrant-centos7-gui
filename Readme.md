Oracle Data Integrator on Docker
=============
Sample Docker configurations to facilitate installation, configuration, and environment setup for Docker users. 

At the end of this configuration there will be 2 virtual machines running : 1) DB 2) ODI Agent.

## Prerequisites

1. Download Java Files from Oracle OTN ( jdk-8u171) and ODI Files 12.2.1.3.0 from Oracle eDelivery  ( V886451-01_1of2.zip,V886451-01_2of2.zip ) and copy them into this directory.

You should have these situation before starting:

![https://i.imgur.com/jzvw0LE.png](https://i.imgur.com/jzvw0LE.png)

If you download ODI from OTB website just change ODI_PKG1 and ODI_PKG2 variables into install_odi.sh and install_odi_p2.sh files with the correct filenames. Same trick if you choose a different version of java.

2. Database

You need to have a running database container or a database running on any machine. 
The database connection details are required for creating ODI specific RCU schemas while configuring ODI domain. 
While using a 12.2.0.1+ CDB/PDB DB, ensure PDB is used to load the schemas. RCU loading on CDB is not supported.

The Oracle Database virtual machine can be pulled from [my repo](https://github.com/GrazianoFracasso/vagrant-oracle19c)

Create an environment file **db.env.list**

        ORACLE_SID=<DB SID>
        ORACLE_PDB=<PDB ID>
        ORACLE_PWD=<password>

Sample data should look similar to:

        ORACLE_SID=ORCL
        ORACLE_PDB=ORCLPDB1
        ORACLE_PWD=oracle

Sample command to start the Database:

         $ vagrant up

The above command starts a DB container mounting a host directory as /opt/oracle/oradata for persistence. 
It maps the containers 1521 and 5500 port to respective host port such that the services can be accessible outside of localhost.

## ODI image Creation and Running

### Building Image for ODI

**IMPORTANT:** you have to download the binary of ODI and put it in this directory.

Create an environment file **odi.env.list**

        CONNECTION_STRING=<Database Host Name>:<port#>/<ORACLE_PDB>
        RCUPREFIX=<RCU_Prefix>
        DB_PASSWORD=<database_password>
        DB_SCHEMA_PASSWORD=<RCU schema Password>
        SUPERVISOR_PASSWORD=<Password for SUPERVISOR>
        WORK_REPO_NAME=<Name for WORK repository>
        WORK_REPO_PASSWORD=<Password for WORK repository>
        HOST_NAME=<Hostname where docker is running>


Sample data should look similar to:

        CONNECTION_STRING=192.168.50.4:1521/PDB1
        RCUPREFIX=LAB
        DB_PASSWORD=oracle
        DB_SCHEMA_PASSWORD=oracle
        SUPERVISOR_PASSWORD=SUPERVISOR
        WORK_REPO_NAME=WORKREP
        WORK_REPO_PASSWORD=oracle
        HOST_NAME=192.168.50.6

To start a vm with an ODI domain and agent, run the following command:

         $ vagrant up
    This includes the command for RCU creation, domain creation and configuration followed by starting ODI Agent. 
    Mapping container port 20910 to host port 20910 enables accessing of the Agent outside of the local host.

Once the ODI container is created logs will be tailed and displayed to keep the container running.

Now you can access the Agent at http://\< host name \>:20910/oraclediagent.

Installation completed screenshot:

![https://i.imgur.com/PtTosJp.jpg](https://i.imgur.com/PtTosJp.jpg)         
**NOTES:** 

1) If DB_SCHEMA_PASSWORD, SUPERVISOR_PASSWORD, WORK_REPO_PASSWORD are not provided in odi.env.list then it will generate random password and use it while running RCU. It will display generated random password on console.

2) Studio can be accessed from the same Virtual Machine, if GUI is disabled, you can reenabled it by setting in Vagrantfile 

```
v.gui = true
```

You can login as vagrant( password vagrant)

![https://i.imgur.com/OcwnGdl.jpg](https://i.imgur.com/OcwnGdl.jpg)

Change oracle password:

![https://i.imgur.com/QLV17Hd.jpg](https://i.imgur.com/QLV17Hd.jpg)

login as oracle and then start ODI

![https://i.imgur.com/jArBsD7.jpg](https://i.imgur.com/jArBsD7.jpg)

Setup the connection to repository like this:

![https://i.imgur.com/yZkZER6.jpg](https://i.imgur.com/yZkZER6.jpg)

3) ODI images supports only Oracle Database as the repository database. 

4) For all other supported matrix information, please refer to ODI documentation. The supported database for repository mentioned above supersede the configuration matrix for ODI.

5) As a prerequisite (Only for ODI 12.2.1.2.6), "Maximum number of sessions" field needs to be overwritten in Studio UI for the Agent created by the ODI Container. Post docker configuration, "Maximum number of sessions" is set as null in the repository database, but the Studio UI  render 1000 as the default value set. User is required  to explicitly overwrite the "Maximum number of sessions"  value to force an update in the repository. If this step is not performed, all sessions will continue to wait in the queue and will not be processed.

	Steps to overwrite the "Maximum number of sessions"  value in Studio UI
	
	* Login to ODI Studio
	* In Topology Navigator expand the Agents node in the Physical Architecture navigation tree
	* Select the Agent created by the ODI Container
	* Right-click and select View
	* In the Definition tab, for the field “Maximum number of sessions”, overwrite the value again to 5 and click Save button. Then again overwrite the value to 1000 and click Save button.

## License ( Copy Pasted from official Oracle Github)
To download and run Oracle Data Integrator 12c Distribution regardless of inside or outside a Docker container, and regardless of the distribution, you must download the binaries from Oracle website and accept the license indicated at that page.

To download and run Oracle JDK regardless of inside or outside a Docker container, you must download the binary from Oracle website and accept the license indicated at that pge.

All scripts and files hosted in this project and GitHub [docker-images/OracleDataIntegrator](./) repository required to build the Docker images are, unless otherwise noted, released under the Universal Permissive License v1.0.

## Copyright ( Copy Pasted from official Oracle Github)
Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.

