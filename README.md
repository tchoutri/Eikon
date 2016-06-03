# Eikōn [![Elixir](https://cdn.rawgit.com/tchoutri/Eikon/master/elixir.svg)](http://elixir-lang.org) [![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://raw.githubusercontent.com/tchoutri/eikon/master/LICENSE) [![Hex Version](http://img.shields.io/hexpm/v/eikon.svg?style=flat-square)](https://hex.pm/packages/eikon) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/tchoutri/Eikon.svg)](https://beta.hexfaktor.org/github/tchoutri/Eikon)

Eikōn is an image file parser. Feed it a PNG, JPG, and it will return informations about it.

# Table of Contents
1. [Installation](#installation)
2. [Usage](#usage)
3. [Examples](#examples)


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


## Examples
### Parsing a binary

```Elixir
Erlang/OTP 18 [erts-7.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]

Interactive Elixir (1.2.5) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> alias Eikon.PNG.Parser
nil
iex(2)⋅❯ File.read!("priv/mandelbrot.png") |> Parser.parse
{:ok,
 %Eikon.PNG{bit_depth: 8,
  chunks: {:ok,
   <<0, 0, 0, 3, 115, 66, 73, 84, 8, 8, 8, 219, 225, 79, 224, 0, 0, 32, 0, 73, 68, 65, 84, 120, 94, 237, 217, 235, 113, 228, 56, 150, 6, 208, 204, 117, 137, 52, 65, 46, 148, 13, 116, 161, 77, 40, ...>>},
  color_type: 2, compression: 0, filter: 0, height: 747, interlace: 0,
  width: 1365}}
```

### Only return the metadata
```Elixir
iex(3)⋅❯ File.read!("priv/mandelbrot.png") |> Parser.infos
%Eikon.PNG{bit_depth: 8, chunks: nil, color_type: 2, compression: 0, filter: 0, height: 747, interlace: 0, width: 1365}
```

### Extract some particular metadata
```Elixir
iex(4)⋅❯ image = (File.read!("priv/mandelbrot.png") |> Parser.infos)
%Eikon.PNG{bit_depth: 8, chunks: nil, color_type: 2, compression: 0, filter: 0,
 height: 747, interlace: 0, width: 1365}
iex(5)⋅❯ image.width
1365
```

### Works also with GIFs
```Elixir
iex(6)⋅❯ alias Eikon.GIF.Parser
nil
iex(7)⋅❯ File.read!("priv/hammer_time.gif") |> Parser.infos
%Eikon.GIF{height: 540, images: nil, version: "89a", width: 960}
```

### When you just want to know if it's a valid file.
```Elixir
iex(8)⋅❯ File.read!("priv/hammer_time.gif") |> Parser.magic?
true
```

