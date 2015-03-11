# NAME

Mojolicious::Command::generate::lexicont - Mojolicious Lexicon Translation Generator

# SYNOPSIS

    # Translate from English to Frenchh
    ./script/my_app generate lexicont en fr
    

    # Translate from English to German, Frenchh and Russian
    ./script/my_app generate lexicont en de fr ru

# DESCRIPTION

Mojolicious::Command::generate::lexicont is lexicon translation generator.

Mojolicious::Plugin::I18N is standard I18N module for Mojolicious.
For example English, you must make lexicon file in the package my\_app::I18N::en.
This module is lexicon file generator from one language to specified languages using
Lingua::Translate. So you can customize translation service.

# CONFIGURATION

Create config file lexicont.conf on your project home directory.



\#InterTran

{
    lingua\_translate => {
      back\_end => "InterTran",
    },
    sleep => 5,
}

\#Bing

{
    lingua\_translate => {
        back\_end => "BingWrapper",
        client\_id => "YOUR\_CLIENT\_ID", 
        client\_secret => "YOUR\_CLIENT\_SECRET"
    }
}



\#Google

{
    lingua\_translate => {
        back\_end => "Google",
        api\_key => "YOUR\_API\_KEY", 
    }
}



# LICENSE

Copyright (C) dokechin.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

dokechin <>
