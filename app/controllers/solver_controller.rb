class SolverController < ApplicationController
  skip_before_action :verify_authenticity_token
  include SolverHelper

  def main
    render 'main'
  end

  def solve
    @X = params['value_x'].strip.split(',').map(&:to_f)
    @Y = params['value_y'].strip.split(',').map(&:to_f)
    @step = ((@X.max - @X.min) / (1 + 3.322 * Math.log10(100))).roundf(3)
    @intervals = compute_intervals(@X, @step)
    puts @step
    render 'solve'
  end
end

class Float
  def roundf(places)
    temp = to_s.length
    format("%#{temp}.#{places}f", self).to_f
  end
end
