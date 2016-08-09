class PrioritySerializer
  def self.dump(obj)
    return unless obj
    {
      :critical => 0,
      :high => 1,
      :normal => 2,
      :low => 3
    }[obj]
  end

  def self.load(obj)
    return unless obj
    {
      0 => :critical,
      1 => :high,
      2 => :normal,
      3 => :low
    }[obj.to_i]
  end
end
