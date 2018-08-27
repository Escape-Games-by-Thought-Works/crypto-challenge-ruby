require 'input_splitter'

RSpec.describe InputSplitter do
  it 'splits a 64bit block into 4 16bit blocks' do
    input_splitter = InputSplitter.new
    blocks = input_splitter.split64(0x0123456789abcdef)
    expect(blocks).to eq([0x0123, 0x4567, 0x89ab, 0xcdef])
  end

  it 'splits a string into 64bit blocks' do
    input_splitter = InputSplitter.new
    blocks = input_splitter.split_string('some str')

    blocks_as_hex = blocks.each.map {|b| b.to_s(16)}
    expect(blocks_as_hex[0]).to eq(chars_as_block('s', 'o', 'm', 'e', ' ', 's', 't', 'r'))
  end
end

def chars_as_block(*chars)
  shift = 56
  res = 0
  for i in 0..7
    res = res | (chars[i].ord << shift)
    shift -= 8
  end
  res.to_s(16)
end
