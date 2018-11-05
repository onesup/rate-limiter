module RateLimit
	COUNTING_EXPIRY_TIME = 3600
	REQUEST_LIMIT = 100
	BLOCKED_EXPIRY_TIME = 60

	def reach_max_request?(ip)
		blocked_key = "blocked_#{ip}"
		counting_key = "counting_#{ip}"

		# check if there is a blocked key with this ip

		if $redis.get(blocked_key)
			seconds_left = $redis.ttl(blocked_key)
			return seconds_left
		end		
		
		# check if there is a counting key with this ip

		if $redis.get(counting_key)
			request_count = $redis.incr(counting_key)

			if request_count.to_i > REQUEST_LIMIT
				$redis.set(blocked_key, true)
				$redis.expire(blocked_key, BLOCKED_EXPIRY_TIME)

				$redis.del(counting_key)
				seconds_left = $redis.ttl(blocked_key)
				return seconds_left
			end

		# if no key exists, create a new one with expiry time
		else
			$redis.set(counting_key, 1)
			$redis.expire(counting_key, COUNTING_EXPIRY_TIME)
		end

		return false
	end
end
