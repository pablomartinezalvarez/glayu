defmodule Glayu.CLI.Build do

  @behaviour Glayu.CLI.Command

  alias Glayu.Tasks.Build

  def options do
    [full: :boolean]
  end

  def aliases do
    [f: :full]
  end

  def help do
    """
    glayu build [regex]

    Generates static pages

    Args:

    [regex]
    If provided only the pages matching the regex will be generated, supported keywords are: :category,:year,:month,:day,:title
    
    Having the permalink option defined as follows on _config.yml: 
    
    permalink: :category/:year/:month/:day/:title
    
    /software/:category/2017/:month/01 will generate all the posts of the software category and subcategories published the first day of each month.

    Options:

    -f --full
    Regenerates the full site, otherwise the site will be generated incrementally.

    """
  end

  def run(params) do
  	Build.run Keyword.merge([regex: List.first(params[:args])],params[:opts]) 
  end

end