package HTML;

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
use lib::Benchmark;
use lib::Database;
use lib::Expire;
use lib::Format;
use lib::Skin;
use lib::Language;
use lib::Highlighting;
use lib::Version;
use Digest::MD5 qw(md5_hex);

# Shows the confirm page with the ID link.
sub Confirm {
	my($ID, $Self_URL, $Code_Size) = @_;

	Header();

	List_Confirm($ID, $Self_URL, $Code_Size);

	Footer();
}


### Shows errors and exits.
sub Error {
	my($Error_ID) = @_;

	# ErrorID List.
	my %Errors = (
		1	=> Language::Get(1),
		2	=> Language::Get(2),
		3	=> Language::Get(3),
		4	=> Language::Get(4)
	);

	Header();

	print $Errors{$Error_ID}, "\n";

	Footer();
}


### Adds html header and stylesheet.
sub Header {

	# The content type. This is the reason, why Header()
	# is only allowed to be called once in an session.
	print "Content-type: text/html; charset=UTF-8\n\n";

	my $Style = Skin::Get_Skin();
	my $Title = Skin::Get_Title();

	open(HEAD,'<','./templates/header.tmpl') or return;
	while(<HEAD>){
		$_ =~ s/#STYLE#/$Style/g;
		$_ =~ s/#TITLE#/$Title/g;
		$_ = Language_Replace($_);
		print;
	}
	close(HEAD);
}


### Replaces #LANGint()# to translated messages.
sub Language_Replace {
	my($String) = @_;
	
	$String =~ s/#LANG([^#]+)#/Language::Get($1)/eg;
	
	return $String;
}


### Adds html footer.
sub Footer {
	open(FOOT,'<','./templates/footer.tmpl') or return;

	my $Version	= $Version::Build;
	my $Needed	= Benchmark::Calculate();

	while(<FOOT>){
		$_ =~ s/#RENDERTIME#/$Needed/g;
		$_ =~ s/#VERSION#/$Version/g;
		$_ = Language_Replace($_);
		print;
	}
	close(FOOT);

	exit(0);
}


### Adds add form page.
sub Add_Form {
	my($FullURL) = @_;

	my $Timeoptions = Expire::Build_Time_List_HTML();
	my $Langoptions = Highlighting::Build_Syntax_List_HTML();


	open(ADD,'<','./templates/list_addform.tmpl') or return;

	while(<ADD>){
		# Replace the template url with the real one for POST.
		$_ =~ s/#SCRIPTNAME#/$FullURL/g;
		# Insert timesheet lists.
		$_ =~ s/#TIMELISTOPTIONS#/$Timeoptions/g;
		# Insert Syntax HL options.
		$_ =~ s/#LANGUAGEOPTIONS#/$Langoptions/g;
		
		$_ = Language_Replace($_);

		print;
	}

	close(ADD);
}


### Creates the confirm page from the template.
sub List_Confirm {
	my($ID, $FullURL, $CodeSize) = @_;

	# Add the '?<ID>' to the Full URL.
	my $FullURL_ID = $FullURL . '?' . $ID;

	open(CONFIRM,'<','./templates/list_confirm.tmpl') or return;

	while(<CONFIRM>){
		# Replace the template url with the real one for POST.
		$_ =~ s/#LINKCODE#/$FullURL_ID/g;
		$_ =~ s/#URLCODE#/$FullURL/g;
		$_ =~ s/#CODESIZE#/$CodeSize/g;
		$_ = Language_Replace($_);
		print;
	}

	close(CONFIRM);
}


### Display the html main add page.
sub Add {
	my($URL) = @_;

	Header();
	Add_Form($URL);
	Footer();
}


### Displays a code.
sub Code {
	my($ID, $Download, $BaseURL) = @_;

	my $Query = 'SELECT name,description,code,md5,cached,time,ip,language FROM nopaste WHERE id = ? LIMIT 1';
	$Query = $Database::dbh->prepare($Query);
	$Query->execute($ID);

	my $List = $Query->fetchrow_hashref();
	if(!$List){
		Add($BaseURL);
	}

	# Declarations and some failovers.
	my $Time        = localtime($List->{'time'});
	my $Author      = $List->{'name'}   || 'Anonymous';
	my $Description = $List->{'description'} || Language::Get(5);
	my $Code        = $List->{'code'}   || '';
	my $Md5         = $List->{'md5'}    || '';
	my $Cached      = $List->{'cached'} || '';
	my $IP          = $List->{'ip'};
	my $Syntax_HL   = $List->{'language'} || 'Plain';
	my $Expires     = Expire::Get_Expire($ID);

	my $DiffCheck = substr $Code, 0, 4;
	if ($Syntax_HL eq 'Plain') {
		if ($DiffCheck eq 'diff') {
			$Syntax_HL = 'Diff';
		}
		elsif ($DiffCheck eq '----') {
			$Syntax_HL = 'Android Logcat';
		}
	}

	# We have to change the content-type for downloads.
	if($Download){
		print "Content-type: text/plain\n\n";
		print $Code;
		exit(0);
	}


	$Author .= ' (' . $IP . ')';

	my $Md5Check = md5_hex($Syntax_HL.$Time.$Code);

	my ($Code_Lines, $Code_Text, $Line_Numbers);

	if ($Cached eq '' || $Md5Check ne $Md5) {
		($Code_Lines, $Code_Text) = Format::To_HTML($Code, $Syntax_HL, 1);
		$Line_Numbers = Format::Build_Line_Numbers($Code_Lines);

		my $CacheQuery = 'UPDATE nopaste set md5=?, cached=? WHERE id = ?';

		$Query = $Database::dbh->prepare($CacheQuery);
		$Query->execute($Md5Check, $Code_Text, $ID);

	} else {
		$Code_Text = $Cached;
		my $Dummy;
		($Code_Lines, $Dummy) = Format::To_HTML($Code, 'Plain', 1);
		$Line_Numbers = Format::Build_Line_Numbers($Code_Lines);
	}

	my($Desc_Lines, $Desc_Text) = Format::To_HTML($Description, 'Plain', 0);

	my $Get_Link = '<a href="' . $BaseURL . '?' . $ID . '&amp;download">' . Language::Get(6) . '</a>';
	my $New_Link = '<a href="' . $BaseURL . '">' . Language::Get(6) . '</a>';

	Header();

	# Write authors part.
	my $Tmpl_Authors = '';

	open(AUTHORS,'<','./templates/list_table_author.tmpl') or return;
	while(<AUTHORS>){
		$Tmpl_Authors .= $_;
	}
	close(AUTHORS);

	$Tmpl_Authors =~ s/#TIME#/$Time/g;
	$Tmpl_Authors =~ s/#LANGUAGE#/$Syntax_HL/g;
	$Tmpl_Authors =~ s/#EXPIRES#/$Expires/g;
	$Tmpl_Authors =~ s/#LINENUMBERS#/$Line_Numbers/g;
	$Tmpl_Authors =~ s/#DOWNLOAD#/$Get_Link/g;
	$Tmpl_Authors =~ s/#ADD_NEW#/$New_Link/g;
	$Tmpl_Authors = Language_Replace($Tmpl_Authors);
	$Tmpl_Authors =~ s/#AUTHOR#/$Author/g;


	# Write desc part.
	my $Tmpl_Desc = '';

	open(DESC,'<','./templates/list_table_desc.tmpl') or return;
	while(<DESC>){
		$Tmpl_Desc .= $_;
	}
	close(DESC);

	$Tmpl_Desc =~ s/#LINENUMBERS#/$Line_Numbers/g;
	$Tmpl_Desc = Language_Replace($Tmpl_Desc);
	$Tmpl_Desc =~ s/#DESCRIPTION#/$Desc_Text/g;


	# Write code part.
	my $Tmpl_Code = '';

	open(CODE,'<','./templates/list_table_code.tmpl') or return;
	while(<CODE>){
		$Tmpl_Code .= $_;
	}
	close(CODE);

	$Tmpl_Code =~ s/#CODETEXT#/$Code_Text/g;

	print $Tmpl_Authors, $Tmpl_Desc, $Tmpl_Code;

	# Print footer.
	Footer();

}


1;
