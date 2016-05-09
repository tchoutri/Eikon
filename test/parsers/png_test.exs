defmodule Eikon.PNGTest do
  alias Eikon.PNG.Parser
  use ExUnit.Case

  test "Magic number" do
    assert File.read!("priv/mandelbrot.png") |> Parser.magic? == true
    assert File.read!("priv/foobarlol.dat")  |> Parser.magic? == false
  end

  test "Informations" do
    assert File.read!("priv/mandelbrot.png") |> Parser.infos == %Eikon.PNG{bit_depth: 8, chunks: nil, color_type: 2,
 								   										   compression: 0, filter: 0, height: 747, interlace: 0, width: 1365}
  end
end
