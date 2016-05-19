defmodule Eikon do
  @moduledoc """
  Eikōn is an Elixir library providing a read-only interface for image files.

  It currently supports the following formats:
  * PNG
  * GIF
  """
end

defmodule Eikon.Parser do
  @moduledoc false

  @callback parse(bitstring)    :: {:ok, struct} | {:error, term}
  @callback parse!(bitstring)   :: struct | no_return

  @callback magic?(bitstring)   :: boolean

  @callback content(bitstring)  :: {:ok, bitstring} | {:error, term}
  @callback content!(bitstring) :: bitstring | no_return

  @callback infos(bitstring)    :: struct
end
