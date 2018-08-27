class InputSplitter
  def split64(block64)
    [block64 >> (64 - 16),
     (block64 >> 32) & 0xffff,
     (block64 >> 16) & 0xffff,
     block64 & 0xffff]
  end

  def split_string(str)
    blocks = []
    for i in 0.step(str.bytesize - 1, 8)
      block = 0
      for j in 0..7
        if i + j < str.bytesize
          block |= str.getbyte(i + j) << (56 - (j * 8))
        end
      end
      blocks.push(block)
    end
    blocks
  end
end
