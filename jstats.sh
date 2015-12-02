#!/bin/bash
# run local as root
/opt/wildfly/bin/jboss-cli.sh -c controller=$(hostname -s) --command="/core-service=platform-mbean/type=memory:read-attribute(name=heap-memory-usage)"
/opt/wildfly/bin/jboss-cli.sh -c controller=$(hostname -s) --command="/subsystem=datasources/data-source=OracleDS/statistics=pool:read-resource(recursive=true, include-runtime=true)"
