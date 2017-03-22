defmodule Glayu.Build.NodeProcessor do
	
	def process(node) do
		try do
			# raise "oops"
			:timer.sleep(3_000)
		rescue error ->
      		exit {:shutdown, error}
    	catch key, error ->
      		exit {:shutdown, {key, error}}
		end
	end

end