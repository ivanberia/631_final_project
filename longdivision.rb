# version of http://rubyquiz.strd6.com/quizzes/180-long-division
# takes two inputs (dividend, divisor) and outputs the quotient and remainder

load "proxyclass.rb"

def main(dividend, divisor)
	quotient = 0
	remainder = dividend
	Math.log10(dividend).ceil.downto(0) do |exp|
		magnitude = 10 ** exp
		trydiv, rest = dividend.divmod(magnitude)
		if trydiv >= divisor
			quotient_digit, remainder = trydiv.divmod(divisor)
			quotient += quotient_digit * magnitude
			dividend = (remainder * magnitude + rest)
			break
		end
	end
	return quotient, remainder
end

def mainProxied(dd, dv)
	dividend = FixnumProxy.new(dd)
	divisor = FixnumProxy.new(dv)
	quotient = FixnumProxy.new(0)
	remainder = FixnumProxy.new(dd)
	Math.log10(dividend.to_f).ceil.downto(0) do |exp|
		magnitude = 10 ** exp
		trydiv, rest = dividend.divmod(magnitude)
		if trydiv >= divisor
			quotient_digit, remainder = trydiv.divmod(divisor)
			quotient += quotient_digit * magnitude
			dividend = (remainder * magnitude + rest)
			break
		end
	end
	
	# in long division, the remainder should always be less than the divisor (otherwise we would divide another time)
	puts "remainder < divisor? (expect: TRUE)", ProxyClass.assert_less_than(remainder, divisor)
	
	# similarly, this should be false
	puts "remainder >= divisor? (expect: FALSE)", ProxyClass.assert_greater_than_or_equal(remainder, divisor)
	
	# divisor should not be zero
	puts "divisor != 0? (expect: TRUE)", ProxyClass.assert_not_equal(divisor, 0)
	
	return quotient, remainder
end

# get command-line arguments
dd = ARGV[0].to_i
dv = ARGV[1].to_i
if dv != 0
	q, r = main(dd, dv)
	puts "Quotient: #{q}, Remainder: #{r}"
	
	puts "------------------------"
	
	q, r = mainProxied(dd, dv)
	puts "Quotient: #{q}, Remainder: #{r}"
else
	puts "Error: div by zero"
end