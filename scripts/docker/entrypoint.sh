#!/usr/bin/env sh

set -euo pipefail

# Ensure these available as envs
# SPRING_DATASOURCE_USERNAME="root"
# SPRING_DATASOURCE_PASSWORD="dev"
# SPRING_DATASOURCE_HOST="host.docker.internal"
# SPRING_DATASOURCE_PORT="3306"
# SPRING_DATASOURCE_DB_NAME="xxx"

# Construct the JDBC URL
JDBC_URL="jdbc:mysql://$SPRING_DATASOURCE_HOST:$SPRING_DATASOURCE_PORT/$SPRING_DATASOURCE_DB_NAME"

# Export the constructed URL as environment variables
export SPRING_DATASOURCE_URL="$JDBC_URL"
export SPRING_DATASOURCE_WRITER_URL="$JDBC_URL"

# For debugging remove this
echo "SPRING_DATASOURCE_URL=$SPRING_DATASOURCE_URL"
echo "SPRING_DATASOURCE_WRITER_URL=$SPRING_DATASOURCE_WRITER_URL"

# Run Java application
exec java $JAVA_OPTS -jar /app.jar