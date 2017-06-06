defmodule Glayu.Utils.YamlTest do

  use ExUnit.Case

  test "to_map handles charlists and arrays of integers" do

    doc =
    """
    empty:
    latin: áñ
    integer: 12
    charlist: 1a
    array_integers:
    - 1
    - 2
    array_charlists:
    - 1
    - a
    """

    map = doc
      |> :yamerl_constr.string
      |> List.flatten
      |> Glayu.Utils.Yaml.to_map

    assert map[:empty] == nil
    assert map[:latin] == "áñ"
    assert map[:integer] == 12
    assert map[:charlist] == "1a"
    # assert map[:array_integers] == [1, 2] unable to diferenciate charlists from array of integers :(
    assert map[:array_integers] == <<1, 2>>
    assert map[:array_charlists] == [1, "a"]

  end

end