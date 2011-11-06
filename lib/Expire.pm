package Expire;

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


our %Time_List = (
	'6h'	=> 21600,
	'1d'	=> 86400,
	'1w'	=> 604800,
	'1m'	=> 2419200,
	'never'	=> 0
);

# Standard choice.
our $Standard = '1w';


### Builds an array of the times.
sub Time_List {
	my @List = sort {
		$Time_List{$b} <=> $Time_List{$a}
	} keys %Time_List;

	return @List;
}


### Creates the time list with option tags for HTML.
sub Build_Time_List_HTML {
	my @List = Time_List();

	my $String = '';

	foreach my $Tmp (@List){
		if($Tmp eq $Standard){
			$String .= '<option selected="selected">' . $Tmp . '</option>' . "\n";
		} else {
			$String .= '<option>' . $Tmp . '</option>' . "\n";
		}
	}

	return $String;
}


### Checks if the expire time is valid.
sub Valid_Time {
	my($Time) = @_;

	if(!defined $Time_List{$Time}){
		return 0;
	}

	return 1;
}


### Get the expire date of a code.
sub Get_Expire {
	my($ID) = @_;

	my $Query = 'SELECT time,expires FROM nopaste WHERE id = ? LIMIT 1';
	$Query = $Database::dbh->prepare($Query);
	$Query->execute($ID);

	my $Result = $Query->fetchrow_hashref();

	my $Expiretime = $Result->{'expires'};
	my $Createtime = $Result->{'time'};

	# It will never expires.
	if(!$Expiretime){
		return 'never';
	}

	$Expiretime += $Createtime;
	$Expiretime = localtime($Expiretime);

	return $Expiretime;
}


### Deletes expired entrys.
sub Delete_Old_Entrys {

	my $Query = 'DELETE FROM nopaste WHERE expires != 0 AND time + expires < ?';
	$Query = $Database::dbh->prepare($Query);
	$Query->execute(time());

}


### Gets default setting for cleanup option.
sub Get_Cleanup {
	my $Default = 1;

	my $Query = 'SELECT cleanup FROM settings LIMIT 1';
	$Query = $Database::dbh->prepare($Query);
	$Query->execute();

	my $List = $Query->fetchrow_hashref();
	if(defined $List->{'cleanup'}){
		$Default = $List->{'cleanup'};
	}

	return $Default;
}

1;
