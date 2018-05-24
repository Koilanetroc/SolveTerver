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

  def compute_laplases(full_intervals, x_vec, deviation_X)
    full_intervals.each do |interval|
      left = interval[:left].to_s.include?('inf') ? laplas(interval[:left]) : laplas((interval[:left] - x_vec) / deviation_X) { |x| f(x) }
      right = interval[:right].to_s.include?('inf') ? laplas(interval[:right]) : laplas((interval[:right] - x_vec) / deviation_X) { |x| f(x) }
      interval[:laplas] = (right - left).roundf(3)
    end
    full_intervals
  end

  def laplas(_raw_x1)
    return -0.5 if _raw_x1.to_s.eql? '-inf'
    return 0.5 if _raw_x1.to_s.eql? 'inf'
    x1 = _raw_x1.abs
    dx = x1 / 1000.0
    x = 0
    sum = 0
    loop do
      y = yield(x)
      sum += dx * y
      x += dx
      break if x > x1
    end
    answer = sum * (1 / (2 * Math::PI)**0.5)
    if _raw_x1 < 0.0
      answer.roundf(3) * -1
    else
      answer.roundf(3)
    end
  end

  def f(_t)
    Math.exp((-_t**2) / 2)
  end

  def reshape_intervals(intervals, n, _x_vec, _deviation_x)
    new_intervals = []
    left = nil
    right = nil
    intervals.each_with_index do |interval, i|
      left = interval[:left] if left.nil?
      right = interval[:right] if right.nil?
      if compute_P(left, right, _x_vec, _deviation_x) * n > 10 || right.to_s.eql?('inf')
        if compute_P(intervals[i + 1][:left], 'inf', _x_vec, _deviation_x) * n > 10
          new_intervals.push(left: left, right: right, laplas: compute_P(left, interval[:right], _x_vec, _deviation_x))
          left = nil
          right = nil
        else
          new_intervals.push(left: left, right: 'inf', laplas: compute_P(left, 'inf', _x_vec, _deviation_x))
          left = nil
          right = nil
          break
        end
      else
        right = nil
      end
    end
    new_intervals
  end

  def compute_frequencies(_intervals,n,x,step)
  _intervals.each do |_interval|
    n_i = 0
    x.each do |v|
      if _interval[:left].to_s.eql? '-inf'
        n_i += 1 if v <= _interval[:right]
      elsif _interval[:right].to_s.eql? 'inf'
        n_i += 1 if v > _interval[:left]
      else
        n_i += 1 if (v > _interval[:left]) && (v <= _interval[:right])
      end
    end
    _interval[:n_i] = n_i
    _interval[:w_i] = n_i / n.to_f
    _interval[:w_i_h] = (n_i / n.to_f) / step.to_f
  end
  _intervals
  end

  def compute_frequencies2(_intervals, x, n)
    _intervals.each do |_interval|
      n_i = 0
      x.each do |v|
        if _interval[:left].to_s.eql? '-inf'
          n_i += 1 if v <= _interval[:right]
        elsif _interval[:right].to_s.eql? 'inf'
          n_i += 1 if v > _interval[:left]
        else
          n_i += 1 if (v > _interval[:left]) && (v <= _interval[:right])
        end
      end
      _interval[:n_i] = n_i
      _interval[:p_i] = _interval[:laplas]
      _interval[:n_p_i] = (_interval[:laplas] * n).roundf(3)
      _interval[:xi_pirsona] = (((n_i - n * _interval[:laplas])**2) / (n * _interval[:laplas])).roundf(3)
    end
    _intervals
  end

  def compute_P(_from, _to, _x_vec, _deviation_x)
    from = _from.to_s.include?('inf') ? laplas(_from) : laplas((_from - _x_vec) / _deviation_x) { |x| f(x) }
    to = _to.to_s.include?('inf') ? laplas(_to) : laplas((_to - _x_vec) / _deviation_x) { |x| f(x) }
    (to - from).roundf(3)
  end

  XI_K = {
    1 => 3.8415,
    2 => 5.991,
    3 => 7.8147,
    4 => 9.4877
  }.freeze
  T_GAMMA = 1.984
  Q = 0.143
  T_ALFA = 1.98
end

# КОстыль костылей госпаде
class Float
  def roundf(places)
    temp = to_s.length
    format("%#{temp}.#{places}f", self).to_f
  end
end
