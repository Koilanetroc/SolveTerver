class SolverController < ApplicationController
  skip_before_action :verify_authenticity_token
  include SolverHelper

  def main
    render 'main'
  end

  def solve
    # Task 1
    @X = params['value_x'].strip.split(',').map(&:to_f)
    @Y = params['value_y'].strip.split(',').map(&:to_f)
    @N = @X.size
    @step = ((@X.max - @X.min) / (1 + 3.322 * Math.log10(100))).roundf(3)
    # Task 2
    @intervals = compute_intervals(@X, @step)
    # Task 3
    @X_vec = (@X.inject(0) { |sum, x| sum + x } / @N.to_f).roundf(3)
    @Y_vec = (@Y.inject(0) { |sum, x| sum + x } / @N.to_f).roundf(3)
    @fixed_dispersion_X = ((1 / (@N - 1).to_f) * @X.inject(0) { |sum, x| sum + (x**2 - @X_vec.to_f**2) }).roundf(3)
    @fixed_dispersion_Y = ((1 / (@N - 1).to_f) * @Y.inject(0) { |sum, y| sum + (y**2 - @Y_vec.to_f**2) }).roundf(3)
    @deviation_X = (@fixed_dispersion_X**0.5).roundf(3)
    @deviation_Y = (@fixed_dispersion_Y**0.5).roundf(3)
    # Task 4
    @intervals[0][:left] = '-inf'
    @intervals.last[:right] = 'inf'
    @intervals_2 = compute_laplases(@intervals, @X_vec, @deviation_X)
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
    @t_v = (@r_v * (@N - 2)**0.5) / (1 - @r_v**2)**0.5
    @t_alfa = T_ALFA
    render 'solve'
  end
end

class Float
  def roundf(places)
    temp = to_s.length
    format("%#{temp}.#{places}f", self).to_f
  end
end
