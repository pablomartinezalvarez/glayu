defmodule Glayu.Validations.ValidatorTest do

  use ExUnit.Case

  test "validate raises a ValidationError when receives an invalid proplist " do

    source = [
      {'title', 'The Glayu Times'},
      {'permalink', 'categories/year/month/day/titl'}, # invalid permalink format
      {'source_dir', 'source'},
      {'theme', 'glayu-times'},
      {'theme_uri', 'glayu-times'}, # invalid uri format
      {'base_dir', '/my-glayu-site'}
      # public_dir is required
    ]

    validators = [
      {'title', [Glayu.Validations.RequiredValidator.validator()]},
      {'source_dir', [Glayu.Validations.RequiredValidator.validator()]},
      {'public_dir', [Glayu.Validations.RequiredValidator.validator()]},
      {'permalink', [Glayu.Validations.RequiredValidator.validator(), Glayu.Validations.PermalinkConfValidator.validator()]},
      {'theme', [Glayu.Validations.RequiredValidator.validator()]},
      {'theme_uri', [Glayu.Validations.URIValidator.validator()]}
    ]

    assert_raise Glayu.Validations.ValidationError, "Validation Error:\n'public_dir': \"is required\"\n'permalink': \"invalid permalink format\"\n'theme_uri': \"invalid uri format\"", fn ->
      Glayu.Validations.Validator.validate!(source, validators, fn (source, field) ->
        found = :proplists.get_value(field, source)
        case found do
          :undefined ->
             nil
          _ ->
            to_string found
        end
      end)
    end

  end

  test "validate returns :ok when receives a valid document context" do

    source = %{
      categories: [
        %{keys: ["software"], name: "Software", path: "/software/index.html"},
        %{keys: ["software", "static-sites"], name: "Static Sites", path: "/software/static-sites/index.html"}
      ],
      content: "<p>A new Glayu post</p>\n",
      date: DateTime.from_naive!(~N[2017-05-11 07:20:03.000], "Etc/UTC"),
      layout: :draft,
      path: "/software/static-sites/new-post.html",
      raw: "A new Glayu post\n",
      score: 10,
      source: "/Users/pablomartinezalvarez/Documents/development/workspaces/glayu/glayu-test-site/source/_drafts/new-post.md",
      summary: "<p>A new Glayu post</p>\n",
      tags: ["Glayu", "Elixir"],
      title: "New Post",
      type: :draft
    }

    validators = [
      {:title, [Glayu.Validations.RequiredValidator.validator()]},
      {:categories, [Glayu.Validations.RequiredValidator.validator()]},
      {:date, [Glayu.Validations.RequiredValidator.validator()]}
    ]

    assert source == Glayu.Validations.Validator.validate!(source, validators, fn (source, field) ->
      source[field]
    end)

  end

end