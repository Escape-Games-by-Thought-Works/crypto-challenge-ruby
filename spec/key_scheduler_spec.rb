require 'key_scheduler'

RSpec.describe KeyScheduler do
  describe '#key' do
    it 'retrieves the first six keys' do
      scheduler = KeyScheduler.for_key(0xFFFF0000EEEE1111DDDD2222CCCC3333)
      expect(scheduler.key(0)).to eq(0xFFFF)
      expect(scheduler.key(1)).to eq(0x0000)
      expect(scheduler.key(2)).to eq(0xEEEE)
      expect(scheduler.key(3)).to eq(0x1111)
      expect(scheduler.key(4)).to eq(0xDDDD)
      expect(scheduler.key(5)).to eq(0x2222)
    end
  end

  describe '#next' do
    it 'creates the KeyScheduler for the next round' do
      scheduler = KeyScheduler.for_key(0xFFFF0000EEEE1111DDDD2222CCCC3333)

      next_round = scheduler.next

      expect(next_round.key(0)).to eq(0xCCCC)
      expect(next_round.key(1)).to eq(0x3333)
      expect(next_round.key(2)).to eq(0x01dd)
      expect(next_round.key(3)).to eq(0xdc22)
      expect(next_round.key(4)).to eq(0x23bb)
      expect(next_round.key(5)).to eq(0xba44)
    end

    it 'creates more KeyScheduler incrementally' do
      scheduler = KeyScheduler.for_key(0xFFFF0000EEEE1111DDDD2222CCCC3333)

      third_round = scheduler.next.next
      expect(third_round.key(0)).to eq(0x4599)
      expect(third_round.key(1)).to eq(0x9866)
    end
  end
end
