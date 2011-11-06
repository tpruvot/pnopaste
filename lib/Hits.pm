package Hits;

# This file is part of the pnopaste program
# Copyright (C) 2008-2010 Patrick Matthäi <pmatthaei@debian.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

use warnings;
use strict;
use lib::Database;


### Inc the Badword hit.
sub Inc_Badword {
	my($ID) = @_;

	my $Query = 'UPDATE blacklist_word SET hits = hits + 1 WHERE id = ? LIMIT 1';
	$Query = $Database::dbh->prepare($Query);
	$Query->execute($ID);
}


### Inc the Badhost hit.
sub Inc_Badhost {
	my($ID) = @_;

	my $Query = 'UPDATE blacklist_ip SET hits = hits + 1 WHERE id = ? LIMIT 1';
	$Query = $Database::dbh->prepare($Query);
	$Query->execute($ID);
}


1;
