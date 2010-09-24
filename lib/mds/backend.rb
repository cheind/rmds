#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

module MDS

  # Defines the preferrred order of interfaces.
  PREFERRED_INTERFACE_ORDER = ['MDS::LinalgInterface', 'MDS::GSLInterface', 'MDS::StdlibInterface']
  
  # Globbing pattern to find backends shipped with RMDS
  DEFAULT_BACKEND_PATHS = File.join(File.dirname(__FILE__), 'interfaces', '*interface.rb')
  
  #
  # Provides a common interface to matrix operations.
  #
  class Backend
    # Stack of active matrix interfaces
    @active = []
    # Array of available interface classes
    @available = []
    
    class << self; 
      # 
      # Access the active matrix interface.
      #
      def active
        @active.first; 
      end
      
      #
      # Set the active matrix interface.
      #
      def active=(i)
        @active.pop
        @active.push(i)
      end

      #
      # Push matrix interface onto the stack and set it active.
      #      
      def push_active(i)
        @active.push(i)
      end
      
      #
      # Deactivate active matrix interface by popping it from stack.
      #
      def pop_active
        @active.pop()
      end
      
      # 
      # Add available interface class.
      #
      # This method is automatically called once a {MDS::MatrixInterface} subclass
      # is loaded. {MDS::MatrixInterface} overrides #{Object.inherited} to inform
      # {MDS::Backend} of new class.
      #
      # @param [MatrixInterface] i the concrete interface class
      #
      def add(i)
        @available << i
      end
      
      #
      # Return available interface classes.
      #
      # @return the available interface classes.
      #
      def available
        @available
      end
      
      #
      # Return the first interface class.
      #
      # If no interface class matches a string in +search_order+,
      # the first available interface is returned.
      #
      # @param search_order order of preferred backend names.
      #
      def first(search_order = MDS::PREFERRED_INTERFACE_ORDER)
        c = search_order.map do |name|
          begin
            name.split('::').inject(Kernel) do |scope, const_name| 
              scope.const_get(const_name)
            end
          rescue NameError
            nil
          end
        end.compact!
        
        (!c || c.length == 0) ? @available.first : c.first
      end
      
      #
      # Require all interfaces from path and conceal load possible errors.
      #
      # @param String path the path or globbing expression to pass to require
      #
      def load_backends(path = MDS::DEFAULT_BACKEND_PATHS)
        Dir.glob(File.expand_path(path)) do |path|
          begin
            require path
          rescue LoadError
          end
        end
      end
            
    end 
    
    
  end
end
