defmodule Glayu.Date do
	
	def date do
		Chronos.Formatter.strftime(Chronos.today, Glayu.Config.get('date_format'))
  	end

end