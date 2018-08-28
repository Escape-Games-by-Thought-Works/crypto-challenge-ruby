class KeyScheduler
  def initialize(main_key, offset)
    @main_key = main_key
    @offset = offset
  end

  def self.for_key(main_key)
    new(main_key, 0)
  end

  def key(index)
    shift_by = (index + @offset) % 8

    result_with_overflow = key_for_index(index) >> (128 - (shift_by + 1) * 16)
    
    result_with_overflow & 0xffff
  end

  def next
    KeyScheduler.new(key_for_next_round, (@offset + 6) % 8)
  end

private
  def rotated_key
    overflow = @main_key >> (128 - 25)
    key_with_25_zeros = (@main_key << 25) & 0xffffffffffffffffffffffffffffffff
    key_with_25_zeros | overflow
  end

  def key_for_index(index)
    if index + @offset > 7
      rotated_key
    else
      @main_key
    end
  end

  def key_for_next_round
    if @offset + 6 > 8
      rotated_key
    else
      @main_key
    end
  end
end
