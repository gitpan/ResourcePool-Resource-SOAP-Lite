#! /usr/bin/perl -w
#*********************************************************************
#*** t/30SOAP.t
#*** Copyright (c) 2003 by Markus Winand <mws@fatalmind.com>
#*** $Id: 40CallCmd.t,v 1.3 2003/02/22 20:34:20 mws Exp $
#*********************************************************************
use strict;
use Test;

use SOAP::Lite;
use ResourcePool;
use ResourcePool::Factory::SOAP::Lite;
use ResourcePool::Command::SOAP::Lite::Call;

BEGIN { plan tests => 11;};

# there shall be silence
$SIG{'__WARN__'} = sub {};

my $f1 = ResourcePool::Factory::SOAP::Lite->new(
          "http://www.fatalmind.com/projects/ResourcePool/SOAPtest/"
);

my $p1 = ResourcePool->new($f1, MaxExecTry => 2);

my $cmd = ResourcePool::Command::SOAP::Lite::Call->new('RPSLTEST');
ok ($p1->execute($cmd, 'test_return') eq "hirsch");

ok ($p1->execute($cmd, 'test_echo1', 'hirsch') eq "hirsch");
ok ($p1->execute($cmd, 'test_echo1', 'reh') eq "reh");

eval {
	$p1->execute($cmd, 'test_die');
};
my $ex = $@;
ok ($ex);
ok ($ex->isa('ResourcePool::Command::Exception'));
ok ($ex->rootException()->{faultstring} =~ /a dead deer/);
ok ($ex->getExecutions() == 2); # Server fault -> no NoFailoverException

eval {
	$p1->execute($cmd, 'test_client_fault');
};
$ex = $@;
ok ($ex);
ok ($ex->isa('ResourcePool::Command::Exception'));
ok ($ex->rootException()->{faultstring} =~ /a deer has been shot/);
ok ($ex->getExecutions() == 1); # Client fault -> NoFailoverException

