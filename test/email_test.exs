defmodule KompassenCrawlerTest do
  use ExUnit.Case
  doctest Kompassen.Mailer

  test "get email" do
    email = Kompassen.Email.food_alert_email("-Raggmunk med hummersås och dill samt gratinerad duchesse", "test@test.com")
    assert email.to == "test@test.com"
    assert String.contains?(email.text_body, "Raggmunk")
  end
end
