defmodule Glayu.Templates.Page do

	def tpl(title) do
		"""
    	---
    	title: #{title}
    	date: #{Glayu.Date.date}
    	---

    	New Glayu page
    	"""
	end

end