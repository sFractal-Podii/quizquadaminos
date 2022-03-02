defmodule Quadblockquiz.GameBoard.Records do
  @moduledoc """
  This module is responsible for manipulating player game records.
  """
  alias Quadblockquiz.Accounts
  alias Quadblockquiz.GameBoard
  alias Quadblockquiz.Repo

  @spec record_player_game(boolean(), map()) ::
          {:ok, GameBoard.t()} | {:error, Ecto.Changeset.t()}
  def record_player_game(true = _game_over, game_records) do
    create_record(game_records)
  end

  def record_player_game(_game_over, _game_records), do: nil

  def sort_games(sort_by \\ "score") do
    GameBoard.game_record_query(sort_by)
    |> Repo.all()
  end

  def contest_game(nil, nil), do: []

  def contest_game(start_time, end_time)
      when not is_nil(end_time) and not is_nil(start_time) do
    start_time
    |> GameBoard.by_start_and_end_time(end_time)
    |> GameBoard.preloads([:user])
    |> Repo.all()
  end

  def contest_game(_, _), do: []

  def contest_game(nil), do: []

  def contest_game(start_time) do
    start_time
    |> GameBoard.by_time()
    |> GameBoard.preloads([:user])
    |> Repo.all()
  end

  def create_record(game_records) when is_list(game_records) do
    Enum.map(game_records, fn record -> create_record(record) end)
  end

  def create_record(%{uid: uid} = game_records) do
    unless uid == "anonymous" do
      game_records
      |> change_game_board()
      |> Repo.insert()
    end
  end

  def get_game!(board_id) do
    GameBoard
    |> Repo.get!(board_id)
    |> Repo.preload(:user)
  end

  def game_available?(uid, login_level) when is_struct(login_level) do
    game_available?(uid, login_level.name)
  end

  def game_available?(nil = _uid, _login_level), do: true

  def game_available?(uid, "oauth_login") do
    Accounts.user_has_role?(uid, ["admin", "player"])
  end

  def game_available?(uid, "by_config") do
    Accounts.user_has_role?(uid, ["admin"])
  end

  def game_available?(_uid, _login_level), do: true

  def change_game_board(attrs) do
    %GameBoard{}
    |> GameBoard.changeset(attrs)
  end

  def fetch_records(page \\ 1, sorter \\ "score") do
    query =
      GameBoard
      |> GameBoard.sort_by(sorter)
      |> GameBoard.paginate_query(page, 25)
      |> GameBoard.preloads([:user])

    Repo.all(query)
  end
end
