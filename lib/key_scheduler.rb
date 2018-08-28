class KeyScheduler
  def initialize(main_key)
    @main_key = main_key
  end

  def key(index)
    (@main_key >> (128 - (index + 1) * 16)) & 0xffff
  end
end
