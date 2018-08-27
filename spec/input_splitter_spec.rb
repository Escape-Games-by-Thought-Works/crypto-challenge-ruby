require 'input_splitter'

RSpec.describe InputSplitter do
  it 'splits a 64bit block into 4 16bit blocks' do
    input_splitter = InputSplitter.new
    blocks = input_splitter.split64(0x0123456789abcdef)
    expect(blocks).to eq([0x0123, 0x4567, 0x89ab, 0xcdef])
  end
end
