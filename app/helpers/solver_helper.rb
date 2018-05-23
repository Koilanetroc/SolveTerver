module SolverHelper
  def compute_intervals(x, step)
    min = (x.min - step / 2).roundf(3)
    puts "min value = #{min}"

    left = min
    right = min + step
    intervals = []
    until (right - x.max) >= step
      intervals.push(
        left: left.roundf(3),
        right: right.roundf(3)
      )
      left = right
      right += step
    end
    intervals
end
end
