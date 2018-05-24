class SolverController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_client
  include SolverHelper

  def main
    # puts "https://api.github.com/user/starred/bkeepers/dotenv?client_id=#{ENV['CLIENT_ID']}&client_secret=#{ENV['CLIENT_SECRET']}"
    conn = Faraday.new("https://api.github.com/user/starred/Koilanetroc/SolveTerver?access_token=#{session[:access_token]}")
    @result = conn.get.status
    if @result == 204
      render 'main'
    else
      flash[:notice] = 'Оцените проект!'
      redirect_to stars_path
    end
  end

  def give_star
    @result = @client.delete_repository('Koilanetroc/Kursach')
    render 'give_star'
  end

  def solve
    # Task 1
    @X = params['value_x'].strip.split(',').map(&:to_f)
    @Y = params['value_y'].strip.split(',').map(&:to_f)
    if @X.size < 100
      flash[:notice] = 'Введено меньше 100 значений X либо введено кривые символы'
      render 'main'
    elsif @Y.size < 100
      flash[:notice] = 'Введено меньше 100 значений Y'
      render 'main'
    else
      @N = @X.size
      @step = if params['step'].to_s.empty?
                ((@X.max - @X.min) / (1 + 3.322 * Math.log10(100))).roundf(3)
              else
                params['step'].to_f
              end
      @step = 1.0 if @step < 0.1
      # Task 2
      intervals_1 = compute_intervals(@X, @step)
      @intervals_1 = compute_frequencies(intervals_1,@X,@N,@step)
      temp_intervals = compute_intervals(@X, @step)
      # Task 3
      @X_vec = (@X.inject(0) { |sum, x| sum + x } / @N.to_f).roundf(3)
      @Y_vec = (@Y.inject(0) { |sum, x| sum + x } / @N.to_f).roundf(3)
      @fixed_dispersion_X = ((1 / (@N - 1).to_f) * @X.inject(0) { |sum, x| sum + (x**2 - @X_vec.to_f**2) }).roundf(3)
      @fixed_dispersion_Y = ((1 / (@N - 1).to_f) * @Y.inject(0) { |sum, y| sum + (y**2 - @Y_vec.to_f**2) }).roundf(3)
      @deviation_X = (@fixed_dispersion_X**0.5).roundf(3)
      @deviation_Y = (@fixed_dispersion_Y**0.5).roundf(3)
      # Task 4
      temp_intervals[0][:left] = '-inf'
      temp_intervals.last[:right] = 'inf'
      @intervals_2 = compute_laplases(temp_intervals, @X_vec, @deviation_X)
      reshaped_intervals = reshape_intervals(@intervals_2, @N, @X_vec, @deviation_X)
      @intervals_3 = compute_frequencies2(reshaped_intervals, @X, @N)
      @xi_pirsona = 0
      @intervals_3.each { |interval| @xi_pirsona += interval[:xi_pirsona] }
      @xi_pirsona = @xi_pirsona.roundf(3)
      @xi_k = XI_K[@intervals_3.size - 3]
      # Task 5
      @beta = (T_GAMMA * @deviation_X) / @N**0.5
      @q = Q
      # Task 6
      sum = 0
      @X.each_with_index { |_x, i| sum += (@X[i] * @Y[i] - @X_vec * @Y_vec) }
      @r_v = ((sum * 1 / @N) / (@deviation_X * @deviation_Y)).roundf(4)
      # Task 7
      @t_v = ((@r_v * (@N - 2)**0.5) / (1 - @r_v**2)**0.5).roundf(3)
      @t_alfa = T_ALFA
      # Task 8
      @y_a = (@r_v * (@deviation_Y / @deviation_X)).roundf(3)
      @y_b = (@Y_vec - @r_v * @X_vec * (@deviation_Y / @deviation_X)).roundf(3)
      @x_a = (@r_v * (@deviation_X / @deviation_Y)).roundf(3)
      @x_b = (@X_vec - @r_v * @Y_vec * (@deviation_X / @deviation_Y)).roundf(3)
      render 'solve'
    end
  end

  private

  def set_client
    @client = Octokit::Client.new(access_token: session[:access_token])
  end
end

class Float
  def roundf(places)
    temp = to_s.length
    format("%#{temp}.#{places}f", self).to_f
  end
end
