package Benchmark;

# This file is part of the pnopaste program
# Copyright (C) 2008-2010 Patrick Matthäi <pmatthaei@debian.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

use warnings;
use strict;
use Time::HiRes qw(gettimeofday);


my($Start_Sec, $Start_USec) = gettimeofday();
my $Bench_Start = $Start_Sec . '.' . $Start_USec;


sub Calculate {

	my($End_Sec, $End_USec) = gettimeofday();
	my $Bench_End = $End_Sec . '.' . $End_USec;

	my $Diff = $Bench_End - $Bench_Start;
	$Diff = sprintf("%.4f", $Diff);

	if($Diff < 0){
		$Diff = '0.0000';
	}

	return $Diff;
}


1;
