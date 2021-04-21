defmodule Quadquizaminos.GameBoard.Records do
  @moduledoc """
  This module is responsible for manipulating player game records.
  """

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

  def create_record(%{user_id: user_id} = game_records) do
    unless user_id == "anonymous" do
      game_records
      |> change_game_board()
      |> Repo.insert()
    end
  end

  def change_game_board(attrs) do
    %GameBoard{}
    |> GameBoard.changeset(attrs)
  end
end
