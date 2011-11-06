package Database;

# This file is part of the pnopaste program
# Copyright (C) 2008-2010 Patrick Matthäi <pmatthaei@debian.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

use warnings;
no warnings 'once';
use strict;
use DBI;
use conf::SQL_Access;

### Database handle.
our $dbh = DBI->connect_cached(
	"dbi:$SQL_Access::Driver:$SQL_Access::Database:$SQL_Access::Hostname",
	$SQL_Access::Username,
	$SQL_Access::Password
) or die 'SQL error: ', $DBI::errstr;


1;
