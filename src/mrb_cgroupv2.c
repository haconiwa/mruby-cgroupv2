/*
** mrb_cgroupv2.c - CgroupV2 class
**
** Copyright (c) Uchio Kondo 2017
**
** See Copyright Notice in LICENSE
*/

#include <mruby.h>

#define DONE mrb_gc_arena_restore(mrb, 0);

void mrb_mruby_cgroupv2_gem_init(mrb_state *mrb)
{
  struct RClass *cgroupv2;
  cgroupv2 = mrb_define_module(mrb, "CgroupV2");
  DONE;
}

void mrb_mruby_cgroupv2_gem_final(mrb_state *mrb)
{
}
