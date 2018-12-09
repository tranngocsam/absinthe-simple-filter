defmodule Demo.Sessions.Session do
  use Ecto.Schema

  import Ecto.Changeset

  alias Demo.Accounts.User

  @max_age 86_400
  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "sessions" do
    field(:expires_at, :utc_datetime)
    belongs_to(:user, User, type: :binary_id)

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> set_expires_at(attrs)
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end

  defp set_expires_at(%__MODULE__{} = session, attrs) do
    max_age = attrs[:max_age] || @max_age
    {:ok, expires_at} = exp_datetime(max_age)
    %__MODULE__{session | expires_at: DateTime.truncate(expires_at, :second)}
  end

  defp exp_datetime(max_age) do
    DateTime.utc_now()
    |> DateTime.to_naive()
    |> NaiveDateTime.add(max_age)
    |> DateTime.from_naive("Etc/UTC")
  end
end
