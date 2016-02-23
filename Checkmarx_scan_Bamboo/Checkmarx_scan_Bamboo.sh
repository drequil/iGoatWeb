#!/bin/sh
export USERNAME="admin@cx"
export PASS="admin"
export CHECKMARX_HOST="10.31.0.79"
export PRESET="All"
export CX_CONSOLE_PATH="/opt/CxConsole_CI"
export HIGH_VULNERABILITY_THRESHOLD="140"
export MEDIUM_VULNERABILITY_THRESHOLD="90"

if [ -z $WORKSPACE ]
then
    export WORKSPACE="/tmp/w"
    export JOB_NAME="XFN"
fi



export CxCONSOLE_COMMAND_PATH=$CX_CONSOLE_PATH/runCxConsole.sh
export XSLT_HTML_OUTPUT=$CX_CONSOLE_PATH/CxResult.xslt
export XSLT_HTML_RES=$CX_CONSOLE_PATH/CxHigh.xslt
export MSXSL_COMMAND_PATH=$CX_CONSOLE_PATH/xsltproc

if [ -f $WORKSPACE/${JOB_NAME}_CXresults.html ] 
then
 rm  $WORKSPACE/${JOB_NAME}_CXresults.html
fi
if [ -f $WORKSPACE/${JOB_NAME}_CXresults.pdf ] 
then
 rm  $WORKSPACE/${JOB_NAME}_CXresults.pdf
fi
if [ -f $WORKSPACE/${JOB_NAME}_CXresult.xml ] 
then
 rm  $WORKSPACE/${JOB_NAME}_CXresult.xml
fi


$CxCONSOLE_COMMAND_PATH Scan -CxServer $CHECKMARX_HOST -CxUser $USERNAME -CxPassword $PASS -ProjectName CxServer\\SP\\$JOB_NAME -Locationtype folder -locationpath $WORKSPACE -Preset $PRESET  -reportxml $WORKSPACE/${JOB_NAME}_CXresult.xml -reportpdf $WORKSPACE/${JOB_NAME}_CXresults.pdf  -v

if [ -d $CX_CONSOLE_PATH/${JOB_NAME} ]
then
    rm -rf $CX_CONSOLE_PATH/${JOB_NAME}
fi


if [ -f $WORKSPACE/${JOB_NAME}_CXresult.xml -a -x $MSXSL_COMMAND_PATH ] 
then
    $MSXSL_COMMAND_PATH  -o "$WORKSPACE/${JOB_NAME}_CXresults.html" "$XSLT_HTML_OUTPUT" "$WORKSPACE/${JOB_NAME}_CXresult.xml" 
    RES=`$MSXSL_COMMAND_PATH   "$XSLT_HTML_RES" "$WORKSPACE/${JOB_NAME}_CXresult.xml" |tee | awk '/High/{print $2" "$5}'`
    echo $RES
    HIGH=`echo $RES   | awk '{print $1}'`
    MEDIUM=`echo $RES | awk '{print $2}'`
    if [ $HIGH -gt $HIGH_VULNERABILITY_THRESHOLD -o $MEDIUM -gt $MEDIUM_VULNERABILITY_THRESHOLD ]
    then
	exit 1
    fi
fi


