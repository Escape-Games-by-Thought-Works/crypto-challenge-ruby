class KeyScheduler
  def initialize(main_key, offset)
    @main_key = main_key
    @offset = offset
  end

  def self.for_key(main_key)
    new(main_key, 0)
  end

  def encrypt_keys(round)
    (0..5).map { |idx| subkey(idx, round) }
  end


private
  def rotate_key(key)
    overflow = key >> (128 - 25)
    key_with_25_zeros = (key << 25) & 0xffffffffffffffffffffffffffffffff
    return key_with_25_zeros | overflow
  end

  def compute_key(global_key_idx)
    rotations = (global_key_idx / 8).to_i
    tmp_key = @main_key
    rotations.times do
      tmp_key = rotate_key(tmp_key)
    end
    return tmp_key
  end

  def subkey(index, round)
    global_key_idx = index + round * 6
    shift_by = global_key_idx % 8

    result_with_overflow = compute_key(global_key_idx) >> (128 - (shift_by + 1) * 16)

    result_with_overflow & 0xffff
  end

end
