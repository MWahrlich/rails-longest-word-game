class LongestWordController < ApplicationController
  def game
    @grid_size = params[:grid_size]
    @grid = (0...@grid_size.to_i).map { 65.+(rand(25)).chr }
  end

  def score
    @answer = params[:answer].downcase
    @start = params[:start].to_i
    @grid = params[:grid].split(",")
    @stop = Time.now.to_i
    dict_result = JSON.parse(open("https://wagon-dictionary.herokuapp.com/" + @answer.downcase).read)
    @result = {}
    @result[:time] = (@stop - @start)
    @result[:score] = 0
    array = []
    @answer.each_char { |o| array << o.upcase! && @grid.delete(o) if @grid.include? o.upcase }
    @result = { message: "Well done", score: ((2**@answer.length.to_f / (@result[:time].to_f))*10).round(2), time: @result[:time] }
    @result = { message: "Not an english word", score: 0 } if dict_result["found"] == false
    @result = { message: "Word is not in the grid", score: 0 } if array != @answer.upcase.split("")
  end
end
