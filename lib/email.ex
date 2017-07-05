defmodule Kompassen.Email do
    import Bamboo.Email
    @emailbody File.read! "./lib/email.txt"
    def food_alert_email(food, email_address) do
        new_email
        |> to(email_address)
        |> from("enGodVan@email.com")
        |> subject("Food alert!")
        |> text_body(String.replace(@emailbody, "BYTUTMIG", food))
    end
end