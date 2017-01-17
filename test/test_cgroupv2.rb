##
## CgroupV2 Test
##

assert("CgroupV2.root") do
  t = CgroupV2.root
  assert_equal(CgroupV2::Group, t.class)
end
