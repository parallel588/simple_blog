defmodule SimpleBlog.GuardianSerializer do
  @moduledoc false
  @behaviour Guardian.Serializer

  alias SimpleBlog.Repo
  alias SimpleBlog.User.Account

  def for_token(account = %Account{}), do: {:ok, "Account:#{account.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("Account:" <> id), do: {:ok, Repo.get(Account, String.to_integer(id))}
  def from_token(_), do: {:error, "Unknown resource type"}
end
