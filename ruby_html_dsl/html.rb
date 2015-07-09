module HTML
  class Writer < BasicObject

    def self.closed_tag(*arg)
      arg.each do |name|
        define_method name do |*attr|
          @file.puts "<#{name}#{attr_to_str attr.last}>"
        end
      end
    end

    closed_tag :img, :hr, :br

    def initialize(f)
      @file = f
      @file.puts "<!DOCTYPE html>"
    end

    def attr_to_str(attr)
      if attr.nil?
        return ""
      end

      s = attr.map{ |k, v| "#{k}=#{v.inspect}" }.join(" ")
      " " + s + " "
    end

    def text(s)
      @file.puts s
    end

    def method_missing(name, *arg, &block)
      tag = name.to_s
      @file.puts "<#{tag}#{attr_to_str arg.last}>"
      instance_eval &block
      @file.puts "</#{tag}>"
    end
  end

  def self.create(f, &block)
    writer = Writer.new(f)
    writer.instance_eval &block
  end
end

