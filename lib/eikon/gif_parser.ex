defmodule Eikon.GIF do
  @moduledoc "A struct that holds several informations about a PNG file"
  @typedoc """
A struct with the following fields: 
- :width
- :height
- :version
- :images
  """
  @type t :: struct
  defstruct [
            :width,
            :height,
            :version,
            :images
            ]
end

defmodule Eikon.GIF.Parser do
  @moduledoc """
  Provides a basic interface for GIF files.
  """
  alias Eikon.{GIF,Parser}
  @behaviour Parser

  @magic89 to_string([?G, ?I, ?F, ?8, ?9, ?a])
  @magic87 to_string([?G, ?I, ?F, ?8, ?7, ?a])

  @doc "Check the magic number of the file."
  @spec magic?(bitstring) :: true | false
  def magic?(<<@magic89, _rest :: binary>>), do: true
  def magic?(<<@magic87, _rest :: binary>>), do: true
  def magic?(_),                             do: false

  @doc "Returns the metadata about the GIF file."
  @spec infos(bitstring) :: GIF.t
  def infos(<<@magic89, width :: little-size(16), height :: little-size(16), _ :: binary>>) do
    %GIF{width: width, height: height, version: "89a"}
  end
  def infos(<<@magic87, width :: little-size(16), height :: little-size(16), _ :: binary>>) do
    %GIF{width: width, height: height, version: "89a"}
  end

  @doc "Returns the content of the GIF file"
  @spec content(bitstring) :: {:ok, bitstring} | {:error, String.t}
  def content(<<@magic89, _width :: little-size(16), _height :: little-size(16), rest :: binary>>), do: {:ok, rest}
  def content(<<@magic87, _width :: little-size(16), _height :: little-size(16), rest :: binary>>), do: {:ok, rest}
  def content(_),                                                                     do: {:error, "Invalid file format!"}

  @doc "Returns the content of the GIF file or raises an error"
  @spec content!(bitstring) :: bitstring | no_return
  def content!(bitstring) do
    case content(bitstring) do
      {:ok, rest}   -> rest
      {:error, msg} -> raise(ArgumentError, msg)
    end
  end

  @doc "Returns a %GIF{} struct with the file's metadata and content"
  @spec parse(bitstring) :: {:ok, GIF.t} | {:error, term}
  def parse(gif) do
    if magic?(gif) do
      result = infos(gif) |> struct(images: content!(gif))
      {:ok, result}
    else
      {:error, "Invalid file format!"}
    end
  end

  @doc "Returns a %GIF{} struct with the file's metadata and content or raises an error"
  @spec parse!(bitstring) :: GIF.t | no_return
  def parse!(gif) do
    case parse(gif) do
      {:ok, %GIF{}=gif} -> gif
      {:error, msg} -> raise(ArgumentError, msg)
    end
  end
end
