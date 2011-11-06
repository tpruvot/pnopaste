package SQL_Access;

#use warnings;
#use strict;
use conf::debiandb;

# DBI driver (we only support officaly mysql at the moment!).
our $Driver = $dbtype;

# SQL Access.
our $Hostname = $dbserver;
our $Database = $dbname;
our $Username = $dbuser;
our $Password = $dbpass;

1;
