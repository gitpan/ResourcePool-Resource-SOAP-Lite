#*********************************************************************
#*** ResourcePool::Factory::SOAP::Lite
#*** Copyright (c) 2003 by Markus Winand <mws@fatalmind.com>
#*** $Id: Lite.pm,v 1.4 2003/05/07 20:38:10 mws Exp $
#*********************************************************************

package ResourcePool::Factory::SOAP::Lite;

use vars qw($VERSION @ISA);
use strict;
use ResourcePool::Resource::SOAP::Lite;
use ResourcePool::Factory;

$VERSION = "1.0101";
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

sub info($) {
	my ($self) = @_;
	return $self->{PROXYURL};
}

1;
