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
		puts "method #{name} missing! args were: #{args}"
		
		# pass them on to the original thing
		@val.send(name, *args)
	end
end

class Testing
	def hello()
		puts "hi testing"
	end
	def argfun(woo)
		puts "now for an arg: #{woo}"
	end
end

# this works
t = ProxyClass.new(Testing.new)
t.hello()
t.argfun(42)

t2 = ProxyClass.new(37)
t2.to_f()
