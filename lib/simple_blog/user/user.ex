defmodule SimpleBlog.User do
  @moduledoc """
  The boundary for the User system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias SimpleBlog.Repo

  alias SimpleBlog.User.{ Account, Registration, Session, Password }

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

  iex> get_account!(123)
  %Account{}

  iex> get_account!(456)
  ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)
  def get_account_by_email(email), do: Repo.get_by(Account, email: email)
  def get_account_by_code(code) do
    Account
    |> Repo.get_by(password_reset_code: code)
  end

  @doc """
  Signs in a account.

  ## Examples

  iex> signin_account(%{field: value})
  {:ok, %Account{}}

  iex> signin_account(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def signin_account(attrs) do
    %Session{}
    |> session_changeset(attrs)
    |> check_password(attrs)
  end

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

  def reset_password_account(%Account{} = account) do
    code_length = 40
    random_string = :crypto.strong_rand_bytes(code_length)
    |> Base.url_encode64
    |> binary_part(0, code_length)

    account
    |> reset_password_account_changeset(%{password_reset_code: random_string})
    |> Repo.update
  end

  defp reset_password_account_changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:password_reset_code])
    |> validate_required([:password_reset_code])
  end

  def update_password(%Account{} = account, attrs) do
    case reset_password_changeset(attrs) do
      %Ecto.Changeset{valid?: true} = changeset ->
        account
        |> cast(%{password_reset_code: ""}, [:password_reset_code])
        |> put_change(:encrypted_password, hashed_password(
              Map.get(changeset.changes, :password))
        )
        |> Repo.update()
      %Ecto.Changeset{valid?: false} = changeset ->
        {:error, %{changeset | action: "update"}}
    end
  end


  def reset_password_changeset(attrs) do
    %Password{}
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
  end

  def prepare_reset_password_changeset(attrs) do
    %Password{}
    |> cast(attrs, [:password, :password_confirmation])
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
  Deletes a Account.

  ## Examples

  iex> delete_account(account)
  {:ok, %Account{}}

  iex> delete_account(account)
  {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
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
        |> put_change(
          :encrypted_password, hashed_password(Map.get(attrs, :password))
        )
      _ ->
        registration
    end
  end

  defp hashed_password(nil), do: nil
  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

  defp check_password(%Ecto.Changeset{valid?: false} = session, _attrs) do
    {:error, %{session | action: "insert"}}
  end
  defp check_password(session, %{"password" => password, "email" => email}) do
    account = Repo.get_by(Account, email: email)

    case authenticate(account, password) do
      true ->
        {:ok, account}
      false ->
        invalid_session =
          session
          |> add_error(:password, "password and email do not match")
        {
          :error,
          %{invalid_session | action: "insert"}
        }
    end
  end

  defp authenticate(account, password) do
    case account do
      nil -> false
      _ -> Comeonin.Bcrypt.checkpw(password, account.encrypted_password)
    end
  end
end
