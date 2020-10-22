defmodule Mindex.Core.BoardTest do
  use ExUnit.Case

  alias Mindex.Core.Board

  describe "new/0" do
    test "should create a board with a random answer" do
      %Board{answer: answer} = Board.new()

      assert Enum.count(answer) == 4
      assert is_list(answer)
    end

    test "should create a board with empty guesses" do
      %Board{guesses: []} = Board.new()
    end
  end

  describe "new/1" do
    test "should create a board with the provided answer" do
      answer_param = [1, 2, 3, 4]
      %Board{answer: ^answer_param} = Board.new(answer_param)
    end
  end

  describe "move/2" do
  end

  def answers(size \\ 5) do

    Stream.repeatedly(&Board.random_answer/0)
    |> Enum.take(size)
  end

  def valid_answers?(answers) do
    valid_answer = fn answer -> length(answer) == length(Enum.uniq(answer)) end
    Enum.all?(answers, valid_answer)
  end

  describe "new/0 Property based testing" do

    test "result answers should be valid" do
      result =
      answers(1000)
        |> valid_answers?()

      assert result
    end
  end


end
