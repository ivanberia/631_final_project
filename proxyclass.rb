# proxy class for things
# define a method_missing that passes the original values to the original method call

class ProxyClass
	def initialize(actualVal)
		@val = actualVal
		# is this important?
		@type = actualVal.class
	end
	
	def method_missing(name, *args)
		# intercept the method name and args
		puts "method '#{name}' missing! args were: #{args}"
		
		# at this point we collect the info about the thing and do a thing and z3 things

		# if a ProxyClass object is an arg, use the value of it as the arg
		for i in 0..args.length
			if args[i].instance_of? ProxyClass
				args[i] = args[i].instance_variable_get('@val')
			end
		end
		
		# pass them on to the original function call
		@val.send(name, *args)
	end
end

# some testing examples
a = ProxyClass.new(10)
b = ProxyClass.new(5)
puts a+b
puts a / b
puts a