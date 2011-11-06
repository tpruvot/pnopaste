#!/usr/bin/perl

# This file is part of the pnopaste program
# Copyright (C) 2008-2010 Patrick Matthäi <pmatthaei@debian.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

use warnings;
use strict;

# Distribution mode. Just uncomment the following lines
# if you are a packager!
use FindBin qw($Bin);
BEGIN {
	push(@INC, $Bin . '/../');
}

use lib::Expire;

Expire::Delete_Old_Entrys();

exit(0);
