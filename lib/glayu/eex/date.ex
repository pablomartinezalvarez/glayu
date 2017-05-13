defmodule Glayu.EEx.Date do

  use Timex

  def format(date, format) do
    Timex.format!(date, format, :strftime)
  end

  def now(format) do
    Timex.format!(Timex.now, format, :strftime)
  end

end