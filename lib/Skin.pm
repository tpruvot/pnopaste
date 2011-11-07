package Skin;

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

# Default (fallback) settings.
my $CSS_Default		= 'rabbid';
my $Title_Default	= 'Nopaste';


### Returns available skins in an array.
sub Get_Available_Skins {
	my @Skins;

	opendir(R,'./skins/');

	while(my $File = readdir(R)){
		if(-e './skins/' . $File and $File =~ /^.*\.css$/){
			$File =~ s/\.css$//;
			push(@Skins, $File);
		}
	}

	closedir(R);

	return @Skins;
}


### Returns the HTML title.
sub Get_Title {
	my $Query = 'SELECT title FROM settings LIMIT 1';
	$Query = $Database::dbh->prepare($Query);
	$Query->execute();

	my $Result = $Query->fetchrow_hashref();
	my $Title = $Result->{'title'};

	if(!defined $Title){
		return $Title_Default;
	} else {
		return $Title;
	}
}


### Checks if a skin is valid.
sub Is_Valid {
	my($Check) = @_;

	return 0 if !$Check;

	my @Skinlist = Get_Available_Skins();

	foreach my $Tmp (@Skinlist){
		if($Tmp eq $Check){
			# Valid.
			return 1;
		}
	}

	# Invalid.
	return 0;
}


### Gets the saved skin from the database.
sub Get_Skin {
	my $Query = 'SELECT style FROM settings LIMIT 1';
	$Query = $Database::dbh->prepare($Query);
	$Query->execute();

	my $Result = $Query->fetchrow_hashref();
	my $Skin = $Result->{'style'};

	if(Is_Valid($Skin) == 0){
		return $CSS_Default;
	} else {
		return $Skin;
	}
}

1;

