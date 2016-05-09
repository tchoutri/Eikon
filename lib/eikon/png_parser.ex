defmodule Eikon.PNG do
  @moduledoc false
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
  Provide a basic interface for PNG files.
  """
  alias Eikon.{PNG,Parser}
  @behaviour Parser

  # Type definitions
  @typedoc """
  Header of the PNG file.
  """
  @type magic :: bitstring()

  @type chunk_length :: integer()
  @type width :: integer()
  @type height :: integer()
  @type bit_depth :: integer()
  @type color_type :: integer()
  @type filter :: integer()
  @type crc :: integer()
  @type interlace :: integer()

  @type png :: struct()

  # Headers
  @magic <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>

  ## API
  @doc "Parses the file and returns a %PNG{} struct"
  @spec parse(bitstring) :: {:ok, struct} | {:error, term}
  def parse(png) do
    if magic?(png) do
      result = infos(png) |> struct(chunks: content(png))
      {:ok, result}
    else
      {:error, "Invalid file format!"}
    end
  end

  def parse!(png) do
    case parse(png) do
      {:ok, %PNG{}=png} -> png
      {:error, msg} -> raise(ArgumentError, msg)
    end
  end

  @doc "Check the magic number of the file."
  @spec magic?(bitstring) :: true | false
  def magic?(<<@magic, _ :: binary>>), do: true
  def magic?(_),                       do: false

  @doc "Returns the metadata about the PNG file."
  @spec infos(bitstring) :: png
  def infos(<<@magic, 
            _lenght :: size(32),
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
  @spec content(bitstring) :: bitstring
  def content(<<@magic, 
            _lenght :: size(32),
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
    chunks
  end
end
