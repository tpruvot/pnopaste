package Language;

# This file is part of the pnopaste program
# Copyright (C) 2008-2010 Patrick Matthäi <pmatthaei@debian.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

use warnings;
use strict;
use Geo::IP;
use CGI qw/:standard/;


# Default language.
my $Language = 'EN';
my $Lang_Dir = 'lang/';

# Start the language detection.
Initialiaze();


### Initialize the remote client.
sub Initialiaze {
	# Our CGI object.
	my $CGI = new CGI;
	my $Remote_Addr = $CGI->remote_host();

	if(!defined $Remote_Addr or $Remote_Addr eq 'localhost'){
		# Could not get the IP address, we set the default and return.
		Set_Language($Language);
		return;
	}

	# Our GeoIP object with the standard country database.
	my $GeoIP = Geo::IP->new(GEOIP_STANDARD);

	# Get country code of the remote client.
	my $Country = $GeoIP->country_code_by_addr($Remote_Addr);

	Set_Language($Country);
}


### Sets the language based on the result of geoip country code.
sub Set_Language {
	my($Lang) = @_;

	$Lang = Mapping($Lang);

	my $Lang_File = $Lang_Dir . $Lang . '.pm';

	if(-e $Lang_File){
		# We have got a translation for this client.
		$Language = $Lang;
	}

}


### Do some static language country code mappings.
sub Mapping {
	my($Lang) = @_;

	if(!defined $Lang){
		$Lang = 'EN';
	}
	elsif($Lang eq 'AT'){
		$Lang = 'DE';
	}

	return $Lang;
}


### Get all available translations.
sub Get_Languages {
	my @Languages = ();

	opendir(R, $Lang_Dir) or return undef;

	while(my $File = readdir(R)){
		if($File =~ /^.*\.pm$/){
			$File =~ s/\.pm//;

			push(@Languages, $File);
		}
	}

	closedir(R);

	return @Languages;
}


### Get the translation for the translateable ID.
sub Get {
	my($ID) = @_;

	# Load language module.
	require $Lang_Dir . $Language . '.pm';

	return $Translation::Strings{$ID};
}


1;
