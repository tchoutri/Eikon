defmodule Eikon.GIF do
  defstruct [
            :width,
            :height,
            :version,

            ]
end
defmodule Eikon.GIF.Parser do
  @moduledoc """
  Provide a basic interface for PNG files.
  """
  alias Eikon.GIF

  @gif struct
  @magic89 <<0x47, 0x49, 0x46, 0x38, 0x39, 0x61>>
  @magic87 <<0x47, 0x49, 0x46, 0x38, 0x37, 0x61>>

  def magic?(<<@magic89, rest :: binary>>), do: true
  def magic?(<<@magic87, rest :: binary>>), do: true
  def magic?(_),                            do: false

  @spec infos(bistring) :: gif
  def infos(<<@magic89, width :: size(16), height :: size(16), rest :: binary>>) do
    %GIF{width: width, height: height, version: "89a"}
  end
  def infos(<<@magic87, width :: size(16), height :: size(16), rest :: binary>>) do
    %GIF{width: width, height: height, version: "89a"}
  end
end
