require 'key_scheduler'

RSpec.describe KeyScheduler do
  describe '#encrypt_keys' do
    it 'retrieves the keys for the first round' do
      scheduler = KeyScheduler.for_key(0xFFFF0000EEEE1111DDDD2222CCCC3333)
      keys = scheduler.encrypt_keys(0)
      expect(keys[0]).to eq(0xFFFF)
      expect(keys[1]).to eq(0x0000)
      expect(keys[2]).to eq(0xEEEE)
      expect(keys[3]).to eq(0x1111)
      expect(keys[4]).to eq(0xDDDD)
      expect(keys[5]).to eq(0x2222)
    end

    it 'retrieves the keys for the second round' do
      scheduler = KeyScheduler.for_key(0xFFFF0000EEEE1111DDDD2222CCCC3333)
      keys = scheduler.encrypt_keys(1)
      expect(keys[0]).to eq(0xCCCC)
      expect(keys[1]).to eq(0x3333)
      expect(keys[2]).to eq(0x01dd)
      expect(keys[3]).to eq(0xdc22)
      expect(keys[4]).to eq(0x23bb)
      expect(keys[5]).to eq(0xba44)
    end

    it 'retrieves the keys for the third round' do
      scheduler = KeyScheduler.for_key(0xFFFF0000EEEE1111DDDD2222CCCC3333)
      keys = scheduler.encrypt_keys(2)
      expect(keys[0]).to eq(0x4599)
      expect(keys[1]).to eq(0x9866)
    end
  end

end
