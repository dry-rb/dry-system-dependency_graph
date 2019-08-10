module Dry
  module System
    module DependencyGraph
      class ClassSourceLocation
        def call(klass)
          methods = defined_methods(klass)
          file_groups = methods.group_by{|sl| sl[0]}
          file_counts = file_groups.map do |file, sls|
            lines = sls.map{|sl| sl[1]}
            count = lines.size
            line = lines.min
            {file: file, count: count, line: line}
          end
          file_counts.sort_by!{|fc| fc[:count]}
          file_counts.map { |fc| fc[:file] }.first
        end

      private

        def source_location(method)
          method.source_location || (
            method.to_s =~ /: (.*)>/
            $1
          )
        end

        def defined_methods(klass)
          methods = klass.methods(false).map{|m| klass.method(m)} +
            klass.instance_methods(false).map{|m| klass.instance_method(m)}
          methods.map!(&:source_location)
          methods.compact!
          methods
        end
      end

      CLASS_NAME_REGEXP = /<([\w:]+)+:\w+>/

      class DependencyInfo
        def call(dependency)
          dependency_class_name = dependency.to_s.match(CLASS_NAME_REGEXP)
          return {} unless dependency_class_name

          dependency_class_name = dependency_class_name[1]
          dependency_class = Kernel.const_get(dependency_class_name)
          source_location = ClassSourceLocation.new.call(dependency_class)

          {
            class: dependency_class,
            source_location: source_location,
            source_code: source_location && File.read(source_location)
          }
        end
      end
    end
  end
end
