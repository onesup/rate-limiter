module RateLimit
	COUNTING_EXPIRY_TIME = 3600
	REQUEST_LIMIT = 100
	BLOCKED_EXPIRY_TIME = 60

	def reach_max_request?(key)
		# check if this key is a blocked key
		if $redis.get("blocked_#{key}")
			seconds_left = $redis.ttl("blocked_#{key}")
			return seconds_left
		end		

		# get and increase the value for the key
		# if the key doesn't exist, the value will be set as 1
		request_count = $redis.incr("counting_#{key}")

		# check if the request count is greater than the limit
		if request_count > REQUEST_LIMIT
			$redis.setex("blocked_#{key}", BLOCKED_EXPIRY_TIME, true)
			$redis.del("counting_#{key}")

			seconds_left = $redis.ttl("blocked_#{key}")
			return seconds_left
		else
			$redis.expire("counting_#{key}", COUNTING_EXPIRY_TIME)
		end
		return false
	end
end
