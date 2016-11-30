#!/bin/bash

# Ensure XDebug and Blackfire remain OFF by default
phpdismod xdebug
phpdismod blackfire

BLACKFIRE=false;
XDEBUG=false;
CONFIGURATION="NONE";

if [ "$BLACKFIRE_ENABLED" == "1"  ] || [ "$BLACKFIRE_ENABLED" == 1 ] || [ "$BLACKFIRE_ENABLED" == "true" ]; then
  BLACKFIRE=true;
  CONFIGURATION="BLACKFIRE";
fi

if [ "$XDEBUG_ENABLED" == "1"  ] || [ "$XDEBUG_ENABLED" == 1 ] || [ "$XDEBUG_ENABLED" == "true" ]; then
  XDEBUG=true;
  CONFIGURATION="XDEBUG";
fi

if [ $BLACKFIRE == true ] && [ $XDEBUG == true ]; then
  echo "[php-debug] NOTICE: Blackfire is not compatible with XDebug, but both are enabled.";
  echo "[php-debug] NOTICE: Disabling XDebug for Blackfire compatibility";
  XDEBUG=false;
  CONFIGURATION="BLACKFIRE";
fi


echo "[php-debug] DEBUG STARTUP: ${CONFIGURATION}"
echo "[php-debug] DIR CONF XDEBUG: ${CONF_PHP_XDEBUG}"
echo "[php-debug] DIR CONF BLACKFIRE: ${CONF_PHP_BLACKFIRE}"


#############################################
#                                           #
#  XDEBUG CONFIGURATIONS                    #
#                                           #
#############################################

echo "[php-debug] setting xdebug.max_nesting_level = ${XDEBUG_MAX_NESTING}"
sed -i "s/xdebug.max_nesting_level=.*/xdebug.max_nesting_level=${XDEBUG_MAX_NESTING}/" $CONF_PHP_XDEBUG

echo "[php-debug] setting xdebug.remote_connect_back = ${XDEBUG_REMOTE_CONNECT_BACK}"
sed -i "s/xdebug.remote_connect_back=.*/xdebug.remote_connect_back=${XDEBUG_REMOTE_CONNECT_BACK}/" $CONF_PHP_XDEBUG

echo "[php-debug] setting xdebug.remote_host = ${XDEBUG_REMOTE_HOST}"
sed -i "s/xdebug.remote_host=.*/xdebug.remote_host=${XDEBUG_REMOTE_HOST}/" $CONF_PHP_XDEBUG

echo "[php-debug] setting xdebug.remote_autostart = ${XDEBUG_REMOTE_AUTOSTART}"
sed -i "s/xdebug.remote_autostart=.*/xdebug.remote_autostart=${XDEBUG_REMOTE_AUTOSTART}/" $CONF_PHP_XDEBUG

echo "[php-debug] setting xdebug.profiler_output_dir = ${XDEBUG_PROFILE_DIR}"
sed -i "s|xdebug.profiler_output_dir=.*|xdebug.profiler_output_dir=${XDEBUG_PROFILE_DIR}|" $CONF_PHP_XDEBUG

echo "[php-debug] setting xdebug.profiler_output_name = ${XDEBUG_PROFILE_FILENAME}"
sed -i "s/xdebug.profiler_output_name=.*/xdebug.profiler_output_name=${XDEBUG_PROFILE_FILENAME}/" $CONF_PHP_XDEBUG

echo "[php-debug] setting xdebug.profiler_enable = ${XDEBUG_PROFILE_ALL}"
sed -i "s/xdebug.profiler_enable=.*/xdebug.profiler_enable=${XDEBUG_PROFILE_ALL}/" $CONF_PHP_XDEBUG

echo "[php-debug] setting xdebug.profiler_enable_trigger = ${XDEBUG_PROFILE_REQUEST}"
sed -i "s/xdebug.profiler_enable_trigger=.*/xdebug.profiler_enable_trigger=${XDEBUG_PROFILE_REQUEST}/" $CONF_PHP_XDEBUG

echo "[php-debug] setting xdebug.profiler_enable_trigger_value = ${XDEBUG_PROFILE_REQUEST_VALUE}"
sed -i "s/xdebug.profiler_enable_trigger_value=.*/xdebug.profiler_enable_trigger_value=${XDEBUG_PROFILE_REQUEST_VALUE}/" $CONF_PHP_XDEBUG



#############################################
#                                           #
#  BLACKFIRE CONFIGURATIONS                 #
#                                           #
#############################################

echo "[php-debug] setting blackfire.agent_socket = ${BLACKFIRE_AGENT_CONNECTION}"
sed -i "s|blackfire.agent_socket=.*|blackfire.agent_socket=${BLACKFIRE_AGENT_CONNECTION}|" $CONF_PHP_BLACKFIRE

echo "[php-debug] setting blackfire.agent_timeout = ${BLACKFIRE_AGENT_TIMEOUT}"
sed -i "s/blackfire.agent_timeout=.*/blackfire.agent_timeout=${BLACKFIRE_AGENT_TIMEOUT}/" $CONF_PHP_BLACKFIRE

echo "[php-debug] setting blackfire.log_level = ${BLACKFIRE_LOG_LEVEL}"
sed -i "s/blackfire.log_level=.*/blackfire.log_level=${BLACKFIRE_LOG_LEVEL}/" $CONF_PHP_BLACKFIRE

echo "[php-debug] setting blackfire.server_id = (hidden)"
sed -i "s/blackfire.server_id=.*/blackfire.server_id=${BLACKFIRE_SERVER_ID}/" $CONF_PHP_BLACKFIRE

echo "[php-debug] setting blackfire.server_token = (hidden)"
sed -i "s/blackfire.server_token=.*/blackfire.server_token=${BLACKFIRE_SERVER_TOKEN}/" $CONF_PHP_BLACKFIRE


#############################################
#                                           #
#  RESULTANT CONFIGURATIONS                 #
#                                           #
#############################################

if [ $BLACKFIRE == true ]; then
  phpenmod blackfire
fi

if [ $XDEBUG == true ]; then
  phpenmod xdebug
fi
