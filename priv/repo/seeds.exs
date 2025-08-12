# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Aida.Repo.insert!(%Aida.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Aida.Repo
alias Aida.Subscriptions
alias Aida.KB.Item

today = Date.utc_today()

# --- Subscriptions (2) ---
{:ok, _spotify} =
  Subscriptions.create_subscription(%{
    title: "Spotify Premium",
    content: "Music streaming subscription",
    tags: ["subscription", "music"],
    detail: %{
      vendor: "Spotify",
      amount_cents: 999,
      currency: "USD",
      cadence: "monthly",
      next_charge_on: Date.add(today, 10),
      lead_days: 3,
      payment_method: "credit_card",
      meta: %{plan: "Individual"}
    }
  })

{:ok, _github} =
  Subscriptions.create_subscription(%{
    title: "GitHub Pro",
    content: "Developer tools subscription",
    tags: ["subscription", "dev"],
    detail: %{
      vendor: "GitHub",
      amount_cents: 400,
      currency: "USD",
      cadence: "yearly",
      next_charge_on: Date.add(today, 60),
      lead_days: 7,
      payment_method: "credit_card",
      meta: %{notes: "Discounted annual"}
    }
  })

# --- Language / Phrase items for review (2) ---
{:ok, _es} =
  %Item{}
  |> Item.changeset(%{
    kind: "phrase",
    title: "¿Cómo estás?",
    content: "How are you?",
    tags: ["language", "spanish"],
    first_seen: today,
    next_review: today
  })
  |> Repo.insert()

{:ok, _ja} =
  %Item{}
  |> Item.changeset(%{
    kind: "phrase",
    title: "ありがとうございます",
    content: "Thank you",
    tags: ["language", "japanese"],
    first_seen: today,
    next_review: today
  })
  |> Repo.insert()

IO.puts("Seeded 2 subscriptions and 2 language/phrase items.")
