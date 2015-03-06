package Mojolicious::Command::generate::lexicont;
use 5.008005;
use strict;
use warnings;
use Mojo::Base 'Mojolicious::Command';

our $VERSION = "0.01";

__PACKAGE__->attr(description => <<'EOF');
Generate lexicon file translations.
EOF

__PACKAGE__->attr(usage => <<"EOF");
usage: $0 generate lexicont src_lang dest_lang ...
EOF

sub run {
    my $self      = shift;

    if ($@ < 2){
        print "please specify arguments";
        exit;
    }

    my $src_lang  = shift;

    my $app;
    if (ref $self->app eq 'CODE'){
        $app = $self->app->();
    }
    else{
        $app = $self->app;
    }
    my $app_class = ref $app;
    $app_class =~ s{::}{/}g;
    my $app_klass = ref $app;

    my $verbose;

    my @dest_langs = @_;

    my $src_file = $app->home->rel_file("lib/$app_class/I18N/${src_lang}.pm");

    if (-e $src_file) {
        print <<NOTFOUND;
File not found $src_file
NOTFOUND
        return;
    }

    my %srclex = eval {
        require "$app_class/I18N/${src_lang}.pm";
        no strict 'refs';
        %{*{"${app_class}::I18N::${src_lang}::Lexicon"}};
    };

    for my $dest_lang (@dest_langs){

        my $dest_file = $app->home->rel_file("lib/$app_class/I18N/${dest_lang}.pm");
        
        my %lexicon = map { $_ => _translate( $srclex{$_}, $dest_lang) } keys %srclex;

        # Output lexem
        $self->render_to_file('package', $dest_file, $app_klass, $dest_lang,
            \%lexicon);

    }

}

sub _translate{

  my $src = shift;
  my $lang = shift;
  
  return "dummy";

}
__DATA__
@@ package
% my ($app_class, $language, $lexicon) = @_;
package <%= $app_class %>::I18N::<%= $language %>;
use base '<%= $app_class %>::I18N';
use utf8;

our %Lexicon = (
% foreach my $lexem (sort keys %$lexicon) {
    % my $data = $lexicon->{$lexem} || '';
    % $lexem=~s/'/\\'/g;
    % utf8::encode $data;
    % $data =~s/'/\\'/g;
    % if( $data =~ s/\n/\\n/g ){
    %   $data = '"' . $data . '"';
    % } else {
    %   $data = "'${data}'";
    % }
    % unless ($lexem=~s/\n/\\n/g) {
    '<%= $lexem %>' => <%= $data %>,
    % } else {
    "<%= $lexem %>" => <%= $data %>,
    % };
% }
);

1;

__END__

=encoding utf-8

=head1 NAME

Mojolicious::Command::generate::lexicont - Mojolicious Lexicon Translation Generator

=head1 SYNOPSIS

    APPLICATION generate lexicont src_lang dest_lang ...

=head1 DESCRIPTION

Mojolicious::Command::generate::lexicont is lexicon translation generator for Mojolicious.

=head1 LICENSE

Copyright (C) dokechin.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

dokechin E<lt>E<gt>

=cut

