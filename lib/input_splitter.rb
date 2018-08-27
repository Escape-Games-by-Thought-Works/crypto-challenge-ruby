class InputSplitter
  def split64 block64
    [block64 >> (64 - 16),
     (block64 >> 32) & 0xffff,
     (block64 >> 16) & 0xffff,
     block64 & 0xffff]
  end
end
