#!/usr/bin/perl

##
## Tests for accessors::classic
##

#use blib;
use strict;
use warnings;

use Test::More tests => 12;
use Carp;

BEGIN { use_ok( "accessors::classic" ) };

my $time = shift || 1;

my $foo = bless {}, 'Foo';
can_ok( $foo, 'bar' );
can_ok( $foo, 'baz' );

is( $foo->bar( 'set' ), 'set', 'set foo->bar' );
is( $foo->baz( 2 ), 2,         'set foo->baz' );
is( $foo->bar, 'set',          'get foo->bar' );

SKIP: {
    eval "use Benchmark qw( timestr countit )"; # ya never know...
    skip 'Benchmark.pm not installed!', 3 if ($@);
    eval "use t::Benchmark";
    die $@ if $@;

    my $i    = 0;
    my @list = ('a' .. 'aaaa');
    test_generation_performance
      (
       sub { package Blah;
	     import accessors::classic ($list[$i++ % @list]) }
      );

    test_set_get_performance( time      => $time,
			      generated => bless( {}, 'Generated' ),
			      hardcoded => bless( {}, 'HardCoded' ),
			      optimized => bless( {}, 'Optimized' ), );
}

package Foo;
use accessors::classic qw( bar baz );

# use different classes w/same accessor name + variable length
# for performance tests...
package Generated;
use accessors::classic qw( foo );
package HardCoded;
sub foo {
    my $self = shift;
    $self->{foo} = shift if (@_);
    return $self->{foo};
}
package Optimized;
sub foo {
    (@_ > 1) ? $_[0]->{'foo'} = $_[1] : $_[0]->{'foo'};
}
