require 'input_splitter'

RSpec.describe InputSplitter do
  it 'splits a 64bit block into 4 16bit blocks' do
    input_splitter = InputSplitter.new
    blocks = input_splitter.split(0x0123456789abcdef0123456789abcdef)
    expect(blocks.length).to be(4)
  end
end
