#!/usr/bin/perl

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
use CGI qw/:standard/;
use lib::Code;
use lib::HTML;
use lib::Security;
use lib::Highlighting;
use lib::Expire;


# CGI class.
my $CGI = new CGI;

# Security settings for the cgi module.
$CGI::DISABLE_UPLOADS = 1;
$CGI::POST_MAX = 83886080;


# Start the application.
Main();


### Main function - it decides where we go.
sub Main {

	my $Full_URL = $CGI->url(-full => 1);
	my $Remote_Addr = $CGI->remote_host();

	if(!defined $Full_URL){
		$Full_URL = 'none';
	}
	if(!defined $Remote_Addr){
		$Remote_Addr = 'none';
	}

	# Block all banned IPs directly.
	if(Security::Blacklist_Host($Remote_Addr) == 1){
		HTML::Error(2);
	}

	#Clean up database from expired entries.
	if(Expire::Get_Cleanup()){
		Expire::Delete_Old_Entrys();
	}


	# Get all GET parameters.
	my $Params = $CGI->url_param('keywords');

	# Seems like someone wants a code.
	if($Params and $Params =~ /^\d/){

		my $Download = 0;
		if($Params =~ /download$/){
			$Download = 1;
		}

		$Params =~ s/^\D*?(\d+).*$/$1/;
		$Params = int($Params);

		HTML::Code($Params, $Download, $Full_URL);
	}

	# New code comes in.
	elsif($CGI->param('code')){
		# Get POST parameters.
		my $Code = $CGI->param('code')          || '';
		my $Desc = $CGI->param('description')   || '';
		my $Name = $CGI->param('name')          || '';
		my $Expi = $CGI->param('expires')       || $Expire::Standard;
		my $Synt = $CGI->param('language')      || 'Plain';

		Code::Add($Code, $Desc, $Name, $Expi, $Synt, $Remote_Addr, $Full_URL);
	}

	else {
		# Else just show the add page.
		HTML::Add($Full_URL);
	}

}


1;
