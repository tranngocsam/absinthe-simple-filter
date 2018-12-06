# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# It is also run when you use the command `mix ecto.setup`
#

Faker.start()

user_attrs = [
  %{email: "jane.doe@example.com", password: "12341234"},
  %{email: "john.smith@example.org", password: "12341234"},
  %{email: Faker.Internet.email, password: "12341234"},
  %{email: Faker.Internet.email, password: "12341234"},
  %{email: Faker.Internet.email, password: "12341234"},
  %{email: Faker.Internet.email, password: "12341234"},
  %{email: Faker.Internet.email, password: "12341234"}
]

users = user_attrs
  |> Enum.map(fn(user_attr)-> 
    {:ok, user} = Demo.Accounts.create_user(user_attr)

    user
  end)
  |> Enum.map(fn(user)-> 
    profile_attr = %{
      user_id: user.id,
      name: Faker.Name.name,
      dob: Faker.Date.date_of_birth,
      address: %{city: Faker.Address.city, state: Faker.Address.state, country: Faker.Address.country}
    }

    {:ok, profile} = Demo.Accounts.create_user_profile(profile_attr)

    user
  end)