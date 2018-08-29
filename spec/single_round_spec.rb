require 'inner_round'
require 'half_round'
require 'key_scheduler'
require 'operations'

RSpec.describe 'single round' do
  it 'encrypts and decrypts correctly in regular round' do
    input_blocks = [0x0123, 0x4567, 0x89ab, 0xcdef]
    key_scheduler = KeyScheduler.for_key(0xabab00edefEE111234D08152CCCC3333)
    enc_keys1 = key_scheduler.encrypt_keys(2)
    enc_keys2 = key_scheduler.encrypt_keys(3)
    dec_keys1 = key_scheduler.decrypt_keys(5)
    dec_keys2 = key_scheduler.decrypt_keys(6)

    half_round1_enc = HalfRound.new(enc_keys1)
    inner_round_enc = InnerRound.new(enc_keys1)
    half_round2_enc = HalfRound.new(enc_keys2)

    half_round1_dec = HalfRound.new(dec_keys1)
    inner_round_dec = InnerRound.new(enc_keys1)
    half_round2_dec = HalfRound.new(dec_keys2)

    encrypted_blocks1 = half_round1_enc.run(input_blocks)
    encrypted_blocks2 = inner_round_enc.run(encrypted_blocks1)
    encrypted_blocks3 = half_round2_enc.run(encrypted_blocks2)

    decrypted_blocks1 = half_round1_dec.run(encrypted_blocks3)
    decrypted_blocks2 = inner_round_dec.run(decrypted_blocks1)
    decrypted_blocks3 = half_round2_dec.run(decrypted_blocks2)

    expect(decrypted_blocks3).to eq(input_blocks)
  end
end
