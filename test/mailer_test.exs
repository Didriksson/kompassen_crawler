defmodule KompassenCrawlerTest do
  use ExUnit.Case
  doctest KompassenCrawler

  test "get body" do
    assert KompassenCrawler.get_body("http://www.restaurangkompassen.se")
  end

  test "get the fooditems and days" do
    kompassenBody = File.read! "./test/body.txt"
    assert KompassenCrawler.get_food_and_day_list(kompassenBody) 
          |> List.flatten 
          |> Enum.at(1)
          |> String.contains?("skagendressing") == true
  end

  test "get alert for raggmunk" do
    kompassenBody = File.read! "./test/body.txt"
    assert KompassenCrawler.crawl("raggmunk", kompassenBody, "Torsdag") == "-Raggmunk med hummersås och dill samt gratinerad duchesse"
  end
end
