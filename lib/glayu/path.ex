defmodule Glayu.Path do

	@moduledoc """
	This module provides utilities to resolve the file locations on a Glayu site
  	"""

  	alias Glayu.Slugger
  	alias Glayu.Config

  	def source_draft_path_from_title(title) do
  		Path.join([".", Config.get('source_dir'), "_drafts", Slugger.slug(title) <> ".md"])
  	end

  	def source_page_path_from_title(title) do
  		Path.join([".", Config.get('source_dir'), Slugger.slug(title) <> ".md"])
  	end

  	def source_draft_path_from_file_name(file_name) do
  		Path.join([".", Config.get('source_dir'), "_drafts", file_name])
  	end

  	def public_dir_from_permalink(permalink) do
  		Path.join([".", Config.get('public_dir')] ++ Enum.drop(permalink,-1))
  	end

    def public_post_from_permalink(permalink) do
      dir = Enum.drop(permalink,-1)
      file_name = List.last(permalink)
      Path.join([".", Config.get('public_dir')] ++ dir ++ [file_name <> ".md"])
    end


end