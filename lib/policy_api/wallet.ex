defmodule PolicyApi.Wallet do
  alias PolicyApi.Crawl

  @moduledoc """
  The Wallet context.
  """

  import Ecto.Query, warn: false
  alias PolicyApi.Repo

  alias PolicyApi.Wallet.Policys

  @doc """
  Returns the list of policy.

  ## Examples

  iex> list_policy()
  [%Policys{}, ...]

  """
  def list_policy do
    Repo.all(Policys)
  end

  @doc """
  Gets a single policys.

  Raises `Ecto.NoResultsError` if the Policys does not exist.

  ## Examples

  iex> get_policys!(123)
  %Policys{}

  iex> get_policys!(456)
  ** (Ecto.NoResultsError)

  """
  def get_policys!(id), do: Repo.get!(Policys, id)

  def get_by_id(id) do
    case Repo.get_by(Policys, id: id) do
      nil ->
        {:error, :not_found}
      policy ->
        {:ok, policy}
    end
  end

  def get_by_number(number) do
    case Repo.get_by(Policys, number: number) do
      nil ->
        {:error, :not_found}
      policy ->
        {:ok, policy}
    end
  end

  @doc """
  Creates a policys.

  ## Examples

  iex> create_policys(%{field: value})
  {:ok, %Policys{}}

  iex> create_policys(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_policys(attrs \\ %{}) do

    %{number: number} = attrs

    case Crawl.valid_number(number) do

      {:ok, _} -> 
        %Policys{}
        |> Policys.changeset(attrs)
        |> Repo.insert()

      {:error, policy} -> 
        {:error, policy}
    end


  end


  @doc """
  Updates a policys.

  ## Examples

  iex> update_policys(policys, %{field: new_value})
  {:ok, %Policys{}}

  iex> update_policys(policys, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_policys(%Policys{} = policys, attrs) do
    policys
    |> Policys.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a policys.

  ## Examples

  iex> delete_policys(policys)
  {:ok, %Policys{}}

  iex> delete_policys(policys)
  {:error, %Ecto.Changeset{}}

  """
  def delete_policys(%Policys{} = policys) do
    Repo.delete(policys)
  end

  def delete_by_number(number) do
    case Repo.get_by(Policys, number: number) do
      nil ->
        {:error, :not_found}
      policy ->
        Repo.delete(policy)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking policys changes.

  ## Examples

  iex> change_policys(policys)
  %Ecto.Changeset{data: %Policys{}}

  """
  def change_policys(%Policys{} = policys, attrs \\ %{}) do
    Policys.changeset(policys, attrs)
  end
end
