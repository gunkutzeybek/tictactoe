defmodule TictactoeWeb.PageController do
  use TictactoeWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/game")
  end

  def tictactoe(conn, params) do
    case params do
      %{"game_id" => game_id} -> render(conn, "tictactoe.html", game_id: game_id)
      _ -> render(conn, "game_error.html")
    end
  end

  def game(conn, _params) do
    render(conn, "game.html")
  end
end
