defmodule Eikon.PNGTest do
  alias Eikon.PNG.Parser
  use ExUnit.Case

  test "PNG Magic number" do
    assert true == File.read!("priv/mandelbrot.png") |> Parser.magic?
    assert false == File.read!("priv/foobarlol.dat") |> Parser.magic?
  end

  test "PNG Informations" do
    assert File.read!("priv/mandelbrot.png")
      |> Parser.infos == %Eikon.PNG{bit_depth: 8, chunks: nil, color_type: 2,
    	 compression: 0, filter: 0, height: 747, interlace: 0, width: 1365}
  end
end
