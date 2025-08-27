#!/usr/bin/env sh

#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

APP_NAME="Gradle"
APP_BASE_NAME=`basename "$0"`

# See how we were called.
ACTION="$1"

# Resolve links: $0 may be a link
PRG="$0"
# Need this for relative symlinks.
while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=`dirname "$PRG"`"/$link"
    fi
done
SAVED="`pwd`"
cd "`dirname \"$PRG\"`/" >&-
APP_HOME="`pwd -P`"
cd "$SAVED" >&-

# Check that we have Java
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        # IBM's JDK on AIX uses strange locations for the executables
        JAVACMD="$JAVA_HOME/jre/sh/java"
    else
        JAVACMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVACMD" ] ; then
        echo "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME"
        echo "Please set the JAVA_HOME variable in your environment to match the"
        echo "location of your Java installation."
        exit 1
    fi
else
    JAVACMD="java"
    which java >/dev/null 2>&1 || { echo "ERROR: JAVA is not available."; exit 1; }
fi

# Use the maximum available, or set MAX_FD != -1 to use that instead
MAX_FD="maximum"

# Tell the user how to run us in debug mode
if [ "$1" = "--debug" ] ; then
    echo "DEBUG: Please set the environment variable GRADLE_OPTS to enable debug mode."
    shift
fi

# Increase the maximum file descriptors if we can
if [ "$MAX_FD" != "maximum" ] ; then
    if [ "$MAX_FD" != "maximum" ] && [ "$MAX_FD" != "max" ] ; then
        ulimit -n $MAX_FD
        if [ $? -ne 0 ] ; then
            echo "ERROR: Could not set maximum file descriptor limit: $MAX_FD"
            exit 1
        fi
    fi
else
    # use default unlimited
    ulimit -n unlimited
fi

# For Darwin, add options to lock memory to prevent paged out.
# For Cygwin, switch to native paths before running java
cygwin=false
darwin=false
case "`uname`" in
  CYGWIN* )
    cygwin=true
    ;;
  Darwin* )
    darwin=true
    ;;
esac

# For Darwin, add options to lock memory to prevent paged out.
if $darwin ; then
    GRADLE_OPTS="$GRADLE_OPTS -XstartOnFirstThread -Djava.awt.headless=true"
fi

# For Cygwin, switch to native paths before running java
if $cygwin ; then
    APP_HOME=`cygpath --path --windows "$APP_HOME"`
    CLASSPATH=`cygpath --path --windows "$CLASSPATH"`
    JAVACMD=`cygpath --path --windows "$JAVACMD"`
fi

# Stop at first failure
if [ "$ACTION" = "--no-daemon" ] ; then
    exec "$JAVACMD" $JAVA_OPTS $GRADLE_OPTS -classpath "$CLASSPATH" org.gradle.wrapper.GradleWrapperMain --no-daemon "$@"
else
    exec "$JAVACMD" $JAVA_OPTS $GRADLE_OPTS -classpath "$CLASSPATH" org.gradle.wrapper.GradleWrapperMain "$@"
fi
