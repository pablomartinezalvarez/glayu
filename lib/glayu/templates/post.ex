defmodule Glayu.Templates.Post do

	def tpl(title) do
		"""
    	---
    	title: #{title}
    	date: #{Glayu.Date.now}
    	categories:
    	- Software
    	- Static Sites
    	tags:
    	- Glayu
    	- Elixir
    	---

    	A new Glayu post
    	"""
	end

end