require 'input_splitter'

RSpec.describe InputSplitter do
  input_splitter = InputSplitter.new
  it 'splits a 64bit block into 4 16bit blocks' do
    blocks = input_splitter.split64(0x0123456789abcdef)
    expect(blocks).to eq([0x0123, 0x4567, 0x89ab, 0xcdef])
  end

  it 'splits a string into 64bit blocks' do
    blocks = input_splitter.split_string('some str')

    blocks_as_hex = blocks.each.map {|b| b.to_s(16)}
    expect(blocks_as_hex).to eq([chars_as_block('s', 'o', 'm', 'e', ' ', 's', 't', 'r')])
  end

  it 'fills a string with zeros' do
    blocks = input_splitter.split_string('some string')

    blocks_as_hex = blocks.each.map {|b| b.to_s(16)}
    expect(blocks.length).to eq(2)
    expect(blocks_as_hex).to eq([
      chars_as_block('s', 'o', 'm', 'e', ' ', 's', 't', 'r'),
      chars_as_block('i', 'n', 'g', "\0", "\0", "\0", "\0", "\0")
      ])
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
