defmodule Glayu.Path do

	@moduledoc """
	This module provides utilities to resolve the file locations on a Glayu site
  	"""

  	alias Glayu.Slugger
  	alias Glayu.Config

  	def draft_source_path(title) do
  		Path.join([".", Config.get('source_dir'), "_drafts", Slugger.slug(title) <> ".md"])
  	end

  	def page_source_path(title) do
  		Path.join([".", Config.get('source_dir'), Slugger.slug(title) <> ".md"])
  	end

end