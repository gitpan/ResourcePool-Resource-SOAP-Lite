#*********************************************************************
#*** ResourcePool::Factory::SOAP::Lite
#*** Copyright (c) 2003 by Markus Winand <mws@fatalmind.com>
#*** $Id: Lite.pm,v 1.2 2003/02/22 17:07:47 mws Exp $
#*********************************************************************

package ResourcePool::Factory::SOAP::Lite;

use vars qw($VERSION @ISA);
use strict;
use ResourcePool::Resource::SOAP::Lite;
use ResourcePool::Factory;

$VERSION = "1.0100";
push @ISA, "ResourcePool::Factory";

sub new($$) {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = $class->SUPER::new("SOAP::Lite");

	if (! exists($self->{PROXYURL})) {
		$self->{PROXYURL} = shift;
	}
	bless($self, $class);
	return $self;
}

sub create_resource($) {
	my ($self) = @_;
	return ResourcePool::Resource::SOAP::Lite->new(
		  $self->{PROXYURL}
	);
}

1;
