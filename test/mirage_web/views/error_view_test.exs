defmodule MirageWeb.ErrorViewTest do
  use MirageWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(MirageWeb.ErrorView, "404.html", []) =~ "404"
  end

  test "renders 500.html" do
    assert render_to_string(MirageWeb.ErrorView, "500.html", []) =~ "500"
  end
end
