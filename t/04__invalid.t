#!/usr/bin/perl

##
## Tests for invalid accessors
##

#use blib;
use strict;
use warnings;

use Test::More tests => 5;
use Carp;

use_ok( "accessors" );

## invalid accessor names
do {
    eval { import accessors $_ };
    ok( $@, "invalid accessor - $_" );
} for (qw( DESTROY AUTOLOAD 1notasub @$%*&^';\/ ));

