defmodule Demo.Schema.DataTypes do
  use Absinthe.Schema.Notation
  import_types Absinthe.Type.Custom
  use AstSimpleFilter.DefineCommonObjects

  object :user do
    field :id, :asf_uuid
    field :email, :string
  end

  object :session do
    field :token, :string
  end

  object :user_profile do
    field :name, :string
    field :slug, :string
    field :dob, :date
    field :address, :asf_json
    field :image, :asf_json do
      resolve fn user_profile, _, _ ->
        urls = Demo.Utils.uploaded_file_urls(Demo.ImageUploader, user_profile.image, user_profile)
        {:ok, urls}
      end
    end
  end

  use AstSimpleFilter.DefineTypes, base_name: :user, field_types: Demo.Accounts.User.filter_fields
  use AstSimpleFilter.DefineFilterInput, base_name: :user, field_types: Demo.Accounts.User.filter_fields

  use AstSimpleFilter.DefineTypes, base_name: :user_profile, field_types: Demo.Accounts.UserProfile.filter_fields, model_object: :user_profile
  use AstSimpleFilter.DefineFilterInput, base_name: :user_profile, field_types: Demo.Accounts.UserProfile.filter_fields

  use AstSimpleFilter.DefineTypes, base_name: :company, field_types: Demo.Accounts.Company.filter_fields
  use AstSimpleFilter.DefineFilterInput, base_name: :company, field_types: Demo.Accounts.Company.filter_fields
end