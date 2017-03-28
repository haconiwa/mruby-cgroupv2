module CgroupV2
  class << self
    attr_writer :mount_path, :root

    def new_group(name)
      ::CgroupV2::Group.new(name)
    end

    def mount_path
      @mount_path ||= "/cgroup2"
    end

    def root
      @__root ||= ::CgroupV2::Group.new("/")
    end

    def controllers
      root.controllers
    end

    def subtree_control
      root.subtree_control
    end

    def subtree_control=(controllers)
      root.subtree_control = controllers
    end

    def available?(subsys_name)
      root.available?(subsys_name)
    end
  end

  class Group
    def initialize(path)
      @path = path
      @path += "/" unless @path.end_with? "/"
      @params = {}
      @changed = []
    end
    attr_reader :path

    def create
      dir = to_fullpath
      unless File.exist? dir
        Dir.mkdir dir
      end
    end

    def controllers
      read_file("cgroup.controllers").split(" ")
    end

    def subtree_control
      read_file("cgroup.subtree_control").split(" ")
    end

    def subtree_control=(controllers)
      value = controllers.map{|c| "+#{c}" }.join(" ")
      write_file("cgroup.subtree_control", value)
      subtree_control
    end

    def available?(subsys_name)
      controllers.include? subsys_name.to_s
    end

    def [](key)
      @params[key] ||= read_file(key)
    end

    def []=(key, value)
      @params[key] = value
      @changed << key
      value
    end

    def memory
      raise("Unavailable: memory") unless available?("memory")
      @__memory ||= MemorySubsystem.new(self)
    end

    def io
      raise("Unavailable: io") unless available?("io")
      @__io ||= IOSubsystem.new(self)
    end

    def pids
      raise("Unavailable: pids") unless available?("pids")
      @__pids ||= PidsSubsystem.new(self)
    end

    def commit
      unless @changed.empty?
        @changed.uniq.each do |key|
          write_file(key, self[key])
        end
      end
      real_changed = @changed.uniq
      reload
      return real_changed
    end
    alias modify commit

    def reload
      @changed = []
      @params = {}
    end

    def attach
      write_file("cgroup.procs", Process.pid, "a")
    end

    def delete
      dir = to_fullpath
      if File.exist? dir
        Dir.rmdir dir
      end
    end

    private

    def to_fullpath(subpath="")
      p = CgroupV2.mount_path + "/" + path + subpath
      while p.include? "//"
        p.sub!("//", "/")
      end
      p
    end

    def read_file(subpath)
      f = File.open(to_fullpath(subpath), "r")
      value = f.read
      f.close
      value
    end

    def write_file(subpath, value, mode='w')
      f = File.open(to_fullpath(subpath), mode)
      f.write value
      f.close
      value
    end
  end

  class SubsystemProxy
    def initialize(group)
      @group = group
    end
    attr_reader :group

    def set_to_group(key, val)
      group[subsys_name + "." + key] = val
    end

    def get_from_group(key)
      group[subsys_name + "." + key]
    end

    class << self
      def has_cgroup_getter(keys)
        keys.each do |key|
          define_method key.split(".").join("_") do
            get_from_group(key)
          end
        end
      end

      def has_cgroup_setter(keys)
        keys.each do |key|
          define_method(key.split(".").join("_") + "=") do |value|
            set_to_group(key, value)
          end
        end
      end
    end
  end

  class MemorySubsystem < SubsystemProxy
    def subsys_name
      "memory"
    end

    has_cgroup_getter %w(current low high max stat swap.current swap.max)
    has_cgroup_setter %w(low high max swap.max)
  end

  class IOSubsystem < SubsystemProxy
    def subsys_name
      "io"
    end

    has_cgroup_getter %w(stat weight max)
    has_cgroup_setter %w(weight max)
  end

  class PidsSubsystem < SubsystemProxy
    def subsys_name
      "pids"
    end

    has_cgroup_getter %w(current max)
    has_cgroup_setter %w(max)
  end
end
