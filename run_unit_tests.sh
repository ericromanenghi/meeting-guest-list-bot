#! /bin/bash

cover -delete
PERL5OPT=-MDevel::Cover=-ignore,"/usr/bin/prove",+ignore,".t$" prove -r -Ilib t/unit/
cover

