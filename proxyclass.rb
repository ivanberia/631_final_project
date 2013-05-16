load "z3.rb"
include Z3

class ProxyClass
	attr_reader :val,:type,:sym,:name,:methods
	
	# list of Z3 symbols
	@@symbols = Hash.new
	@@ctx = Z3.getCtx()
	@@solver = Z3_mk_solver(@@ctx)
	
	def self.assert_aux(var1, var2)
		Z3_solver_inc_ref(Z3.getCtx(), @@solver)
		
		val1 = var1
		if var1.is_a? ProxyClass
			puts "arg is a proxy"
			val1 = var1.instance_variable_get("@val")
			zvar1 = var1.instance_variable_get("@sym")
		else
			# todo: generalize
			zvar1 = z3IntLiteral(va12)
		end
		
		val2 = var2
		if var2.is_a? ProxyClass
			puts "arg2 is a proxy"
			val2 = var2.instance_variable_get("@val")
			zvar2 = var2.instance_variable_get("@sym")
		else
			zvar2 = z3IntLiteral(val2)
		end
				
		return [val1, zvar1, val2, zvar2]
	end
	
	def self.printAssertResults(zeqn)
		puts "Scopes:", Z3.Z3_solver_get_num_scopes(@@ctx, @@solver)
		#puts "AST:", Z3_ast_to_string(@@ctx, zeqn)
		result = Z3.Z3_solver_check(@@ctx, @@solver)
		puts "Result:", result
<<<<<<< HEAD
		#puts "Model:", Z3.Z3_model_to_string(@@ctx, Z3.Z3_solver_get_model(@@ctx, @@solver))
=======
		# 1  = true, -1 = false
		#puts "Model:", Z3.Z3_model_to_string(@@ctx, Z3.Z3_solver_get_model(@@ctx, @@solver))
		boolresult = (r==1) ? true : false
		if not boolresult
			# todo: print a more helpful message
			raise 'Assertion failed'
		end
>>>>>>> 0d62e7f1cf9c234aca25e93827d66ec92b29e589
	end
	
	def self.assert_equal(var1, var2)
		val1, zvar1, val2, zvar2 = self.assert_aux(var1, var2)
		
		zeqn = Z3_mk_eq(@@ctx, zvar1, zvar2)
		Z3.Z3_solver_assert(@@ctx, @@solver, zeqn)
		
		self.printAssertResults(zeqn)
		return (val1 == val2)
	end

	def self.assert_not_equal(var1, var2)
		val1, zvar1, val2, zvar2 = self.assert_aux(var1, var2)
		
		zeqn = Z3_mk_not(@@ctx, Z3_mk_eq(@@ctx, zvar1, zvar2))
		Z3.Z3_solver_assert(@@ctx, @@solver, zeqn)
		
		self.printAssertResults(zeqn)
		return (val1 == val2)
	end
	
	def self.assert_less_than(var1, var2)
		val1, zvar1, val2, zvar2 = self.assert_aux(var1, var2)
		zeqn = Z3_mk_lt(@@ctx, zvar1, zvar2)
		Z3.Z3_solver_assert(@@ctx, @@solver, zeqn)
		self.printAssertResults(zeqn)
		return (val1 < val2)
	end
	
	def self.assert_less_than_or_equal(var1, var2)
		val1, zvar1, val2, zvar2 = self.assert_aux(var1, var2)
		zeqn = Z3_mk_le(@@ctx, zvar1, zvar2)
		Z3.Z3_solver_assert(@@ctx, @@solver, zeqn)
		self.printAssertResults(zeqn)
		return (val1 <= val2)
	end
	
	def self.assert_greater_than(var1, var2)
		val1, zvar1, val2, zvar2 = self.assert_aux(var1, var2)
		zeqn = Z3_mk_gt(@@ctx, zvar1, zvar2)
		Z3.Z3_solver_assert(@@ctx, @@solver, zeqn)
		self.printAssertResults(zeqn)
		return (val1 > val2)	
	end
	
	def self.assert_greater_than_or_equal(var1, var2)
		val1, zvar1, val2, zvar2 = self.assert_aux(var1, var2)
		zeqn = Z3_mk_ge(@@ctx, zvar1, zvar2)
		Z3.Z3_solver_assert(@@ctx, @@solver, zeqn)
		self.printAssertResults(zeqn)
		return (val1 >= val2)	
	end
	
	def initialize(actualVal)
		@val = actualVal
		
		# create symbol here
		sym = actualVal
		#@@symbols[name] = @val
		
		@type = actualVal.class
		Z3.initContext()
	end
	
	def coerce(stg)
		puts "proxy #{@val} is being coerced"
		# todo: get originating call? (is this possible?)
		[stg, @val]
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

	def initialize(actualVal)
		super
		@sym = Z3.z3IntVar()
	end
	
	def method_missing(name, *args)
		super
		self.z3Call(@@methods[name][0],@@methods[name][1],*args) if @@methods.has_key?(name)
		@val.send(name, *args)
	end
end
