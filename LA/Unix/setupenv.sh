
export BTT_HOME=/SandBox
export WAS_HOME=/opt/IBM/WebSphere/AppServer

export release=composer612
export ENG_WORK_SPACE=$BTT_HOME/$release

# export RAD_HOME=C:/RAD70/SDP70
# export RAD_SHARED_HOME=C:/RAD70/SDP70Shared
# export ANTVERSION=apache-ant-1.6.5

export ANTLOC=$WAS_HOME/deploytool/itp/plugins/org.apache.ant_1.6.5/bin
export EJBDEPLOYED_WAS_HOME=$WAS_HOME
export JAVA_HOME=$WAS_HOME/java
export ITP_LOC=$WAS_HOME/deploytool/itp
export PATH=$ANTLOC:$WAS_HOME:$WAS_HOME/bin:$JAVA_HOME/bin:$WAS_HOME/deploytool:$PATH
export CLASSPATH=$JAVA_HOME/lib:$CLASSPATH
export LOCAL_SETTINGS_FILE=$BTT_HOME/LocalSettings.properties
