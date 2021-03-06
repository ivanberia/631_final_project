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
			val1 = var1.instance_variable_get("@val")
			zvar1 = var1.instance_variable_get("@sym")
		else
			# todo: generalize
			zvar1 = z3IntLiteral(val1)
		end
		
		val2 = var2
		if var2.is_a? ProxyClass
			val2 = var2.instance_variable_get("@val")
			zvar2 = var2.instance_variable_get("@sym")
		else
			zvar2 = z3IntLiteral(val2)
		end
				
		return [val1, zvar1, val2, zvar2]
	end
	
	def self.printAssertResults(zeqn)
		puts "Scopes:", Z3.Z3_solver_get_num_scopes(@@ctx, @@solver)
		result = Z3.Z3_solver_check(@@ctx, @@solver)
		boolresult = (result == 1) ? true : false
		puts "Result: #{result} (#{boolresult})"
		if not boolresult
			# todo: print a more helpful message
			raise 'Assertion failed'
		else
			puts "Model:", Z3.Z3_model_to_string(@@ctx, Z3.Z3_solver_get_model(@@ctx, @@solver))
		end
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
		return (val1 != val2)
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
		
		@type = actualVal.class
		Z3.initContext()
	end
	
	def coerce(stg)
		# todo: get originating call? (is this possible?)
		[stg, @val]
	end
	
	def method_missing(name, *args)
		# intercept the method name and args
		#puts "method '#{name}' missing for proxy #{@val}! args were: #{args}"
		
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
	# array for Z3, x is the other parameter to the operation
	def z3Call(func,array_bool,x)
		if x != nil
			case x
				when ProxyClass
					x_sym = x.sym
				when Fixnum
					x_sym = Z3.z3IntLiteral(x)
				when TrueClass
					x_sym = Z3.z3BoolLiteral(true)
				when FalseClass
					x_sym = Z3.z3BoolLiteral(false)
				else
					puts "Unknown/unsupported type"
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

	def self.printUnsatCore()
		Z3.Z3_solver_check(@@ctx,@@solver)
		unsat = Z3.Z3_solver_get_unsat_core(@@ctx,@@solver)
		puts Z3.Z3_ast_vector_to_string(@@ctx,unsat)
	end

	def setSym(x)
		@sym = x
	end
end

class FixnumProxy < ProxyClass
	@@methods = {:+ => [:Z3_mk_add,true],
				:* => [:Z3_mk_mul,true],
				:- => [:Z3_mk_sub,true],
				:/ => [:Z3_mk_div,false],
				:% => [:Z3_mk_mod,false]
				}

	def initialize(actualVal)
		super
		@sym = Z3.z3IntVar()
	end
	
	def method_missing(name, *args)
		if @@methods.has_key? name
			sym = self.z3Call(@@methods[name][0],@@methods[name][1],*args)
			out = FixnumProxy.new(super)
			out.setSym(sym)
			return out
		end
		return super
	end
end

class BoolProxy < ProxyClass
	@@methods = {:& => [:Z3_mk_and,true],
				:| => [:Z3_mk_or,true],
				:^ => [:Z3_mk_xor,false],
				:and => [:Z3_mk_and,true],
				:or => [:Z3_mk_or,true]
				}

	def initialize(actualVal)
		super
		@sym = Z3.z3BoolVar()
	end
	
	def method_missing(name, *args)
		if @@methods.has_key? name
			sym = self.z3Call(@@methods[name][0],@@methods[name][1],*args)
			out = BoolProxy.new(super)
			out.setSym(sym)
			return out
		end
	end
end
