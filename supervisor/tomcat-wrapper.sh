#!/bin/bash
# Source: https://confluence.atlassian.com/plugins/viewsource/viewpagesrc.action?pageId=252348917
function shutdown()
{
    date
    echo "Shutting down Tomcat"
    unset CATALINA_PID # Necessary in some cases
    unset LD_LIBRARY_PATH # Necessary in some cases
    unset JAVA_OPTS # Necessary in some cases

    $CATALINA_HOME/bin/catalina.sh stop
}

date
echo "Starting Tomcat"
export JAVA_HOME="/usr"
export CATALINA_PID="/var/run/tomcat8.pid"
export CATALINA_HOME="/usr/share/tomcat8"
export ENV CATALINA_BASE="/var/lib/tomcat8"
export ENV JAVA_OPTS="-Xmx1024m"
export LD_LIBRARY_PATH=/usr/local/apr/lib

. $CATALINA_HOME/bin/catalina.sh start

# Allow any signal which would kill a process to stop Tomcat
trap shutdown HUP INT QUIT ABRT KILL ALRM TERM TSTP

echo "Waiting for `cat $CATALINA_PID`"
wait `cat $CATALINA_PID`
