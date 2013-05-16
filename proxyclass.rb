load "z3.rb"
include Z3

class ProxyClass
	attr_reader :val,:type,:sym,:name,:methods

	def self.assert(varstr)
		# varstr is some boolean expression ie "a < 3"
		# this needs to check against Z3?
		# can get object_ids
		
		return eval(varstr)
	end
	
	def initialize(varName, actualVal)
		@val = actualVal
		# is this important?
		@type = actualVal.class
		@name = varName
		Z3.initContext()
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

	# func is a symbol, array_bool specifies if parameters need to be in an
	# array for Z3, a is the other parameter to the operation
	def z3Call(func,array_bool,x)
		if x
			case x
				when ProxyClass
					x_sym = x.sym
				else
					# Create Z3 constant for x depending on type
					# ONLY INT IMPLEMENTED NOW, NO CHECKS FOR TYPE
					x_sym = Z3.z3IntLiteral(x)
			end
			if array_bool
				arr = Z3.z3Array([@sym,x_sym])
				send(func,Z3.getCtx(),2,arr)
			else
				send(func,Z3.getCtx(),@sym,x_sym)
			end
		else
			send(func,Z3.getCtx(),@sym)
		end
	end
end

class FixnumProxy < ProxyClass
	@@methods = {:+ => [:Z3_mk_add,true],
				:* => [:Z3_mk_mul,true],
				:- => [:Z3_mk_sub,true]
				}

	def initialize(varName,actualVal)
		super
		@sym = Z3.z3IntVar(@name)
	end
	
	def method_missing(name, *args)
		super
		self.z3Call(@@methods[name][0],@@methods[name][1],*args) if @@methods.has_key?(name)
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

x = FixnumProxy.new('x',5)
y = 3
z = x + y
Z3.printContext()
