require 'half_round'
require 'inner_round'
require 'swap_round'
require 'string_block_converter'

class IDEA

  def initialize(key)
    @key_scheduler = KeyScheduler.for_key(key)
    @converter = StringBlockConverter.new
  end

  def encrypt_string(string)
    @converter.str_to_blocks(string)
      .map { |b| @converter.split64(b) }
      .map { |b| encrypt_block(b) }
  end

  def decrypt_string(blocks)
    blocks64 = blocks
      .map { |four_blocks| decrypt_block(four_blocks) }
      .map { |four_blocks| @converter.join64(four_blocks) }
    @converter.join_string(blocks64)
  end

  def encrypt_block(four_blocks)
    round_keys = (0..8).map { |round_idx| @key_scheduler.encrypt_keys(round_idx) }
    rounds = round_keys.each.with_index.flat_map do |keys, idx|
      if idx == 8
        [HalfRound.new(keys)]
      elsif idx == 0
        [HalfRound.new(keys),
         InnerRound.new(keys)]
      else
        [swap,
         HalfRound.new(keys),
         InnerRound.new(keys)]
      end
    end
    return execute_rounds(rounds, four_blocks)
  end

  def decrypt_block(four_blocks)
    round_keys = (0..8).map { |round_idx| @key_scheduler.decrypt_keys(round_idx) }
    rounds = round_keys.each.with_index.flat_map do |keys, idx|
      if idx == 8
        [HalfRound.new(keys)]
      elsif idx == 0
        [HalfRound.new(keys),
         InnerRound.new(keys)]
      else
        [swap,
         HalfRound.new(swap.run(keys)),
         InnerRound.new(keys)]
      end
    end
    return execute_rounds(rounds, four_blocks)
  end

  private
  def swap
    SwapRound.new
  end

  def execute_rounds(rounds, four_blocks)
    rounds.reduce(four_blocks) {|blocks, round| round.run(blocks)}
  end
end
