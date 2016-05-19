defmodule Eikon.PNG do
  @moduledoc "A struct that holds several informations about a PNG file"
  @typedoc """
A struct with the following fields: 
- :bit_depth
- :chunks
- :color_type
- :compressionfilter
- :height
- :interlace
- :width
  """
  @type t :: struct
  defstruct [
            :width,
            :height,
            :bit_depth,
            :color_type,
            :compression,
            :filter,
            :interlace,
            :chunks
          ]
end

defmodule Eikon.PNG.Parser do
  @moduledoc """
  Provides a basic interface for PNG files.
  """
  alias Eikon.{PNG,Parser}
  @behaviour Parser

  # (Useless) Type definitions
  @type magic :: bitstring()

  @type chunk_length :: integer()
  @type width :: integer()
  @type height :: integer()
  @type bit_depth :: integer()
  @type color_type :: integer()
  @type filter :: integer()
  @type crc :: integer()
  @type interlace :: integer()

  # Headers
  @magic <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>

  ## API
  @doc "Parse a bitstring and return a struct with its metadata and content"
  @spec parse(bitstring) :: {:ok, PNG.t} | {:error, term}
  def parse(png) do
    if magic?(png) do
      result = infos(png) |> struct(chunks: content(png))
      {:ok, result}
    else
      {:error, "Invalid file format!"}
    end
  end

  @doc "Parse a bitstring and return a struct with its metadata and content or raises an error"
  @spec parse!(bitstring) :: PNG.t | no_return
  def parse!(png) do
    case parse(png) do
      {:ok, %PNG{}=png} -> png
      {:error, msg} -> raise(ArgumentError, msg)
    end
  end

  @doc "Check data's magic number"
  @spec magic?(bitstring) :: true | false
  def magic?(<<@magic, _ :: binary>>), do: true
  def magic?(_),                       do: false

  @doc "Returns the PNG metadata"
  @spec infos(bitstring) :: PNG.t
  def infos(<<@magic, 
            _length :: size(32),
            "IHDR",
            width   :: size(32),
            height  :: size(32),
            bit_depth,
            color_type,
            compression,
            filter,
            interlace,
            _crc :: size(32),
            _chunks :: binary>>) do
    %PNG{width: width, height: height, bit_depth: bit_depth,
    color_type: color_type, compression: compression, filter: filter,
    interlace: interlace}
  end
  def infos(_), do: raise(ArgumentError, "Invalid file format!")

  @doc "Returns the content of the PNG file (aka: the image itself)"
  @spec content(bitstring) :: {:ok, bitstring} | {:error, term}
  def content(<<@magic, 
            _length :: size(32),
            "IHDR",
            _width   :: size(32),
            _height  :: size(32),
            _bit_depth,
            _color_type,
            _compression,
            _filter,
            _interlace,
            _crc :: size(32),
            chunks :: binary>>) do
    {:ok, chunks}
  end
  def content(_), do: {:error, "Invalid file format!"}

  @doc "Returns the content of the PNG file or raises an error"
  @spec content!(bitstring) :: bitstring | no_return
  def content!(png) do
    case content(png) do
      {:ok, chunks} -> chunks
      {:error, msg} -> raise(ArgumentError, msg)
    end
  end
end
