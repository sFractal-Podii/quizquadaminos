defmodule Quadquizaminos.GameBoard.Records do
  @moduledoc """
  This module is responsible for manipulating player game records.
  """
  alias Quadquizaminos.Accounts
  alias Quadquizaminos.GameBoard
  alias Quadquizaminos.Repo

  @spec record_player_game(boolean(), map()) ::
          {:ok, GameBoard.t()} | {:error, Ecto.Changeset.t()}
  def record_player_game(true = _game_over, game_records) do
    create_record(game_records)
  end

  def record_player_game(_game_over, _game_records), do: nil

  def top_10_games do
    GameBoard.game_record_query()
    |> Repo.all()
  end

  def create_record(%{uid: uid} = game_records) do
    unless uid == "anonymous" do
      game_records
      |> change_game_board()
      |> Repo.insert()
    end
  end

  def game_available?(user_id, login_level) when is_struct(login_level) do
    game_available?(user_id, login_level.name)
  end

  def game_available?(nil = _user_id, _login_level), do: true

  def game_available?(user_id, "oauth_login") do
    Accounts.user_has_role?(user_id, ["admin", "player"])
  end

  def game_available?(user_id, "by_config") do
    Accounts.user_has_role?(user_id, ["admin"])
  end

  def game_available?(_user_id, _login_level), do: true

  def change_game_board(attrs) do
    %GameBoard{}
    |> GameBoard.changeset(attrs)
  end
end
