##
## CgroupV2 Test
##

assert("CgroupV2#hello") do
  t = CgroupV2.new "hello"
  assert_equal("hello", t.hello)
end

assert("CgroupV2#bye") do
  t = CgroupV2.new "hello"
  assert_equal("hello bye", t.bye)
end

assert("CgroupV2.hi") do
  assert_equal("hi!!", CgroupV2.hi)
end
