assert("CgroupV2::Group#[]=") do
  g = CgroupV2::Group.new("example")
  g["pids.max"] = 9999
  assert_equal(9999, g["pids.max"])
end

assert("CgroupV2::SubsystemProxy") do
  g = CgroupV2::Group.new("example")
  def g.controllers
    ["pids", "memory", "io"]
  end

  g.pids.max = 9999
  assert_equal(9999, g["pids.max"])

  g.io.weight = 100
  assert_equal(100, g["io.weight"])

  g.memory.swap_max = 100 * 1024 * 1024
  assert_equal(100 * 1024 * 1024, g["memory.swap.max"])
end

assert("when CgroupV2::Group#pid.max is unavailable") do
  g = CgroupV2::Group.new("example")
  def g.controllers
    [""]
  end

  _e = nil
  begin
    g.pids.max = 9999
  rescue => e
    _e = e
  end
  assert_equal("Unavailable: pids", _e.message)
end
