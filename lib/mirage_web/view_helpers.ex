defmodule MirageWeb.ViewHelpers do
  def datetime_for_display(datetime) do
    Timex.format!(datetime, "{D}. {Mshort} {YYYY}, {h24}:{m}")
  end
end