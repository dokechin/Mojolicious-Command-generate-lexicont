#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
no warnings 'once';

use FindBin;
use File::Copy;

use Test::More tests => 10;

use lib "$FindBin::Bin/lib";

use_ok 'Mojolicious::Command::generate::lexicont';

copy("$FindBin::Bin/lib/Lexemes2/I18N/ja.ori","$FindBin::Bin/lib/Lexemes2/I18N/ja.pm");

my $conf_file = "$FindBin::Bin/lexicont.test.conf";
my $l = new_ok 'Mojolicious::Command::generate::lexicont', [conf_file=>$conf_file];

$l->quiet(1);
$l->app(sub { Mojo::Server->new->build_app('Lexemes2') });

$l->run("ja", "en", "zh" ,"es");

require_ok "$FindBin::Bin/lib/Lexemes2/I18N/ja.pm";

is_deeply \%Lexemes2::I18N::ja::Lexicon,
  {key2 =>'日本語', key3 => '英語'},'correct japanese';

require_ok "$FindBin::Bin/lib/Lexemes2/I18N/en.pm";

is_deeply \%Lexemes2::I18N::en::Lexicon,
  {key2 =>'Japanese', key3 => 'English'},'correct english';

require_ok "$FindBin::Bin/lib/Lexemes2/I18N/es.pm";

is_deeply \%Lexemes2::I18N::es::Lexicon,
  {'key2' => 'japonés', key3 =>'idioma en Inglés'}, 'correct spanish';

require_ok "$FindBin::Bin/lib/Lexemes2/I18N/zh.pm";

is_deeply \%Lexemes2::I18N::zh::Lexicon,
  {'key2' => '日本', key3 =>'英语'}, 'correct chinese';

#unlink "$FindBin::Bin/lib/Lexemes2/I18N/ja.pm";
unlink "$FindBin::Bin/lib/Lexemes2/I18N/en.pm";
unlink "$FindBin::Bin/lib/Lexemes2/I18N/es.pm";
unlink "$FindBin::Bin/lib/Lexemes2/I18N/zh.pm";
