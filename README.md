# NAME

Mojolicious::Command::generate::lexicont - Mojolicious Lexicon Translation Generator

# SYNOPSIS

    APPLICATION generate lexicont src_lang dest_lang ...

# DESCRIPTION

Mojolicious::Command::generate::lexicont is lexicon translation generator.

# CONFIGURATION

Create config file lingua\_translate.conf on your project home directory.

for example 

Bing

{
  back\_end => "Bing",
  client\_id => "YOUR\_CLIENT\_ID", 
  client\_secret => "YOUR\_CLIENT\_SECRET"
}

Google

{
  back\_end => "Google",
  apy\_key  => "YOUR\_API\_KEY",
}

# LICENSE

Copyright (C) dokechin.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

dokechin <>
