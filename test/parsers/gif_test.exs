defmodule Eikon.GIFTest do
  alias Eikon.GIF.Parser
  use ExUnit.Case

  test "GIF Magic number" do
    assert true == File.read!("priv/hammer_time.gif") |> Parser.magic?
    assert false == File.read!("priv/foobarlol.dat")  |> Parser.magic?
  end

  test "GIF Informations" do
    assert File.read!("priv/hammer_time.gif") |> Parser.infos == %Eikon.GIF{height: 540, images: nil, version: "89a", width: 960}
  end

  test "GIF Parsing" do
    assert {:error, "Invalid file format!"} == File.read!("priv/foobarlol.dat") |> Parser.parse
  end
end
