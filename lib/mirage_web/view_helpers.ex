defmodule MirageWeb.ViewHelpers do
  def datetime_for_display(datetime) do
    Timex.format!(datetime, "{D}. {Mshort} {YYYY}, {h24}:{m}")
  end

  def datetime_from_now(nil), do: nil
  def datetime_from_now(datetime), do: Timex.from_now(datetime)
end
