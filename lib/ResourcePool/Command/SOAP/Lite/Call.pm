#*********************************************************************
#*** ResourcePool/Command/SOAP/Lite/Call.pm
#*** Copyright (c) 2003 by Markus Winand <mws@fatalmind.com>
#*** $Id: Call.pm,v 1.3 2003/05/07 20:38:09 mws Exp $
#*********************************************************************
package ResourcePool::Command::SOAP::Lite::Call;

use ResourcePool::Command;
use ResourcePool::Command::NoFailoverException;
use strict;
use SOAP::Lite;
use vars qw(@ISA $VERSION);

$VERSION = "1.0101";
push @ISA, qw(ResourcePool::Command);

sub new($$) {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	$self->{namespace} = shift;

	bless($self, $class);
	return $self;
}

sub execute($$$@) {
	my ($self, $soaph, $method, @args) = @_;

	$soaph->uri($self->{namespace});
	my $som = $soaph->call($method => @args);
	my $fc = $som->faultcode();
	if ($fc) {
		# some error happend
		# throw NoFailoverException if it is a Client fault
		my $ex;
		if ($fc =~ /^[^:]*:Client/i) {
			$ex = ResourcePool::Command::NoFailoverException->new($som->fault());
		} else {
			$ex = $som->fault();
		}

		die $ex;
	}
	return $som->result();
}

