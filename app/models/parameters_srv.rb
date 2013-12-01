class ParametersSRV
  include GSL
  attr_reader :tmax, :fmax, :del_t_syst, :del_t_obrab, :del_t_diskret, :tv_max, :v_max, :points, :number_of_points_in_period

  DF_MAX         = 200 #delta f maximum
  F_MAX          = 454.6
  PI             = 3.141592
  NUMBER_PERIODS = 10
  LENGTH_PERIOD  = 7

  def initialize(parameters)
    @period   = parameters[:period]
    @t_begin  = parameters[:begin]
    @df_min   = parameters[:dfmin]
    @tmax     = 0
    @fmax     = 0
    @ht_begin = first_stage

    @v_max, @tv_max = second_stage(@ht_begin)

    @f_absolute = @fmax * 0.05

    search_f_obrabotki(@ht_begin)

    @del_t_diskret = @del_t_obrab / 10
    @points        = (@tmax / @del_t_diskret).round

  end

  def search_f_obrabotki(ht_begin)
    if custom_function(@tv_max) - custom_function(@tv_max - ht_begin) > @f_absolute
      search_f_obrabotki(ht_begin / 2)
    else
      if custom_function(@tv_max) - custom_function(@tv_max - ht_begin) <= @f_absolute/10
        search_f_obrabotki(ht_begin * 2)
      else
        @del_t_obrab = ht_begin
      end
    end
  end

  def first_stage
    half_period     = @period / 2
    @tmax           = half_period - 0.004
    ht_begin        = half_period / 10
    delta_f_current = custom_function(@tmax) - custom_function(@tmax - ht_begin)

    @fmax = custom_function(@tmax)

    while delta_f_current >= DF_MAX
      ht_begin /= 2

      delta_f_current = custom_function(@tmax) - custom_function(@tmax - ht_begin)

    end

    ht_begin
  end

  def second_stage(ht_begin)
    i      = ht_begin
    v_max  = custom_function(i) - custom_function(0)
    tv_max = ht_begin
    i      += ht_begin

    while i <= @tmax
      delta = custom_function(i) - custom_function(i - ht_begin)
      v_tek = delta / ht_begin
      if v_tek > v_max
        v_max  = v_tek
        tv_max = i
      end

      i += ht_begin
    end
    [v_max, tv_max]
  end

  def custom_function(t)
    Sf::sin(t/2)/Sf::cos(t/2)
  end

  def fmax_tmax_htbegin(fmax, tmax, div)
    @fmax1, @t_max1, @ht_begin = fmax, t_max, @ht_begin / div if @fmax1 < fmax
  end

  def get_data_for_real_graph
    end_of_loop = @period * 10

    values = []

    step = @del_t_diskret*100
    i    = 0

    while i <= end_of_loop do
      y = custom_function(i)

      if y.abs > F_MAX
        y = F_MAX * (y/y.abs)
      end

      values << { x: i, y: y }
      i += step
    end

    values
  end

  def get_data_for_model_graph
    end_of_loop = NUMBER_PERIODS * LENGTH_PERIOD
    koef        = @period / LENGTH_PERIOD

    values = []

    step = 0.003
    i    = 0

    while i <= end_of_loop do
      y = custom_function(i * koef)

      if y.abs > F_MAX
        y = F_MAX * (y/y.abs)
      end

      values << { x: i, y: y }
      i += step
    end

    values
  end

end