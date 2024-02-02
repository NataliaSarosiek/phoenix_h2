defmodule FoggerWeb.ScoreControllerTest do
  use FoggerWeb.ConnCase

  import Fogger.LeaderBoardFixtures

  @create_attrs %{points: 42, initials: "some initials"}
  @update_attrs %{points: 43, initials: "some updated initials"}
  @invalid_attrs %{points: nil, initials: nil}

  describe "index" do
    test "lists all scores", %{conn: conn} do
      conn = get(conn, ~p"/scores")
      assert html_response(conn, 200) =~ "Listing Scores"
    end
  end

  describe "new score" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/scores/new")
      assert html_response(conn, 200) =~ "New Score"
    end
  end

  describe "create score" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/scores", score: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/scores/#{id}"

      conn = get(conn, ~p"/scores/#{id}")
      assert html_response(conn, 200) =~ "Score #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/scores", score: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Score"
    end
  end

  describe "edit score" do
    setup [:create_score]

    test "renders form for editing chosen score", %{conn: conn, score: score} do
      conn = get(conn, ~p"/scores/#{score}/edit")
      assert html_response(conn, 200) =~ "Edit Score"
    end
  end

  describe "update score" do
    setup [:create_score]

    test "redirects when data is valid", %{conn: conn, score: score} do
      conn = put(conn, ~p"/scores/#{score}", score: @update_attrs)
      assert redirected_to(conn) == ~p"/scores/#{score}"

      conn = get(conn, ~p"/scores/#{score}")
      assert html_response(conn, 200) =~ "some updated initials"
    end

    test "renders errors when data is invalid", %{conn: conn, score: score} do
      conn = put(conn, ~p"/scores/#{score}", score: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Score"
    end
  end

  describe "delete score" do
    setup [:create_score]

    test "deletes chosen score", %{conn: conn, score: score} do
      conn = delete(conn, ~p"/scores/#{score}")
      assert redirected_to(conn) == ~p"/scores"

      assert_error_sent 404, fn ->
        get(conn, ~p"/scores/#{score}")
      end
    end
  end

  defp create_score(_) do
    score = score_fixture()
    %{score: score}
  end
end
