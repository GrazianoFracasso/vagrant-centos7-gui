#export    ODI_PKG1=fmw_12.2.1.3.0_odi_Disk1_1of2.zip 
#export    ODI_PKG2=fmw_12.2.1.3.0_odi_Disk1_2of2.zip 

read_var() {
  if [ -z "$1" ]; then
    echo "environment variable name is required"
    return
  fi

  local ENV_FILE='.env'
  if [ ! -z "$2" ]; then
    ENV_FILE="$2"
  fi

  local VAR=$(grep $1 "$ENV_FILE" | xargs)
  IFS="=" read -ra VAR <<< "$VAR"
  echo ${VAR[1]}
}

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

yum install -y unzip

env

mkdir /u01 && \
    useradd -b /u01 -d /u01/oracle -m -s /bin/bash oracle && \
    mkdir -p /u01/oracle/container-scripts /u01/oracle/logs && \
    chmod a+xr /u01 

#
# Copy required files to build this image
# ---------------------------------------
cp /vagrant/$ODI_PKG1 /u01/ 
cp /vagrant/$ODI_PKG2 /u01/ 
cp /vagrant/oraInst.loc /u01/
cp /vagrant/$JAVA_PKG1 /u01/
cp /vagrant/CreateODIDomainandRunAgent.sh /u01/oracle/container-scripts/
cp /vagrant/CreateODIDomain.py /u01/oracle/container-scripts/
cp /vagrant/db.env.list /u01/oracle/container-scripts/
cp /vagrant/odi.env.list /u01/oracle/container-scripts/
cp /vagrant/install_odi_p2.sh /u01/oracle/container-scripts/

chown oracle:oracle -R /u01 && \
    chmod a+xr /u01/oracle/container-scripts/*.*

sudo -H -u oracle bash -c 'bash /u01/oracle/container-scripts/install_odi_p2.sh' 