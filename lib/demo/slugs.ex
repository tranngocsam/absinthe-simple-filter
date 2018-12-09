defmodule NameSlug do
  use EctoAutoslugField.Slug, from: :name, to: :slug
end

defmodule TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end