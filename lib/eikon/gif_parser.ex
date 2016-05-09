defmodule Eikon.GIF do
  defstruct [
            :width,
            :height,
            :version,
            :images
            ]
end

defmodule Eikon.GIF.Parser do
  @moduledoc """
  Provide a basic interface for GIF files.
  """
  alias Eikon.{GIF,Parser}
  @behaviour Parser

  @type gif :: struct()

  @magic89 <<0x47, 0x49, 0x46, 0x38, 0x39, 0x61>>
  @magic87 <<0x47, 0x49, 0x46, 0x38, 0x37, 0x61>>

  @doc "Check the magic number of the file."
  @spec magic?(bitstring) :: true | false
  def magic?(<<@magic89, _rest :: binary>>), do: true
  def magic?(<<@magic87, _rest :: binary>>), do: true
  def magic?(_),                             do: false

  @doc "Returns the metadata about the GIF file."
  @spec infos(bitstring) :: gif
  def infos(<<@magic89, width :: size(16), height :: size(16), _ :: binary>>) do
    %GIF{width: width, height: height, version: "89a"}
  end
  def infos(<<@magic87, width :: size(16), height :: size(16), _ :: binary>>) do
    %GIF{width: width, height: height, version: "89a"}
  end

  @doc "Returns the content of the GIF file"
  @spec content(bitstring) :: bitstring | no_return
  def content(<<@magic89, _width :: size(16), _height :: size(16), rest :: binary>>), do: rest
  def content(<<@magic87, _width :: size(16), _height :: size(16), rest :: binary>>), do: rest

  @spec parse(bitstring) :: {:ok, struct} | {:error, term}
  def parse(gif) do
    if magic?(gif) do
      result = infos(gif) |> struct(images: content(gif))
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
