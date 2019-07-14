#
# Install as oracle user
# ----------------------
sudo su - oracle
echo "Acting as.."
whoami 

export    ODI_PKG1=V886451-01_1of2.zip
export    ODI_PKG2=V886451-01_2of2.zip
export    ODI_JAR=fmw_12.2.1.3.0_odi.jar 
export    ODI_JAR2=fmw_12.2.1.3.0_odi2.jar 
export    JAVA_PKG1=jdk-8u171-linux-x64.tar.gz
export    JAVA_DIR=jdk1.8.0_171
export    ORACLE_HOME=/u01/oracle 
export    PATH=$PATH:/u01/oracle/oracle_common/common/bin:/u01/oracle/container-scripts 
export    ODI_AGENT_PORT=20910
export    DOMAIN_NAME="${DOMAIN_NAME:-base_domain}" 
export    DOMAIN_ROOT="${DOMAIN_ROOT:-/u01/oracle/user_projects/domains}"


cd /u01 
tar -xvzf $JAVA_PKG1
export JAVA_HOME=/u01/$JAVA_DIR 
export PATH=$PATH:$JAVA_HOME
echo "export JAVA_HOME="$JAVA_DIR > /u01/oracle/.bash_profile
echo "export PATH=$PATH:$JAVA_HOME" >> /u01/oracle/.bash_profile
echo "export PATH=$PATH:/u01/oracle/oracle_common/common/bin:/u01/oracle/container-scripts" >> /u01/oracle/.bash_profile

unzip /u01/$ODI_PKG1  && unzip /u01/$ODI_PKG2  
$JAVA_HOME/bin/java -jar /u01/$ODI_JAR -silent -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="Standalone Installation"
rm -f /u01/$ODI_PKG1 
rm -f /u01/$ODI_PKG2 
rm -f /u01/$ODI_JAR 
rm -f /u01/$ODI_JAR2 
rm -f /u01/$JAVA_PKG1 
rm -f /u01/fmw_12213_readme.htm 
rm -f /u01/oraInst.loc


cd /u01/oracle/container-scripts/
export $(egrep -v '^#' db.env.list | xargs)
export $(egrep -v '^#' odi.env.list | xargs)

cd $ORACLE_HOME

/u01/oracle/container-scripts/CreateODIDomainandRunAgent.sh