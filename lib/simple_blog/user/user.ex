defmodule SimpleBlog.User do
  @moduledoc """
  The boundary for the User system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias SimpleBlog.Repo

  alias SimpleBlog.User.{Account,Registration,Session}


   @doc """
  Creates a account.
  ## Examples
      iex> create_account(account, %{field: value})
      {:ok, %Account{}}
      iex> create_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_account(attrs \\ %{})
  def create_account(%Ecto.Changeset{valid?: false} = registration) do
    {:error, %{registration | action: "insert"}}
  end
  def create_account(%Ecto.Changeset{valid?: true} = registration) do
    create_account(registration.changes)
  end
  def create_account(attrs) do
    %Account{}
    |> new_account_changeset(attrs)
    |> Repo.insert()
  end

  defp new_account_changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:name, :email])
    |> validate_required([:email])
    |> password_digest_changeset(attrs)
  end

  @doc """
  Registers a account.
  ## Examples
      iex> register_account(%{field: value})
      {:ok, %Account{}}
      iex> register_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def register_account(attrs) do
    %Registration{}
    |> registration_changeset(attrs)
    |> create_account()
  end

  @doc """
  Updates a account.

  ## Examples

  iex> update_account(account, %{field: new_value})
  {:ok, %Account{}}

  iex> update_account(account, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> account_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

  iex> change_account(account)
  %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    account_changeset(account, %{})
  end

  defp account_changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end


  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session changes.
  ## Examples
  iex> prepare_session(session)
  %Ecto.Changeset{source: %Session{}}
  """
  def prepare_session(%Session{} = session) do
    session_changeset(session, %{})
  end

  defp session_changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking registration changes.
  ## Examples
  iex> prepare_registration(session)
  %Ecto.Changeset{source: %Registration{}}
  """
  def prepare_registration(%Registration{} = registration) do
    registration_changeset(registration, %{})
  end

  defp registration_changeset(registration, attrs) do
    registration
    |> cast(attrs, [:name, :email])
    |> validate_required([:email])
    |> password_changeset(attrs)
  end

  defp password_changeset(registration, attrs) do
    registration
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
  end

  defp password_digest_changeset(registration, attrs) do
    case registration do
      %Ecto.Changeset{valid?: true} ->
        registration
        |> put_change(:encrypted_password, hashed_password(Map.get(attrs, :password)))
      _ ->
        registration
    end
  end

  defp hashed_password(nil), do: nil
  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end
end
