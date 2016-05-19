defmodule Eikon.GIF do
  @moduledoc false
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

  @type gif :: struct()

  @magic89 to_string([?G, ?I, ?F, ?8, ?9, ?a])
  @magic87 to_string([?G, ?I, ?F, ?8, ?7, ?a])

  @doc "Check the magic number of the file."
  @spec magic?(bitstring) :: true | false
  def magic?(<<@magic89, _rest :: binary>>), do: true
  def magic?(<<@magic87, _rest :: binary>>), do: true
  def magic?(_),                             do: false

  @doc "Returns the metadata about the GIF file."
  @spec infos(bitstring) :: gif
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

  @spec content!(bitstring) :: bitstring | no_return
  def content!(bitstring) do
    case content(bitstring) do
      {:ok, rest}   -> rest
      {:error, msg} -> raise(ArgumentError, msg)
    end
  end

  @spec parse(bitstring) :: {:ok, struct} | {:error, term}
  def parse(gif) do
    if magic?(gif) do
      result = infos(gif) |> struct(images: content!(gif))
      {:ok, result}
    else
      {:error, "Invalid file format!"}
    end
  end

  def parse!(gif) do
    case parse(gif) do
      {:ok, %GIF{}=gif} -> gif
      {:error, msg} -> raise(ArgumentError, msg)
    end
  end
end
