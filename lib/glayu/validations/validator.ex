defmodule Glayu.Validations.Validator do

  def validate!(source, validations, extract_value_fn) do

    errors = Enum.flat_map(validations, fn {field, item_validators}  ->

      value = extract_value_fn.(source, field)
      if value || Enum.member?(item_validators, Glayu.Validations.RequiredValidator.validator()) do
        result = Saul.validate(value, Saul.all_of(item_validators))
        case result do
          {:error, resume} ->
            [{resume.validator, field, value, resume.reason}]
          _ -> []
        end
      else
       []
      end

    end)

    if length(errors) > 0 do
      raise Glayu.Validations.ValidationError, errors: errors
    else
      source
    end

  end

end