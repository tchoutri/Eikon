# Eikōn

Eikōn is an image file parser. Feed it a PNG, JPG, and it will return informations about it.

## Installation

        def deps do
          [{:eikon, "~> 0.0.1"}]
        end

## Usage
Each file format is supported through a parser, for instance `Eikon.PNG.Parser` which contains the functions to work with it.  
For the moment, the following formats are supported :

- [ ] PNG
