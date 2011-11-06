package Highlighting;

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
use Syntax::Highlight::Engine::Kate;
use conf::Syntax_Languages;


# Language object.
my $Language = '';


### Sets the language object.
sub Language {
	my($Lang) = @_;

	if(Is_Valid($Lang)){
		$Language = $Lang;
		return 1;
	}

	return 0;
}


### Checks if the given language is available.
sub Is_Valid {
	my($Check) = @_;

	if($Syntax_Languages::Langs{$Check} == 1){
		# Valid.
		return 1;
	}

	return 0;
}


### Gets the available languages.
sub Get_Languages {
	my @List;

	while(my($Code_Lang, $Code_Enable) = each(%Syntax_Languages::Langs)){
		if($Code_Enable){
			# Just add activated languages.
			push(@List, $Code_Lang);
		}
	}

	return @List;
}


### Creates the highlighting using the Kate module.
sub Highlight {
	my($Code) = @_;

	if(!$Language){
		return 'No language defined.';
	}

	my $hl = new Syntax::Highlight::Engine::Kate(
		language => $Language,
		substitutions => {
			"<"		=> "&lt;",
			">"		=> "&gt;",
			"&"		=> "&amp;",
			"\t"		=> "    ",
			# All hail to <pre>! (ToDo: Does this work with trailing spaces?)
			# " "		=> "&nbsp;",
			# "\t"		=> "&nbsp;&nbsp;&nbsp;&nbsp;",
			"\r"		=> "",
			"\n"		=> "\n",
		},
		format_table => {
			Alert			=> ["<span class=\"hl_Alert\">", "</span>"],
			BaseN			=> ["<span class=\"hl_BaseN\">", "</span>"],
			BString			=> ["<span class=\"hl_BString\">", "</span>"],
			Char			=> ["<span class=\"hl_Char\">", "</span>"],
			Comment			=> ["<span class=\"hl_Comment\">", "</span>"],
			DataType		=> ["<span class=\"hl_DataType\">", "</span>"],
			DecVal			=> ["<span class=\"hl_DecVal\">", "</span>"],
			Error			=> ["<span class=\"hl_Error\">", "</span>"],
			Float			=> ["<span class=\"hl_Float\">", "</span>"],
			Function		=> ["<span class=\"hl_Function\">", "</span>"],
			IString			=> ["<span class=\"hl_IString\">", "</span>"],
			Keyword			=> ["<span class=\"hl_Keyword\">", "</span>"],
			Normal			=> ["", ""],
			Operator		=> ["<span class=\"hl_Operator\">", "</span>"],
			Others			=> ["<span class=\"hl_Others\">", "</span>"],
			RegionMarker	=> ["<span class=\"hl_RegionMarker\">", "</span>"],
			Reserved		=> ["<span class=\"hl_Reserved\">", "</span>"],
			String			=> ["<span class=\"hl_String\">", "</span>"],
			Variable		=> ["<span class=\"hl_Variable\">", "</span>"],
			Warning			=> ["<span class=\"hl_Warning\">", "</span>"],
		},
	);

	$Code = $hl->highlightText($Code);
	return $Code;
}


### Creates the time list with option tags for HTML.
sub Build_Syntax_List_HTML {
	my @List = Get_Languages();

	my $String = '';

	@List = sort(@List);

	foreach my $Tmp (@List){
		if($Tmp eq $Syntax_Languages::Selected){
			$String .= '<option selected="selected">' . $Tmp . '</option>' . "\n";
		} else {
			$String .= '<option>' . $Tmp . '</option>' . "\n";
		}
	}

	return $String;
}


1;
