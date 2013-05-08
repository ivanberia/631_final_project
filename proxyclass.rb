#load "z3.rb"

class ProxyClass
	# Z3 context (todo)
	@@context = nil
	
	# list of Z3 symbols
	@@symbols = []
	
	def self.assert(varstr)
		# varstr is some boolean expression ie "a < 3"
		# this needs to check against Z3?
		# can get object_ids
		
		return eval(varstr)
	end
	
	def initialize(actualVal)
		@val = actualVal
		# is this important?
		@type = actualVal.class
	end
	
	def <(arg)
		# catch
		# this will go in the ProxyFixnum class
		print "catching lt, self is ", @val, ", arg is ", arg, "\n"
		v = @val
		a = arg
		if arg.is_a? self.class
			puts "arg is a proxy"
			a = arg.instance_variable_get("@val")
		end
		boolval = v < a
		
		puts "checkpt"
		
		puts @val < arg
		
		#if boolval
		#	return TrueClassProxy(v, a)
		#else
		#	return FalseClassProxy(v, a)
		#end
	end
	
	def coerce(stg)
		puts "proxy #{@val} is being coerced"
		[stg, @val]
		# what is calling this though and for what method
		# http://stackoverflow.com/questions/2799571/in-ruby-how-does-coerce-actually-work
	end
	
	def method_missing(name, *args)
		# intercept the method name and args
		puts "method '#{name}' missing for proxy #{@val}! args were: #{args}"
		
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

# does not work!
module BoolProxy
	def self.initialize(arg1, arg2)
		puts "boolproxy init"
		@arg1 = arg1
		@arg2 = arg2
	end
end

class TrueClass
	extend BoolProxy
end

class FalseClass
	include BoolProxy
end
