istor
=====

`istor` is a bash utility for checking if an IP (IPv4) belongs to a Tor exit
node on Debian based systems. Comparison is made for speed against the local
postgres database of exit nodes established with the `tornodes` script of the
inside the present repository.

For details:

  ./istor --help
  ./tornodes --help

The default URL of currently advertised Tor exit nodes in use is

https://check.torproject.org/torbulkexitlist

Requirements
------------

curl, postgres, postgresql-contrib, torsocks [optional]

istor
-----

usage: istor <IP> [OPTIONS]

Checks if the provided IP belongs to a Tor exit node. It exits with

        0 if it belongs to an exit node
        1 if it does not
        3 in case of database error (see below)
        2 in case of wrong usage

Comparison is made for speed against the local database of Tor exit nodes 
established with the 'tornodes' command. Keep this database synced with
list of advertised Tor exit nodes in order to get correct results. 
See 'tornodes --help' for details.

Options
  --help, -h  Display this message and exit
  --dbamne  the local database of Tor exit nodes (default: "tornodes")
  --dbuser  user name of the above database (default: "postgres")

Examples
  $ istor 104.244.76.13
  $ istor 104.244.76.13 --dbname tornodes --dbuser postgres

tornodes
--------

usage: tornodes <ACTION> [OPTIONS]

Utility for locally maintaining a postgres database of Tor exit nodes
on Debian based systems via psql.

Notes on database: The database is fairly minimal. It consists of one
table "exit_nodes" with one column "ip". Its default name is "tornodes"
with default user "postgres".

Actions
  create        Create local database and populate with the IPs from the
                list of currently advertised Tor exit nodes
  update        Synchronize the local database with the list of currently
                advertised Tor exit nodes
  clear         Delete local database entries
  drop          Drop local database
  open          Access local database via psql in terminal mode
  number        Print number of exit nodes
  all           Print list of exit nodes
  diff          Print differences between local database and list of
                currently advertized exit Tor nodes

Options
  --help, -h    Display this message and exit
  --url         URL of advertised Tor exit nodes to use. Defaults to
                https://check.torproject.org/torbulkexitlist
  --dbname      Name of local database (default: tornodes)
  --dbuser      Database user (default: postgres)
  --no-populate Do not populate database upon creation (default: false)
  --torify      Torify connection to exit nodes URL (default: false)
  --remote      When combined with "number" or "all", derive
                info from the current public list of exit nodes
                instead of quering the database

Examples
  $ tornodes create
  $ tornodes diff
  $ tornodes update
