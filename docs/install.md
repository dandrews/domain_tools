### Postgresql ###

    brew install postgresql

    ln -sfv /usr/local/opt/postgresql/*plist ~/Library/LaunchAgents

    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

### Database Schema ###

    bundle exec rake db:create db:migrate

    psql domain_tools_development < domains.sql

### Rake Tasks and Scripts ###

    # get zone files locally, into zones/ directory
    bundle exec rake get_zone_files

    # clean and gzip all zones files
    ./script

    # create /zones/master.zone
    bundle exec rake load_tlds_even_faster

    # import zones into database
    bundle exec rake import_zones_from_master