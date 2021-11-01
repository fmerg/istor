# istor

[`istor`](./istor) is a bash utility for checking if an IP (v4) belongs to
a Tor exit node on Debian based systems. Comparison is made for speed against
the local (postgres) database of exit nodes established with the 
[`tornodes`](./tornodes) script inside the present repository.
Run with `--help` for details.

## Basic setup and usage

Install `curl`, `postgres`, `postgresql-contrib`. Create and populate a local 
database of exit nodes with:

```commandline
./tornodes create
```

You can now check if an IP belongs to an exit node as follows:

``` commandline
$ ./istor 176.10.99.200
true
$ echo $?
0
```

Run wih `--help` for more options. Make sure to place the scripts in
a directory of executable programs if you want to run them as commands without
need of relative paths.


### Example use case

You can use `istor` to monitor your NGINX proxy for Tor connections as follows:

```bash
tail -fn0 /var/log/nginx/access.log | while read line; do
    ip=$(echo $line | awk -F' ' '{print $1}')
    istor $ip
    if [[ $? -eq 0 ]]; then 
        #
        # Do something with requests coming from Tor exit nodes
        #
    fi
done
```


## Periodic update

`istor` is fast because it queries a local database instead of everytime
fetching the list of currently advertised exit nodes. Consequently, 
in order to get correct results, you need to update your database on a 
regular basis with

```
$ ./tornodes update
```

For example, assuming `tornodes` has been placed in a directory of executable 
programs, you can create a cronjob for updating the database every minute (it
costs nothing):

```
* * * * * tornodes update
```

## Advanced usage

### [`istor`](./istor)
```
usage: istor <IP> [OPTIONS]

Checks if the provided IP (IPv4) belongs to a Tor exit node. It exits with

    0 if it belongs to an exit node
    1 if it does not
    2 in case of wrong usage
    3 in case of database error (see below)

Comparison is made for speed against the local database of Tor exit nodes 
established with the 'tornodes' command. Keep this database synced with
list of advertised Tor exit nodes in order to get correct results. 
See 'tornodes --help' for details.

Options
  --help, -h  Display this message and exit
  --dbamne    the local database of Tor exit nodes (default: "tornodes")
  --dbuser    user name of the above database (default: "postgres")

Examples
  $ istor 104.244.76.13
  $ istor 104.244.76.13 --dbname tornodes --dbuser postgres
```

### [`tornodes`](./tornodes)
```
usage: tornodes <ACTION> [OPTIONS]

Utility for locally maintaining a postgres database of Tor exit nodes
on Debian based systems via psql.

Notes on database: The database is fairly minimal. It consists of one
table "exit_nodes" with one column "ip". Its default name is "tornodes"
with default user "postgres".

Actions
  create        Create local database and populate with the IPs from the
                list of currently advertised Tor exit nodes
  exists        Check if a database with the provided name (see options)
                exists. Exit with 0 if yes, 1 otherwise.
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
  --force       If with create, overwrite existing database with the same
                name (default: false)
  --no-populate Do not populate database upon creation (default: false)
  --torify      Torify connection to exit nodes URL (default: false)
  --remote      When combined with "number" or "all", derive info from the
                list of currently advertised Tor exit nodes instead of quering
                the local database.

Examples
  $ tornodes create
  $ tornodes diff
  $ tornodes update
```
