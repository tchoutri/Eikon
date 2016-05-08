defmodule Eikon.JPEG do
  @moduledoc false
  defstruct [
            :width,
            :height,
            :chunks
          ]
end

defmodule Eikon.JPEG.Parser do
  alias Eikon.JPEG
  @moduledoc """
  Provides a basic interface for JPEG files.
  """

  @type jpeg :: struct()

  @magic <<0xFF, 0xD8>>
  @jfif  <<0xFF, 0xE0>>
  @exif  <<0xFF, 0xE1>>
  @sof0  <<0xFF, 0xC0>>
  @sof2  <<0xFF, 0xC2>>
  @dht   <<0xFF, 0xC4>>
  @dqt   <<0xFF, 0xDB>>
  @dri   <<0xFF, 0xDD>>
  @sos   <<0xFF, 0xDA>>
  @com   <<0xFF, 0xFE>>

  @doc "Check the magic number of the file"
  @spec magic?(bitstring) :: true | false
  def magic?(<<@magic, _ :: binary>>), do: true
  def magic?(_),                       do: false


  
end
