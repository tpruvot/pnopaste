package Security;

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
use lib::Hits;


### Check if the IP is blacklisted.
sub Blacklist_Host {
	my($IP) = @_;

	my $Query = 'SELECT id FROM blacklist_ip WHERE ip = ? LIMIT 1';
	$Query = $Database::dbh->prepare($Query);
	$Query->execute($IP);

	my $List = $Query->fetchrow_hashref();

	if($List->{'id'}){
		Hits::Inc_Badhost($List->{'id'});
		return 1;
	}

	# Not blacklisted.
	return 0;
}


### Returns the bad Hosts as array.
sub Get_Blacklist_Hosts {
	my $Query = 'SELECT ip FROM blacklist_ip ORDER by id';
	$Query = $Database::dbh->prepare($Query);
	$Query->execute();

	my @Result;

	while(my $List = $Query->fetchrow_hashref()){
		push(@Result, $List->{'ip'});
	}

	return @Result
}


### Check codes for badwords.
sub Blacklist_Words {
	my($Code) = @_;

	my $Query = 'SELECT id,word FROM blacklist_word';
	$Query = $Database::dbh->prepare($Query);
	$Query->execute();

	while(my $List = $Query->fetchrow_hashref()){
		my $Match = $List->{'word'};
		if($Code =~ /$Match/i){
			Hits::Inc_Badword($List->{'id'});
			# Blacklisted.
			return 1;
		}
	}

	# Nothing evil found.
	return 0;
}


### Returns the badwords as array.
sub Get_Blacklist_Words {
	my $Query = 'SELECT word FROM blacklist_word ORDER by id';
	$Query = $Database::dbh->prepare($Query);
	$Query->execute();

	my @Result;

	while(my $List = $Query->fetchrow_hashref()){
		push(@Result, $List->{'word'});
	}

	return @Result;
}

1;
