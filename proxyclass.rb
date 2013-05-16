#load "z3.rb"

class ProxyClass
	# Z3 context (todo)
	@@context = nil
	
	# list of Z3 symbols
	@@symbols = Hash.new
	
	def self.assert_aux(var1, var2)
		val1 = var1
		if var1.is_a? ProxyClass
			puts "arg is a proxy"
			val1 = var1.instance_variable_get("@val")
		end
		
		val2 = var2
		if var2.is_a? ProxyClass
			puts "arg2 is a proxy"
			val2 = var2.instance_variable_get("@val")
		end
		
		return [val1, val2]
	end
	
	def self.assert_equal(var1, var2)
		puts "asserting equal hi sup"
		val1, val2 = self.assert_aux(var1, var2)
		
		puts "asserting equal: ", val1 == val2
		return (val1 == val2)
	end
	
	def self.assert_lessthan(var1, var2)
		val1, val2 = self.assert_aux(var1, var2)
		
		return (val1 < val2)
	end
	
	def self.assert(varstr)
		# varstr is some boolean expression with whitespace between variables ie "a < 3"
		# important assumption that there are max two variables and /only/ comparison operators being used in assert
		vararr = varstr.split()
		print vararr
		# create Z3 solver
		#solver = Z3_mk_solver(context)
		
		# possible expressions: "<" "==" ">" "<=" ">="
		# check if any symbols in varstr and replace accordingly?
		operators = ["==", "!=", "<", "<=", ">", ">="]
		theOp = nil
		for op in operators
			if vararr.member? op
				# this operator is in the string
				theOp = op
			end
		end
		
		sym1 = nil
		sym2 = nil
		for sy in @@symbols.keys
			idx = vararr.index(sy)
			if idx != nil
				if idx == 0
					sym1 = sy
				else
					sym2 = sy
				end
			end
		end
		
		# actually have the solver solve things
		#intz3 = Z3_solver_check(pointer, pointer)
		
		infostr = "for str '#{varstr}', operator = #{theOp}, symbols = "
		evalstr = varstr
		
		if sym1 != nil
			val1 = @@symbols[sym1]
			infostr += "#{sym1}=#{val1}, "
			evalstr = evalstr.sub(sym1, val1.to_s)
		end
		
		if sym2 != nil
			val2 = @@symbols[sym2]
			infostr += "#{sym2}=#{val2}"
			evalstr = evalstr.sub(sym2, val2.to_s)
		end
		puts infostr + "\n"
		result = eval(evalstr)
		puts "result: #{result}"
	end
	
	def initialize(name, actualVal)
		@val = actualVal
		@name = name
		
		# create symbol here
		sym = actualVal
		@@symbols[name] = @val
		
		@type = actualVal.class
	end
	
	def <(arg)
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
