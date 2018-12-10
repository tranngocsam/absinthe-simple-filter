defmodule Demo.Utils do
  def full_messages(errors) do
    for {key, {message, _}} <- errors do
      "#{key} #{message}"
    end
  end
end