#!/bin/bash
#
# Clean Reports (Daily)
/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production reports:prune upto=1 unit=day

#
# Delete orphaned data associated with the above deleted reports.
/opt/puppet/bin/rake \
  -f /opt/puppet/share/puppet-dashboard/Rakefile \
  RAILS_ENV=production \
  reports:prune:orphaned

# Reclaim the space from the database
/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production db:raw:optimize
