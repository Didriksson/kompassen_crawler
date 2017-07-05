defmodule Kompassen.Crawler do
  @weekday_map %{
               1 => "Måndag",
               2 => "Tisdag",
               3 => "Onsdag",
               4 => "Torsdag",
               5 => "Fredag",
               6 => "Lördag",
               7 => "Söndag"
              }
              
  @kompassen_url "http://www.restaurangkompassen.se/index.php?option=com_content&view=article&id=64&Itemid=66"
  @kompassen_url_next_week "http://www.restaurangkompassen.se/index.php?option=com_content&view=article&id=108%3Adagens-lunch&catid=34&Itemid=66"
  
  def get_body(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :( " <> url 
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def get_food_and_day_list(body) do
    body
     |> Floki.find(".meny_back")
     |> Enum.at(1) 
     |> elem(2) 
     |> Enum.map(&elem(&1, 2)) 
     |> List.flatten
  end

  def get_food_for_day(menu, day) do
    menu
     |> Enum.drop_while(fn it -> day != it end)
     |> Enum.take_while(fn it -> 
        Map.values(@weekday_map)
        |> List.delete(day)
        |> Enum.member?(it)
        |> Kernel.not
        end
      )
  end

  def tomorrow() do
    Date.utc_today
    |> Date.day_of_week
    |> Kernel.+(1)
    |> rem(7)
    |> (&(Map.get(@weekday_map, &1))).()
  end

  defp clean_string([head | _tail]) do
    head
     |> String.replace("\n", "")
  end
  
  defp clean_string([]), do: []
  
  defp get_kompassen_url() do
    if Date.day_of_week == 7 do
      @kompassen_url_next_week
    else
      @kompassen_url
    end
  end

  def crawl(food, body \\ get_body(get_kompassen_url()), day \\ tomorrow()) do
    body
    |> get_food_and_day_list
    |> get_food_for_day(day)
    |> Enum.filter(&(
        String.downcase(&1) |> String.contains?(food))
        )
    |> clean_string
  end

end
