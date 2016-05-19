# Eikōn [![Elixir](https://cdn.rawgit.com/tchoutri/Eikon/master/elixir.svg)](http://elixir-lang.org) [![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://raw.githubusercontent.com/tchoutri/eikon/master/LICENSE) [![Hex Version](http://img.shields.io/hexpm/v/eikon.svg?style=flat-square)](https://hex.pm/packages/eikon)

Eikōn is an image file parser. Feed it a PNG, JPG, and it will return informations about it.

## Installation

```Elixir
def deps do
    [{:eikon, "~> 0.0.2"}]
end
```

## Usage
Each file format is supported through a parser, for instance `Eikon.PNG.Parser` which contains the functions to work with it.  
For the moment, the following formats are supported :

- [x] PNG
- [x] GIF (Although `content/1` could be improved)
- [ ] JPEG

### The `Parser` Behaviour

Every parser implements the [Parser](lib/eikon.ex#L11) behaviour, which contains standard functions:

* General Parsing
    * `parse/1`
    * `parse!/1`

* Magic number checking
    * `magic?/1`

* Metadata extraction
    * `infos/1`
* Returning the content of the image (without the metadata)
    * `content/1`
    * `content!/1`

