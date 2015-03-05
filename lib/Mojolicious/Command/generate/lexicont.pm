package Mojolicious::Command::generate::lexicont;
use 5.008005;
use strict;
use warnings;
use Mojo::Base 'Mojolicious::Command';

our $VERSION = "0.01";

__PACKAGE__->attr(description => <<'EOF');
Generate lexicon file translation.
EOF

__PACKAGE__->attr(usage => <<"EOF");
usage: $0 generate lexicont src_lang dest_lang
Options:
  -v, --verbose
EOF

sub run {
    my $self      = shift;
    my $src_lang  = shift;
    my $dest_lang = shift;
    my $app;
    if (ref $self->app eq 'CODE'){
        $app = $self->app->();
    }
    else{
        $app = $self->app;
    }
    my $app_class = ref $app;
    $app_class =~ s{::}{/}g;

    my $verbose;

    local @ARGV = @_ if @_;

    my $result = GetOptions(
        'verbose|v:1'        => \$verbose,
    );

    my $lexem_file = $app->home->rel_file("lib/$app_class/I18N/${src_lang}.pm");

    if (-e $lexem_file) {
        print <<NOTFOUND;
File not found $lexem_file
NOTFOUND
        return;
    }

}

1;
__END__

=encoding utf-8

=head1 NAME

Mojolicious::Command::generate::lexicont - Mojolicious Lexicon Translation Generator

=head1 SYNOPSIS

    use Mojolicious::Command::generate::lexicont;

=head1 DESCRIPTION

Mojolicious::Command::generate::lexicont is lexicon translation generator for Mojolicious.

=head1 LICENSE

Copyright (C) dokechin.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

dokechin E<lt>E<gt>

=cut

