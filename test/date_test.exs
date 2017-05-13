defmodule Glayu.DateTest do

  use ExUnit.Case

  test "parse valid date" do
    expected = DateTime.from_naive!(~N[2017-05-11 07:20:03.000], "Etc/UTC")
    current = Glayu.Date.parse("2017-05-11 07:20:03")
    assert DateTime.compare(expected, current) == :eq
  end

end
