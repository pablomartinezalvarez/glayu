defmodule Glayu.Templates.Config do
	def tpl do
		"""
		# Glayu Configuration

		# Site
		title: A brand new static site

		# URL
		url: yoursite.com
		permalink: :category/:year/:month/:day/:title/

		# Directory
		source_dir: source
		public_dir: public

		# Language
		language: en-us

		# Date / Time format
		date_format: %Y-%m-%d
		time_format: %H:%M:%S

		# Pagination
		## Set per_page to 0 to disable pagination
		per_page: 10
		pagination_dir: page

		# Theme
		theme: bootstrap
		"""
	end
end