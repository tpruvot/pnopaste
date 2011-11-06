package Format;

# This file is part of the pnopaste program
# Copyright (C) 2008-2010 Patrick Matthäi <pmatthaei@debian.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

use warnings;
use strict;
use lib::Highlighting;


### Build line numbers in html.
sub Build_Line_Numbers {
	my($Count) = @_;

	my $String = '';

	# Build $Count anker elements and return them.
	for(my $x = 1; $x <= $Count; $x++){
		$String .= '<a id="line' . $x . '">' . $x . ':</a>' . "\n";
	}

	$String =~ s/\n$//;

	return $String;
}


### Reformat the text for html.
sub To_HTML {
	my($Input, $Language, $Syntax_HL) = @_;

	my $Return = '';


	if($Language eq 'Plain'){
		$Syntax_HL = 0;
	}
	elsif($Syntax_HL == 1){
		Highlighting::Language($Language);
	}

	# We need the numbers of lines.
	my @Walk;
	push(@Walk, $_) for split m!\n! => $Input;


	if($Syntax_HL){
		# Use the highlighting engine.
		$Return = Highlighting::Highlight($Input);
	}
	else {

		foreach my $Line (@Walk){
			$Line =~ s/\r//g;
			$Line =~ s/&/&amp;/g;
			# Do some html enties.
			$Line =~ s/</&lt;/g;
			$Line =~ s/>/&gt;/g;
			$Line =~ s/"/&quot;/g;

			# Add to string.
			if(defined $Line){
				$Return .= $Line . "\n";
			}
		}
	}


	$Return =~ s/\n$//;

	return(scalar(@Walk), $Return);
}

1;
