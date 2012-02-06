package Code;

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
use lib::Expire;
use lib::HTML;
use lib::Security;
use lib::Highlighting;

### Adds a new code to the database.
sub Add {
	my($Code, $Desc, $Name, $Expi, $Synt, $Remote_Addr, $Full_URL) = @_;

        # Now some security checks, if all given values are valid.
        if(Expire::Valid_Time($Expi) == 0){
                HTML::Error(1);
        }
        elsif(Security::Blacklist_Words($Code) == 1){
                HTML::Error(3);
        }
        elsif(Highlighting::Is_Valid($Synt) == 0){
                HTML::Error(4);
        }

        # Create query with all needed data.
        my $Query = 'INSERT INTO nopaste (name, description, code, time, ip, expires, language) VALUES (?, ?, ?, ?, ?, ?, ?)';
        $Query = $Database::dbh->prepare($Query);

        $Query->execute($Name, $Desc, $Code, time(), $Remote_Addr, $Expire::Time_List{$Expi}, $Synt);

        # Get the last MySQL auto_increment ID.
        my $Last_ID = $Database::dbh->{'mysql_insertid'};

        # Show us the confirm page.
        HTML::Confirm($Last_ID, $Full_URL, length($Code));
}

1;
